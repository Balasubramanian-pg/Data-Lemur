---
Created: 2025-06-28T18:34
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Top Three Salaries_from_made_1
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Medium/Top Three Salaries_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
As part of an ongoing analysis of salary distribution within the company, your manager has requested a report identifying high earners in  
each department. A 'high earner' within a department is defined as an employee with a salary ranking among the top three salaries within that  
department.  

You're tasked with identifying these high earners across all departments. Write a query to display the employee's name along with their department name and salary. In case of duplicates, sort the results of department name in ascending order, then by salary in descending order. If multiple employees have the same salary, then order  
them alphabetically.  

Note: Ensure to utilize the appropriate ranking window function to handle duplicate salaries effectively.

_As of June 18th, we have removed the requirement for unique salaries and revised the sorting order for the results._

### `employee` Schema:

|   |   |   |
|---|---|---|
|column_name|type|description|
|employee_id|integer|The unique ID of the employee.|
|name|string|The name of the employee.|
|salary|integer|The salary of the employee.|
|department_id|integer|The department ID of the employee.|
|manager_id|integer|The manager ID of the employee.|

### `employee` Example Input:

|   |   |   |   |   |
|---|---|---|---|---|
|employee_id|name|salary|department_id|manager_id|
|1|Emma Thompson|3800|1|6|
|2|Daniel Rodriguez|2230|1|7|
|3|Olivia Smith|2000|1|8|
|4|Noah Johnson|6800|2|9|
|5|Sophia Martinez|1750|1|11|
|6|Liam Brown|13000|3||
|7|Ava Garcia|12500|3||
|8|William Davis|6800|2||
|9|Isabella Wilson|11000|3||
|10|James Anderson|4000|1|11|

### `department` Schema:

|   |   |   |
|---|---|---|
|column_name|type|description|
|department_id|integer|The department ID of the employee.|
|department_name|string|The name of the department.|

### `department` Example Input:

|   |   |
|---|---|
|department_id|department_name|
|1|Data Analytics|
|2|Data Science|

### Example Output:

|   |   |   |
|---|---|---|
|department_name|name|salary|
|Data Analytics|James Anderson|4000|
|Data Analytics|Emma Thompson|3800|
|Data Analytics|Daniel Rodriguez|2230|
|Data Science|Noah Johnson|6800|
|Data Science|William Davis|6800|

The output displays the high earners in each department.

- In the Data Analytics deaprtment, James Anderson leads with a salary of $4,000, followed by Emma Thompson earning $3,800, and Daniel  
    Rodriguez with $2,230.  
    
- In the Data Science department, both Noah Johnson and William Davis earn $6,800, with Noah listed before William due to alphabetical ordering.


Looking at this problem, I need to:

1. Join employee and department tables
2. Rank employees by salary within each department (handling ties appropriately)
3. Select top 3 ranked employees per department
4. Sort results by department name (ascending), salary (descending), then name (alphabetically)

The key insight is choosing the right ranking function. Since we want the top 3 salaries and need to handle ties properly, I'll use `DENSE_RANK()` which ensures that if multiple people have the same salary, they get the same rank, and the next rank continues sequentially.This query solves the problem by:

1. **CTE (**`**ranked_employees**`**)**:
    - Joins `employee` and `department` tables to get department names
    - Uses `DENSE_RANK()` window function to rank employees by salary within each department
    - `PARTITION BY e.department_id` ensures ranking is done separately for each department
    - `ORDER BY e.salary DESC` ranks from highest to lowest salary
2. **Main Query**:
    - Filters for `salary_rank <= 3` to get the top 3 salary ranks per department
    - Orders results by:
        - `department_name ASC` (alphabetical order of departments)
        - `salary DESC` (highest salaries first within each department)
        - `name ASC` (alphabetical order for employees with same salary)

**Why DENSE_RANK()?**

- `DENSE_RANK()` handles ties properly - if two employees have the same salary, they both get the same rank
- Unlike `ROW_NUMBER()`, it doesn't arbitrarily break ties
- Unlike `RANK()`, it doesn't skip ranks after ties (e.g., if two people tie for rank 1, the next person gets rank 2, not rank 3)

**Tracing through the example**:

- **Data Analytics**: James Anderson (4000, rank 1), Emma Thompson (3800, rank 2), Daniel Rodriguez (2230, rank 3)
- **Data Science**: Noah Johnson and William Davis both have 6800 (rank 1), with Noah listed first alphabetically

This matches the expected output perfectly!

```SQL
WITH ranked_employees AS (
  SELECT 
    d.department_name,
    e.name,
    e.salary,
    DENSE_RANK() OVER (
      PARTITION BY e.department_id 
      ORDER BY e.salary DESC
    ) AS salary_rank
  FROM employee e
  INNER JOIN department d ON e.department_id = d.department_id
)

SELECT 
  department_name,
  name,
  salary
FROM ranked_employees
WHERE salary_rank <= 3
ORDER BY department_name ASC, salary DESC, name ASC;
```