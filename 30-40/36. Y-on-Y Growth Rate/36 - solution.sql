-- Solved on: PostgreSQL 14
WITH cte_product_yearly_spend AS (
  SELECT 
    product_id
    , DATE_PART('year', transaction_date) AS year
    , SUM(spend) curr_year_spend
  FROM user_transactions
  GROUP BY product_id, DATE_PART('year', transaction_date)
)

SELECT 
  curr_year.year
  , curr_year.product_id
  , curr_year.curr_year_spend
  , prev_year.curr_year_spend AS prev_year_spend
  , ROUND ((curr_year.curr_year_spend - prev_year.curr_year_spend) * 100.0
    / prev_year.curr_year_spend, 2) AS yoy_rate
FROM cte_product_yearly_spend AS curr_year
LEFT JOIN cte_product_yearly_spend AS prev_year
  ON curr_year.product_id = prev_year.product_id
  AND curr_year.year - 1 = prev_year.year
ORDER BY 2, 1;