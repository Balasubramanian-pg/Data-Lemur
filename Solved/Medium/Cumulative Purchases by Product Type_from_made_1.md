---
Company:
- Amazon
Difficulty: Intermediate
Created: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Cumulative Purchases by Product Type_from_made_1
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Medium/Cumulative Purchases
  by Product Type_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Of course! This query is a fantastic example of a correlated subquery used to calculate a running total. It's a great opportunity to introduce the more modern and efficient window function alternative.

Here is the complete breakdown.

***

### 1. The Question

The business question being asked by this SQL query is:

**"For each product type, what is the cumulative (running total) quantity purchased over time? Show a list of every transaction, and for each one, display the total quantity purchased for that product's type up to and including that order's date."**

---

### 2. Table Schema

The query references a single table, `total_trans`. This table likely acts as a daily summary or a raw transaction log. A plausible schema would be:

```sql
-- Table: total_trans
-- Stores a record of product transactions, possibly aggregated daily.
CREATE TABLE total_trans (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    order_date     DATE NOT NULL,             -- The date of the transaction
    product_type   VARCHAR(100) NOT NULL,     -- The category or type of product
    quantity       INT NOT NULL               -- The number of units sold
);

-- Adding a composite index can improve performance for these queries.
CREATE INDEX idx_product_date ON total_trans (product_type, order_date);
```

---

### 3. Structured SQL Query (Method 1: Correlated Subquery)

This is your original query, formatted for clarity. This method works but is generally inefficient on large datasets.

```sql
SELECT
    t1.order_date,
    t1.product_type,
    (
        SELECT
            SUM(quantity)
        FROM
            total_trans AS t2
        WHERE
            t2.order_date <= t1.order_date
            AND t2.product_type = t1.product_type
    ) AS cum_purchased
FROM
    total_trans AS t1
ORDER BY
    t1.product_type, t1.order_date; -- Added for readable output
```

---

### 4. Explanation of the Query

This query calculates a running total using a **correlated subquery**. This means the inner query is executed once for *every single row* processed by the outer query.

1.  **`FROM total_trans AS t1`**
    *   This is the outer query. It iterates through each row of the `total_trans` table, aliasing it as `t1`.

2.  **`SELECT t1.order_date, t1.product_type, (...) AS cum_purchased`**
    *   For each row from `t1`, it selects the `order_date` and `product_type`.
    *   The third column, `cum_purchased`, is calculated by the subquery.

3.  **The Subquery: `(SELECT SUM(quantity) ...)`**
    *   This is the "correlated" part. This inner query is re-run for every row of `t1`.
    *   `FROM total_trans AS t2`: It scans the `total_trans` table again (as `t2`) to perform its calculation.
    *   `WHERE t2.product_type = t1.product_type`: This is the correlation. It ensures the subquery only sums quantities for the **same product type** as the current row in the outer query (`t1`).
    *   `AND t2.order_date <= t1.order_date`: This is the "cumulative" logic. It restricts the sum to include only rows with a date on or before the outer query's current row's date.

**Performance Issue:** This method is very inefficient. If `total_trans` has 10,000 rows, the inner subquery will be executed 10,000 times, leading to poor performance on large tables.

---

### 5. Another SQL Method (Method 2: Using a Window Function)

The modern, standard, and far more efficient way to calculate running totals is with **window functions**.

```sql
SELECT
    order_date,
    product_type,
    SUM(quantity) OVER (
        PARTITION BY product_type
        ORDER BY order_date
    ) AS cum_purchased
FROM
    total_trans
ORDER BY
    product_type, order_date;
```

---

### 6. Explanation of the Alternative Query

This query produces the exact same result but in a much more efficient way by performing a single pass over the data.

1.  **`FROM total_trans`**
    *   The query reads from the `total_trans` table.

2.  **`SUM(quantity) OVER (...) AS cum_purchased`**
    *   This is the window function. It calculates a `SUM` over a specific "window" of rows related to the current row.
    *   `OVER (...)`: This clause defines the window.

3.  **`PARTITION BY product_type`**
    *   This is like a `GROUP BY` for window functions. It divides the data into partitions, or groups. In this case, all rows for 'Electronics' go into one partition, all rows for 'Apparel' go into another, etc. The `SUM` calculation will be contained within these partitions (i.e., it will reset for each new `product_type`).

4.  **`ORDER BY order_date`**
    *   This sorts the rows **within each partition** by `order_date`. This ordering is crucial, as it tells the `SUM` function how to accumulate the total. The function will sum the `quantity` from the first row of the partition up to the **current row**.

**How it Works:** The database looks at each row. For that row, it considers its partition (`product_type`) and its position in the order (`order_date`). It then sums the `quantity` for all rows in that same partition that come on or before the current row's date, producing the running total in a single, efficient operation.