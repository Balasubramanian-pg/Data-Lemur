---
Company:
- Visa
Difficulty: Intermediate
Created: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Monthly Merchant Balance_from_made_1
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Hard/Monthly Merchant Balance_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
### 1. The Question

The business question being asked by this SQL query is:

**"What is the daily cumulative running balance for each month? The balance should be calculated based on the net of all deposits and withdrawals, and it should reset to the new day's net change at the beginning of each month."**

*Note: The title "monthly merchant balance" suggests a per-merchant calculation, but the query as written calculates a single, aggregate balance. To make it per-merchant, a `merchant_id` would need to be added to the `GROUP BY` and `PARTITION BY` clauses.*


### 2. Table Schema

The query references a single table, `transactions`. A plausible schema for this financial table would be:

```sql
-- Table: transactions
-- Stores a record for every deposit or withdrawal transaction.
CREATE TABLE transactions (
    transaction_id   BIGINT PRIMARY KEY,
    merchant_id      INT,                      -- ID of the merchant (for a per-merchant version)
    transaction_date TIMESTAMP NOT NULL,       -- The exact date and time of the transaction
    type             VARCHAR(20) NOT NULL,     -- The type of transaction, e.g., 'deposit', 'withdrawal'
    amount           DECIMAL(12, 2) NOT NULL   -- The absolute value of the transaction amount
);

-- An index on the transaction date is critical for performance.
CREATE INDEX idx_transactions_date ON transactions (transaction_date);
```


### 3. Structured SQL Query (Method 1: Multi-Step CTEs)

This is your original query, which breaks down the problem into very clear, logical steps.

```sql
-- Step 1: Assign a positive or negative sign to each transaction amount.
WITH signed_transactions AS (
    SELECT
        DATE(transaction_date) AS transaction_date,
        CASE
            WHEN type = 'deposit' THEN amount
            ELSE -amount
        END AS amount
    FROM
        transactions
),
-- Step 2: Aggregate the signed transactions to get the net balance change for each day.
daily_balance_details AS (
    SELECT
        transaction_date AS transaction_day,
        EXTRACT(MONTH FROM transaction_date) AS month,
        SUM(amount) AS daily_balance
    FROM
        signed_transactions
    GROUP BY
        transaction_date,
        EXTRACT(MONTH FROM transaction_date)
)
-- Step 3: Calculate the running total of the daily net changes, resetting each month.
SELECT
    transaction_day,
    SUM(daily_balance) OVER (PARTITION BY month ORDER BY transaction_day ASC) AS balance
FROM
    daily_balance_details
ORDER BY
    transaction_day ASC;
```


### 4. Explanation of the Query

This query uses a sequential, multi-step process to transform the raw transaction log into a daily running balance report.

**Step 1: `signed_transactions` CTE**
*   This CTE prepares the data for calculation by assigning the correct sign to each transaction.
*   `CASE WHEN type = 'deposit' THEN amount ELSE -amount END`: This is the core logic. It converts withdrawals into negative numbers, so when we sum them up, they correctly subtract from the total.
*   `DATE(transaction_date)`: This removes the time component from the `transaction_date`, which is necessary for grouping all of a day's transactions together.

**Step 2: `daily_balance_details` CTE**
*   This CTE calculates the *net financial movement* for each individual day.
*   `GROUP BY transaction_date, ...`: It groups all the signed transactions from the previous step by the day they occurred.
*   `SUM(amount) AS daily_balance`: Because the amounts are now signed, this `SUM` calculates the net result for the day (e.g., total deposits - total withdrawals).

**Step 3: Final `SELECT` Statement**
*   This final step takes the daily net changes and calculates the month-to-date running total using a window function.
*   `SUM(daily_balance) OVER (...) AS balance`: This is the window function that calculates the cumulative sum.
*   `PARTITION BY month`: This is a crucial instruction. It tells the `SUM` function to operate independently for each month. The running total will accumulate within a month and **reset** at the start of the next month.
*   `ORDER BY transaction_day ASC`: This sorts the data within each partition (each month) by day, ensuring the sum accumulates chronologically.


### 5. Another SQL Method (Method 2: Combined CTE)

You can make the query more concise by combining the first two steps into a single CTE, which can sometimes be more efficient.

```sql
-- Step 1: Directly calculate the daily net balance change in a single CTE.
WITH daily_net_change AS (
    SELECT
        DATE(transaction_date) AS transaction_day,
        EXTRACT(MONTH FROM transaction_date) AS month,
        SUM(
            CASE
                WHEN type = 'deposit' THEN amount
                ELSE -amount
            END
        ) AS daily_balance
    FROM
        transactions
    GROUP BY
        DATE(transaction_date),
        EXTRACT(MONTH FROM transaction_date)
)
-- Step 2: Calculate the running total of the daily net changes.
SELECT
    transaction_day,
    SUM(daily_balance) OVER (PARTITION BY month ORDER BY transaction_day ASC) AS balance
FROM
    daily_net_change
ORDER BY
    transaction_day ASC;
```


### 6. Explanation of the Alternative Query

This method achieves the exact same result but with one less intermediate step.

1.  **The `daily_net_change` CTE**:
    *   This single CTE combines the logic of the first two CTEs from the original query.
    *   It groups by the transaction day and month directly from the source `transactions` table.
    *   The `SUM(CASE...END)` expression calculates the daily net balance in a single operation. It applies the positive/negative sign logic *inside* the `SUM` function.

2.  **The Final `SELECT` Statement**:
    *   This part is **identical** to the original query's final step. It takes the pre-calculated daily net changes and uses the same window function (`SUM OVER (PARTITION BY month ...)` to compute the month-to-date running balance.

**Comparison:**
*   The **multi-step CTE method (Method 1)** is excellent for readability and debugging. You can easily test each CTE independently to ensure the logic is correct at each stage.
*   The **combined CTE method (Method 2)** is more concise and can be slightly more performant as it requires one less materialization step by the database engine. However, the core logic remains the same.