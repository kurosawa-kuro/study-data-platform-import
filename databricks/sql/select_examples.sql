USE study_import;

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
  c.prefecture,
  COUNT(o.order_id) AS order_count,
  SUM(o.amount) AS total_amount
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
GROUP BY c.prefecture
ORDER BY total_amount DESC;
