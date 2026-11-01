use std::collections::BTreeMap;

use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Debug, Deserialize)]
pub struct UpdatePreferencesRequest {
    pub preferences: BTreeMap<String, Value>,
}

#[derive(Debug, Serialize)]
pub struct PreferencesResponse {
    pub preferences: BTreeMap<String, Value>,
}
