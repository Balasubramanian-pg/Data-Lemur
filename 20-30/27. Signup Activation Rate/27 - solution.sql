-- Solved on: PostgreSQL 14
SELECT 
  -- count(DISTINCT A.user_id) AS total_users_emailed
  -- , count(DISTINCT B.text_id) AS total_users_confirmed
  ROUND(count(DISTINCT B.text_id) * 1.0 / count(DISTINCT A.user_id), 2)
FROM emails A
LEFT JOIN texts B 
  ON A.email_id = B.email_id 
  AND B.signup_action = 'Confirmed'
;