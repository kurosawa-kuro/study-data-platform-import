# study-data-platform-import

ローカルの CSV / JSON / Parquet ファイルを Databricks / Snowflake / Redshift / BigQuery に取り込み、テーブル化と SQL 確認を行うための基礎学習リポジトリ。

## 1. 目的

本リポジトリの目的は、Databricks / Snowflake / Redshift / BigQuery の高度機能を網羅することではない。

まずはローカルにあるデータファイルをそれぞれのサービスに取り込み、テーブルとして扱える状態にする。

到達目標は以下。

- ローカルファイルを Databricks に取り込める
- ローカルファイルを Snowflake に取り込める
- ローカルファイルを Redshift に取り込める
- ローカルファイルを BigQuery に取り込める
- 取り込んだデータをテーブル化できる
- SQL で中身を確認できる
- 4 サービスの基本的な違いを比較できる

## 2. 学習スコープ

### 対象にすること

- CSV ファイルの取り込み
- JSON ファイルの取り込み
- Parquet ファイルの取り込み
- Databricks でのテーブル作成
- Snowflake でのテーブル作成
- Redshift でのテーブル作成
- BigQuery でのテーブル作成
- SQL による確認
- JOIN / GROUP BY などの基本クエリ
- Databricks / Snowflake / Redshift / BigQuery の概念比較

### 対象にしないこと

初期段階では以下は扱わない。

- GCS / S3 / Azure Blob の継続連携設計
- Snowpipe
- Databricks Auto Loader
- Databricks Workflows
- Delta Live Tables
- Unity Catalog の詳細設計
- Snowflake Streams / Tasks
- Dynamic Tables
- Redshift Spectrum / Glue Catalog 連携
- BigQuery Dataform / BigLake
- dbt
- Airflow / Dagster
- 本番レベルの権限設計
- コスト最適化の詳細
- MLflow / Feature Store の詳細

## 3. 前提

データのスタート地点はクラウドではなく、ローカルファイルとする。

```text
local file
  ↓
Databricks / Snowflake / Redshift / BigQuery
  ↓
table
  ↓
SQL
```

GCS や S3 を起点にしない理由は、学習対象が増えすぎるため。

今回の主眼は、クラウド間連携ではなく、各サービスの基本的な取り込み体験である。

## 4. 使用するサンプルデータ

### ディレクトリ

```text
data/
  customers.csv
  orders.csv
  events.json
  products.parquet
```

### customers.csv

顧客マスタ。

```csv
customer_id,name,age,prefecture,signup_date
1,Taro Yamada,34,Tokyo,2024-01-10
2,Hanako Sato,28,Osaka,2024-02-15
3,Ken Suzuki,41,Hokkaido,2024-03-20
```

### orders.csv

注文データ。

```csv
order_id,customer_id,amount,ordered_at
101,1,12000,2024-04-01 10:30:00
102,1,8000,2024-04-03 14:20:00
103,2,15000,2024-04-05 09:10:00
104,3,6000,2024-04-07 18:45:00
```

### events.json

ユーザー行動ログ。

```json
[
  {
    "event_id": "e001",
    "customer_id": 1,
    "event_type": "page_view",
    "page": "/products/1",
    "timestamp": "2024-04-01T09:00:00"
  },
  {
    "event_id": "e002",
    "customer_id": 1,
    "event_type": "purchase",
    "page": "/checkout",
    "timestamp": "2024-04-01T10:30:00"
  },
  {
    "event_id": "e003",
    "customer_id": 2,
    "event_type": "page_view",
    "page": "/products/2",
    "timestamp": "2024-04-05T08:55:00"
  }
]
```

### products.parquet

商品マスタ。

| product_id | product_name | category   | price |
| ---------- | ------------ | ---------- | ----- |
| 1          | Keyboard     | peripheral | 12000 |
| 2          | Mouse        | peripheral | 5000  |
| 3          | Monitor      | display    | 30000 |

## 5. ディレクトリ構成

```text
study-data-platform-import/
  README.md
  data/
    customers.csv
    orders.csv
    events.json
    products.parquet
  databricks/
    notebooks/
      01_import_csv.ipynb
      02_import_json.ipynb
      03_import_parquet.ipynb
      04_query_tables.ipynb
    sql/
      create_tables.sql
      select_examples.sql
  snowflake/
    sql/
      01_create_database_schema.sql
      02_create_tables.sql
      03_copy_into.sql
      04_select_examples.sql
  redshift/
    sql/
      01_create_schema.sql
      02_create_tables.sql
      03_copy_commands.sql
      04_select_examples.sql
  bigquery/
    sql/
      01_create_dataset.sql
      02_create_tables.sql
      03_load_commands.md
      04_select_examples.sql
  docs/
    01_goal.md
    02_databricks_import.md
    03_snowflake_import.md
    04_redshift_import.md
    05_bigquery_import.md
    06_comparison.md
```

## 6. Databricks 側の学習内容

Databricks では、ローカルファイルをアップロードし、Notebook 上で読み込み、Delta Table として保存する。

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

学習ポイントは以下。

- ファイルアップロード
- Spark DataFrame としての読み込み
- 一時ビュー作成
- Delta Table として保存
- SQL での確認

CSV の最小例:

