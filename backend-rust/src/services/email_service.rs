use lettre::{
    AsyncSmtpTransport, AsyncTransport, Message, Tokio1Executor, message::Mailbox,
    transport::smtp::authentication::Credentials,
};
use sqlx::{FromRow, PgPool, Postgres, Transaction};

use crate::{common::error::AppError, config::Config};

const MAX_ATTEMPTS: i32 = 5;

#[derive(Debug, FromRow)]
struct PendingEmail {
    id: i64,
    recipient_email: String,
    subject: String,
    body: String,
    attempts: i32,
}

/// Inserts an outbox row in the caller's transaction. The API process polls
/// the outbox, so registration never waits for SMTP.
pub async fn enqueue(
    transaction: &mut Transaction<'_, Postgres>,
    recipient: &str,
    subject: &str,
    body: &str,
) -> Result<(), AppError> {
    sqlx::query("INSERT INTO email_outbox (recipient_email, subject, body) VALUES ($1, $2, $3)")
        .bind(recipient)
        .bind(subject)
        .bind(body)
        .execute(&mut **transaction)
        .await
        .map_err(AppError::Database)?;
    Ok(())
}

/// Delivers up to `limit` due messages. A failed delivery is retried with
/// exponential backoff until `MAX_ATTEMPTS`, then marked `failed`.
pub async fn dispatch_pending(
    pool: &PgPool,
    config: &Config,
    limit: usize,
) -> Result<usize, AppError> {
    requeue_stale(pool).await?;
    let mut delivered = 0;
    for _ in 0..limit {
        let Some(email) = claim_next(pool).await? else {
            break;
        };
        match deliver(config, &email).await {
            Ok(()) => {
                mark_sent(pool, email.id).await?;
                delivered += 1;
            }
            Err(message) => {
                mark_failed(pool, email.id, email.attempts, &message).await?;
                tracing::warn!(
                    email_id = email.id,
                    attempts = email.attempts,
                    error = %message,
                    "email delivery failed"
                );
            }
        }
    }
    Ok(delivered)
}

/// A dispatcher may die between claiming a row and updating it. Requeue rows
/// that have been `sending` for too long so they are not lost forever.
async fn requeue_stale(pool: &PgPool) -> Result<(), AppError> {
    sqlx::query(
        "UPDATE email_outbox
         SET status = CASE WHEN attempts >= $1 THEN 'failed' ELSE 'queued' END,
             claimed_at = NULL
         WHERE status = 'sending'
           AND claimed_at < CURRENT_TIMESTAMP - INTERVAL '5 minutes'",
    )
    .bind(MAX_ATTEMPTS)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(())
}

async fn claim_next(pool: &PgPool) -> Result<Option<PendingEmail>, AppError> {
    sqlx::query_as::<_, PendingEmail>(
        "UPDATE email_outbox
         SET status = 'sending', attempts = attempts + 1, claimed_at = CURRENT_TIMESTAMP
         WHERE id = (
             SELECT id FROM email_outbox
             WHERE status = 'queued' AND next_attempt_at <= CURRENT_TIMESTAMP
             ORDER BY id
             LIMIT 1
             FOR UPDATE SKIP LOCKED
         )
         RETURNING id, recipient_email, subject, body, attempts",
    )
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)
}

async fn mark_sent(pool: &PgPool, id: i64) -> Result<(), AppError> {
    sqlx::query(
        "UPDATE email_outbox
         SET status = 'sent', sent_at = CURRENT_TIMESTAMP, last_error = NULL, claimed_at = NULL
         WHERE id = $1",
    )
    .bind(id)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(())
}

async fn mark_failed(pool: &PgPool, id: i64, attempts: i32, error: &str) -> Result<(), AppError> {
    let status = if attempts >= MAX_ATTEMPTS {
        "failed"
    } else {
        "queued"
    };
    let delay_secs = attempts.max(1) * 30;
    let error = error.chars().take(500).collect::<String>();
    sqlx::query(
        "UPDATE email_outbox
         SET status = $2,
             last_error = $3,
             next_attempt_at = CURRENT_TIMESTAMP + make_interval(secs => $4::int),
             claimed_at = NULL
         WHERE id = $1",
    )
    .bind(id)
    .bind(status)
    .bind(error)
    .bind(delay_secs)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(())
}

async fn deliver(config: &Config, email: &PendingEmail) -> Result<(), String> {
    if config.email_mode == "log" {
        // Log mode is for local development only: the body contains the
        // one-time verification/reset link so developers can click it.
        tracing::info!(
            to = %email.recipient_email,
            subject = %email.subject,
            body = %email.body,
            "email delivery (log mode)"
        );
        return Ok(());
    }

    let from = config
        .email_from
        .parse::<Mailbox>()
        .map_err(|error| format!("EMAIL_FROM 无效: {error}"))?;
    let to = email
        .recipient_email
        .parse::<Mailbox>()
        .map_err(|error| format!("收件人地址无效: {error}"))?;
    let message = Message::builder()
        .from(from)
        .to(to)
        .subject(email.subject.clone())
        .body(email.body.clone())
        .map_err(|error| format!("邮件内容无效: {error}"))?;

    let mut builder = if config.email_smtp_tls {
        AsyncSmtpTransport::<Tokio1Executor>::relay(&config.email_smtp_host)
            .map_err(|error| format!("SMTP 配置无效: {error}"))?
            .port(config.email_smtp_port)
    } else {
        AsyncSmtpTransport::<Tokio1Executor>::builder_dangerous(&config.email_smtp_host)
            .port(config.email_smtp_port)
    };
    if let Some(username) = &config.email_smtp_username {
        let password = config.email_smtp_password.clone().unwrap_or_default();
        builder = builder.credentials(Credentials::new(username.clone(), password));
    }
    builder
        .build()
        .send(message)
        .await
        .map(|_| ())
        .map_err(|error| format!("SMTP 投递失败: {error}"))
}
