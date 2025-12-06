---
Created: 2025-06-28T18:34
Area:
- Top-N Analysis
Key Functions:
- DENSE_RANK()
- PARTITION BY
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Department Top 3 Salaries
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Department Top 3
  Salaries.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Here's the structured solution for Question 14:

### Problem Statement

Find employees who earn the top three salaries in each department. Include ties (employees with the same salary should have the same rank).

### Tables

**Employee table:**

```Plain
+----+-------+--------+--------------+
| Id | Name  | Salary | DepartmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 85000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
| 7  | Will  | 70000  | 1            |
+----+-------+--------+--------------+
```

**Department table:**

```Plain
+----+----------+
| Id | Name     |
+----+----------+
| 1  | IT       |
| 2  | Sales    |
+----+----------+
```

### Expected Output

```Plain
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Randy    | 85000  |
| IT         | Joe      | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+
```

### SQL Solution

```SQL
SELECT
    a.department,
    a.employee,
    a.salary
FROM (
    SELECT
        d.name AS department,
        e.name AS employee,
        salary,
        DENSE_RANK() OVER(PARTITION BY d.name ORDER BY salary DESC) AS rk
    FROM Employee e
    JOIN Department d ON e.departmentid = d.id
) a
WHERE a.rk < 4;
```

### Explanation

1. **Subquery (a):**
    - Joins the Employee and Department tables
    - Uses `DENSE_RANK()` window function to rank employees by salary in descending order within each department
    - The `DENSE_RANK()` function handles ties by assigning the same rank to employees with identical salaries
2. **Main Query:**
    - Filters the results to only include employees with a rank less than 4 (top 3 salaries in each department)
    - Returns the department name, employee name, and salary
    - The output will include all employees who are in the top 3 salary brackets, including ties

### Key Points

- `DENSE_RANK()` is used instead of `RANK()` or `ROW_NUMBER()` to properly handle ties
- The partition is done by department name to calculate ranks separately for each department
- The filter `rk < 4` ensures we get all top 3 salary earners (including ties) from each department
- The solution handles cases where multiple employees share the same salary within a department