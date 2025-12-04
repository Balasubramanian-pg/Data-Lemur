-- Solved on: PostgreSQL 14
SELECT 
  manufacturer
  , CONCAT('$',ROUND(SUM(total_sales) / 1000000, 0), ' million')
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer ASC;
