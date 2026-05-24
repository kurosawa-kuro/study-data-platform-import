# Databricks 取り込みメモ

## 基本フロー

```text
local file
  ↓
local Python batch
  ↓
Databricks Connect
  ↓
Delta Table
  ↓
SQL
```

## 進め方

1. ローカルで `pip install -e .` を実行する
2. Databricks Connect の認証を設定する
3. `./scripts/databricks_import.sh csv` を実行する
4. `./scripts/databricks_import.sh query` で確認する
5. 必要に応じて `json` `parquet` `all` を実行する

## 参照ファイル

- `src/study_data_platform_import/databricks/cli.py`
- `scripts/databricks_import.sh`
- `databricks/sql/create_tables.sql`
- `databricks/sql/select_examples.sql`
