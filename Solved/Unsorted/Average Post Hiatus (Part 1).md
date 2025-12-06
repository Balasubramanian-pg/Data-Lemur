---
Company:
- Facebook
Difficulty: Intermediate
Created: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Average Post Hiatus (Part 1)
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Average Post Hiatus
  (Part 1).md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---

Of course! This is an excellent query that combines filtering, aggregation, and group-level filtering with `HAVING`. It's a great candidate for analysis.

***

### 1. The Question

The business or data question being answered here is:

**"For users who posted more than once during the year 2021, what is the time span (in days) between their very first post and their very last post of that year?"**

*Note: The query title "average post hiatus" is slightly different from what the query calculates. The query computes the total duration of a user's posting activity, not the average time *between* their individual posts.*

---

### 2. Table Schema

The query references a single table, `posts`. A plausible schema for this table would be:

```sql
-- Table: posts
-- Stores a record for every post made by a user.
CREATE TABLE posts (
    post_id      INT PRIMARY KEY,        -- Unique identifier for each post
    user_id      INT NOT NULL,           -- The ID of the user who created the post
    post_content TEXT,                   -- The text content of the post
    post_date    TIMESTAMP NOT NULL      -- The exact date and time the post was created
);

-- An index on the post_date column is highly recommended for this query's performance.
CREATE INDEX idx_posts_post_date ON posts (post_date);

-- A composite index would be even better for both filtering and grouping.
CREATE INDEX idx_posts_user_date ON posts (user_id, post_date);
```

---

### 3. Structured SQL Query (Method 1: `DATE_PART` with `HAVING`)

This is your original query, formatted for clarity. The syntax is specific to databases like PostgreSQL.

```sql
SELECT
    user_id,
    MAX(post_date::DATE) - MIN(post_date::DATE) AS days_between
FROM
    posts
WHERE
    DATE_PART('year', post_date) = 2021
GROUP BY
    user_id
HAVING
    COUNT(post_id) > 1;
```

---

### 4. Explanation of the Query

This query filters posts from a specific year and then calculates a time difference for active users. Here's the breakdown of how the database processes it:

1.  **`FROM posts`**
    *   The query starts by accessing the `posts` table.

2.  **`WHERE DATE_PART('year', post_date) = 2021`**
    *   It first filters the rows, keeping only those where the `post_date` falls within the year 2021. The `DATE_PART` function extracts the year component from the timestamp for the comparison.
    *   **Note:** Applying a function like `DATE_PART` to a column can sometimes prevent the database from using an index on that column, which can be inefficient on large tables.

3.  **`GROUP BY user_id`**
    *   The remaining rows (all from 2021) are then grouped together by `user_id`. This creates a separate "bucket" of posts for each user.

4.  **`HAVING COUNT(post_id) > 1`**
    *   After grouping, the `HAVING` clause filters the *groups*. It counts the number of posts in each user's bucket and discards any group that does not have more than one post. This is crucial because calculating a time difference requires at least two data points (a start and an end).

5.  **`SELECT user_id, MAX(post_date::DATE) - MIN(post_date::DATE) AS days_between`**
    *   This is executed on the final remaining groups.
    *   `user_id`: Selects the user's ID.
    *   `MIN(post_date::DATE)`: Finds the earliest post date for that user within the 2021 group.
    *   `MAX(post_date::DATE)`: Finds the latest post date for that user within the 2021 group.
    *   `::DATE`: This is a PostgreSQL-specific cast that converts the `TIMESTAMP` to a `DATE`, removing the time component.
    *   `MAX(...) - MIN(...)`: Subtracting two dates in PostgreSQL results in an integer representing the number of days between them. This result is aliased as `days_between`.

---

### 5. Another SQL Method (Method 2: SARGable `WHERE` Clause)

This alternative method achieves the same result but uses a more performant filtering technique. It is also more portable across different SQL databases.

```sql
SELECT
    user_id,
    -- MAX/MIN on a DATE column is often slightly faster than on a TIMESTAMP
    MAX(post_date)::DATE - MIN(post_date)::DATE AS days_between
FROM
    posts
WHERE
    post_date >= '2021-01-01'
    AND post_date < '2022-01-01'
GROUP BY
    user_id
HAVING
    COUNT(post_id) > 1;
```

---

### 6. Explanation of the Alternative Query

The logic is identical to the first method, but with one key improvement in the `WHERE` clause.

1.  **`WHERE post_date >= '2021-01-01' AND post_date < '2022-01-01'`**
    *   This is the major change. Instead of applying a function to the `post_date` column, it performs a direct range comparison.
    *   This type of condition is called **SARGable** (Search ARGument Able), which means the database's query optimizer can efficiently use an index on the `post_date` column to find the relevant rows.
    *   This avoids a "full table scan" where the database would have to check the `DATE_PART` of every single row. On large tables, this will be significantly faster.
    *   Using a half-open interval (`>=` start date, `<` day after end date) is a robust way to capture the entire time period without worrying about the time part of the timestamp.

The `GROUP BY`, `HAVING`, and `SELECT` clauses work exactly as they did in the first method, but they now operate on a set of data that was filtered much more efficiently.