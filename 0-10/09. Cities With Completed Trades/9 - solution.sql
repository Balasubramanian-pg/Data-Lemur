-- Solved on: PostgreSQL 14
SELECT 
  city
  , COUNT(DISTINCT order_id) AS total_orders
FROM trades A
LEFT JOIN users B ON A.user_id = B.user_id 
WHERE status = 'Completed'
GROUP BY city
ORDER BY 2 DESC
LIMIT 3;