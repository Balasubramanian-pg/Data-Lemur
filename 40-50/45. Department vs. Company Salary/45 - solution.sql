-- Solved on: PostgreSQL 14
WITH cte_company_avg AS (
  SELECT 
    DATE_PART('year', payment_date) y
    , DATE_PART('month', payment_date) m
    , AVG(amount) avg
  FROM employee A
  LEFT JOIN salary B on A.employee_id = B.employee_id
  GROUP BY DATE_PART('year', payment_date), DATE_PART('month', payment_date)
)

, cte_department_avg AS (
  SELECT 
    department_id
    , DATE_PART('year', payment_date) y
    , DATE_PART('month', payment_date) m
    , AVG(amount) avg
  FROM employee A
  LEFT JOIN salary B on A.employee_id = B.employee_id
  GROUP BY department_id, DATE_PART('year', payment_date), DATE_PART('month', payment_date)
)

SELECT 
  department_id 
  , CONCAT(RIGHT(CONCAT('0',A.m),2),'-',A.y)
  , CASE WHEN A.avg = B.avg THEN 'same'
    WHEN A.avg > B.avg THEN 'higher'
    ELSE 'lower'
    END AS comparison
FROM cte_department_avg A
LEFT JOIN cte_company_avg B 
  on A.y = B.y
  AND A.m = B.m
WHERE A.m = 3
ORDER BY 1;