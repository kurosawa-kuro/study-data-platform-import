CREATE OR REPLACE TABLE `study_import.customers` (
  customer_id INT64,
  name STRING,
  age INT64,
  prefecture STRING,
  signup_date DATE
);

CREATE OR REPLACE TABLE `study_import.orders` (
  order_id INT64,
  customer_id INT64,
  amount INT64,
  ordered_at TIMESTAMP
);

CREATE OR REPLACE TABLE `study_import.events` (
  event_id STRING,
  customer_id INT64,
  event_type STRING,
  page STRING,
  event_timestamp TIMESTAMP
);

CREATE OR REPLACE TABLE `study_import.products` (
  product_id INT64,
  product_name STRING,
  category STRING,
  price INT64
);
