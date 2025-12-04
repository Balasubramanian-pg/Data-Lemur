-- Solved on: PostgreSQL 14
WITH cte_user_transactions_ranked AS (
  SELECT 
    *
    , DENSE_RANK() OVER (
        PARTITION BY user_id 
        ORDER BY transaction_date DESC
      ) transaction_rank
  FROM user_transactions
)

SELECT 
  transaction_date
  , user_id
  , COUNT(product_id)
FROM cte_user_transactions_ranked 
WHERE transaction_rank = 1
GROUP BY transaction_date, user_id;