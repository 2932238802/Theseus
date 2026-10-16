use std::time::Duration;

use sqlx::PgPool;

#[derive(Debug, Clone, Default)]
pub struct JudgeService;

impl JudgeService {
    pub async fn judge_submission(
        &self,
        pool: &PgPool,
        submission_id: i32,
        user_id: i32,
        problem_id: i32,
        total_test_cases: i32,
    ) -> Result<(), sqlx::Error> {
        sqlx::query("UPDATE submissions SET status = 'judging' WHERE id = $1")
            .bind(submission_id)
            .execute(pool)
            .await?;

        // Do not claim success until an isolated evaluator is configured.
        tokio::time::sleep(Duration::from_millis(10)).await;
        let total = total_test_cases.max(0);
        let mut transaction = pool.begin().await?;
        sqlx::query(
            "UPDATE submissions SET status = 'runtime_error', test_cases_passed = 0, total_test_cases = $1, error_message = '评测器尚未配置，请稍后重试' WHERE id = $2",
        )
        .bind(total)
        .bind(submission_id)
        .execute(&mut *transaction)
        .await?;
        sqlx::query(
            "UPDATE problems SET submit_count = submit_count + 1, acceptance_rate = CASE WHEN submit_count + 1 = 0 THEN 0 ELSE (accept_count::double precision / (submit_count + 1)::double precision) * 100 END WHERE id = $1",
        )
        .bind(problem_id)
        .execute(&mut *transaction)
        .await?;
        sqlx::query(
            "INSERT INTO user_problem_status (user_id, problem_id, status, last_submission_id) VALUES ($1, $2, 'attempted', $3) ON CONFLICT (user_id, problem_id) DO UPDATE SET last_submission_id = EXCLUDED.last_submission_id, updated_at = CURRENT_TIMESTAMP",
        )
        .bind(user_id)
        .bind(problem_id)
        .bind(submission_id)
        .execute(&mut *transaction)
        .await?;
        transaction.commit().await
    }
}
