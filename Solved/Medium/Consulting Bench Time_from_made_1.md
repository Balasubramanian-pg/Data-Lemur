---
Company:
- Google
Difficulty: Intermediate
Created: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Consulting Bench Time_from_made_1
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Medium/Consulting Bench Time_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Of course! This is a great real-world business query that uses a CTE to simplify a multi-step calculation. It's an excellent candidate for analysis.

***

### 1. The Question

The business question being asked by this SQL query is:

**"Assuming a 365-day year, how many days was each consultant 'on the bench' (i.e., not actively staffed on a consulting engagement)? Provide a list of each consultant's employee ID and their total calculated bench days."**

---

### 2. Table Schema

The query involves two tables, `staffing` and `consulting_engagements`. A plausible schema would be:

```sql
-- Table: staffing
-- Maps employees to specific jobs or roles, including non-consulting roles.
CREATE TABLE staffing (
    staffing_id   INT PRIMARY KEY,
    employee_id   INT NOT NULL,           -- Foreign key to an 'employees' table
    job_id        INT NOT NULL,           -- Foreign key to the 'consulting_engagements' table
    is_consultant BOOLEAN NOT NULL        -- A flag to identify if the role is a consultant role
);

-- Table: consulting_engagements
-- Stores details about each specific client project or engagement.
CREATE TABLE consulting_engagements (
    job_id          INT PRIMARY KEY,
    engagement_name VARCHAR(255) NOT NULL,
    client_id       INT,
    start_date      DATE NOT NULL,        -- The start date of the project
    end_date        DATE NOT NULL         -- The end date of the project
);
```

---

### 3. Structured SQL Query (Method 1: Using a Common Table Expression - CTE)

This is your original query, formatted for clarity. It breaks the problem into two logical steps, which enhances readability.

```sql
-- Step 1: Calculate the duration of each individual consulting assignment.
WITH consulting_days_tbl AS (
    SELECT
        s.employee_id,
        (ce.end_date - ce.start_date) + 1 AS non_bench_days
    FROM
        staffing AS s
    INNER JOIN
        consulting_engagements AS ce ON s.job_id = ce.job_id
    WHERE
        s.is_consultant = TRUE -- Using a boolean TRUE is more standard than the string 'true'
)
-- Step 2: Sum up all assignment days for each employee and subtract from a full year.
SELECT
    employee_id,
    365 - SUM(non_bench_days) AS bench_days
FROM
    consulting_days_tbl
GROUP BY
    employee_id;
```

---

### 4. Explanation of the Query

This query uses a CTE to first calculate the duration of individual projects and then aggregates them for each employee.

**Step 1: The `consulting_days_tbl` CTE**

1.  **`FROM staffing AS s INNER JOIN consulting_engagements AS ce ...`**: The query starts by joining `staffing` and `consulting_engagements` on `job_id`. This creates a link between an employee and the start/end dates of a project they were assigned to.
2.  **`WHERE s.is_consultant = TRUE`**: It filters this joined data to only include records for employees who are designated as consultants.
3.  **`SELECT s.employee_id, (ce.end_date - ce.start_date) + 1 AS non_bench_days`**: For each project assignment, it calculates the duration in days. The `+ 1` makes the calculation inclusive of both the start and end dates. This result is aliased as `non_bench_days`.
4.  **Result of CTE**: The CTE produces a temporary table where each row represents one project an employee worked on, containing their `employee_id` and the `non_bench_days` for that single project. An employee will have multiple rows if they worked on multiple projects.

**Step 2: The Final Query**

1.  **`FROM consulting_days_tbl`**: This query operates on the temporary table created by the CTE.
2.  **`GROUP BY employee_id`**: It groups all the rows by `employee_id`. This gathers all the project assignments for a single consultant into one group.
3.  **`SELECT employee_id, 365 - SUM(non_bench_days) AS bench_days`**: This is executed on each group.
    *   `SUM(non_bench_days)`: It first sums up the duration of all projects for that specific consultant.
    *   `365 - ...`: It then subtracts this total from `365` to calculate the number of days they were *not* on a project. This is aliased as `bench_days`.

---

### 5. Another SQL Method (Method 2: Direct Aggregation without CTE)

For a query this straightforward, you can achieve the same result without a CTE by combining the logic into a single query block. This can sometimes be more compact.

```sql
SELECT
    s.employee_id,
    365 - SUM((ce.end_date - ce.start_date) + 1) AS bench_days
FROM
    staffing AS s
INNER JOIN
    consulting_engagements AS ce ON s.job_id = ce.job_id
WHERE
    s.is_consultant = TRUE
GROUP BY
    s.employee_id;
```

---

### 6. Explanation of the Alternative Query

This query performs the same logical steps but in a more condensed form, allowing the database optimizer to potentially handle it more holistically.

1.  **`FROM ... INNER JOIN ...`**: The tables are joined first, just like in the CTE.
2.  **`WHERE s.is_consultant = TRUE`**: The joined results are filtered to only include consultants.
3.  **`GROUP BY s.employee_id`**: The filtered rows are then immediately grouped by employee ID.
4.  **`SELECT s.employee_id, 365 - SUM(...) AS bench_days`**:
    *   The `SUM` function is applied directly within the main query.
    *   `SUM((ce.end_date - ce.start_date) + 1)`: For each employee group, it calculates the duration of each project and sums them all up in one step.
    *   This total sum is then subtracted from `365` to get the final `bench_days`.

**Key Assumption & Limitation in Both Methods:**
Both queries rely on a hardcoded `365` days and do not specify a time period. This means they don't account for leap years and may incorrectly calculate bench time if projects span across different years. A more robust real-world query would typically include a `WHERE` clause to analyze data for a specific calendar year (e.g., `WHERE EXTRACT(YEAR FROM ce.start_date) = 2023`).