---
Company:
- Etsy
Difficulty: Intermediate
Created: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: First Transaction_from_made_1
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Medium/First Transaction_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---

Of course! This is a fantastic query that uses a window function within a Common Table Expression (CTE). It's a modern and highly efficient way to solve this common type of "first event" analysis.

Here is the complete breakdown.


### 1. The Question

The business question being asked by this SQL query is:

**"How many unique users made their very first transaction with a value of $50 or more?"**


### 2. Table Schema

The query references a single table, `user_transactions`. A plausible schema for this table would be:

```sql
-- Table: user_transactions
-- Stores a record for every transaction made by a user.
CREATE TABLE user_transactions (
    transaction_id   INT PRIMARY KEY,
    user_id          INT NOT NULL,           -- The ID of the user making the transaction
    spend            DECIMAL(10, 2) NOT NULL,-- The amount of money spent
    transaction_date TIMESTAMP NOT NULL      -- The exact date and time of the transaction
);

-- A composite index on the columns used in the window function is crucial for performance.
CREATE INDEX idx_user_trans_date ON user_transactions (user_id, transaction_date);
```


### 3. Structured SQL Query (Method 1: Using a Window Function in a CTE)

This is your original query, which is an excellent and highly readable way to solve the problem.

```sql
-- Step 1: Rank all transactions for each user chronologically.
WITH transaction_ranking AS (
    SELECT
        user_id,
        spend,
        transaction_date,
        DENSE_RANK() OVER (PARTITION BY user_id ORDER BY transaction_date ASC) AS transaction_num
    FROM
        user_transactions
)
-- Step 2: From the ranked list, count users whose #1 transaction meets the criteria.
SELECT
    COUNT(DISTINCT user_id) AS users
FROM
    transaction_ranking
WHERE
    transaction_num = 1
    AND spend >= 50;
```


### 4. Explanation of the Query

This query uses a two-step process, made clear by the CTE, to find the answer efficiently.

**Step 1: The `transaction_ranking` CTE**

1.  **`DENSE_RANK() OVER (...) AS transaction_num`**: This is the core of the logic. It's a **window function** that assigns a rank to each transaction.
    *   `PARTITION BY user_id`: This tells the function to perform the ranking independently for each user. The rank will restart at `1` for every new `user_id`.
    *   `ORDER BY transaction_date ASC`: Within each user's "partition" (all their transactions), the rows are ordered by `transaction_date` from earliest to latest.
    *   `DENSE_RANK()`: This assigns the rank. The earliest transaction for a user gets rank `1`. If two transactions happen at the exact same time, they both get rank `1`, and the next transaction gets rank `2`.
2.  **Result of CTE**: The `transaction_ranking` CTE is a temporary table that contains all the original transaction data, plus a new column `transaction_num` that identifies the chronological order of each transaction for every user.

**Step 2: The Final `SELECT` Statement**

1.  **`FROM transaction_ranking`**: The query now operates on our temporary, ranked data.
2.  **`WHERE transaction_num = 1 AND spend >= 50`**: This is the filtering step.
    *   `transaction_num = 1`: This keeps only the row(s) that represent the very first transaction(s) for each user.
    *   `AND spend >= 50`: It then further filters that set, keeping only the first transactions where the spend was 50 or more.
3.  **`SELECT COUNT(DISTINCT user_id) AS users`**: Finally, it counts the number of unique `user_id`s that remain after the filtering, giving the final answer.


### 5. Another SQL Method (Method 2: Using a Subquery with `GROUP BY` and `JOIN`)

A more traditional way to solve this, without window functions, is to first find the minimum transaction date for each user and then join that information back to the main table.

```sql
SELECT
    COUNT(DISTINCT t.user_id) AS users
FROM
    user_transactions AS t
INNER JOIN (
    -- Subquery to find the first transaction date for each user
    SELECT
        user_id,
        MIN(transaction_date) AS first_transaction_date
    FROM
        user_transactions
    GROUP BY
        user_id
) AS first_transactions
ON t.user_id = first_transactions.user_id
AND t.transaction_date = first_transactions.first_transaction_date
WHERE
    t.spend >= 50;
```


### 6. Explanation of the Alternative Query

This method achieves the same result by explicitly finding the first transaction and its details.

1.  **The Subquery (Derived Table)**:
    *   `SELECT user_id, MIN(transaction_date) ... GROUP BY user_id`: This inner query is executed first. It groups all transactions by `user_id` and finds the earliest (`MIN`) `transaction_date` for each one.
    *   The result is a temporary table aliased as `first_transactions` with two columns: `user_id` and their corresponding `first_transaction_date`.

2.  **The Outer Query**:
    *   `FROM user_transactions AS t INNER JOIN first_transactions ...`: The main `user_transactions` table is joined to our derived table.
    *   **`ON t.user_id = first_transactions.user_id AND t.transaction_date = first_transactions.first_transaction_date`**: This is a multi-part join key. It finds the full row from the original table that matches *both* the user ID and their specific first transaction date. This effectively isolates the first transaction record for every user.
    *   **`WHERE t.spend >= 50`**: This clause then filters these first-transaction records, keeping only those where the spend was 50 or more.
    *   **`SELECT COUNT(DISTINCT t.user_id) ...`**: Finally, it counts the unique users who are left.

The window function approach is often more concise and can be more easily extended to find the 2nd, 3rd, or Nth transaction, but the `GROUP BY`/`JOIN` method is a very solid and fundamental SQL pattern.