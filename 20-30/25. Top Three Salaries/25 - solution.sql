-- Solved on: PostgreSQL 14
SELECT 
  department_name, name, salary
FROM (
  SELECT 
    B.department_name
    , A.name
    , A.salary
    , DENSE_RANK() OVER (
      PARTITION BY department_name 
      ORDER BY salary DESC
    ) AS salary_rank
  FROM employee A
  LEFT JOIN department B ON A.department_id = B.department_id
) ranked_salaries
WHERE salary_rank <= 3
ORDER BY department_name, salary DESC, name;