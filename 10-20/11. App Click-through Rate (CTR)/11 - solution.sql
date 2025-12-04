-- Solved on: PostgreSQL 14
SELECT 
  app_id
  , ROUND(
      (COUNT(CASE WHEN event_type = 'click' THEN event_type END)) * 100.0
      / COUNT(CASE WHEN event_type = 'impression' THEN event_type END)
    , 2) AS ctr
FROM events
WHERE DATE_PART('year',timestamp) = 2022
GROUP BY app_id;