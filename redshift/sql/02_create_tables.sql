SET search_path TO import_basic;

CREATE TABLE IF NOT EXISTS customers (
  customer_id INTEGER,
  name VARCHAR(100),
  age INTEGER,
  prefecture VARCHAR(100),
  signup_date DATE
);

CREATE TABLE IF NOT EXISTS orders (
  order_id INTEGER,
  customer_id INTEGER,
  amount INTEGER,
  ordered_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS events (
  event_id VARCHAR(50),
  customer_id INTEGER,
  event_type VARCHAR(50),
  page VARCHAR(255),
  event_timestamp TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
  product_id INTEGER,
  product_name VARCHAR(100),
  category VARCHAR(100),
  price INTEGER
);
