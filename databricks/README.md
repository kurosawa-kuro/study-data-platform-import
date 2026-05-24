# Databricks README

Databricks パートは notebook 主体ではなく、ローカル Python から `Databricks Connect` 経由で実行する前提に切り替える。

対象は以下のファイル。

- `src/study_data_platform_import/databricks/cli.py`
- `scripts/databricks_import.sh`
- `data/customers.csv`
- `data/orders.csv`
- `data/events.json`
- `data/products.parquet`

## 1. この手順のゴール

以下をローカル Python から実行できれば十分。

- `customers.csv` と `orders.csv` を Databricks に取り込める
- `events.json` と `products.parquet` も追加で取り込める
- `study_import` database にテーブルを作れる
- JOIN クエリを実行して結果を確認できる

## 2. 全体の流れ

```text
local file
  ↓
local Python batch
  ↓
Databricks Connect
  ↓
Databricks table
  ↓
SQL / query result
```

## 3. 前提

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

## 4. 実装構成

Databricks 用のメイン実装は Python CLI。

```text
src/study_data_platform_import/databricks/cli.py
scripts/databricks_import.sh
```

この CLI は以下を行う。

- ローカル `data/` を読む
- pandas で小さいサンプルデータを読み込む
- `DatabricksSession` で Databricks Connect 接続を作る
- Spark DataFrame に変換する
- Delta Table として保存する
- サンプルクエリを実行する

## 5. 実行コマンド

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

## 6. データの読み方

この構成では `spark.read.csv("/home/...")` のように Databricks 側からローカルパスを直接読ませない。

代わりにローカル Python で読む。

- CSV: `pandas.read_csv`
- JSON: `json.load` + `pandas.DataFrame`
- Parquet: `pandas.read_parquet`

その後 `spark.createDataFrame(...)` で Databricks 側の DataFrame に変換する。

この形なら、ML Engineer / MLOps Engineer の普段のローカル開発フローに近い。

## 7. 実行順

最初は以下の順が分かりやすい。

1. `./scripts/databricks_import.sh csv`
2. `./scripts/databricks_import.sh query`
3. `./scripts/databricks_import.sh json`
4. `./scripts/databricks_import.sh parquet`
5. `./scripts/databricks_import.sh all`

## 8. notebook について

`databricks/notebooks/` は補助的な学習資材として残しているが、主導線ではない。

主導線は以下。

- `src/` に Python コードを書く
- `scripts/` からローカル実行する
- 必要に応じて Databricks Job / bundle へ発展させる

## 9. つまずきやすい点

### Databricks Connect の認証で失敗する

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

## 10. 次の拡張

この後の自然な発展先は以下。

- Databricks CLI を使った認証標準化
- Databricks bundle の追加
- Job 化してリモート実行
- CI/CD からのデプロイ
