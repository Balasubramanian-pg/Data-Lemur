-- Solved on: PostgreSQL 14
SELECT
  DATE_PART('month',curr_month.event_date) AS month
  , COUNT(DISTINCT prev_month.USER_ID) AS monthly_active_users
FROM user_actions curr_month
LEFT JOIN user_actions prev_month
  ON curr_month.user_id = prev_month.user_id
  AND DATE_PART('year',prev_month.event_date) = DATE_PART('year', curr_month.event_date - INTERVAL '1 month')
  AND DATE_PART('month',prev_month.event_date) = DATE_PART('month', curr_month.event_date - INTERVAL '1 month')
WHERE 
  DATE_PART('year',curr_month.event_date) = 2022
  AND DATE_PART('month',curr_month.event_date) = 7
GROUP BY DATE_PART('month',curr_month.event_date);