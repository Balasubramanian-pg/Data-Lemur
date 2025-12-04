-- Solved on: PostgreSQL 14
WITH cte_product_wise_spend AS (
  SELECT 
    category
    , product
    , SUM (spend) total_spend
  FROM product_spend
  WHERE DATE_PART('year',transaction_date) = 2022
  GROUP BY category, product
)

, cte_ranked_listing AS (
  SELECT *
  , ROW_NUMBER () OVER (PARTITION BY category ORDER BY total_spend DESC) rnk
  FROM cte_product_wise_spend
)

SELECT category, product, total_spend
FROM cte_ranked_listing WHERE rnk <= 2;