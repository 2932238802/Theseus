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
    let redis = if config.run_code_enabled {
        match queue::connect(&config.redis_url).await {
            Ok(connection) => Some(connection),
            Err(error) => {
                tracing::error!(error = %error, "run queue unavailable; run API will fail closed");
                None
            }
        }
    } else {
        None
    };
    if config.run_code_enabled && config.run_sandbox_runtime != "runsc" {
        tracing::warn!(
            runtime = %config.run_sandbox_runtime,
            "sandbox runtime is not runsc; this is only allowed for local development"
        );
    }
    let bind_address = config.bind_address;
    let listener = tokio::net::TcpListener::bind(bind_address).await?;
    tracing::info!(%bind_address, "Theseus backend listening");
    axum::serve(listener, routes::router(AppState::new(pool, config, redis))).await?;
    Ok(())
}
