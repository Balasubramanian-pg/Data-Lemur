---
Created: 2025-06-28T18:34
Area:
- Rolling Aggregations
Key Functions:
- OVER(ORDER BY date)
- SUM()
Company:
- Netflix
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Cumulative sum of an employee's salary over a period of 3 months
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Cumulative sum of
  an employee's salary over a period of 3 months.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Get the **cumulative sum of an employee's salary** over a **3-month window**, **excluding the most recent month** for each employee.

---

###  **Table:** `**employee**`

|   |   |   |
|---|---|---|
|Id|Month|Salary|
|1|1|20|
|1|2|30|
|1|3|40|
|1|4|60|
|2|1|20|
|2|2|30|
|3|2|40|
|3|3|60|
|3|4|70|

---

###  **Objective**

- For each employee, **ignore their most recent month**.
- Then calculate the **3-month rolling sum** (including the current month and 2 preceding ones).
- Output should be sorted by **Id (ascending)** and **Month (descending)**.

---

###  **Approach**

1. **Identify most recent month** per employee using `MAX()` window function.
2. **Filter out rows for the most recent month**.
3. **Apply a cumulative window** (`ROWS BETWEEN 2 PRECEDING AND CURRENT ROW`) to get 3-month sum.

---

###  **Final Query (Well-Formatted)**

```SQL
-- Step 1: Add a column for most recent month per employee
WITH t1 AS (
    SELECT *,
           MAX(Month) OVER(PARTITION BY Id) AS recent_month
    FROM employee
)

-- Step 2: Calculate 3-month rolling sum, excluding most recent month
SELECT
    Id,
    Month,
    SUM(Salary) OVER(
        PARTITION BY Id
        ORDER BY Month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS Salary
FROM t1
WHERE Month < recent_month -- exclude the most recent month
ORDER BY Id ASC, Month DESC;
```

---

###  **Result**

|   |   |   |
|---|---|---|
|Id|Month|Salary|
|1|3|90|
|1|2|50|
|1|1|20|
|2|1|20|
|3|3|100|
|3|2|40|

---

Let me know if you'd like this tailored for a different SQL dialect like PostgreSQL or want to build this into a training exercise!