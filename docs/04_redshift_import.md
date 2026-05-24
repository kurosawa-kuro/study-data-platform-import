# Redshift 取り込みメモ

## 基本フロー

```text
local file
  ↓
temporary S3 upload
  ↓
Redshift COPY
  ↓
table
  ↓
SQL
```

## 実行順

1. `redshift/sql/01_create_schema.sql`
2. `redshift/sql/02_create_tables.sql`
3. `redshift/sql/03_copy_commands.sql`
4. `redshift/sql/04_select_examples.sql`

## 補足

- Redshift の `COPY` は通常 S3 を経由する
- CSV は `IGNOREHEADER 1` を使う
- JSON は `FORMAT AS JSON 'auto'` で開始できる
- Parquet は `FORMAT AS PARQUET` を使う
