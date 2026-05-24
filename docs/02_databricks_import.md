# Databricks 取り込みメモ

## 基本フロー

```text
local file
  ↓
Databricks upload
  ↓
Spark DataFrame
  ↓
Delta Table
  ↓
SQL
```

## 進め方

1. `data/` 配下のファイルを Databricks ワークスペースへアップロードする
2. notebook で `spark.read` により読み込む
3. `saveAsTable` で Delta Table として保存する
4. SQL で件数と内容を確認する

## 参照ファイル

- `databricks/notebooks/01_import_csv.ipynb`
- `databricks/notebooks/02_import_json.ipynb`
- `databricks/notebooks/03_import_parquet.ipynb`
- `databricks/notebooks/04_query_tables.ipynb`
- `databricks/sql/create_tables.sql`
- `databricks/sql/select_examples.sql`
