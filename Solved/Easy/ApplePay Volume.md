---
Company:
- Visa
Difficulty: Intermediate
Created: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: ApplePay Volume
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Easy/ApplePay Volume.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
## 1. The Question

Based on the provided SQL, the business question being asked is:

**"What is the total transaction volume processed via Apple Pay for each merchant? List the merchants in descending order, from the one with the highest Apple Pay volume to the lowest."**
### 2. Table Schema

The query references a single table, `transactions`. A plausible schema for this table would be:

```sql
-- Table: transactions
-- Stores a record of every transaction processed.
CREATE TABLE transactions (
    transaction_id     INT PRIMARY KEY AUTO_INCREMENT, -- A unique ID for each transaction
    merchant_id        INT NOT NULL,                   -- The ID of the merchant who processed the transaction
    transaction_amount DECIMAL(10, 2) NOT NULL,        -- The value of the transaction
    payment_method     VARCHAR(50),                    -- The method used, e.g., 'Apple Pay', 'Credit Card'
    transaction_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- The date and time of the transaction
);
```

### 3. Structured SQL Query (Method 1: Conditional Aggregation with `CASE`)

This is your original query, formatted for clarity.

```sql
SELECT
    merchant_id,
    SUM(
        CASE
            WHEN LOWER(payment_method) = 'apple pay' THEN transaction_amount
            ELSE 0
        END
    ) AS volume
FROM
    transactions
GROUP BY
    merchant_id
ORDER BY
    volume DESC;
```

### 4. Explanation of the Query

This query uses a technique called **conditional aggregation** to calculate the sum for a specific subset of data without filtering out any merchants.

1.  **`SELECT merchant_id, SUM(...) AS volume`**
    *   This selects the `merchant_id` for each merchant.
    *   It then calculates a sum, which is given the alias `volume`.

2.  **`CASE WHEN LOWER(payment_method) = 'apple pay' THEN transaction_amount ELSE 0 END`**
    *   This is an `if-then-else` statement that operates on every single row before the `SUM` is calculated.
    *   `LOWER(payment_method)`: This converts the `payment_method` text to lowercase to ensure a case-insensitive match (e.g., it will match 'Apple Pay', 'apple pay', or 'APPLE PAY').
    *   For each transaction row, it checks if the payment method was 'apple pay'.
        *   If it **is**, it returns the `transaction_amount` for that row.
        *   If it **is not**, it returns `0`.

3.  **`SUM(...)`**
    *   The `SUM` function then adds up the values produced by the `CASE` statement for all transactions belonging to a single merchant (as defined by the `GROUP BY` clause). This effectively sums only the Apple Pay transactions, because all other transactions contribute `0` to the total.

4.  **`FROM transactions`**
    *   This specifies that the data is coming from the `transactions` table.

5.  **`GROUP BY merchant_id`**
    *   This is a crucial step. It groups all rows with the same `merchant_id` together, so the `SUM` function calculates a separate total for each merchant.

6.  **`ORDER BY volume DESC`**
    *   Finally, this sorts the results. The merchant with the highest `volume` (total Apple Pay amount) will appear at the top.

**Advantage of this method:** It will list **all** merchants, even those with an Apple Pay volume of `0`, because no merchants are filtered out before the aggregation.

### 5. Another SQL Method (Method 2: Filtering with `WHERE`)

A more direct and often more performant way to write this query is to filter the rows *before* aggregating them.

```sql
SELECT
    merchant_id,
    SUM(transaction_amount) AS volume
FROM
    transactions
WHERE
    LOWER(payment_method) = 'apple pay'
GROUP BY
    merchant_id
ORDER BY
    volume DESC;
```

### 6. Explanation of the Alternative Query

This method achieves a similar result by first reducing the dataset to only the relevant rows.

1.  **`FROM transactions`**
    *   Specifies the source table.

2.  **`WHERE LOWER(payment_method) = 'apple pay'`**
    *   This is the key difference. This clause **filters the entire table first**, keeping only the rows where the payment method is 'apple pay'. All other rows (e.g., 'Credit Card') are discarded before any grouping or calculation happens.

3.  **`GROUP BY merchant_id`**
    *   This then groups the remaining (Apple Pay only) rows by `merchant_id`.

4.  **`SELECT merchant_id, SUM(transaction_amount) AS volume`**
    *   Since only Apple Pay transactions are left, we can now use a simple `SUM(transaction_amount)`. The calculation is performed on the pre-filtered data for each merchant group.

5.  **`ORDER BY volume DESC`**
    *   This sorts the final result set, showing the highest-volume merchants first.

**Key Difference:** This `WHERE` clause method will **only** return merchants who have had at least one Apple Pay transaction. Merchants with zero Apple Pay volume will not appear in the results at all, because they were filtered out by the `WHERE` clause. This can be more efficient if you don't need to see the merchants with a zero total.