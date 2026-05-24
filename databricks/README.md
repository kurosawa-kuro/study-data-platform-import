# Databricks README

## 最重要

この Databricks パートは、**Databricks Free Edition のみ利用可能**という制約を最上位前提にする。

Free Trial や通常の有償 workspace は前提にしない。

また、現時点の Python バッチ実装は **Free Edition で実動未確認** である。  
したがって、`Databricks Connect` ベースのローカル Python 実行を、Databricks 学習の主導線として扱ってはいけない。

Databricks 学習の主導線は、まず以下に限定する。

- Free Edition のワークスペース UI
- Free Edition で提供される Serverless SQL Warehouse
- UI 上での SQL 実行確認
- ローカルからの SQL Warehouse 疎通確認

Databricks パートは notebook 主体ではなく、将来的にはローカル Python 実行も検証対象に含めるが、**Free Edition で確認できるまでは参考実装扱い**とする。

対象は以下のファイル。

- `src/study_data_platform_import/databricks/sql_connectivity.py`
- `scripts/databricks_sql_test.sh`
- `src/study_data_platform_import/databricks/cli.py`
- `scripts/databricks_import.sh`
- `data/customers.csv`
- `data/orders.csv`
- `data/events.json`
- `data/products.parquet`

## 1. このドキュメントの位置づけ

この README は 2 つを分けて扱う。

- Free Edition で今すぐ信頼してよい主導線
- 将来検証する Python バッチ参考実装

まず優先するのは前者である。

## 2. この手順のゴール

Free Edition 確実ルートの最初の成功条件は、**ローカルから SQL Warehouse へ接続し、`SELECT 1` が返ること**。

このリポジトリでは、まず次のコマンドの成功を目標にする。

```bash
./scripts/databricks_sql_test.sh
```

その先の拡張として、以下をローカル Python から実行できれば十分。

- `customers.csv` と `orders.csv` を Databricks に取り込める
- `events.json` と `products.parquet` も追加で取り込める
- `study_import` database にテーブルを作れる
- JOIN クエリを実行して結果を確認できる

ただし、これは **Databricks Connect が Free Edition で使えることを確認できた場合に限る**。

Free Edition で今すぐ優先するゴールは以下。

- SQL Warehouse に接続できる
- SQL を実行できる
- ローカルから `SELECT 1` を返せる
- Free Edition の制約を踏まえて、どこまでできるかを切り分けられる

## 3. Free Edition での主導線

```text
Databricks Free Edition login
  ↓
SQL Warehouse
  ↓
local SQL connectivity test
  ↓
SELECT 1
  ↓
動作確認
```

## 4. Free Edition で強く意識すること

- Serverless compute のみ
- SQL Warehouse は小さい構成に制限される
- 使える機能が有償 workspace より狭い
- Databricks Connect やローカル開発フローは、そのまま使えると決めつけない

## 5. Free Edition 確実ルート

### 5.1 依存を入れる

```bash
cd /home/ubuntu/repos/study-data-platform-import
python3 -m venv .venv
source .venv/bin/activate
pip install -e .
```

### 5.2 Databricks 画面から接続情報を取得する

`SQL Warehouses` の `Connection details` から次を控える。

- `Server hostname`
- `HTTP path`

さらに Personal Access Token を作成する。

### 5.3 環境変数を設定する

```bash
export DATABRICKS_SERVER_HOSTNAME="dbc-xxxxxxxx.cloud.databricks.com"
export DATABRICKS_HTTP_PATH="/sql/1.0/warehouses/xxxxxxxxxxxxxxxx"
export DATABRICKS_TOKEN="dapi...."
```

### 5.4 疎通確認を実行する

```bash
./scripts/databricks_sql_test.sh
```

成功すると、`Databricks SQL connectivity succeeded.` と `SELECT 1` の結果が表示される。

### 5.5 任意の SQL を流す

```bash
./scripts/databricks_sql_test.sh --query "SELECT current_catalog()"
```

## 6. Python バッチ実装の位置づけ

以下はリポジトリ内に存在するが、**Free Edition 対応済みとは見なさない**。

- `src/study_data_platform_import/databricks/cli.py`
- `scripts/databricks_import.sh`

これらは **参考実装 / 将来の検証候補** である。

## 7. Python バッチを試す場合の前提

ローカル環境で以下を使えるようにする。

