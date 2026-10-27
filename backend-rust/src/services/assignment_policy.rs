use chrono::{DateTime, Duration, Utc};

pub const LATE_POLICY_FORBID: &str = "forbid";
pub const LATE_POLICY_ALLOW: &str = "allow";

pub const SCORING_HIGHEST: &str = "highest";
pub const SCORING_LAST: &str = "last";
pub const SCORING_FIRST_AC: &str = "first_ac";

pub const SCORE_VISIBILITY_AFTER_PUBLISH: &str = "after_publish";
pub const SCORE_VISIBILITY_AFTER_DUE: &str = "after_due";
pub const SCORE_VISIBILITY_DURING: &str = "during";

pub const EXEMPTION_FULL_SCORE: &str = "full_score";
pub const EXEMPTION_EXCLUDED: &str = "excluded";

pub const SUBMISSION_STATUS_ACCEPTED: &str = "accepted";
pub const SUBMISSION_STATUS_INTERNAL_ERROR: &str = "internal_error";

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ScoringPolicy {
    Highest,
    Last,
    FirstAc,
}

impl ScoringPolicy {
    pub fn parse(value: &str) -> Option<Self> {
        match value {
            SCORING_HIGHEST => Some(Self::Highest),
            SCORING_LAST => Some(Self::Last),
            SCORING_FIRST_AC => Some(Self::FirstAc),
            _ => None,
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ScoreVisibility {
    AfterPublish,
    AfterDue,
    During,
}

impl ScoreVisibility {
    pub fn parse(value: &str) -> Option<Self> {
        match value {
            SCORE_VISIBILITY_AFTER_PUBLISH => Some(Self::AfterPublish),
            SCORE_VISIBILITY_AFTER_DUE => Some(Self::AfterDue),
            SCORE_VISIBILITY_DURING => Some(Self::During),
            _ => None,
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ExemptionMode {
    FullScore,
    Excluded,
}

impl ExemptionMode {
    pub fn parse(value: &str) -> Option<Self> {
        match value {
            EXEMPTION_FULL_SCORE => Some(Self::FullScore),
            EXEMPTION_EXCLUDED => Some(Self::Excluded),
            _ => None,
        }
    }
}

#[derive(Debug, Clone, Default)]
pub struct StudentOverride {
    pub makeup_due_at: Option<DateTime<Utc>>,
    pub waive_late_penalty: bool,
    pub exempt: bool,
    pub exemption_mode: Option<String>,
}

impl StudentOverride {
    pub fn exemption_mode(&self) -> Option<ExemptionMode> {
        self.exemption_mode
            .as_deref()
            .and_then(ExemptionMode::parse)
    }
}

#[derive(Debug, Clone)]
pub struct ScoringSubmission {
    pub id: i32,
    pub status: String,
    pub submitted_at: DateTime<Utc>,
    pub is_late: bool,
    pub late_days: i32,
}

impl ScoringSubmission {
    pub fn is_accepted(&self) -> bool {
        self.status == SUBMISSION_STATUS_ACCEPTED
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ProblemGrade {
    pub auto_score: i32,
    pub final_score: i32,
    pub late_days: i32,
    pub is_late: bool,
    pub exempt: bool,
    pub exemption_mode: Option<String>,
    pub included_in_total: bool,
}

pub fn effective_deadline(
    due_at: Option<DateTime<Utc>>,
    makeup_due_at: Option<DateTime<Utc>>,
) -> Option<DateTime<Utc>> {
    match (due_at, makeup_due_at) {
        (Some(due), Some(makeup)) => Some(due.max(makeup)),
        (Some(due), None) => Some(due),
        (None, Some(makeup)) => Some(makeup),
        (None, None) => None,
    }
}

pub fn submission_window_end(
    due_at: Option<DateTime<Utc>>,
    makeup_due_at: Option<DateTime<Utc>>,
    late_policy: &str,
    late_grace_hours: i32,
) -> Option<DateTime<Utc>> {
    let deadline = effective_deadline(due_at, makeup_due_at)?;
    if late_policy == LATE_POLICY_ALLOW {
        Some(deadline + Duration::hours(i64::from(late_grace_hours.max(0))))
    } else {
        Some(deadline)
    }
}

pub fn raw_late_days(submitted_at: DateTime<Utc>, due_at: Option<DateTime<Utc>>) -> i32 {
    let Some(due_at) = due_at else {
        return 0;
    };
    if submitted_at <= due_at {
        return 0;
    }
    let seconds = (submitted_at - due_at).num_seconds();
    ((seconds + 86_399) / 86_400).max(0) as i32
}

pub fn effective_late_days(
    raw_days: i32,
    submitted_at: DateTime<Utc>,
    student_override: Option<&StudentOverride>,
) -> i32 {
    if let Some(over) = student_override
        && over.waive_late_penalty
        && over
            .makeup_due_at
            .is_some_and(|makeup| submitted_at <= makeup)
    {
        return 0;
    }
    raw_days.max(0)
}

pub fn late_deduction(points: i32, late_days: i32, per_day: i32, cap: i32) -> i32 {
    if points <= 0 || late_days <= 0 {
        return 0;
    }
    let percent =
        (i64::from(late_days.max(0)) * i64::from(per_day.max(0))).min(i64::from(cap.clamp(0, 100)));
    if percent <= 0 {
        return 0;
    }
    let deduction = (i64::from(points) * percent + 99) / 100;
    deduction.clamp(0, i64::from(points)) as i32
}

pub fn select_scoring_submission(
    policy: ScoringPolicy,
    submissions: &[ScoringSubmission],
) -> Option<&ScoringSubmission> {
    let valid = || {
        submissions
            .iter()
            .filter(|submission| submission.status != SUBMISSION_STATUS_INTERNAL_ERROR)
    };
    match policy {
        ScoringPolicy::Highest | ScoringPolicy::FirstAc => valid()
            .filter(|submission| submission.is_accepted())
            .min_by_key(|submission| (submission.submitted_at, submission.id)),
        ScoringPolicy::Last => {
            valid().max_by_key(|submission| (submission.submitted_at, submission.id))
        }
    }
}

#[allow(clippy::too_many_arguments)]
pub fn compute_problem_grade(
    points: i32,
    submissions: &[ScoringSubmission],
    manual_score: Option<i32>,
    student_override: Option<&StudentOverride>,
    scoring_policy: ScoringPolicy,
    late_penalty_per_day: i32,
    late_penalty_cap: i32,
) -> ProblemGrade {
    let scoring = select_scoring_submission(scoring_policy, submissions);
    let raw_days = scoring.map_or(0, |submission| submission.late_days);
    let late_days = scoring.map_or(0, |submission| {
        effective_late_days(raw_days, submission.submitted_at, student_override)
    });
    let is_late = scoring.is_some_and(|submission| submission.is_late) && late_days > 0;
    let deduction = late_deduction(points, late_days, late_penalty_per_day, late_penalty_cap);
    let auto_score = if scoring.is_some_and(ScoringSubmission::is_accepted) {
        (points - deduction).max(0)
    } else {
        0
    };

    let exempt = student_override.is_some_and(|over| over.exempt);
    let exemption_mode = student_override.and_then(StudentOverride::exemption_mode);
    let included_in_total =
        manual_score.is_some() || !(exempt && exemption_mode == Some(ExemptionMode::Excluded));

    let final_score = if let Some(manual) = manual_score {
        manual.clamp(0, points.max(0))
    } else if exempt {
        match exemption_mode {
            Some(ExemptionMode::FullScore) => points,
            Some(ExemptionMode::Excluded) => 0,
            None => auto_score,
        }
    } else {
        auto_score
    };

    ProblemGrade {
        auto_score,
        final_score,
        late_days,
        is_late,
        exempt,
        exemption_mode: exemption_mode.map(|mode| match mode {
            ExemptionMode::FullScore => EXEMPTION_FULL_SCORE.to_owned(),
            ExemptionMode::Excluded => EXEMPTION_EXCLUDED.to_owned(),
        }),
        included_in_total,
    }
}

pub fn is_score_visible(
    visibility: ScoreVisibility,
    now: DateTime<Utc>,
    due_at: Option<DateTime<Utc>>,
    grades_published_at: Option<DateTime<Utc>>,
) -> bool {
    match visibility {
        ScoreVisibility::AfterPublish => grades_published_at.is_some(),
        ScoreVisibility::AfterDue => due_at.is_some_and(|due| now >= due),
        ScoreVisibility::During => true,
    }
}

pub fn is_solution_visible(
    now: DateTime<Utc>,
    due_at: Option<DateTime<Utc>>,
    solutions_published_at: Option<DateTime<Utc>>,
) -> bool {
    solutions_published_at.is_some() && due_at.is_some_and(|due| now >= due)
}

pub fn attempts_exhausted(used: i64, limit: Option<i32>) -> bool {
    limit.is_some_and(|limit| used >= i64::from(limit))
}

#[cfg(test)]
mod tests {
    use chrono::{TimeZone, Utc};

    use super::{
        ExemptionMode, SCORING_FIRST_AC, SCORING_HIGHEST, SCORING_LAST, ScoreVisibility,
        ScoringPolicy, ScoringSubmission, StudentOverride, compute_problem_grade,
        effective_deadline, effective_late_days, is_score_visible, is_solution_visible,
        late_deduction, raw_late_days, select_scoring_submission, submission_window_end,
    };

    fn at(day: u32, hour: u32) -> chrono::DateTime<Utc> {
        Utc.with_ymd_and_hms(2026, 11, day, hour, 0, 0)
            .single()
            .unwrap()
    }

    fn submission(
        id: i32,
        status: &str,
        submitted_at: chrono::DateTime<Utc>,
        late_days: i32,
    ) -> ScoringSubmission {
        ScoringSubmission {
            id,
            status: status.to_owned(),
            submitted_at,
            is_late: late_days > 0,
            late_days,
        }
    }

    #[test]
    fn late_days_round_up_to_whole_days() {
        assert_eq!(raw_late_days(at(2, 10), Some(at(2, 10))), 0);
        assert_eq!(raw_late_days(at(2, 11), Some(at(2, 10))), 1);
        assert_eq!(raw_late_days(at(3, 11), Some(at(2, 10))), 2);
    }

    #[test]
    fn grace_hours_extend_window_without_removing_penalty() {
        let due = at(2, 10);
        assert_eq!(
            submission_window_end(Some(due), None, "allow", 24),
            Some(at(3, 10))
        );
        assert_eq!(raw_late_days(at(3, 9), Some(due)), 1);
    }

    #[test]
    fn makeup_deadline_can_waive_late_days() {
        let used_at = at(4, 10);
        let student_override = StudentOverride {
            makeup_due_at: Some(at(5, 10)),
            waive_late_penalty: true,
            ..Default::default()
        };
        assert_eq!(effective_late_days(2, used_at, Some(&student_override)), 0);

        let student_override = StudentOverride {
            makeup_due_at: Some(at(5, 10)),
            waive_late_penalty: false,
            ..Default::default()
        };
        assert_eq!(effective_late_days(2, used_at, Some(&student_override)), 2);
    }

    #[test]
    fn late_deduction_caps_and_rounds_up() {
        assert_eq!(late_deduction(100, 1, 10, 50), 10);
        assert_eq!(late_deduction(100, 9, 10, 50), 50);
        assert_eq!(late_deduction(15, 1, 10, 50), 2);
        assert_eq!(late_deduction(100, 0, 10, 50), 0);
    }

    #[test]
    fn highest_and_first_ac_pick_earliest_accepted() {
        let rows = vec![
            submission(3, "accepted", at(3, 10), 1),
            submission(1, "wrong_answer", at(1, 10), 0),
            submission(2, "accepted", at(2, 10), 0),
        ];
        assert_eq!(
            select_scoring_submission(ScoringPolicy::Highest, &rows).map(|row| row.id),
            Some(2)
        );
        assert_eq!(
            select_scoring_submission(ScoringPolicy::FirstAc, &rows).map(|row| row.id),
            Some(2)
        );
    }

    #[test]
    fn last_ignores_system_errors() {
        let rows = vec![
            submission(1, "accepted", at(1, 10), 0),
            submission(2, "internal_error", at(2, 10), 0),
        ];
        assert_eq!(
            select_scoring_submission(ScoringPolicy::Last, &rows).map(|row| row.id),
            Some(1)
        );
    }

    #[test]
    fn manual_score_beats_late_penalty_and_exemption() {
        let rows = vec![submission(1, "accepted", at(3, 10), 1)];
        let grade = compute_problem_grade(
            100,
            &rows,
            Some(88),
            Some(&StudentOverride {
                exempt: true,
                exemption_mode: Some("excluded".to_owned()),
                ..Default::default()
            }),
            ScoringPolicy::Highest,
            10,
            50,
        );
        assert_eq!(grade.auto_score, 90);
        assert_eq!(grade.final_score, 88);
        assert!(grade.included_in_total);
    }

    #[test]
    fn exemption_full_score_and_excluded() {
        let full = compute_problem_grade(
            100,
            &[],
            None,
            Some(&StudentOverride {
                exempt: true,
                exemption_mode: Some("full_score".to_owned()),
                ..Default::default()
            }),
            ScoringPolicy::Highest,
            10,
            50,
        );
        assert_eq!(full.final_score, 100);
        assert!(full.included_in_total);

        let excluded = compute_problem_grade(
            100,
            &[],
            None,
            Some(&StudentOverride {
                exempt: true,
                exemption_mode: Some("excluded".to_owned()),
                ..Default::default()
            }),
            ScoringPolicy::Highest,
            10,
            50,
        );
        assert_eq!(excluded.final_score, 0);
        assert!(!excluded.included_in_total);
        assert_eq!(excluded.exemption_mode, Some("excluded".to_owned()));
    }

    #[test]
    fn score_visibility_modes() {
        let due = at(2, 10);
        let now = at(1, 10);
        assert!(!is_score_visible(
            ScoreVisibility::AfterPublish,
            now,
            Some(due),
            None
        ));
        assert!(!is_score_visible(
            ScoreVisibility::AfterDue,
            now,
            Some(due),
            None
        ));
        assert!(is_score_visible(
            ScoreVisibility::AfterDue,
            at(3, 10),
            Some(due),
            None
        ));
        assert!(is_score_visible(
            ScoreVisibility::During,
            now,
            Some(due),
            None
        ));
    }

    #[test]
    fn solutions_require_published_and_due() {
        let due = at(2, 10);
        assert!(!is_solution_visible(at(3, 10), Some(due), None));
        assert!(!is_solution_visible(at(1, 10), Some(due), Some(at(1, 10))));
        assert!(is_solution_visible(at(3, 10), Some(due), Some(at(3, 10))));
    }

    #[test]
    fn effective_deadline_takes_later_value() {
        assert_eq!(
            effective_deadline(Some(at(2, 10)), Some(at(5, 10))),
            Some(at(5, 10))
        );
        assert_eq!(
            effective_deadline(Some(at(5, 10)), Some(at(2, 10))),
            Some(at(5, 10))
        );
    }

    #[test]
    fn scoring_policy_parses_known_values() {
        assert_eq!(
            ScoringPolicy::parse(SCORING_HIGHEST),
            Some(ScoringPolicy::Highest)
        );
        assert_eq!(
            ScoringPolicy::parse(SCORING_LAST),
            Some(ScoringPolicy::Last)
        );
        assert_eq!(
            ScoringPolicy::parse(SCORING_FIRST_AC),
            Some(ScoringPolicy::FirstAc)
        );
        assert_eq!(ScoreVisibility::parse("unknown"), None);
        assert_eq!(
            ExemptionMode::parse("full_score"),
            Some(ExemptionMode::FullScore)
        );
    }
}
