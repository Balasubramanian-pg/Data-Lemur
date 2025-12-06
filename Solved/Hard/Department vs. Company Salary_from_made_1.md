---
Company:
- Amazon
Difficulty: Easy
Created: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Department vs. Company Salary_from_made_1
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Hard/Department vs. Company
  Salary_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---

You work as a data analyst for a FAANG company that tracks employee salaries over time. The company wants to understand how the average salary in each department compares to the company's overall average salary each month.

Write a query to compare the average salary of employees in each department to the company's average salary for March 2024. Return the comparison result as 'higher', 'lower', or 'same' for each department. Display the department ID, payment month (in MM-YYYY format), and the comparison result.

### `employee` Schema:

|column_name|type|description|
|---|---|---|
|employee_id|integer|The unique ID of the employee.|
|name|string|The full name of the employee.|
|salary|integer|The salary of the employee.|
|department_id|integer|The department ID of the employee.|
|manager_id|integer|The manager ID of the employee.|

### `employee` Example Input:

|employee_id|name|salary|department_id|manager_id|
|---|---|---|---|---|
|1|Emma Thompson|3800|1|6|
|2|Daniel Rodriguez|2230|1|7|
|3|Olivia Smith|7000|1|8|
|5|Sophia Martinez|1750|1|11|

### `salary` Schema:

|column_name|type|description|
|---|---|---|
|salary_id|integer|A unique ID for each salary record.|
|employee_id|integer|The unique ID of the employee.|
|amount|integer|The salary of the employee.|
|payment_date|datetime|The date and time when the salary was paid to the employee.|

### `salary` Example Input:

|salary_id|employee_id|amount|payment_date|
|---|---|---|---|
|1|1|3800|01/31/2024 00:00:00|
|2|2|2230|01/31/2024 00:00:00|
|3|3|7000|01/31/2024 00:00:00|
|4|4|6800|01/31/2024 00:00:00|
|5|5|1750|01/31/2024 00:00:00|

### Example Output:

|department_id|payment_date|comparison|
|---|---|---|
|1|01-2024|lower|

The output indicates that the average salary of Department 1 is lower than the company's average salary for January 2024.

The dataset you are querying against may have different input & output - **this is just an example**!

Here’s the SQL query to compare each department’s average salary to the company’s average salary for **March 2024**, returning whether it’s `'higher'`, `'lower'`, or `'same'`:

```sql
SELECT 
  e.department_id,
  TO_CHAR(s.payment_date, 'MM-YYYY') AS payment_date,
  CASE
    WHEN AVG(s.amount) > overall.avg_salary THEN 'higher'
    WHEN AVG(s.amount) < overall.avg_salary THEN 'lower'
    ELSE 'same'
  END AS comparison
FROM salary s
JOIN employee e ON s.employee_id = e.employee_id
JOIN (
    SELECT 
      AVG(amount) AS avg_salary
    FROM salary
    WHERE DATE_TRUNC('month', payment_date) = DATE '2024-03-01'
) overall ON TRUE
WHERE DATE_TRUNC('month', s.payment_date) = DATE '2024-03-01'
GROUP BY e.department_id, TO_CHAR(s.payment_date, 'MM-YYYY'), overall.avg_salary;
```

**What it's doing:**

- Filters for salaries paid in March 2024.
    
- Joins with `employee` to get department info.
    
- Computes the average salary per department.
    
- Compares each department's average to the company's average using a `CASE` expression.
    
Another method is using **Common Table Expressions (CTEs)** to split the logic clearly:

```sql
WITH march_salaries AS (
  SELECT 
    s.employee_id,
    e.department_id,
    s.amount,
    TO_CHAR(s.payment_date, 'MM-YYYY') AS payment_date
  FROM salary s
  JOIN employee e ON s.employee_id = e.employee_id
  WHERE DATE_TRUNC('month', s.payment_date) = DATE '2024-03-01'
),
dept_avg AS (
  SELECT 
    department_id,
    payment_date,
    AVG(amount) AS dept_avg_salary
  FROM march_salaries
  GROUP BY department_id, payment_date
),
company_avg AS (
  SELECT 
    AVG(amount) AS company_avg_salary
  FROM march_salaries
)
SELECT 
  d.department_id,
  d.payment_date,
  CASE
    WHEN d.dept_avg_salary > c.company_avg_salary THEN 'higher'
    WHEN d.dept_avg_salary < c.company_avg_salary THEN 'lower'
    ELSE 'same'
  END AS comparison
FROM dept_avg d
CROSS JOIN company_avg c;
```

This method is cleaner and easier to maintain. Use `CROSS JOIN` to bring the company average into scope for comparison.