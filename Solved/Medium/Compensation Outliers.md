---
Company:
- Accenture
Difficulty: Intermediate
Created: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Compensation Outliers_from_made_1
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Medium/Compensation Outliers_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Of course! This is a fantastic query that uses a correlated subquery inside a CTE to find outliers. It's a perfect candidate for demonstrating the power of window functions as a more efficient alternative.

Here is the complete breakdown.

***

### 1. The Question

The business question being asked by this SQL query is:

**"Which employees are compensation outliers within their own job title? An 'outlier' is defined as any employee whose salary is more than double the average salary for their title ('Overpaid') or less than half the average salary for their title ('Underpaid')."**

---

### 2. Table Schema

The query references a single table, `employee_pay`. A plausible schema would be:

```sql
-- Table: employee_pay
-- Stores salary and job title information for each employee.
CREATE TABLE employee_pay (
    employee_id  INT PRIMARY KEY,
    first_name   VARCHAR(100),
    last_name    VARCHAR(100),
    title        VARCHAR(255) NOT NULL, -- The employee's job title, e.g., 'Software Engineer'
    salary       DECIMAL(12, 2) NOT NULL -- The employee's annual salary
);

-- An index on the title column is critical for the performance of this query.
CREATE INDEX idx_employee_title ON employee_pay (title);
```

---

### 3. Structured SQL Query (Method 1: CTE with Correlated Subquery)

This is your original query, formatted for clarity. It works but can be very inefficient on large datasets.

```sql
WITH employee_status AS (
    SELECT
        e1.employee_id,
        e1.salary,
        e1.title,
        CASE
            WHEN e1.salary > 2 * (SELECT AVG(e2.salary) FROM employee_pay AS e2 WHERE e1.title = e2.title)
                THEN 'Overpaid'
            WHEN e1.salary < 0.5 * (SELECT AVG(e2.salary) FROM employee_pay AS e2 WHERE e1.title = e2.title)
                THEN 'Underpaid'
            ELSE 'Near Average'
        END AS status
    FROM
        employee_pay AS e1
)
SELECT
    employee_id,
    salary,
    status
FROM
    employee_status
WHERE
    status IN ('Underpaid', 'Overpaid');
```

---

### 4. Explanation of the Query

This query uses a CTE and correlated subqueries to categorize each employee's salary.

**Step 1: The `employee_status` CTE**

1.  **`FROM employee_pay AS e1`**: The query iterates through each employee row in the `employee_pay` table, aliased as `e1`.
2.  **The `CASE` Statement**: For **each employee row**, this `CASE` statement determines their `status`.
3.  **The Correlated Subquery**:
    *   `SELECT AVG(e2.salary) FROM employee_pay AS e2 WHERE e1.title = e2.title`: This subquery is executed twice for every single row of the outer query.
    *   It calculates the average salary for all employees (`e2`) who have the **same job title** as the current employee (`e1`). This is the "correlation."
    *   The main query then uses this calculated average to check if the current employee's salary is `> 2 * avg` or `< 0.5 * avg`.
4.  **Result of the CTE**: The CTE produces a temporary table containing the `employee_id`, `salary`, `title`, and the calculated `status` for every employee.

**Step 2: The Final `SELECT`**

1.  **`FROM employee_status`**: The final query reads from the temporary result set created by the CTE.
2.  **`WHERE status IN ('Underpaid', 'Overpaid')`**: It filters this result set, keeping only the rows where the employee was flagged as an outlier.
3.  **`SELECT employee_id, salary, status`**: It returns the final list of outliers and their compensation status.

**Performance Issue:** This method is very inefficient. If you have 10,000 employees, the correlated subquery (which scans the table) will be executed up to 20,000 times.

---

### 5. Another SQL Method (Method 2: Using a Window Function in a CTE)

A far more efficient and modern approach is to use a window function to calculate the average salary for each title in a single pass over the data.

```sql
WITH title_avg_salary AS (
    -- Step 1: Calculate the average salary for each title in one pass
    SELECT
        employee_id,
        salary,
        title,
        AVG(salary) OVER (PARTITION BY title) AS avg_salary_for_title
    FROM
        employee_pay
)
-- Step 2: Use the pre-calculated average to find outliers
SELECT
    employee_id,
    salary,
    CASE
        WHEN salary > 2 * avg_salary_for_title THEN 'Overpaid'
        WHEN salary < 0.5 * avg_salary_for_title THEN 'Underpaid'
    END AS status
FROM
    title_avg_salary
WHERE
    salary > 2 * avg_salary_for_title
    OR salary < 0.5 * avg_salary_for_title;
```

---

### 6. Explanation of the Alternative Query

This method is dramatically more performant because it avoids the row-by-row subquery execution.

**Step 1: The `title_avg_salary` CTE**

1.  **`AVG(salary) OVER (PARTITION BY title) AS avg_salary_for_title`**: This is the key. It's a window function.
    *   `PARTITION BY title`: This divides the data into groups based on job title (e.g., all 'Software Engineers' in one partition, all 'Data Analysts' in another).
    *   `AVG(salary) OVER (...)`: For each row, this calculates the average salary of all other rows *within the same partition*.
    *   The result is that every employee row is now annotated with the average salary for their specific job title. This entire calculation is done in **one efficient scan** of the table.

**Step 2: The Final `SELECT`**

1.  **`FROM title_avg_salary`**: The query operates on the CTE, which now contains each employee's salary and the relevant average for their title.
2.  **`WHERE salary > 2 * avg_salary_for_title OR salary < 0.5 * avg_salary_for_title`**:
    *   This `WHERE` clause can now directly compare the employee's `salary` to the pre-calculated `avg_salary_for_title` for their role. This is extremely fast.
    *   This filters the result set down to only the outliers.
3.  **`SELECT ...` and `CASE ...`**: The final `SELECT` statement then displays the required columns and uses a `CASE` statement to assign the 'Overpaid' or 'Underpaid' label. We don't need an `ELSE` clause here because the `WHERE` clause has already removed all the 'Near Average' employees.

This window function approach is the industry-standard, high-performance solution for this type of "compare-to-group" analysis.
