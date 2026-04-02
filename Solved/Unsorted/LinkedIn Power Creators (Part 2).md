---
Created: null
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: LinkedIn Power Creators (Part 2)
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/LinkedIn Power Creators
  (Part 2).md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Of course! This is a fascinating and somewhat advanced version of the "power creators" query. The use of `GROUP BY` with `MIN()` on a calculated flag is a clever trick to check a condition across an entire group.

Here is the complete breakdown.


### 1. The Question

This query answers a more complex business question than simply finding power creators. The specific question is:

**"Which individuals are 'power creators' relative to *every single company* they are associated with in our database? A power creator is defined as having more followers on their personal profile than the company page has."**

The key nuance is the "every single company" part, which is what the `GROUP BY` and `HAVING` clauses are designed to solve.


### 2. Table Schema

The query joins three tables. This implies a linking table (`employee_company`) exists between profiles and companies, which is a common design pattern for many-to-many relationships (a person can have multiple associated employers over time).

```sql
-- Table: personal_profiles
CREATE TABLE personal_profiles (
    profile_id   INT PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    followers    INT DEFAULT 0
);

-- Table: company_pages
CREATE TABLE company_pages (
    company_id   INT PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    followers    INT DEFAULT 0
);

-- Table: employee_company (Linking Table)
-- Associates people with companies.
CREATE TABLE employee_company (
    personal_profile_id INT,
    company_id          INT,
    PRIMARY KEY (personal_profile_id, company_id),
    FOREIGN KEY (personal_profile_id) REFERENCES personal_profiles(profile_id),
    FOREIGN KEY (company_id) REFERENCES company_pages(company_id)
);
```


### 3. Structured SQL Query (Method 1: Using `MIN()` on a Flag)

This is your original query, which uses a clever trick to verify a condition across a whole group.

```sql
-- Step 1: Join all tables and create a flag for each person-company relationship.
WITH power_creators AS (
    SELECT
        pp.profile_id,
        (CASE WHEN pp.followers > cp.followers THEN 1 ELSE 0 END) AS power_creator_flag
    FROM
        employee_company AS ec
    INNER JOIN
        personal_profiles AS pp ON ec.personal_profile_id = pp.profile_id
    INNER JOIN
        company_pages AS cp ON ec.company_id = cp.company_id
)
-- Step 2: Group by person and check if the minimum flag value is 1.
SELECT
    profile_id
FROM
    power_creators
GROUP BY
    profile_id
HAVING
    MIN(power_creator_flag) = 1
ORDER BY
    profile_id;
```


### 4. Explanation of the Query

This query identifies the desired individuals in two logical steps.

**Step 1: The `power_creators` CTE**

1.  **`FROM employee_company ... INNER JOIN ...`**: It joins the three tables to create a comprehensive list of every person-company association. If a person is linked to two companies, they will have two rows in this result set.
2.  **`(CASE WHEN pp.followers > cp.followers THEN 1 ELSE 0 END) AS power_creator_flag`**: This is the flagging logic. For each person-company relationship, it checks if the person's followers exceed the company's.
    *   If they do, the flag is `1` (Success).
    *   If they don't, the flag is `0` (Failure).

**Step 2: The Final Query**

1.  **`GROUP BY profile_id`**: This is the crucial step. It takes all the rows from the CTE and groups them by `profile_id`. So, all associations for a single person are now in one bucket.
2.  **`HAVING MIN(power_creator_flag) = 1`**: This is the clever trick.
    *   The `MIN()` aggregate function is applied to the `power_creator_flag` values within each person's group.
    *   If a person is a power creator for *all* their associated companies, their flags will be `(1, 1, 1, ...)`. The minimum value of this set is `1`.
    *   If a person fails the condition for even *one* company, their flags will be something like `(1, 1, 0, ...)`. The minimum value of this set is `0`.
    *   Therefore, the condition `MIN(power_creator_flag) = 1` is a concise way of saying "keep only the groups where every single flag was a 1".


### 5. Another SQL Method (Method 2: Comparing `COUNT`s)

A more intuitive and common way to express the logic "all rows in a group must meet a condition" is to compare counts.

```sql
SELECT
    ec.personal_profile_id AS profile_id
FROM
    employee_company AS ec
INNER JOIN
    personal_profiles AS pp ON ec.personal_profile_id = pp.profile_id
INNER JOIN
    company_pages AS cp ON ec.company_id = cp.company_id
GROUP BY
    ec.personal_profile_id
HAVING
    -- Count of successful conditions
    COUNT(CASE WHEN pp.followers > cp.followers THEN 1 END)
    =
    -- Count of total conditions
    COUNT(ec.company_id)
ORDER BY
    profile_id;
```


### 6. Explanation of the Alternative Query

This method directly expresses the business logic: "Does the number of times this person was a power creator equal the total number of companies they are associated with?"

1.  **`FROM ... INNER JOIN ...`**: The query starts by joining the three tables, just like in the CTE from the first method.
2.  **`GROUP BY ec.personal_profile_id`**: It groups all the joined records by the person's ID.
3.  **`HAVING COUNT(...) = COUNT(...)`**: This clause filters the groups.
    *   **Left Side**: `COUNT(CASE WHEN pp.followers > cp.followers THEN 1 END)` counts the number of "successes." The `CASE` statement produces a `1` only when the condition is met. `COUNT` then counts these `1`s.
    *   **Right Side**: `COUNT(ec.company_id)` simply counts the total number of company associations for that person.
    *   **Comparison**: The `HAVING` clause keeps a group only if the number of successes is equal to the total number of associations. This is logically identical to the `MIN(flag) = 1` trick but can be more readable to other developers.

Both methods are excellent and will likely have similar performance. The choice between them is often a matter of style and readability preference.