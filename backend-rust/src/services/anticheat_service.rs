//! 防作弊 M2：相似度扫描、报告查询、教师复核与学生申诉。
//!
//! 相似度扫描由 `anticheat_worker` 调用；报告与申诉接口只读写数据库，
//! 不直接依赖 Redis，避免把实时队列耦合进 HTTP 请求。

use std::cmp::Ordering;

use chrono::{DateTime, Utc};
use serde_json::{Value, json};
use sqlx::{FromRow, PgPool, Postgres, QueryBuilder};

use crate::{
    common::error::AppError,
    config::Config,
    middleware::auth::AuthUser,
    models::anticheat::{
        ACTION_APPEALED, ACTION_CONFIRMED, ACTION_CREATED, ACTION_DISMISSED, ACTION_OVERTURNED,
        ACTION_PENALTY_RESTORED, ACTION_UPHELD, APPEAL_STATUS_OVERTURNED, APPEAL_STATUS_PENDING,
        APPEAL_STATUS_UPHELD, AppealInput, AppealQueueItem, AppealQueueResponse,
        AppealResolveInput, AppealResolveResponse, AppealSubmitResponse, AppealView,
        CheatReportDetailResponse, CheatReportListResponse, CheatReportQuery, CheatReportSummary,
        CheatReviewInput, Evidence, EvidencePair, MyReportDetailResponse, MyReportListResponse,
        MyReportSummary, REPORT_STATUS_APPEALED, REPORT_STATUS_CONFIRMED, REPORT_STATUS_DISMISSED,
        REPORT_STATUS_OPEN, REPORT_STATUS_OVERTURNED, REPORT_STATUS_UPHELD, ReportActionView,
        ReviewResponse, SubmissionEvidence,
    },
    services::{notification_service, similarity},
};

const DEFAULT_PAGE: u32 = 1;
const DEFAULT_SIZE: u32 = 20;
const MAX_PAGE_SIZE: u32 = 50;
const MAX_REVIEW_NOTE_CHARS: usize = 500;
const MAX_APPEAL_REASON_CHARS: usize = 2_000;
const MAX_EVIDENCE_PAIRS: usize = 20;
const VALID_REPORT_STATUSES: [&str; 6] = [
    REPORT_STATUS_OPEN,
    REPORT_STATUS_CONFIRMED,
    REPORT_STATUS_DISMISSED,
    REPORT_STATUS_APPEALED,
    REPORT_STATUS_UPHELD,
    REPORT_STATUS_OVERTURNED,
];

// ---------------------------------------------------------------------------
// 扫描
// ---------------------------------------------------------------------------

#[derive(Debug, FromRow)]
struct ScanSubmissionRow {
    id: i32,
    user_id: i32,
    username: String,
    problem_id: i32,
    assignment_id: Option<i32>,
    language: String,
    code: String,
    status: String,
}

#[derive(Debug, FromRow)]
struct CandidateSubmissionRow {
    id: i32,
    user_id: i32,
    username: String,
    code: String,
}

#[derive(Debug, FromRow)]
struct AssignmentOwnerRow {
    owner_id: i32,
    title: String,
}

