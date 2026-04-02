---
Created: null
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Unique Money Transfer Relationships_from_made_1
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Medium/Unique Money Transfer
  Relationships_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Of course! This is a fantastic query that uses the `INTERSECT` set operator, which is a powerful and elegant way to find commonalities between two result sets.

Here is the complete breakdown.


### 1. The Question

The business question being asked by this SQL query is:

**"How many unique, two-way (or mutual) money transfer relationships exist in our data? A two-way relationship is defined as one where User A has paid User B, and User B has also paid User A at some point."**


### 2. Table Schema

The query references a single table, `payments`. A plausible schema for this table would be:

```sql
-- Table: payments
-- Stores a record for every money transfer between two users.
CREATE TABLE payments (
    payment_id    INT PRIMARY KEY,
    payer_id      INT NOT NULL,           -- The ID of the user sending the money
    recipient_id  INT NOT NULL,           -- The ID of the user receiving the money
    amount        DECIMAL(10, 2) NOT NULL,
    payment_date  TIMESTAMP
);

-- An index on the payer/recipient pair would significantly improve performance.
CREATE INDEX idx_payments_pair ON payments (payer_id, recipient_id);
```


### 3. Structured SQL Query (Method 1: Using `INTERSECT`)

This is your original query, which is a very clever and concise way to solve this problem.

```sql
-- Step 1: Find all pairs of users (A, B) where A paid B and B paid A.
WITH two_way_rel AS (
    -- This gets all (payer, recipient) pairs that exist.
    SELECT
        payer_id AS payer,
        recipient_id AS recipient
    FROM
        payments
    
    INTERSECT
    
    -- This gets all (recipient, payer) pairs and re-aliases them.
    SELECT
        recipient_id AS payer,
        payer_id AS recipient
    FROM
        payments
)
-- Step 2: Count the resulting pairs and divide by two to get unique relationships.
SELECT
    COUNT(payer) / 2 AS unique_relationships
FROM
    two_way_rel;
```


### 4. Explanation of the Query

This query uses a Common Table Expression (CTE) and the `INTERSECT` operator to find mutual relationships.

**Step 1: The `two_way_rel` CTE**

*   **The Top `SELECT`**: `SELECT payer_id AS payer, recipient_id AS recipient FROM payments`
    *   This query generates a list of all direct payment relationships. For example, if User 1 paid User 2, this produces the pair `(1, 2)`.

*   **The Bottom `SELECT`**: `SELECT recipient_id AS payer, payer_id AS recipient FROM payments`
    *   This query generates a list of the *inverse* relationships. If User 2 paid User 1, this produces the pair `(2, 1)`. The columns are cleverly aliased to have the same names (`payer`, `recipient`) as the top query.

*   **The `INTERSECT` Operator**:
    *   `INTERSECT` takes the results of the top and bottom queries and returns only the rows that appear in **both** sets.
    *   Let's trace it:
        *   Assume User 1 paid User 2. The top query has the pair `(1, 2)`.
        *   Assume User 2 paid User 1. The bottom query has the pair `(1, 2)` (because `recipient_id`=1 becomes `payer`, and `payer_id`=2 becomes `recipient`).
        *   Since `(1, 2)` exists in both sets, `INTERSECT` will include it in the `two_way_rel` result.
    *   The CTE `two_way_rel` will therefore contain a list of all pairs `(A, B)` where A has paid B and B has paid A. Crucially, it will contain **both** `(A, B)` and `(B, A)`.

**Step 2: The Final `SELECT` Statement**

*   **`COUNT(payer) / 2`**: This is the final step to get the correct count.
    *   Since `two_way_rel` contains both `(1, 2)` and `(2, 1)` for a single mutual relationship, simply counting the rows would give us `2`.
    *   By dividing the total count by 2, we correct for this double-counting and get the number of unique *relationships* (which is 1).


### 5. Another SQL Method (Method 2: Using a `SELF-JOIN`)

A more common way to solve this type of "find the mirror image" problem is with a self-join.

```sql
SELECT
    COUNT(DISTINCT p1.payer_id)
FROM
    payments AS p1
INNER JOIN
    payments AS p2 ON p1.payer_id = p2.recipient_id AND p1.recipient_id = p2.payer_id
WHERE
    p1.payer_id < p1.recipient_id;
```


### 6. Explanation of the Alternative Query

This method joins the `payments` table to itself to find pairs of transactions that represent a mutual exchange.

1.  **`FROM payments AS p1 INNER JOIN payments AS p2 ON ...`**: This is a **self-join**. We are treating the `payments` table as two separate tables, `p1` and `p2`.
2.  **The `JOIN` Condition**:
    *   `p1.payer_id = p2.recipient_id AND p1.recipient_id = p2.payer_id`: This is the core logic. It looks for a transaction in `p1` (e.g., A paid B) and tries to find its exact "mirror" transaction in `p2` (where B paid A).
3.  **The `WHERE` Clause**:
    *   `WHERE p1.payer_id < p1.recipient_id`: This is a clever and crucial trick to avoid double-counting. Without it, the join would find the pair for `(A -> B)` and `(B -> A)` and also for `(B -> A)` and `(A -> B)`, resulting in two rows for the same relationship.
    *   By enforcing that we only consider rows where the first ID is smaller than the second, we ensure that for any given pair (e.g., users 1 and 2), we only count the relationship once (when `p1.payer_id` is 1 and `p1.recipient_id` is 2), and ignore the other direction.
4.  **`SELECT COUNT(DISTINCT p1.payer_id)`**: Since the `WHERE` clause has already handled the de-duplication of relationships, we can now simply count the unique payers to get our final answer. (Note: `COUNT(*)` would also work here because of the `WHERE` clause).