use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize)]
pub struct SaveDraftRequest {
    pub language: String,
    pub code: String,
}

#[derive(Debug, Serialize)]
pub struct DraftView {
    pub language: String,
    pub code: String,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct DraftResponse {
    pub draft: Option<DraftView>,
}
