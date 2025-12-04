-- Solved on: PostgreSQL 14
SELECT 
  e.employee_id
  , e.name as employee_name 
FROM employee e
LEFT JOIN employee m on e.manager_id = m.employee_id
WHERE e.salary > m.salary;