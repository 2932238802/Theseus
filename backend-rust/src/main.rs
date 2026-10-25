use std::time::Duration;

use backend_rust::{AppState, config::Config, db, db::pool::create_pool, judge::queue, routes};

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    dotenvy::dotenv().ok();
    tracing_subscriber::fmt()
        .with_env_filter(tracing_subscriber::EnvFilter::from_default_env())
        .init();

    let config = Config::from_env()?;
    let pool = create_pool(&config.database_url).await?;
    db::migrate(&pool).await?;
    let judge_enabled = config.run_code_enabled || config.submit_judge_enabled;
    let redis = if judge_enabled {
        match queue::connect(&config.redis_url).await {
            Ok(connection) => Some(connection),
            Err(error) => {
                tracing::error!(error = %error, "judge queue unavailable; run and submission APIs will fail closed");
                None
            }
        }
    } else {
        None
    };
    if judge_enabled && config.run_sandbox_runtime != "runsc" {
        tracing::warn!(
            runtime = %config.run_sandbox_runtime,
            "sandbox runtime is not runsc; this is only allowed for local development"
        );
    }
    let bind_address = config.bind_address;
    let state = AppState::new(pool, config, redis);
    if state.config.run_code_enabled || state.config.submit_judge_enabled {
        tokio::spawn(reaper_loop(state.clone()));
    }
    let listener = tokio::net::TcpListener::bind(bind_address).await?;
    tracing::info!(%bind_address, "Theseus backend listening");
    axum::serve(listener, routes::router(state))
        .with_graceful_shutdown(shutdown_signal())
        .await?;
    Ok(())
}

/// Periodically fails runs and submissions that have been queued or executing
/// for too long.
///
/// This runs in the API process on purpose: the scenario it protects against
/// is "no judge worker is consuming the stream", which a worker-side reaper
/// could never fix.
async fn reaper_loop(state: AppState) {
    let interval = Duration::from_secs(state.config.run_reaper_interval_secs);
    let mut ticker = tokio::time::interval(interval);
    ticker.set_missed_tick_behavior(tokio::time::MissedTickBehavior::Delay);
    loop {
        ticker.tick().await;
        if state.config.run_code_enabled {
            match state.run_service.expire_stale_runs(&state.pool).await {
                Ok(0) => {}
                Ok(count) => tracing::warn!(count, "expired stale code runs"),
                Err(error) => tracing::error!(error = %error, "failed to expire stale code runs"),
            }
        }
        if state.config.submit_judge_enabled {
            match state
                .submission_service
                .expire_stale_submissions(&state.pool)
                .await
            {
                Ok(0) => {}
                Ok(count) => tracing::warn!(count, "expired stale submissions"),
                Err(error) => {
                    tracing::error!(error = %error, "failed to expire stale submissions")
                }
            }
        }
    }
}

async fn shutdown_signal() {
    let terminate = async {
        match tokio::signal::unix::signal(tokio::signal::unix::SignalKind::terminate()) {
            Ok(mut signal) => {
                signal.recv().await;
            }
            Err(error) => {
                tracing::warn!(error = %error, "failed to install SIGTERM handler");
                std::future::pending::<()>().await;
            }
        }
    };
    tokio::select! {
        _ = tokio::signal::ctrl_c() => {}
        _ = terminate => {}
    }
    tracing::info!("shutdown signal received, draining connections");
}
