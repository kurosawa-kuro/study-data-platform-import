# 目的

このリポジトリは、ローカルファイルを Databricks / Snowflake / Redshift / BigQuery に取り込み、テーブル化して SQL で確認するまでの最小フローを学ぶためのもの。

## 最低完了ライン

- `customers.csv` を Databricks に取り込める
- `orders.csv` を Databricks に取り込める
- `customers.csv` を Snowflake に取り込める
- `orders.csv` を Snowflake に取り込める
- `customers.csv` を Redshift に取り込める
- `orders.csv` を Redshift に取り込める
- `customers.csv` を BigQuery に取り込める
- `orders.csv` を BigQuery に取り込める
- 4 サービスで `SELECT * FROM customers` が実行できる
- 4 サービスで `customers` と `orders` の JOIN が実行できる

## スコープ外

- GCS / S3 / Azure Blob 連携
- Snowpipe / Auto Loader / Workflows
- Redshift Spectrum / BigLake
- dbt / Airflow / Dagster
- 本番向け権限設計やコスト最適化
