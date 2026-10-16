use backend_rust::{AppState, config::Config, db, db::pool::create_pool, routes};

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    dotenvy::dotenv().ok();
    tracing_subscriber::fmt()
        .with_env_filter(tracing_subscriber::EnvFilter::from_default_env())
        .init();

    let config = Config::from_env()?;
    let pool = create_pool(&config.database_url).await?;
    db::migrate(&pool).await?;
    let bind_address = config.bind_address;
    let listener = tokio::net::TcpListener::bind(bind_address).await?;
    tracing::info!(%bind_address, "Theseus backend listening");
    axum::serve(listener, routes::router(AppState::new(pool, config))).await?;
    Ok(())
}
