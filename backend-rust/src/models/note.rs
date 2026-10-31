use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use sqlx::FromRow;

#[derive(Debug, Deserialize)]
pub struct SaveNoteRequest {
    pub body_md: String,
}

#[derive(Debug, FromRow, Serialize)]
pub struct NoteView {
    pub body_md: String,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct NoteResponse {
    pub note: Option<NoteView>,
}

#[derive(Debug, Deserialize, Default)]
pub struct NoteListQuery {
    pub page: Option<u32>,
    pub size: Option<u32>,
}

#[derive(Debug, Serialize)]
pub struct NoteListItem {
    pub problem_id: i32,
    pub title: String,
    pub difficulty: String,
    pub excerpt: String,
    pub updated_at: DateTime<Utc>,
}

#[derive(Debug, Serialize)]
pub struct NoteListResponse {
    pub total: i64,
    pub page: u32,
    pub size: u32,
    pub notes: Vec<NoteListItem>,
}
