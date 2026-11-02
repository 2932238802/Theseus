use std::collections::BTreeMap;

use serde_json::Value;
use sqlx::PgPool;

use crate::{
    common::error::AppError,
    models::preference::{PreferencesResponse, UpdatePreferencesRequest},
};

const MAX_PREFERENCES: usize = 64;
const MAX_SHORTCUT_BINDINGS: usize = 64;
const MAX_SHORTCUT_KEY_LEN: usize = 64;
const MAX_SHORTCUT_VALUE_LEN: usize = 32;

const APPEARANCE_THEMES: &[&str] = &[
    "light",
    "dark",
    "system",
    "one-dark",
    "monokai",
    "dracula",
    "nord",
    "tokyo-night",
    "github-dark",
    "github-light",
    "solarized-light",
];
const EDITOR_THEMES: &[&str] = &[
    "system",
    "theseus-light",
    "theseus-dark",
    "one-dark",
    "monokai",
    "dracula",
    "nord",
    "tokyo-night",
    "github-light",
    "github-dark",
    "atom-one-light",
    "solarized-light",
];
const EDITOR_TAB_SIZES: &[i64] = &[2, 4, 8];
const LANGUAGES: &[&str] = &["cpp", "java", "python", "javascript"];
const PROBLEM_PAGE_SIZES: &[i64] = &[20, 50, 100];

pub const PREFERENCE_KEYS: &[&str] = &[
    "appearance.theme",
    "editor.theme",
    "editor.font_size",
    "editor.tab_size",
    "editor.completion",
    "editor.ai_assistant",
    "editor.ai_context_notice",
    "problems.language",
    "problems.page_size",
    "shortcuts.bindings",
];

fn string_in(value: &Value, allowed: &[&str]) -> bool {
    value.as_str().is_some_and(|text| allowed.contains(&text))
}

fn int_in(value: &Value, allowed: &[i64]) -> bool {
    value
        .as_i64()
        .is_some_and(|number| allowed.contains(&number))
}

fn valid_shortcut_bindings(value: &Value) -> bool {
    let Some(bindings) = value.as_object() else {
        return false;
    };
    if bindings.len() > MAX_SHORTCUT_BINDINGS {
        return false;
    }
    bindings.iter().all(|(key, binding)| {
        key.len() <= MAX_SHORTCUT_KEY_LEN
            && (binding.is_null()
                || binding
                    .as_str()
                    .is_some_and(|text| text.len() <= MAX_SHORTCUT_VALUE_LEN))
    })
}

fn validate_value(key: &str, value: &Value) -> bool {
    match key {
        "appearance.theme" => string_in(value, APPEARANCE_THEMES),
        "editor.theme" => string_in(value, EDITOR_THEMES),
        "editor.font_size" => value
            .as_i64()
            .is_some_and(|number| (10..=32).contains(&number)),
        "editor.tab_size" => value.as_str() == Some("auto") || int_in(value, EDITOR_TAB_SIZES),
        "editor.completion" => value.is_boolean(),
        "editor.ai_assistant" => value.is_boolean(),
        "editor.ai_context_notice" => value.is_boolean(),
        "problems.language" => string_in(value, LANGUAGES),
        "problems.page_size" => int_in(value, PROBLEM_PAGE_SIZES),
        "shortcuts.bindings" => valid_shortcut_bindings(value),
        _ => false,
    }
}

fn validate_preferences(preferences: &BTreeMap<String, Value>) -> Result<(), AppError> {
    if preferences.len() > MAX_PREFERENCES {
        return Err(AppError::BadRequest("偏好项过多".to_owned()));
    }
    for (key, value) in preferences {
        if !PREFERENCE_KEYS.contains(&key.as_str()) {
            return Err(AppError::BadRequest(format!("不支持的偏好项：{key}")));
        }
        if !validate_value(key, value) {
            return Err(AppError::BadRequest(format!("偏好项格式不正确：{key}")));
        }
    }
    Ok(())
}

pub async fn get_preferences(pool: &PgPool, user_id: i32) -> Result<PreferencesResponse, AppError> {
    let rows: Vec<(String, Value)> =
        sqlx::query_as("SELECT key, value FROM user_preferences WHERE user_id = $1 ORDER BY key")
            .bind(user_id)
            .fetch_all(pool)
            .await
            .map_err(AppError::Database)?;
    Ok(PreferencesResponse {
        preferences: rows.into_iter().collect(),
    })
}

pub async fn update_preferences(
    pool: &PgPool,
    user_id: i32,
    request: UpdatePreferencesRequest,
) -> Result<PreferencesResponse, AppError> {
    validate_preferences(&request.preferences)?;
    let mut tx = pool.begin().await.map_err(AppError::Database)?;
    for (key, value) in &request.preferences {
        sqlx::query(
            "INSERT INTO user_preferences (user_id, key, value) \
             VALUES ($1, $2, $3) \
             ON CONFLICT (user_id, key) DO UPDATE \
                 SET value = EXCLUDED.value, updated_at = CURRENT_TIMESTAMP",
        )
        .bind(user_id)
        .bind(key)
        .bind(value)
        .execute(&mut *tx)
        .await
        .map_err(AppError::Database)?;
    }
    tx.commit().await.map_err(AppError::Database)?;
    get_preferences(pool, user_id).await
}

pub async fn delete_preference(
    pool: &PgPool,
    user_id: i32,
    key: &str,
) -> Result<PreferencesResponse, AppError> {
    if !PREFERENCE_KEYS.contains(&key) {
        return Err(AppError::BadRequest("不支持的偏好项".to_owned()));
    }
    sqlx::query("DELETE FROM user_preferences WHERE user_id = $1 AND key = $2")
        .bind(user_id)
        .bind(key)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
    get_preferences(pool, user_id).await
}

pub async fn clear_preferences(
    pool: &PgPool,
    user_id: i32,
) -> Result<PreferencesResponse, AppError> {
    sqlx::query("DELETE FROM user_preferences WHERE user_id = $1")
        .bind(user_id)
        .execute(pool)
        .await
        .map_err(AppError::Database)?;
    Ok(PreferencesResponse {
        preferences: BTreeMap::new(),
    })
}
