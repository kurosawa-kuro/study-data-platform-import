# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## このリポジトリの性質

ローカルの CSV / JSON / Parquet ファイルを **Databricks** / **Snowflake** / **Redshift** / **BigQuery** に取り込み、テーブル化して SQL で確認する **基礎学習リポジトリ**。各プラットフォームの「取り込み体験」と基本構造を比較理解することが目的であり、本番データ基盤ではない。完全な仕様は [README.md](./README.md) を参照。

状態: **inception 段階**。リポジトリには確定したサンプルデータ ([data/](data/)) とディレクトリ骨組みのみ存在し、notebook / SQL の中身はこれから書く。`databricks/` `snowflake/` `docs/` 配下は空に近い。

## 最重要: スコープ境界（禁止リスト）

このリポジトリの本質は「学習対象を絞ること」。README §2「対象にしないこと」・§11「やらない判断」に挙がった機能を**勝手に追加しない**。ベストプラクティスや拡張を理由に持ち込むのも不可。明示指示が無い限り、以下は範囲外:

- GCS / S3 / Azure Blob 連携の常設化
- Snowpipe / Databricks Auto Loader / Workflows / Delta Live Tables
- Unity Catalog の詳細設計、Snowflake Streams / Tasks / Dynamic Tables
- Redshift Spectrum / Glue Catalog、BigLake / Dataform
- dbt / Airflow / Dagster
- 本番レベルの権限設計、コスト最適化、MLflow / Feature Store

「次の拡張候補」(README §13: Cloud Storage 連携 → バッチ → ML → 4 サービス詳細比較) は **将来 Phase であり現スコープ外**。基礎学習 (README §11 完了条件) が終わるまで着手しない。

## ビルド / テスト / lint

**ローカルのビルド・テスト・lint システムは無い。** コードは notebook と SQL で構成され、実行は各プラットフォーム上で対話的に行う:

- **Databricks 側**: ファイルを upload → notebook で `spark.read...` → `saveAsTable` で Delta Table 化 → SQL 確認。notebook は `databricks/notebooks/*.ipynb`、SQL は `databricks/sql/*.sql`。
- **Snowflake 側**: internal stage に upload → `COPY INTO` でロード → SQL 確認。SQL は `snowflake/sql/*.sql`（`01_create_database_schema` → `02_create_tables` → `03_copy_into` → `04_select_examples` の順に実行）。
- **Redshift 側**: 一時 S3 に upload → `COPY` でロード → SQL 確認。SQL は `redshift/sql/*.sql`（`01_create_schema` → `02_create_tables` → `03_copy_commands` → `04_select_examples` の順に実行）。
- **BigQuery 側**: dataset / table を作成 → UI または `bq load` でロード → SQL 確認。SQL / メモは `bigquery/sql/*` を参照。

サンプルデータ ([data/products.parquet](data/products.parquet)) を再生成する場合のみ Python (pyarrow/pandas) を使う。それ以外でローカルランタイムを前提にした実装は持ち込まない。

## 取り込みフロー（2 プラットフォームの対比）

両者で同一ローカルファイルを取り込み、同じ SQL（JOIN / GROUP BY 集計、README §8）を流して比較するのが学習の軸:

```
Databricks:  local file → upload → Spark DataFrame → Delta Table → SQL
Snowflake:   local file → internal stage → COPY INTO → Table → SQL
Redshift:    local file → S3 → COPY → Table → SQL
BigQuery:    local file → load job → Table → SQL
```

実装・doc を追加するときは、この「同じデータ・同じ SQL を各サービスで再現し差分を観察する」構成を崩さない。`docs/06_comparison.md` が比較観点の置き場。

## サンプルデータ

[data/](data/) は README §4 で型・値まで確定済みの fixture。`customers`(顧客マスタ) ↔ `orders`(注文) を `customer_id` で JOIN、`events.json`(行動ログ)、`products.parquet`(商品マスタ) という構成。**値・スキーマを変えない**（README が単一ソース。変更時は README も同時更新）。`.gitignore` は data/ を意図的に除外しない。

## 言語

ドキュメント・コミットメッセージ・PR タイトルは **日本語が canonical**。コード内 identifier・SQL・テーブル名は英語。
