-- Solved on: PostgreSQL 14
SELECT MAX(salary)
FROM employee
WHERE salary <> (SELECT MAX(salary) FROM employee);