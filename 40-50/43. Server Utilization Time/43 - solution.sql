-- Solved on: PostgreSQL 14
-- Assumptions: 
--    - Only two statuses are possible for any server
--    - Start will always be followed by stop with the next record
WITH cte_next_status AS (
  SELECT 
    server_id
    , status_time AS start_time
    , session_status
    , LEAD(status_time) OVER (
        PARTITION BY server_id 
        ORDER BY status_time
      ) stop_time
  FROM server_utilization
)

, cte_uptime AS (
  SELECT 
    *,stop_time - start_time AS uptime
  FROM cte_next_status
  WHERE session_status = 'start'
)

SELECT DATE_PART('days',JUSTIFY_HOURS(SUM(uptime))) total_uptime_days
FROM cte_uptime;
