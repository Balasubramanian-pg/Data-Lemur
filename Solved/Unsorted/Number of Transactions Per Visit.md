---
Created: 2025-06-28T18:34
Area:
- Statistical Aggregation
Key Functions:
- CTE
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Number of Transactions Per Visit
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Number of Transactions
  Per Visit.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Here's the structured solution for Question 101:

### Problem Statement

Create a report showing:

1. All possible transaction counts (from 0 up to the maximum transactions made in one visit)
2. How many visits had each transaction count

### Tables

**Visits table:**

```Plain
+---------+------------+
| user_id | visit_date |
+---------+------------+
| 1       | 2020-01-01 |
| 2       | 2020-01-02 |
| 12      | 2020-01-01 |
| 19      | 2020-01-03 |
| 1       | 2020-01-02 |
| 2       | 2020-01-03 |
| 1       | 2020-01-04 |
| 7       | 2020-01-11 |
| 9       | 2020-01-25 |
| 8       | 2020-01-28 |
+---------+------------+
```

**Transactions table:**

```Plain
+---------+------------------+--------+
| user_id | transaction_date | amount |
+---------+------------------+--------+
| 1       | 2020-01-02       | 120    |
| 2       | 2020-01-03       | 22     |
| 7       | 2020-01-11       | 232    |
| 1       | 2020-01-04       | 7      |
| 9       | 2020-01-25       | 33     |
| 9       | 2020-01-25       | 66     |
| 8       | 2020-01-28       | 1      |
| 9       | 2020-01-25       | 99     |
+---------+------------------+--------+
```

### Expected Output

```Plain
+--------------------+--------------+
| transactions_count | visits_count |
+--------------------+--------------+
| 0                  | 4            |
| 1                  | 5            |
| 2                  | 0            |
| 3                  | 1            |
+--------------------+--------------+
```

### SQL Solution

```SQL
WITH visit_transactions AS (
    SELECT
        v.user_id,
        v.visit_date,
        COUNT(t.transaction_date) AS transaction_count
    FROM Visits v
    LEFT JOIN Transactions t ON v.user_id = t.user_id AND v.visit_date = t.transaction_date
    GROUP BY v.user_id, v.visit_date
),

transaction_counts AS (
    SELECT
        transaction_count,
        COUNT(*) AS visits_count
    FROM visit_transactions
    GROUP BY transaction_count
),

max_transaction AS (
    SELECT MAX(transaction_count) AS max_count
    FROM visit_transactions
),

all_counts AS (
    SELECT 0 AS transactions_count
    UNION ALL
    SELECT transactions_count + 1
    FROM all_counts
    WHERE transactions_count < (SELECT max_count FROM max_transaction)
)

SELECT
    ac.transactions_count,
    COALESCE(tc.visits_count, 0) AS visits_count
FROM all_counts ac
LEFT JOIN transaction_counts tc ON ac.transactions_count = tc.transaction_count
WHERE ac.transactions_count <= (SELECT max_count FROM max_transaction)
ORDER BY ac.transactions_count;
```

### Explanation

1. **First CTE (visit_transactions):**
    - Joins Visits with Transactions
    - Counts transactions per visit (0 if no transactions)
2. **Second CTE (transaction_counts):**
    - Groups by transaction count
    - Counts how many visits had each transaction count
3. **Third CTE (max_transaction):**
    - Finds the maximum transaction count
4. **Fourth CTE (all_counts):**
    - Recursively generates all numbers from 0 to max transaction count
5. **Main Query:**
    - Joins the generated numbers with actual counts
    - Uses COALESCE to show 0 for counts with no visits
    - Orders by transaction count

### Key Points

- Handles all possible transaction counts (including 0)
- Uses LEFT JOIN to ensure all counts are represented
- Recursive CTE generates the full range of numbers needed
- COALESCE ensures proper display of zero counts
- Works for any data volume and range of transaction counts