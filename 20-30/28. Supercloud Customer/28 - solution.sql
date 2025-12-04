-- Solved on: PostgreSQL 14
SELECT 
  A.customer_id
FROM customer_contracts A
LEFT JOIN products B ON A.product_id = B.product_id
GROUP BY customer_id
HAVING 
  COUNT(distinct B.product_category) = (
    SELECT COUNT(DISTINCT product_category) FROM products
);