- Python 3.10+
- Databricks Free Edition へのログイン
- Databricks Connect 用の認証設定

依存インストール:

```bash
cd /home/ubuntu/repos/study-data-platform-import
python3 -m venv .venv
source .venv/bin/activate
pip install -e .
```

この段階でも、Free Edition で動く保証はない。

## 8. 実装構成

Databricks 用の主実装は、まず SQL 疎通確認。

```text
src/study_data_platform_import/databricks/sql_connectivity.py
scripts/databricks_sql_test.sh
```

この実装は以下を行う。

- SQL Warehouse へ接続する
- `SELECT 1` を実行する
- ローカルから Free Edition に到達できるか確認する

参考実装として以下も保持する。

```text
src/study_data_platform_import/databricks/cli.py
scripts/databricks_import.sh
```

参考 CLI は以下を行う。

- ローカル `data/` を読む
- pandas で小さいサンプルデータを読み込む
- `DatabricksSession` で Databricks Connect 接続を作る
- Spark DataFrame に変換する
- Delta Table として保存する
- サンプルクエリを実行する

## 9. 実行コマンド

疎通確認:

```bash
./scripts/databricks_sql_test.sh
```

任意クエリ:

```bash
./scripts/databricks_sql_test.sh --query "SELECT 1"
```

以下は参考実装:

CSV だけ:

```bash
./scripts/databricks_import.sh csv
```

JSON だけ:

```bash
./scripts/databricks_import.sh json
```

Parquet だけ:

```bash
./scripts/databricks_import.sh parquet
```

全部まとめて:

```bash
./scripts/databricks_import.sh all
```

クエリだけ:

```bash
./scripts/databricks_import.sh query
```

database 名を変えたい場合:

```bash
./scripts/databricks_import.sh all --database study_import_dev
```

## 10. データの読み方

この構成では `spark.read.csv("/home/...")` のように Databricks 側からローカルパスを直接読ませない。

代わりにローカル Python で読む。

- CSV: `pandas.read_csv`
- JSON: `json.load` + `pandas.DataFrame`
- Parquet: `pandas.read_parquet`

その後 `spark.createDataFrame(...)` で Databricks 側の DataFrame に変換する。

この形は、ML Engineer / MLOps Engineer の普段のローカル開発フローに近い。

ただし、**Free Edition でそのまま成立するとは限らない**。

## 11. 実行順

最初は以下の順が分かりやすい。

1. `./scripts/databricks_sql_test.sh`
2. `./scripts/databricks_sql_test.sh --query "SELECT current_catalog()"`
3. その後に必要なら Python バッチ参考実装を個別検証する

## 12. notebook について

`databricks/notebooks/` は補助的な学習資材として残しているが、主導線ではない。

主導線は以下。

- `src/` に Python コードを書く
- `scripts/` からローカル実行する
- 必要に応じて Databricks Job / bundle へ発展させる

## 13. Free Edition での第一優先

まず確認すべきなのは以下。

1. Free Edition にログインできる
2. SQL Warehouse が見える
3. `./scripts/databricks_sql_test.sh` で `SELECT 1` が返る

この 3 つが確認できてから、必要に応じて次を検討する。

- SQL を増やす
- UI での操作を増やす
- Python バッチ参考実装を別途検証する

## 14. つまずきやすい点

### SQL Warehouse へ接続できない

以下を確認する。

- Warehouse が起動しているか
- `Server hostname` が正しいか
- `HTTP path` が正しいか
- `DATABRICKS_TOKEN` が正しいか

### Databricks Connect の認証で失敗する

Free Edition では、そもそもこの経路が前提として成立していない可能性を考える。

まず Databricks Connect の認証設定を確認する。

CLI 側のコードは `DatabricksSession.builder.getOrCreate()` を使うため、接続情報がローカルに設定されている前提。

### ローカルファイルはあるのに Spark が読めない

この構成では Spark にローカルファイルパスを直接読ませない。

ローカルで pandas が読めるかを先に確認する。

### Parquet だけ失敗する

`pyarrow` が不足していることが多い。

以下で依存を入れ直す。

```bash
pip install -e .
```

## 15. 次の拡張

この後の自然な発展先は以下。

- Databricks CLI を使った認証標準化
- Databricks bundle の追加
- Job 化してリモート実行
- CI/CD からのデプロイ
