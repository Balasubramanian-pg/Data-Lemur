-- Solved on: PostgreSQL 14
SELECT user_id FROM emails A
LEFT JOIN (
  SELECT * FROM texts WHERE signup_action = 'Confirmed'
) B on A.email_id = B.email_id
WHERE DATE_PART('day',B.action_date - A.signup_date) = 1;