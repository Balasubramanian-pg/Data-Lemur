-- Solved on: PostgreSQL 14
WITH cte_orders_ranked AS (
  SELECT 
    *
    , DENSE_RANK() OVER (ORDER BY order_occurrences DESC) as rnk 
  FROM items_per_order
)

SELECT 
  item_count AS mode
FROM cte_orders_ranked
WHERE rnk = 1;