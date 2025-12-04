-- Solved on: PostgreSQL 14
SELECT
  age_bucket
  , ROUND((open_time * 100.0 / (open_time + send_time)), 2) open_perc
  , ROUND((send_time * 100.0 / (open_time + send_time)), 2) send_perc
FROM (
  SELECT 
    age_bucket
    , SUM(CASE WHEN activity_type = 'open' THEN time_spent ELSE 0 END) AS open_time
    , SUM(CASE WHEN activity_type = 'send' THEN time_spent ELSE 0 END) AS send_time
  FROM activities A
  LEFT JOIN age_breakdown B ON A.user_id = B.user_id
  GROUP BY age_bucket
) TOTALS;