-- Solved on: PostgreSQL 14
SELECT 
  DATE_PART('month', submit_date) mth
  , product_id
  , ROUND(AVG(stars), 2)
FROM reviews
GROUP BY product_id, DATE_PART('month', submit_date)
ORDER BY 1,2;