-- Solved on: PostgreSQL 14
SELECT 
  user_id,spend,transaction_date 
FROM (
  SELECT 
    *
    , ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) t_no
  FROM transactions
) t
WHERE t.t_no = 3;