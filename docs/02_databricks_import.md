# Databricks 取り込みメモ

## 最重要前提

Databricks の学習は、**Databricks Free Edition のみ利用可能**という制約を前提にする。

そのため、Databricks Free Trial や通常の有償 workspace を前提にした説明を、このリポジトリの Databricks 主導線にしてはいけない。

また、リポジトリ内の Python バッチ実装は、**Free Edition での実動未確認**である。

## 現時点の主導線

Databricks でまず優先するのは以下。

1. Free Edition へログインする
2. SQL Warehouse が利用できることを確認する
3. ローカルから SQL Warehouse へ疎通確認する
4. SQL 実行で確認できる範囲を把握する

## 基本フロー

```text
Databricks Free Edition UI
  ↓
SQL Warehouse
  ↓
local SQL connectivity test
  ↓
SELECT 1
  ↓
確認
```

## 補足

`src/study_data_platform_import/databricks/cli.py` と `scripts/databricks_import.sh` は、将来の検証候補として残している参考実装である。

Free Edition で使えると確認できるまでは、Databricks 学習の主導線として扱わない。

一方で、`src/study_data_platform_import/databricks/sql_connectivity.py` と `scripts/databricks_sql_test.sh` は、Free Edition 確実ルートとして扱う。

## 進め方

1. Free Edition の UI で SQL Warehouse を確認する
2. `Server hostname` `HTTP path` `token` を取得する
3. `./scripts/databricks_sql_test.sh` で `SELECT 1` を通す
4. `./scripts/databricks_sql_test.sh --mode catalog` を試す
5. `./scripts/databricks_sql_test.sh --mode ctas` を試す
6. その後に必要なら Python バッチを個別検証する

## 参照ファイル

- `databricks/README.md`
- `src/study_data_platform_import/databricks/sql_connectivity.py`
- `scripts/databricks_sql_test.sh`
- `src/study_data_platform_import/databricks/cli.py`
- `scripts/databricks_import.sh`
- `databricks/sql/create_tables.sql`
- `databricks/sql/select_examples.sql`
