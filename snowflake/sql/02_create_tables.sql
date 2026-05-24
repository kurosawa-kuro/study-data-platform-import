USE DATABASE STUDY_DB;
USE SCHEMA IMPORT_BASIC;

CREATE OR REPLACE TABLE customers (
  customer_id INTEGER,
  name STRING,
  age INTEGER,
  prefecture STRING,
  signup_date DATE
);

CREATE OR REPLACE TABLE orders (
  order_id INTEGER,
  customer_id INTEGER,
  amount INTEGER,
  ordered_at TIMESTAMP_NTZ
);

CREATE OR REPLACE TABLE events_raw (
  payload VARIANT
);

CREATE OR REPLACE TABLE products (
  product_id INTEGER,
  product_name STRING,
  category STRING,
  price INTEGER
);

CREATE OR REPLACE FILE FORMAT csv_format
  TYPE = CSV
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1;

CREATE OR REPLACE FILE FORMAT json_format
  TYPE = JSON;

CREATE OR REPLACE FILE FORMAT parquet_format
  TYPE = PARQUET;

CREATE OR REPLACE STAGE local_csv_stage
  FILE_FORMAT = csv_format;

CREATE OR REPLACE STAGE local_json_stage
  FILE_FORMAT = json_format;

CREATE OR REPLACE STAGE local_parquet_stage
  FILE_FORMAT = parquet_format;
