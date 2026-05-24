# 4 サービス比較メモ

| 観点 | Databricks | Snowflake | Redshift | BigQuery |
| ---- | ---------- | ---------- | -------- | -------- |
| 主な操作単位 | Notebook / Spark | SQL / Stage | SQL / COPY | SQL / Load Job |
| 取り込みの起点 | DataFrame | Stage | S3 経由 `COPY` | load job |
| テーブル保存 | Delta Table | Snowflake Table | Redshift Table | BigQuery Table |
| 初学で重要な概念 | `spark.read`, `saveAsTable` | `FILE FORMAT`, `STAGE`, `COPY INTO` | `COPY`, IAM Role | dataset, `bq load`, autodetect |
| 得意領域 | 大規模変換、ML、Lakehouse | 分析 SQL、DWH、BI 連携 | AWS 統合、既存 DWH 移行 | GCP 分析基盤、サーバレス |

## 同じデータで見るポイント

- `customers` と `orders` の JOIN 結果が一致するか
- `events.json` を structured / semi-structured としてどう扱うか
- `products.parquet` のロード手数がどれだけ違うか
