SET search_path TO import_basic;

SELECT *
FROM customers
LIMIT 10;

SELECT *
FROM orders
LIMIT 10;

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

SELECT
  prefecture,
  COUNT(order_id) AS order_count,
  SUM(amount) AS total_amount
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
GROUP BY prefecture
ORDER BY total_amount DESC;
