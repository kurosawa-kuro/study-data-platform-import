# BigQuery load コマンド例

ローカルファイルからのロードは、BigQuery UI または `bq load` を使う。

## CSV

```bash
bq load \
  --source_format=CSV \
  --skip_leading_rows=1 \
  study_import.customers \
  ./data/customers.csv \
  customer_id:INT64,name:STRING,age:INT64,prefecture:STRING,signup_date:DATE
```

```bash
bq load \
  --source_format=CSV \
  --skip_leading_rows=1 \
  study_import.orders \
  ./data/orders.csv \
  order_id:INT64,customer_id:INT64,amount:INT64,ordered_at:TIMESTAMP
```

## JSON

`events.json` は配列形式なので、BigQuery へ直接ロードする場合は newline-delimited JSON へ変換してから使う。

```bash
jq -c '.[]' ./data/events.json > /tmp/events_ndjson.json

bq load \
  --source_format=NEWLINE_DELIMITED_JSON \
  study_import.events \
  /tmp/events_ndjson.json \
  event_id:STRING,customer_id:INT64,event_type:STRING,page:STRING,event_timestamp:TIMESTAMP
```

`timestamp` キーを `event_timestamp` に合わせる場合は、事前に整形してからロードする。

## Parquet

```bash
bq load \
  --source_format=PARQUET \
  study_import.products \
  ./data/products.parquet
```
