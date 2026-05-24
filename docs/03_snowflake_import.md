# Snowflake 取り込みメモ

## 基本フロー

```text
local file
  ↓
Snowflake internal stage
  ↓
COPY INTO
  ↓
table
  ↓
SQL
```

## 実行順

1. `snowflake/sql/01_create_database_schema.sql`
2. `snowflake/sql/02_create_tables.sql`
3. `snowflake/sql/03_copy_into.sql`
4. `snowflake/sql/04_select_examples.sql`

## 補足

- CSV は `SKIP_HEADER = 1` を使う
- JSON は `TYPE = JSON` の file format を使う
- Parquet は `TYPE = PARQUET` の file format を使う
- ローカルファイルのアップロードは Snowsight の stage UI か `PUT` コマンドで行う