```python
df_customers = spark.read.option("header", True).csv("/FileStore/data/customers.csv")
df_customers.write.mode("overwrite").saveAsTable("customers")
```

## 7. Snowflake 側の学習内容

Snowflake では、ローカルファイルを internal stage にアップロードし、`COPY INTO` でテーブルへロードする。

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

学習ポイントは以下。

- Database 作成
- Schema 作成
- Table 作成
- File Format 作成
- Internal Stage へのアップロード
- `COPY INTO` によるロード
- SQL での確認

## 8. 共通 SQL 確認

4 サービスのすべてで、同じような SQL を実行する。

顧客別注文集計:

```sql
SELECT
  c.customer_id,
  c.name,
  c.prefecture,
  COUNT(o.order_id) AS order_count,
  COALESCE(SUM(o.amount), 0) AS total_amount
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY
  c.customer_id,
  c.name,
  c.prefecture
ORDER BY
  total_amount DESC;
```

都道府県別売上:

```sql
SELECT
  c.prefecture,
  COUNT(o.order_id) AS order_count,
  SUM(o.amount) AS total_amount
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
GROUP BY
  c.prefecture
ORDER BY
  total_amount DESC;
```

## 9. プラットフォーム別の学習内容

### 9.1 Redshift 側

Redshift では、ローカルファイルを S3 に一時配置して `COPY` でロードする学習フローを取る。

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

学習ポイントは以下。

- Schema 作成
- Table 作成
- `COPY` によるロード
- JSON / Parquet ロード時のフォーマット指定
- SQL での確認

### 9.2 BigQuery 側

BigQuery では、ローカルファイルをテーブル作成時に直接 load するか、UI / `bq load` でロードする。

```text
local file
  ↓
BigQuery load job
  ↓
table
  ↓
SQL
```

学習ポイントは以下。

- Dataset 作成
- Table 作成
- `bq load` または UI ロード
- JSON / Parquet のスキーマ取り込み
- SQL での確認

## 10. 4 サービスの比較観点

| 観点 | Databricks | Snowflake | Redshift | BigQuery |
| ---- | ---------- | ---------- | -------- | -------- |
| 主な用途 | Lakehouse / Spark / ML / 大規模変換 | DWH / SQL / BI / 分析基盤 | AWS 中心の DWH | GCP 標準の DWH |
| 基本操作 | Notebook 中心 | SQL 中心 | SQL 中心 | SQL と load job |
| 取り込みの流れ | File → DataFrame → Delta Table | File → Stage → COPY INTO → Table | File → S3 → COPY → Table | File → Load Job → Table |
| テーブル形式 | Delta Table | Snowflake Table | Redshift Table | BigQuery Table |
| 初学で見るべき点 | `spark.read`, `saveAsTable` | Stage と `COPY INTO` | `COPY` と IAM / Role | Load Job と schema autodetect |
| 得意領域 | 大規模処理、ML、特徴量加工 | 分析 SQL、権限管理、BI 連携 | AWS との統合、既存 DWH 置換 | GCP 分析基盤、サーバレス集計 |

## 11. 完了条件

### 最低完了ライン

以下ができれば初回学習として完了。

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

### 追加完了ライン

余力があれば以下も行う。

- JSON を取り込む
- Parquet を取り込む
- Databricks で Delta Table として保存する
- Snowflake で File Format を分けて管理する
- Redshift で JSON / Parquet のロード差分を確認する
- BigQuery で autodetect と明示 schema の違いを確認する
- 4 サービスの違いをメモする

## 12. やらない判断

このリポジトリでは、最初から本番データ基盤を作らない。

やらない理由は、学習の主眼がぼやけるため。

特に以下は後回しにする。

```text
GCS 連携
S3 連携
IAM 設計
Snowpipe
Auto Loader
Redshift Spectrum
BigLake
dbt
Airflow
BI 接続
Feature Store
MLflow
```

まずは、ローカルファイルからテーブル化する感覚を掴む。

## 13. 次の拡張候補

この基礎学習が完了した後、以下に拡張できる。

### Phase 2: Cloud Storage 連携

```text
local file
  ↓
GCS / S3
  ↓
Databricks / Snowflake / Redshift / BigQuery
  ↓
table
```

### Phase 3: バッチ連携

```text
Python batch
  ↓
CSV / JSON / Parquet 生成
  ↓
Databricks / Snowflake
  ↓
SQL 確認
```

### Phase 4: ML 接続

```text
Databricks / Snowflake table
  ↓
Python で取得
  ↓
特徴量作成
  ↓
LightGBM 学習
```

### Phase 5: 4 サービス詳細比較

```text
same local data
  ↓
Databricks
Snowflake
Redshift
BigQuery
  ↓
同じ SQL で比較
```

## 14. 判断メモ

現時点では、4 サービスを専門的に使い倒すことは目的ではない。

目的は、以下の比較感覚を得ること。

```text
BigQuery:
  GCP 標準の DWH

Snowflake:
  クラウド横断の DWH

Databricks:
  Spark / Lakehouse / ML 寄りのデータ基盤

Redshift:
  AWS 中心の DWH
```

そのため、最初の学習範囲はインポートと SQL 確認に絞る。

この絞り込みにより、短時間で両者の基本構造を掴む。
