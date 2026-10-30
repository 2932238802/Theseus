//! 最小 CSV 解析，只服务教学数据导入。
//!
//! 支持双引号包裹、字段内逗号与换行、`""` 转义、CRLF 与 UTF-8 BOM；
//! 空行与以 `#` 开头的注释行会被忽略。

use crate::common::error::AppError;

const MAX_COLUMNS: usize = 10;
const MAX_FIELD_CHARS: usize = 320;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct CsvRecord {
    /// 记录起始的物理行号，从 1 开始，保留给导入结果定位。
    pub line: usize,
    pub cells: Vec<String>,
}

/// 解析 CSV 文本。超过 `max_records` 条有效记录时返回 400，避免一次导入过大。
pub fn parse(input: &str, max_records: usize) -> Result<Vec<CsvRecord>, AppError> {
    let input = input.strip_prefix('\u{feff}').unwrap_or(input);
    let normalized = input.replace("\r\n", "\n").replace('\r', "\n");
    let mut records = Vec::new();
    let mut cells: Vec<String> = Vec::new();
    let mut field = String::new();
    let mut field_quoted = false;
    let mut in_quotes = false;
    let mut line = 1usize;
    let mut record_line = 1usize;

    let mut chars = normalized.chars().peekable();
    while let Some(ch) = chars.next() {
        if in_quotes {
            match ch {
                '"' if chars.peek() == Some(&'"') => {
                    chars.next();
                    field.push('"');
                }
                '"' => in_quotes = false,
                '\n' => {
                    field.push('\n');
                    line += 1;
                }
                _ => field.push(ch),
            }
            continue;
        }
        match ch {
            '"' if field.is_empty() && !field_quoted => {
                in_quotes = true;
                field_quoted = true;
            }
            ',' => {
                cells.push(std::mem::take(&mut field));
                field_quoted = false;
            }
            '\n' => {
                cells.push(std::mem::take(&mut field));
                field_quoted = false;
                push_record(&mut records, &mut cells, record_line, max_records)?;
                line += 1;
                record_line = line;
            }
            _ => field.push(ch),
        }
    }

    if in_quotes {
        return Err(AppError::BadRequest(format!(
            "CSV 第 {record_line} 行的引号未闭合"
        )));
    }
    if !field.is_empty() || !cells.is_empty() || field_quoted {
        cells.push(field);
        push_record(&mut records, &mut cells, record_line, max_records)?;
    }
    Ok(records)
}

fn push_record(
    records: &mut Vec<CsvRecord>,
    cells: &mut Vec<String>,
    line: usize,
    max_records: usize,
) -> Result<(), AppError> {
    let cells = std::mem::take(cells);
    let trimmed: Vec<String> = cells.iter().map(|cell| cell.trim().to_owned()).collect();
    if trimmed.iter().all(String::is_empty) {
        return Ok(());
    }
    if trimmed[0].starts_with('#') {
        return Ok(());
    }
    if trimmed.len() > MAX_COLUMNS {
        return Err(AppError::BadRequest(format!(
            "CSV 第 {line} 行超过 {MAX_COLUMNS} 列"
        )));
    }
    if trimmed
        .iter()
        .any(|cell| cell.chars().count() > MAX_FIELD_CHARS)
    {
        return Err(AppError::BadRequest(format!(
            "CSV 第 {line} 行的字段超过 {MAX_FIELD_CHARS} 个字符"
        )));
    }
    if records.len() >= max_records {
        return Err(AppError::BadRequest("CSV 行数超过上限".to_owned()));
    }
    records.push(CsvRecord {
        line,
        cells: trimmed,
    });
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_plain_rows_and_skips_blank_lines() {
        let records = parse("alice,bob\n\ncarol\r\n# note\n", 10).unwrap();
        assert_eq!(records.len(), 2);
        assert_eq!(records[0].cells, vec!["alice", "bob"]);
        assert_eq!(records[1].line, 3);
        assert_eq!(records[1].cells, vec!["carol"]);
    }

    #[test]
    fn handles_quoted_commas_and_escaped_quotes() {
        let records = parse("\"a,b\",\"say \"\"hi\"\"\"\n", 10).unwrap();
        assert_eq!(records[0].cells, vec!["a,b", "say \"hi\""]);
    }

    #[test]
    fn strips_bom_and_keeps_multiline_fields() {
        let records = parse("\u{feff}name\n\"line1\nline2\"\n", 10).unwrap();
        assert_eq!(records[0].cells, vec!["name"]);
        assert_eq!(records[1].cells, vec!["line1\nline2"]);
        assert_eq!(records[1].line, 2);
    }

    #[test]
    fn rejects_unclosed_quote() {
        let error = parse("\"alice\n", 10).unwrap_err();
        assert!(matches!(error, AppError::BadRequest(_)));
    }

    #[test]
    fn enforces_record_limit() {
        let error = parse("a\nb\nc\n", 2).unwrap_err();
        assert!(matches!(error, AppError::BadRequest(_)));
    }
}
