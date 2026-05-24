# BigQuery 取り込みメモ

## 基本フロー

```text
local file
  ↓
BigQuery load job
  ↓
table
  ↓
SQL
```

## 実行順

1. `bigquery/sql/01_create_dataset.sql`
2. `bigquery/sql/02_create_tables.sql`
3. `bigquery/sql/03_load_commands.md`
4. `bigquery/sql/04_select_examples.sql`

## 補足

- ローカルファイルは UI か `bq load` で取り込める
- CSV は schema を明示する方が学習しやすい
- JSON は newline-delimited JSON に変換するか、UI load で調整する
- Parquet は schema 自動解釈を確認しやすい
