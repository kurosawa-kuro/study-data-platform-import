SELECT *
FROM `study_import.customers`
LIMIT 10;

SELECT *
FROM `study_import.orders`
LIMIT 10;

SELECT
  c.customer_id,
  c.name,
  c.prefecture,
  COUNT(o.order_id) AS order_count,
  COALESCE(SUM(o.amount), 0) AS total_amount
FROM `study_import.customers` c
LEFT JOIN `study_import.orders` o
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
FROM `study_import.orders` o
JOIN `study_import.customers` c
  ON o.customer_id = c.customer_id
GROUP BY c.prefecture
ORDER BY total_amount DESC;