/// 扫描一次提交。返回 `Ok(())` 表示消息可以 ACK；只有数据库/Redis 故障才返回错误，
/// 让调用方保留 Pending 并重投。函数本身对重投幂等。
pub async fn scan_submission(
    pool: &PgPool,
    config: &Config,
    submission_id: i32,
) -> Result<(), AppError> {
    let Some(row) = sqlx::query_as::<_, ScanSubmissionRow>(
        "SELECT s.id, s.user_id, u.username, s.problem_id, s.assignment_id, \
                s.language, s.code, s.status \
         FROM submissions s JOIN users u ON u.id = s.user_id WHERE s.id = $1",
    )
    .bind(submission_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    else {
        tracing::warn!(submission_id, "submission vanished before similarity scan");
        return Ok(());
    };
    let Some(assignment_id) = row.assignment_id else {
        // v1 只扫描作业提交；日常练习与竞赛不进入比对范围。
        return Ok(());
    };
    if row.status == "internal_error" {
        return Ok(());
    }
    let already_scanned: bool = sqlx::query_scalar(
        "SELECT EXISTS(SELECT 1 FROM submission_signals \
         WHERE submission_id = $1 AND signal_type = 'scan_completed')",
    )
    .bind(row.id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;
    if already_scanned {
        return Ok(());
    }

    let current = similarity::fingerprint(&row.language, &row.code);
    if current.token_count < config.anticheat_min_tokens || current.is_empty() {
        mark_scan_completed(pool, row.id, json!({"skipped": "too_short"})).await?;
        return Ok(());
    }

    let candidates: Vec<CandidateSubmissionRow> = sqlx::query_as(
        "SELECT s.id, s.user_id, u.username, s.code \
         FROM submissions s JOIN users u ON u.id = s.user_id \
         WHERE s.assignment_id = $1 AND s.problem_id = $2 AND s.language = $3 \
           AND s.id < $4 AND s.user_id <> $5 AND s.status <> 'internal_error' \
           AND s.submitted_at >= CURRENT_TIMESTAMP - make_interval(days => $6) \
         ORDER BY s.id DESC LIMIT $7",
    )
    .bind(assignment_id)
    .bind(row.problem_id)
    .bind(&row.language)
    .bind(row.id)
    .bind(row.user_id)
    .bind(config.anticheat_window_days as i32)
    .bind(config.anticheat_max_candidates)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;

    let mut pairs: Vec<(CandidateSubmissionRow, similarity::SimilarityScore)> = Vec::new();
    for candidate in candidates {
        let other = similarity::fingerprint(&row.language, &candidate.code);
        if other.token_count < config.anticheat_min_tokens || other.is_empty() {
            continue;
        }
        let score = similarity::compare(&current, &other);
        if score.score >= config.anticheat_record_threshold {
            pairs.push((candidate, score));
        }
    }
    pairs.sort_by(|left, right| {
        right
            .1
            .score
            .partial_cmp(&left.1.score)
            .unwrap_or(Ordering::Equal)
    });
    pairs.truncate(MAX_EVIDENCE_PAIRS);

    let max_score = pairs.first().map(|(_, score)| score.score).unwrap_or(0.0);
    let severity = similarity::severity_for(
        max_score,
        config.anticheat_record_threshold,
        config.anticheat_report_threshold,
        config.anticheat_high_threshold,
    );

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    for (candidate, score) in &pairs {
        let (submission_a, submission_b) = if row.id < candidate.id {
            (row.id, candidate.id)
        } else {
            (candidate.id, row.id)
        };
        let detail = json!({
            "score": score.score,
            "containment": score.containment,
            "jaccard": score.jaccard,
            "a_grams": score.a_grams,
            "b_grams": score.b_grams,
            "matched_grams": score.matched_grams,
            "fragments": score.fragments,
        });
        sqlx::query(
            "INSERT INTO similarity_pairs \
             (submission_a, submission_b, problem_id, assignment_id, algorithm, score, detail) \
             VALUES ($1, $2, $3, $4, $5, $6, $7) \
             ON CONFLICT (submission_a, submission_b, algorithm) DO UPDATE SET \
                 score = EXCLUDED.score, detail = EXCLUDED.detail",
        )
        .bind(submission_a)
        .bind(submission_b)
        .bind(row.problem_id)
        .bind(assignment_id)
        .bind(similarity::ALGORITHM)
        .bind(score.score)
        .bind(detail)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
    }

    let report_severity = severity.filter(|value| *value != "low");
    let mut report_id = None;
    if let Some(severity) = report_severity
        && let Some((candidate, score)) = pairs.first()
    {
        let evidence = json!({
            "algorithm": similarity::ALGORITHM,
            "score": score.score,
            "containment": score.containment,
            "jaccard": score.jaccard,
            "fragments": score.fragments,
            "pairs": pairs.iter().map(|(candidate, score)| json!({
                "submission_id": candidate.id,
                "user_id": candidate.user_id,
                "username": candidate.username,
                "score": score.score,
                "matched_grams": score.matched_grams,
            })).collect::<Vec<_>>(),
        });
        let inserted: Option<i64> = sqlx::query_scalar(
            "INSERT INTO cheat_reports \
             (target_user_id, submission_id, assignment_id, problem_id, severity, score, \
              matched_submission_id, matched_user_id, evidence) \
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) \
             ON CONFLICT (submission_id) DO NOTHING RETURNING id",
        )
        .bind(row.user_id)
        .bind(row.id)
        .bind(assignment_id)
        .bind(row.problem_id)
        .bind(severity)
        .bind(max_score)
        .bind(candidate.id)
        .bind(candidate.user_id)
        .bind(&evidence)
        .fetch_optional(&mut *transaction)
        .await
        .map_err(AppError::Database)?;

        if let Some(id) = inserted {
            report_id = Some(id);
            sqlx::query(
                "INSERT INTO cheat_report_actions (report_id, actor_id, action, note) \
                 VALUES ($1, NULL, $2, $3)",
            )
            .bind(id)
            .bind(ACTION_CREATED)
            .bind(format!(
                "自动扫描命中，相似度 {:.0}%，比对范围：同作业同题同语言",
                max_score * 100.0
            ))
            .execute(&mut *transaction)
            .await
            .map_err(AppError::Database)?;

            if let Some(owner) = sqlx::query_as::<_, AssignmentOwnerRow>(
                "SELECT c.owner_id, a.title FROM assignments a \
                 JOIN classes c ON c.id = a.class_id WHERE a.id = $1",
            )
            .bind(assignment_id)
            .fetch_optional(&mut *transaction)
            .await
            .map_err(AppError::Database)?
            {
                let body = format!(
                    "作业《{}》中 {} 的提交与 {} 的提交相似度 {:.0}%，请到作弊复核页查看。",
                    owner.title,
                    row.username,
                    candidate.username,
                    max_score * 100.0
                );
                notification_service::create(
                    &mut transaction,
                    owner.owner_id,
                    "cheat_report_created",
                    None,
                    "新的代码相似度报告",
                    Some(&body),
                    Some("/teacher/anticheat"),
                    Some("cheat_report"),
                    Some(id),
                )
                .await?;
            }
        }
    }

    let signal_value = json!({
        "candidates": pairs.len(),
        "max_score": max_score,
        "severity": severity,
        "report_id": report_id,
    });
    sqlx::query(
        "INSERT INTO submission_signals (submission_id, signal_type, value, source) \
         VALUES ($1, 'scan_completed', $2, 'server') ON CONFLICT DO NOTHING",
    )
    .bind(row.id)
    .bind(signal_value)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    transaction.commit().await.map_err(AppError::Database)?;
    tracing::info!(
        submission_id = row.id,
        assignment_id,
        pairs = pairs.len(),
        max_score,
        report_id = ?report_id,
        "similarity scan completed"
    );
    Ok(())
}

async fn mark_scan_completed(
    pool: &PgPool,
    submission_id: i32,
    value: Value,
) -> Result<(), AppError> {
    sqlx::query(
        "INSERT INTO submission_signals (submission_id, signal_type, value, source) \
         VALUES ($1, 'scan_completed', $2, 'server') ON CONFLICT DO NOTHING",
    )
    .bind(submission_id)
    .bind(value)
    .execute(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(())
}

// ---------------------------------------------------------------------------
// 教师查询与复核
// ---------------------------------------------------------------------------

#[derive(Debug, FromRow)]
struct ReportSummaryRow {
    id: i64,
    status: String,
    severity: String,
    score: f64,
    created_at: DateTime<Utc>,
    decided_at: Option<DateTime<Utc>>,
    assignment_id: Option<i32>,
    assignment_title: Option<String>,
    class_id: Option<i32>,
    class_name: Option<String>,
    problem_id: i32,
    problem_title: String,
    target_user_id: i32,
    target_username: String,
    submission_id: i32,
    matched_submission_id: Option<i32>,
    matched_username: Option<String>,
    reviewer_id: Option<i32>,
    reviewer_username: Option<String>,
    appeal_status: Option<String>,
    penalty_applied_at: Option<DateTime<Utc>>,
    decision_note: Option<String>,
    total: i64,
}

impl ReportSummaryRow {
    fn into_summary(self) -> CheatReportSummary {
        CheatReportSummary {
            id: self.id,
            status: self.status,
            severity: self.severity,
            score: self.score,
            created_at: self.created_at,
            decided_at: self.decided_at,
            assignment_id: self.assignment_id,
            assignment_title: self.assignment_title,
            class_id: self.class_id,
            class_name: self.class_name,
            problem_id: self.problem_id,
            problem_title: self.problem_title,
            target_user_id: self.target_user_id,
            target_username: self.target_username,
            submission_id: self.submission_id,
            matched_submission_id: self.matched_submission_id,
            matched_username: self.matched_username,
            reviewer_id: self.reviewer_id,
            reviewer_username: self.reviewer_username,
            appeal_status: self.appeal_status,
            penalty_applied: self.penalty_applied_at.is_some(),
            decision_note: self.decision_note,
        }
    }
}

const SUMMARY_SELECT: &str = "SELECT cr.id, cr.status, cr.severity, cr.score::float8 AS score, \
    cr.created_at, cr.decided_at, cr.assignment_id, a.title AS assignment_title, \
    a.class_id, c.name AS class_name, cr.problem_id, p.title AS problem_title, \
    cr.target_user_id, tu.username AS target_username, cr.submission_id, \
    cr.matched_submission_id, mu.username AS matched_username, \
    cr.reviewer_id, rv.username AS reviewer_username, ap.status AS appeal_status, \
    cr.penalty_applied_at, cr.decision_note, COUNT(*) OVER() AS total \
    FROM cheat_reports cr \
    JOIN assignments a ON a.id = cr.assignment_id \
    JOIN classes c ON c.id = a.class_id \
    JOIN problems p ON p.id = cr.problem_id \
    JOIN users tu ON tu.id = cr.target_user_id \
    LEFT JOIN users mu ON mu.id = cr.matched_user_id \
    LEFT JOIN users rv ON rv.id = cr.reviewer_id \
    LEFT JOIN appeals ap ON ap.report_id = cr.id ";

pub async fn teacher_reports(
    pool: &PgPool,
    user: &AuthUser,
    query: &CheatReportQuery,
) -> Result<CheatReportListResponse, AppError> {
    require_teacher(user)?;
    let status = normalized_status(query.status.as_deref())?;
    let page = query.page.unwrap_or(DEFAULT_PAGE).max(1);
    let size = query.size.unwrap_or(DEFAULT_SIZE).clamp(1, MAX_PAGE_SIZE);
    let offset = i64::from(page - 1) * i64::from(size);

    let mut builder: QueryBuilder<Postgres> = QueryBuilder::new(SUMMARY_SELECT);
    builder.push(" WHERE c.owner_id = ").push_bind(user.id);
    if let Some(status) = status {
        builder.push(" AND cr.status = ").push_bind(status);
    }
    if let Some(assignment_id) = query.assignment_id {
        builder
            .push(" AND cr.assignment_id = ")
            .push_bind(assignment_id);
    }
    builder
        .push(" ORDER BY cr.created_at DESC, cr.id DESC LIMIT ")
        .push_bind(i64::from(size))
        .push(" OFFSET ")
        .push_bind(offset);
    let rows: Vec<ReportSummaryRow> = builder
        .build_query_as()
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
    let total = rows.first().map(|row| row.total).unwrap_or(0);

    let pending_count: i64 = sqlx::query_scalar(
        "SELECT COUNT(*) FROM cheat_reports cr \
         JOIN assignments a ON a.id = cr.assignment_id \
         JOIN classes c ON c.id = a.class_id \
         WHERE c.owner_id = $1 AND cr.status = 'open'",
    )
    .bind(user.id)
    .fetch_one(pool)
    .await
    .map_err(AppError::Database)?;

    Ok(CheatReportListResponse {
        total,
        page,
        size,
        pending_count,
        items: rows
            .into_iter()
            .map(ReportSummaryRow::into_summary)
            .collect(),
    })
}

pub async fn teacher_report_detail(
    pool: &PgPool,
    user: &AuthUser,
    report_id: i64,
) -> Result<CheatReportDetailResponse, AppError> {
    require_teacher(user)?;
    let mut builder: QueryBuilder<Postgres> = QueryBuilder::new(SUMMARY_SELECT);
    builder
        .push(" WHERE cr.id = ")
        .push_bind(report_id)
        .push(" AND c.owner_id = ")
        .push_bind(user.id);
    let row: Option<ReportSummaryRow> = builder
        .build_query_as()
        .fetch_optional(pool)
        .await
        .map_err(AppError::Database)?;
    let row = row.ok_or_else(|| AppError::NotFound("报告不存在".to_owned()))?;
    let assignment_id = row
        .assignment_id
        .ok_or_else(|| AppError::NotFound("报告不存在".to_owned()))?;
    let report = row.into_summary();

    let target = fetch_submission_evidence(pool, report.submission_id).await?;
    let pairs: Vec<EvidencePair> = sqlx::query_as::<_, PairRow>(
        "SELECT CASE WHEN sp.submission_a = $1 THEN sp.submission_b ELSE sp.submission_a END AS submission_id, \
                s.user_id, u.username, s.language, s.submitted_at, sp.score::float8 AS score, \
                sp.detail, s.code \
         FROM similarity_pairs sp \
         JOIN submissions s ON s.id = CASE WHEN sp.submission_a = $1 THEN sp.submission_b ELSE sp.submission_a END \
         JOIN users u ON u.id = s.user_id \
         WHERE (sp.submission_a = $1 OR sp.submission_b = $1) AND sp.assignment_id = $2 \
         ORDER BY sp.score DESC, sp.id DESC LIMIT $3",
    )
    .bind(report.submission_id)
    .bind(assignment_id)
    .bind(MAX_EVIDENCE_PAIRS as i64)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?
    .into_iter()
    .map(PairRow::into_view)
    .collect();

    let appeal = fetch_appeal(pool, report.id).await?;
    let actions = fetch_actions(pool, report.id, true).await?;

    Ok(CheatReportDetailResponse {
        report,
        evidence: Evidence {
            algorithm: similarity::ALGORITHM.to_owned(),
            target_submission: target,
            pairs,
        },
        appeal,
        actions,
    })
}

#[derive(Debug, FromRow)]
struct PairRow {
    submission_id: i32,
    user_id: i32,
    username: String,
    language: String,
    submitted_at: DateTime<Utc>,
    score: f64,
    detail: Value,
    code: String,
}

impl PairRow {
    fn into_view(self) -> EvidencePair {
        EvidencePair {
            submission_id: self.submission_id,
            user_id: self.user_id,
            username: self.username,
            language: self.language,
            submitted_at: self.submitted_at,
            score: self.score,
            detail: self.detail,
            code: self.code,
        }
    }
}

#[derive(Debug, FromRow)]
struct ReviewReportRow {
    status: String,
    target_user_id: i32,
    assignment_id: Option<i32>,
    problem_id: i32,
    title: String,
    owner_id: i32,
}

pub async fn review_report(
    pool: &PgPool,
    user: &AuthUser,
    report_id: i64,
    input: &CheatReviewInput,
) -> Result<ReviewResponse, AppError> {
    require_teacher(user)?;
    let decision = input.decision.trim();
    if !matches!(decision, "confirmed" | "dismissed") {
        return Err(AppError::BadRequest(
            "复核结论只能是 confirmed 或 dismissed".to_owned(),
        ));
    }
    let note = input
        .note
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    if let Some(note) = note
        && note.chars().count() > MAX_REVIEW_NOTE_CHARS
    {
        return Err(AppError::BadRequest("复核备注不能超过 500 字".to_owned()));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let report = sqlx::query_as::<_, ReviewReportRow>(
        "SELECT cr.status, cr.target_user_id, cr.assignment_id, cr.problem_id, \
                a.title, c.owner_id \
         FROM cheat_reports cr \
         JOIN assignments a ON a.id = cr.assignment_id \
         JOIN classes c ON c.id = a.class_id \
         WHERE cr.id = $1 FOR UPDATE OF cr",
    )
    .bind(report_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("报告不存在".to_owned()))?;
    if report.owner_id != user.id {
        return Err(AppError::NotFound("报告不存在".to_owned()));
    }
    if report.status != REPORT_STATUS_OPEN {
        return Err(AppError::ConflictWith(
            "该报告已处理，不能重复复核".to_owned(),
        ));
    }

    let mut penalty_applied = false;
    if decision == "confirmed" {
        if input.apply_zero {
            let assignment_id = report
                .assignment_id
                .ok_or_else(|| AppError::NotFound("报告不存在".to_owned()))?;
            let problem_exists: bool = sqlx::query_scalar(
                "SELECT EXISTS(SELECT 1 FROM assignment_problems \
                 WHERE assignment_id = $1 AND problem_id = $2)",
            )
            .bind(assignment_id)
            .bind(report.problem_id)
            .fetch_one(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
            if !problem_exists {
                return Err(AppError::ConflictWith(
                    "该题已不在作业中，无法自动判零".to_owned(),
                ));
            }
            let before: Option<(Option<i32>, Option<String>, Option<i32>)> = sqlx::query_as(
                "SELECT manual_score, feedback, graded_by FROM assignment_problem_grades \
                 WHERE assignment_id = $1 AND user_id = $2 AND problem_id = $3 FOR UPDATE",
            )
            .bind(assignment_id)
            .bind(report.target_user_id)
            .bind(report.problem_id)
            .fetch_optional(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
            let penalty_before = before.map(|(manual_score, feedback, graded_by)| {
                json!({
                    "manual_score": manual_score,
                    "feedback": feedback,
                    "graded_by": graded_by,
                })
            });
            sqlx::query(
                "INSERT INTO assignment_problem_grades \
                 (assignment_id, user_id, problem_id, manual_score, feedback, graded_by) \
                 VALUES ($1, $2, $3, 0, $4, $5) \
                 ON CONFLICT (assignment_id, user_id, problem_id) DO UPDATE SET \
                     manual_score = 0, feedback = EXCLUDED.feedback, \
                     graded_by = EXCLUDED.graded_by, graded_at = CURRENT_TIMESTAMP",
            )
            .bind(assignment_id)
            .bind(report.target_user_id)
            .bind(report.problem_id)
            .bind("防作弊复核确认抄袭，该题计 0 分")
            .bind(user.id)
            .execute(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
            sqlx::query(
                "UPDATE cheat_reports SET status = $2, reviewer_id = $3, decision_note = $4, \
                 decided_at = CURRENT_TIMESTAMP, penalty_applied_at = CURRENT_TIMESTAMP, \
                 penalty_before = $5, updated_at = CURRENT_TIMESTAMP WHERE id = $1",
            )
            .bind(report_id)
            .bind(REPORT_STATUS_CONFIRMED)
            .bind(user.id)
            .bind(note)
            .bind(penalty_before)
            .execute(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
            penalty_applied = true;
        } else {
            sqlx::query(
                "UPDATE cheat_reports SET status = $2, reviewer_id = $3, decision_note = $4, \
                 decided_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = $1",
            )
            .bind(report_id)
            .bind(REPORT_STATUS_CONFIRMED)
            .bind(user.id)
            .bind(note)
            .execute(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
        }
        sqlx::query(
            "INSERT INTO cheat_report_actions (report_id, actor_id, action, note) \
             VALUES ($1, $2, $3, $4)",
        )
        .bind(report_id)
        .bind(user.id)
        .bind(ACTION_CONFIRMED)
        .bind(note)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        let body = format!(
            "作业《{}》的相似度报告已确认。如对结论有异议，可在“我的申诉”提交申诉。",
            report.title
        );
        notification_service::create(
            &mut transaction,
            report.target_user_id,
            "cheat_report_confirmed",
            None,
            "作业提交被确认存在抄袭",
            Some(&body),
            Some("/profile/appeals"),
            Some("cheat_report"),
            Some(report_id),
        )
        .await?;
    } else {
        sqlx::query(
            "UPDATE cheat_reports SET status = $2, reviewer_id = $3, decision_note = $4, \
             decided_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE id = $1",
        )
        .bind(report_id)
        .bind(REPORT_STATUS_DISMISSED)
        .bind(user.id)
        .bind(note)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        sqlx::query(
            "INSERT INTO cheat_report_actions (report_id, actor_id, action, note) \
             VALUES ($1, $2, $3, $4)",
        )
        .bind(report_id)
        .bind(user.id)
        .bind(ACTION_DISMISSED)
        .bind(note)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
        let body = format!("作业《{}》的相似度报告经复核已排除。", report.title);
        let link = report
            .assignment_id
            .map(|assignment_id| format!("/assignments/{assignment_id}"));
        notification_service::create(
            &mut transaction,
            report.target_user_id,
            "cheat_report_dismissed",
            None,
            "相似度报告已排除",
            Some(&body),
            link.as_deref(),
            None,
            None,
        )
        .await?;
    }

    transaction.commit().await.map_err(AppError::Database)?;
    Ok(ReviewResponse {
        message: if decision == "confirmed" {
            if penalty_applied {
                "已确认作弊，并将该题计 0 分".to_owned()
            } else {
                "已确认作弊，成绩未自动修改".to_owned()
            }
        } else {
            "已排除该报告".to_owned()
        },
        status: if decision == "confirmed" {
            REPORT_STATUS_CONFIRMED.to_owned()
        } else {
            REPORT_STATUS_DISMISSED.to_owned()
        },
        penalty_applied,
    })
}

// ---------------------------------------------------------------------------
// 学生申诉
// ---------------------------------------------------------------------------

#[derive(Debug, FromRow)]
struct StudentReportRow {
    id: i64,
    status: String,
    severity: String,
    score: f64,
    created_at: DateTime<Utc>,
    decided_at: Option<DateTime<Utc>>,
    assignment_id: Option<i32>,
    assignment_title: Option<String>,
    problem_id: i32,
    problem_title: String,
    decision_note: Option<String>,
    penalty_applied_at: Option<DateTime<Utc>>,
    appeal_status: Option<String>,
}

impl StudentReportRow {
    fn into_summary(self) -> MyReportSummary {
        MyReportSummary {
            id: self.id,
            status: self.status,
            severity: self.severity,
            score: self.score,
            created_at: self.created_at,
            decided_at: self.decided_at,
            assignment_id: self.assignment_id,
            assignment_title: self.assignment_title,
            problem_id: self.problem_id,
            problem_title: self.problem_title,
            decision_note: self.decision_note,
            penalty_applied: self.penalty_applied_at.is_some(),
            appeal_status: self.appeal_status,
        }
    }
}

const STUDENT_SELECT: &str = "SELECT cr.id, cr.status, cr.severity, cr.score::float8 AS score, \
    cr.created_at, cr.decided_at, cr.assignment_id, a.title AS assignment_title, \
    cr.problem_id, p.title AS problem_title, cr.decision_note, cr.penalty_applied_at, \
    ap.status AS appeal_status \
    FROM cheat_reports cr \
    JOIN problems p ON p.id = cr.problem_id \
    LEFT JOIN assignments a ON a.id = cr.assignment_id \
    LEFT JOIN appeals ap ON ap.report_id = cr.id ";

pub async fn my_reports(pool: &PgPool, user: &AuthUser) -> Result<MyReportListResponse, AppError> {
    let rows: Vec<StudentReportRow> = sqlx::query_as(&format!(
        "{STUDENT_SELECT} WHERE cr.target_user_id = $1 \
             AND cr.status IN ('confirmed', 'appealed', 'upheld', 'overturned') \
             ORDER BY cr.created_at DESC, cr.id DESC"
    ))
    .bind(user.id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(MyReportListResponse {
        items: rows
            .into_iter()
            .map(StudentReportRow::into_summary)
            .collect(),
    })
}

pub async fn my_report_detail(
    pool: &PgPool,
    user: &AuthUser,
    report_id: i64,
) -> Result<MyReportDetailResponse, AppError> {
    let Some(row) = sqlx::query_as::<_, StudentReportRow>(&format!(
        "{STUDENT_SELECT} WHERE cr.id = $1 AND cr.target_user_id = $2 \
         AND cr.status IN ('confirmed', 'appealed', 'upheld', 'overturned')"
    ))
    .bind(report_id)
    .bind(user.id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    else {
        return Err(AppError::NotFound("报告不存在".to_owned()));
    };
    let submission_id: i32 =
        sqlx::query_scalar("SELECT submission_id FROM cheat_reports WHERE id = $1")
            .bind(report_id)
            .fetch_one(pool)
            .await
            .map_err(AppError::Database)?;
    let submission = fetch_submission_evidence(pool, submission_id).await?;
    let appeal = fetch_appeal(pool, report_id).await?;
    let actions = fetch_actions(pool, report_id, false).await?;
    Ok(MyReportDetailResponse {
        report: row.into_summary(),
        submission,
        appeal,
        actions,
    })
}

#[derive(Debug, FromRow)]
struct AppealTargetRow {
    status: String,
    target_user_id: i32,
    reviewer_id: Option<i32>,
    owner_id: i32,
    title: String,
}

pub async fn submit_appeal(
    pool: &PgPool,
    user: &AuthUser,
    report_id: i64,
    input: &AppealInput,
) -> Result<AppealSubmitResponse, AppError> {
    let reason = input.reason.trim();
    if reason.is_empty() {
        return Err(AppError::BadRequest("申诉理由不能为空".to_owned()));
    }
    if reason.chars().count() > MAX_APPEAL_REASON_CHARS {
        return Err(AppError::BadRequest("申诉理由不能超过 2000 字".to_owned()));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let report = sqlx::query_as::<_, AppealTargetRow>(
        "SELECT cr.status, cr.target_user_id, cr.reviewer_id, c.owner_id, a.title \
         FROM cheat_reports cr \
         JOIN assignments a ON a.id = cr.assignment_id \
         JOIN classes c ON c.id = a.class_id \
         WHERE cr.id = $1 FOR UPDATE OF cr",
    )
    .bind(report_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("报告不存在".to_owned()))?;
    if report.target_user_id != user.id {
        return Err(AppError::NotFound("报告不存在".to_owned()));
    }
    if report.status != REPORT_STATUS_CONFIRMED {
        return Err(AppError::ConflictWith(
            "只有已确认的报告可以申诉，或该报告已进入申诉流程".to_owned(),
        ));
    }

    let appeal_id: Option<i64> = sqlx::query_scalar(
        "INSERT INTO appeals (report_id, user_id, reason) VALUES ($1, $2, $3) \
         ON CONFLICT (report_id) DO NOTHING RETURNING id",
    )
    .bind(report_id)
    .bind(user.id)
    .bind(reason)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    let appeal_id =
        appeal_id.ok_or_else(|| AppError::ConflictWith("该报告已提交过申诉".to_owned()))?;

    sqlx::query(
        "UPDATE cheat_reports SET status = $2, updated_at = CURRENT_TIMESTAMP WHERE id = $1",
    )
    .bind(report_id)
    .bind(REPORT_STATUS_APPEALED)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    sqlx::query(
        "INSERT INTO cheat_report_actions (report_id, actor_id, action, note) \
         VALUES ($1, $2, $3, $4)",
    )
    .bind(report_id)
    .bind(user.id)
    .bind(ACTION_APPEALED)
    .bind(reason)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    let handler_id = report.reviewer_id.unwrap_or(report.owner_id);
    let body = format!("学生对《{}》的作弊结论提交了申诉，请复核。", report.title);
    notification_service::create(
        &mut transaction,
        handler_id,
        "cheat_appeal_created",
        Some(user.id),
        "学生提交了作弊申诉",
        Some(&body),
        Some("/teacher/anticheat"),
        Some("appeal"),
        Some(appeal_id),
    )
    .await?;

    transaction.commit().await.map_err(AppError::Database)?;
    Ok(AppealSubmitResponse {
        message: "申诉已提交，等待处理".to_owned(),
        appeal_id,
        status: APPEAL_STATUS_PENDING.to_owned(),
    })
}

pub async fn appeal_queue(
    pool: &PgPool,
    user: &AuthUser,
    query: &CheatReportQuery,
) -> Result<AppealQueueResponse, AppError> {
    let page = query.page.unwrap_or(DEFAULT_PAGE).max(1);
    let size = query.size.unwrap_or(DEFAULT_SIZE).clamp(1, MAX_PAGE_SIZE);
    let offset = i64::from(page - 1) * i64::from(size);

    #[derive(FromRow)]
    struct AppealRow {
        appeal_id: i64,
        report_id: i64,
        reason: String,
        created_at: DateTime<Utc>,
        target_user_id: i32,
        target_username: String,
        assignment_id: Option<i32>,
        assignment_title: Option<String>,
        problem_id: i32,
        problem_title: String,
        score: f64,
        severity: String,
        decision_note: Option<String>,
        decided_at: Option<DateTime<Utc>>,
        total: i64,
    }

    let mut builder: QueryBuilder<Postgres> = QueryBuilder::new(
        "SELECT ap.id AS appeal_id, ap.report_id, ap.reason, ap.created_at, \
                cr.target_user_id, u.username AS target_username, cr.assignment_id, \
                a.title AS assignment_title, cr.problem_id, p.title AS problem_title, \
                cr.score::float8 AS score, cr.severity, cr.decision_note, cr.decided_at, \
                COUNT(*) OVER() AS total \
         FROM appeals ap \
         JOIN cheat_reports cr ON cr.id = ap.report_id \
         JOIN users u ON u.id = cr.target_user_id \
         JOIN problems p ON p.id = cr.problem_id \
         LEFT JOIN assignments a ON a.id = cr.assignment_id \
         WHERE cr.reviewer_id = ",
    );
    builder
        .push_bind(user.id)
        .push(" AND ap.status = ")
        .push_bind(APPEAL_STATUS_PENDING)
        .push(" ORDER BY ap.created_at ASC, ap.id ASC LIMIT ")
        .push_bind(i64::from(size))
        .push(" OFFSET ")
        .push_bind(offset);
    let rows: Vec<AppealRow> = builder
        .build_query_as()
        .fetch_all(pool)
        .await
        .map_err(AppError::Database)?;
    let total = rows.first().map(|row| row.total).unwrap_or(0);

    Ok(AppealQueueResponse {
        total,
        page,
        size,
        items: rows
            .into_iter()
            .map(|row| AppealQueueItem {
                appeal_id: row.appeal_id,
                report_id: row.report_id,
                reason: row.reason,
                created_at: row.created_at,
                target_user_id: row.target_user_id,
                target_username: row.target_username,
                assignment_id: row.assignment_id,
                assignment_title: row.assignment_title,
                problem_id: row.problem_id,
                problem_title: row.problem_title,
                score: row.score,
                severity: row.severity,
                decision_note: row.decision_note,
                decided_at: row.decided_at,
            })
            .collect(),
    })
}

#[derive(Debug, FromRow)]
struct AppealResolveRow {
    status: String,
    report_id: i64,
    reviewer_id: Option<i32>,
    target_user_id: i32,
    assignment_id: Option<i32>,
    problem_id: i32,
    report_status: String,
    penalty_applied_at: Option<DateTime<Utc>>,
    penalty_before: Option<Value>,
    title: String,
}

pub async fn resolve_appeal(
    pool: &PgPool,
    user: &AuthUser,
    appeal_id: i64,
    input: &AppealResolveInput,
) -> Result<AppealResolveResponse, AppError> {
    let decision = input.decision.trim();
    if !matches!(decision, "upheld" | "overturned") {
        return Err(AppError::BadRequest(
            "申诉结论只能是 upheld 或 overturned".to_owned(),
        ));
    }
    let note = input
        .note
        .as_deref()
        .map(str::trim)
        .filter(|value| !value.is_empty());
    if let Some(note) = note
        && note.chars().count() > MAX_REVIEW_NOTE_CHARS
    {
        return Err(AppError::BadRequest("处理备注不能超过 500 字".to_owned()));
    }

    let mut transaction = pool.begin().await.map_err(AppError::Database)?;
    let appeal = sqlx::query_as::<_, AppealResolveRow>(
        "SELECT ap.status, ap.report_id, cr.reviewer_id, cr.target_user_id, \
                cr.assignment_id, cr.problem_id, cr.status AS report_status, \
                cr.penalty_applied_at, cr.penalty_before, a.title \
         FROM appeals ap \
         JOIN cheat_reports cr ON cr.id = ap.report_id \
         JOIN assignments a ON a.id = cr.assignment_id \
         WHERE ap.id = $1 FOR UPDATE OF ap, cr",
    )
    .bind(appeal_id)
    .fetch_optional(&mut *transaction)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("申诉不存在".to_owned()))?;
    if appeal.reviewer_id != Some(user.id) {
        return Err(AppError::ForbiddenWith(
            "只有该报告的处理人可以裁定申诉".to_owned(),
        ));
    }
    if appeal.status != APPEAL_STATUS_PENDING || appeal.report_status != REPORT_STATUS_APPEALED {
        return Err(AppError::ConflictWith("该申诉已处理".to_owned()));
    }

    let mut penalty_restored = false;
    if decision == "overturned" {
        if appeal.penalty_applied_at.is_some()
            && let Some(assignment_id) = appeal.assignment_id
        {
            match &appeal.penalty_before {
                Some(before) => {
                    let manual_score = before.get("manual_score").and_then(Value::as_i64);
                    let feedback = before
                        .get("feedback")
                        .and_then(Value::as_str)
                        .map(str::to_owned);
                    let graded_by = before
                        .get("graded_by")
                        .and_then(Value::as_i64)
                        .map(|value| value as i32);
                    sqlx::query(
                            "INSERT INTO assignment_problem_grades \
                             (assignment_id, user_id, problem_id, manual_score, feedback, graded_by) \
                             VALUES ($1, $2, $3, $4, $5, $6) \
                             ON CONFLICT (assignment_id, user_id, problem_id) DO UPDATE SET \
                                 manual_score = EXCLUDED.manual_score, \
                                 feedback = EXCLUDED.feedback, \
                                 graded_by = EXCLUDED.graded_by, \
                                 graded_at = CURRENT_TIMESTAMP",
                        )
                        .bind(assignment_id)
                        .bind(appeal.target_user_id)
                        .bind(appeal.problem_id)
                        .bind(manual_score.map(|value| value as i32))
                        .bind(feedback)
                        .bind(graded_by)
                        .execute(&mut *transaction)
                        .await
                        .map_err(AppError::Database)?;
                }
                None => {
                    sqlx::query(
                        "DELETE FROM assignment_problem_grades \
                             WHERE assignment_id = $1 AND user_id = $2 AND problem_id = $3",
                    )
                    .bind(assignment_id)
                    .bind(appeal.target_user_id)
                    .bind(appeal.problem_id)
                    .execute(&mut *transaction)
                    .await
                    .map_err(AppError::Database)?;
                }
            }
            penalty_restored = true;
            sqlx::query(
                "INSERT INTO cheat_report_actions (report_id, actor_id, action, note) \
                     VALUES ($1, $2, $3, $4)",
            )
            .bind(appeal.report_id)
            .bind(user.id)
            .bind(ACTION_PENALTY_RESTORED)
            .bind("申诉翻案，已恢复判零前的成绩")
            .execute(&mut *transaction)
            .await
            .map_err(AppError::Database)?;
        }
        sqlx::query(
            "UPDATE cheat_reports SET status = $2, penalty_applied_at = NULL, \
             penalty_before = NULL, updated_at = CURRENT_TIMESTAMP WHERE id = $1",
        )
        .bind(appeal.report_id)
        .bind(REPORT_STATUS_OVERTURNED)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
    } else {
        sqlx::query(
            "UPDATE cheat_reports SET status = $2, updated_at = CURRENT_TIMESTAMP WHERE id = $1",
        )
        .bind(appeal.report_id)
        .bind(REPORT_STATUS_UPHELD)
        .execute(&mut *transaction)
        .await
        .map_err(AppError::Database)?;
    }

    let appeal_status = if decision == "overturned" {
        APPEAL_STATUS_OVERTURNED
    } else {
        APPEAL_STATUS_UPHELD
    };
    sqlx::query(
        "UPDATE appeals SET status = $2, handled_by = $3, handle_note = $4, \
         handled_at = CURRENT_TIMESTAMP WHERE id = $1",
    )
    .bind(appeal_id)
    .bind(appeal_status)
    .bind(user.id)
    .bind(note)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;
    sqlx::query(
        "INSERT INTO cheat_report_actions (report_id, actor_id, action, note) \
         VALUES ($1, $2, $3, $4)",
    )
    .bind(appeal.report_id)
    .bind(user.id)
    .bind(if decision == "overturned" {
        ACTION_OVERTURNED
    } else {
        ACTION_UPHELD
    })
    .bind(note)
    .execute(&mut *transaction)
    .await
    .map_err(AppError::Database)?;

    let (title, body) = if decision == "overturned" {
        (
            "申诉已通过，作弊结论撤销",
            format!(
                "《{}》的作弊结论已撤销{}。",
                appeal.title,
                if penalty_restored {
                    "，该题成绩已恢复"
                } else {
                    ""
                }
            ),
        )
    } else {
        (
            "申诉已驳回，维持作弊结论",
            format!("《{}》的作弊结论经复核维持。", appeal.title),
        )
    };
    notification_service::create(
        &mut transaction,
        appeal.target_user_id,
        "cheat_appeal_resolved",
        None,
        title,
        Some(&body),
        Some("/profile/appeals"),
        Some("appeal"),
        Some(appeal_id),
    )
    .await?;

    transaction.commit().await.map_err(AppError::Database)?;
    Ok(AppealResolveResponse {
        message: if decision == "overturned" {
            "已撤销作弊结论".to_owned()
        } else {
            "已维持作弊结论".to_owned()
        },
        appeal_status: appeal_status.to_owned(),
        report_status: if decision == "overturned" {
            REPORT_STATUS_OVERTURNED.to_owned()
        } else {
            REPORT_STATUS_UPHELD.to_owned()
        },
        penalty_restored,
    })
}

// ---------------------------------------------------------------------------
// 共享查询
// ---------------------------------------------------------------------------

async fn fetch_submission_evidence(
    pool: &PgPool,
    submission_id: i32,
) -> Result<SubmissionEvidence, AppError> {
    sqlx::query_as::<_, SubmissionEvidence>(
        "SELECT s.id, s.user_id, u.username, s.language, s.status, s.submitted_at, s.code \
         FROM submissions s JOIN users u ON u.id = s.user_id WHERE s.id = $1",
    )
    .bind(submission_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?
    .ok_or_else(|| AppError::NotFound("提交不存在".to_owned()))
}

#[derive(Debug, FromRow)]
struct AppealRow {
    id: i64,
    reason: String,
    status: String,
    created_at: DateTime<Utc>,
    handled_by: Option<i32>,
    handled_by_username: Option<String>,
    handle_note: Option<String>,
    handled_at: Option<DateTime<Utc>>,
}

async fn fetch_appeal(pool: &PgPool, report_id: i64) -> Result<Option<AppealView>, AppError> {
    let row: Option<AppealRow> = sqlx::query_as(
        "SELECT ap.id, ap.reason, ap.status, ap.created_at, ap.handled_by, \
                hu.username AS handled_by_username, ap.handle_note, ap.handled_at \
         FROM appeals ap LEFT JOIN users hu ON hu.id = ap.handled_by \
         WHERE ap.report_id = $1",
    )
    .bind(report_id)
    .fetch_optional(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(row.map(|row| AppealView {
        id: row.id,
        reason: row.reason,
        status: row.status,
        created_at: row.created_at,
        handled_by: row.handled_by,
        handled_by_username: row.handled_by_username,
        handle_note: row.handle_note,
        handled_at: row.handled_at,
    }))
}

#[derive(Debug, FromRow)]
struct ActionRow {
    action: String,
    actor_username: Option<String>,
    note: Option<String>,
    created_at: DateTime<Utc>,
}

async fn fetch_actions(
    pool: &PgPool,
    report_id: i64,
    include_actor: bool,
) -> Result<Vec<ReportActionView>, AppError> {
    let rows: Vec<ActionRow> = sqlx::query_as(
        "SELECT ca.action, u.username AS actor_username, ca.note, ca.created_at \
         FROM cheat_report_actions ca LEFT JOIN users u ON u.id = ca.actor_id \
         WHERE ca.report_id = $1 ORDER BY ca.created_at ASC, ca.id ASC",
    )
    .bind(report_id)
    .fetch_all(pool)
    .await
    .map_err(AppError::Database)?;
    Ok(rows
        .into_iter()
        .map(|row| ReportActionView {
            action: row.action,
            actor_username: if include_actor {
                row.actor_username
            } else {
                None
            },
            note: row.note,
            created_at: row.created_at,
        })
        .collect())
}

fn require_teacher(user: &AuthUser) -> Result<(), AppError> {
    if user.is_teacher() {
        Ok(())
    } else {
        Err(AppError::ForbiddenWith(
            "只有教师账号可以执行该操作".to_owned(),
        ))
    }
}

fn normalized_status(status: Option<&str>) -> Result<Option<&str>, AppError> {
    match status {
        None | Some("") | Some("all") => Ok(None),
        Some(value) if VALID_REPORT_STATUSES.contains(&value) => Ok(Some(value)),
        Some(_) => Err(AppError::BadRequest("报告状态筛选无效".to_owned())),
    }
}
