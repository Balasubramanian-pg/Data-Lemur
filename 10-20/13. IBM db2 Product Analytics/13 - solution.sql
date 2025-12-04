-- Solved on: PostgreSQL 14
SELECT
  query_counts AS unique_queries
  , COUNT(employee_id)
FROM (
  SELECT 
    A.employee_id
    , COUNT(DISTINCT query_id) query_counts
  FROM employees A
  LEFT JOIN queries B 
    ON A.employee_id = B.employee_id
    AND DATE_PART('year', query_starttime) = '2023'
    AND DATE_PART('month', query_starttime) BETWEEN 7 AND 9
  GROUP BY A.employee_id
) user_query_counts
GROUP BY query_counts
ORDER BY 1