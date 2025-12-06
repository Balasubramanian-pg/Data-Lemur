---
Created: 2025-06-28T18:34
Area:
- Statistical Aggregation
Key Functions:
- AVERAGE
- CTE
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Average salary of employees in a department to the company's average salary
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Average salary of
  employees in a department to the company's average salary.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Write a SQL query to display whether the **average salary** of employees in a **department** is **higher/lower/same** compared to the **company's average salary**, **per month**.

---

### 📄 **Tables Involved**

### `salary`

|   |   |   |   |
|---|---|---|---|
|id|employee_id|amount|pay_date|
|1|1|9000|2017-03-31|
|2|2|6000|2017-03-31|
|3|3|10000|2017-03-31|
|...|...|...|...|

### `employee`

|   |   |
|---|---|
|employee_id|department_id|
|1|1|
|2|2|
|3|2|

---

### 🎯 **Objective**

For each **pay month** and **department**, compare the **department average salary** with the **company average salary**, and return:

|   |   |   |
|---|---|---|
|pay_month|department_id|comparison|
|2017-03|1|higher|
|2017-03|2|lower|
|2017-02|1|same|
|2017-02|2|same|

---

### 🛠️ **Query (with explanation)**

```SQL
-- Step 1: Create a CTE to calculate department and company average salary per pay month
WITH t1 AS (
    SELECT
        DATE_FORMAT(pay_date, '%Y-%m') AS pay_month,
        department_id,
        -- Department average salary for the month
        AVG(amount) OVER(PARTITION BY MONTH(pay_date), department_id) AS dept_avg,
        -- Company-wide average salary for the month
        AVG(amount) OVER(PARTITION BY MONTH(pay_date)) AS comp_avg
    FROM salary s
    JOIN employee e USING (employee_id)
)

-- Step 2: Select unique pay_month and department_id with their salary comparison
SELECT DISTINCT
    pay_month,
    department_id,
    CASE
        WHEN dept_avg > comp_avg THEN 'higher'
        WHEN dept_avg = comp_avg THEN 'same'
        ELSE 'lower'
    END AS comparison
FROM t1
ORDER BY 1 DESC;
```

---

### 🧠 **Key Concepts Used**

- `JOIN`: To connect `salary` and `employee` tables using `employee_id`.
- `DATE_FORMAT()`: To extract year and month from `pay_date`.
- `AVG() OVER (PARTITION BY ...)`: To calculate rolling averages over departments and company per month.
- `CASE`: To label each comparison as `higher`, `lower`, or `same`.

---

Let me know if you'd like this rewritten in another SQL dialect (e.g., PostgreSQL or SQL Server) or turned into a practice assignment!