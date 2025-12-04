-- Solved on: PostgreSQL 14
WITH cte_numbered_measurements AS (
  SELECT 
    CAST(measurement_time AS date) AS date
    , ROW_NUMBER() OVER (
      PARTITION BY CAST(measurement_time AS date)
      ORDER BY measurement_time
    ) AS measurement_num
    , measurement_value
  FROM measurements
)

SELECT date
  , SUM(CASE WHEN measurement_num % 2 <> 0 THEN measurement_value ELSE 0 END) odd_sum
  , SUM(CASE WHEN measurement_num % 2 = 0 THEN measurement_value ELSE 0 END) even_sum
FROM cte_numbered_measurements
GROUP BY date
ORDER BY 1;