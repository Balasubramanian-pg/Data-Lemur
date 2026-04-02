---
Created: null
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: LinkedIn Power Creators (Part 1)
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/LinkedIn Power Creators
  (Part 1).md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Of course! This is a classic and very intuitive query that directly compares related entities. It's a perfect example to break down.

Here is the complete analysis.


### 1. The Question

The business question being asked by this SQL query is:

**"Which individuals on the platform are 'power creators', defined as having more followers on their personal profile than their employer's company page has? Provide a sorted list of their profile IDs."**


### 2. Table Schema

The query joins two tables, `personal_profiles` and `company_pages`. A plausible schema for these tables would be:

```sql
-- Table: personal_profiles
-- Stores information about each individual user's profile.
CREATE TABLE personal_profiles (
    profile_id   INT PRIMARY KEY,
    full_name    VARCHAR(255) NOT NULL,
    employer_id  INT,                    -- Foreign key to the company_pages table
    followers    INT DEFAULT 0           -- The number of followers for the personal profile
);

-- Table: company_pages
-- Stores information about each company's official page.
CREATE TABLE company_pages (
    company_id   INT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    industry     VARCHAR(100),
    followers    INT DEFAULT 0           -- The number of followers for the company page
);

-- Adding a foreign key constraint to formalize the relationship.
ALTER TABLE personal_profiles
ADD CONSTRAINT fk_employer
FOREIGN KEY (employer_id) REFERENCES company_pages(company_id);
```


### 3. Structured SQL Query (Method 1: `INNER JOIN` with Direct Comparison)

This is your original query, which is the most common and efficient way to solve this problem.

```sql
SELECT
    p.profile_id
FROM
    personal_profiles AS p
INNER JOIN
    company_pages AS c ON p.employer_id = c.company_id
WHERE
    p.followers > c.followers
ORDER BY
    p.profile_id ASC;
```


### 4. Explanation of the Query

This query finds the "power creators" by joining employee and company data and then applying a direct comparison.

1.  **`FROM personal_profiles AS p INNER JOIN company_pages AS c ON p.employer_id = c.company_id`**
    *   This is the core of the data preparation. It creates a temporary virtual table by combining rows from `personal_profiles` (`p`) and `company_pages` (`c`).
    *   The `INNER JOIN` ensures that only profiles with a valid `employer_id` that matches a `company_id` in the `company_pages` table are included. This means employees without a listed company or with an invalid company ID are excluded.
    *   The result is a set of rows where each row contains the details of a person *and* the details of their employer.

2.  **`WHERE p.followers > c.followers`**
    *   This clause filters the combined rows. It iterates through the result of the join and keeps only those rows where the value in the `followers` column from the `personal_profiles` table (`p.followers`) is greater than the value in the `followers` column from the `company_pages` table (`c.followers`).

3.  **`SELECT p.profile_id`**
    *   From the final filtered list of "power creators," this simply selects their `profile_id`.

4.  **`ORDER BY p.profile_id ASC`**
    *   This sorts the resulting list of profile IDs in ascending order for a clean, predictable output.


### 5. Another SQL Method (Method 2: Using a Correlated Subquery)

An alternative way to write this is to use a subquery in the `WHERE` clause to fetch the company's follower count for each profile being evaluated.

```sql
SELECT
    p.profile_id
FROM
    personal_profiles AS p
WHERE
    p.employer_id IS NOT NULL AND
    p.followers > (
        SELECT
            c.followers
        FROM
            company_pages AS c
        WHERE
            c.company_id = p.employer_id
    )
ORDER BY
    p.profile_id ASC;
```


### 6. Explanation of the Alternative Query

This method achieves the same result by evaluating each person's profile one by one and looking up their company's data as needed.

1.  **`FROM personal_profiles AS p`**: The outer query iterates through each row in the `personal_profiles` table.
2.  **`WHERE p.employer_id IS NOT NULL AND ...`**: We first ensure the employee has a listed employer to avoid errors in the subquery.
3.  **The Subquery**:
    *   `p.followers > (SELECT c.followers ...)`: For each profile `p`, the `WHERE` clause executes a **correlated subquery**.
    *   The inner query `(SELECT c.followers FROM company_pages AS c WHERE c.company_id = p.employer_id)` runs for the *current* `profile_id` (`p`) being considered by the outer query. It goes into the `company_pages` table and fetches the `followers` count for the company that matches the current employee's `employer_id`.
    *   This subquery is designed to return exactly one value: the follower count of that person's specific employer.
    *   The outer query then compares the person's follower count (`p.followers`) to this single returned value.
4.  If the condition is true, the `profile_id` is included in the final result set, which is then ordered.

**Comparison:**
*   The **`JOIN` method (Method 1)** is generally preferred. It is often more readable and allows the database's query optimizer more flexibility to find the most efficient execution plan.
*   The **subquery method (Method 2)** can be more intuitive for some people as it reads like a direct question: "Find profiles where followers are greater than the result of this lookup." In most modern database systems, the performance will be identical as the optimizer will likely rewrite the subquery into a `JOIN` internally.