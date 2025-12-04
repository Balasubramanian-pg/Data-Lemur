-- Solved on: PostgreSQL 14
SELECT 
  drug
  , total_sales - cogs as total_profit
FROM pharmacy_sales
ORDER BY 2 DESC
LIMIT 3;