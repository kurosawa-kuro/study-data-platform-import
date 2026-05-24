USE DATABASE STUDY_DB;
USE SCHEMA IMPORT_BASIC;

-- Upload sample files to the stages before running these COPY commands.

COPY INTO customers
FROM @local_csv_stage/customers.csv
FILE_FORMAT = (FORMAT_NAME = csv_format);

COPY INTO orders
FROM @local_csv_stage/orders.csv
FILE_FORMAT = (FORMAT_NAME = csv_format);

COPY INTO events_raw
FROM @local_json_stage/events.json
FILE_FORMAT = (FORMAT_NAME = json_format);

COPY INTO products
FROM @local_parquet_stage/products.parquet
FILE_FORMAT = (FORMAT_NAME = parquet_format)
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
