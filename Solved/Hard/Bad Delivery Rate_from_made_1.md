---
Company:
- Air BNB
Difficulty: Hard
Created: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Bad Delivery Rate_from_made_1
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Hard/Bad Delivery Rate_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---

Of course! This is a fantastic query that uses a Common Table Expression (CTE) to create a multi-step logical flow. It's an excellent example to break down.

***

### 1. The Question

The business question being asked by this SQL query is:

**"For customers who signed up in June 2022, what was the percentage of 'bad experiences' on orders they placed within their first 14 days? A 'bad experience' is defined as any order that was not 'completed successfully'."**

---

### 2. Table Schema

The query joins two tables, `customers` and `orders`. A plausible schema for these tables would be:

```sql
-- Table: customers
-- Stores information about each customer.
CREATE TABLE customers (
    customer_id      INT PRIMARY KEY,
    customer_name    VARCHAR(255),
    signup_timestamp TIMESTAMP NOT NULL -- The exact date and time the customer registered
);

-- Table: orders
-- Stores a record for every order placed by a customer.
CREATE TABLE orders (
    order_id         INT PRIMARY KEY,
    customer_id      INT NOT NULL,
    status           VARCHAR(50) NOT NULL, -- e.g., 'completed successfully', 'cancelled', 'in transit'
    order_timestamp  TIMESTAMP NOT NULL,   -- The date and time the order was placed
    order_value      DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Indexes are crucial for the performance of this query.
CREATE INDEX idx_customers_signup ON customers (signup_timestamp);
CREATE INDEX idx_orders_customer ON orders (customer_id);
```

---

### 3. Structured SQL Query (Method 1: Using a Common Table Expression - CTE)

This is your original query, formatted for readability. It breaks the logic into two distinct steps.

```sql
WITH order_details AS (
    -- Step 1: Isolate all orders from customers who signed up in June 2022
    SELECT
        o.order_id,
        o.status,
        o.order_timestamp,
        c.signup_timestamp
    FROM
        orders AS o
    INNER JOIN
        customers AS c ON o.customer_id = c.customer_id
    WHERE
        EXTRACT(YEAR FROM c.signup_timestamp) = 2022
        AND EXTRACT(MONTH FROM c.signup_timestamp) = 6
)
-- Step 2: From that subset, calculate the failure rate for orders in the first 14 days
SELECT
    ROUND(
        100.0 *
        SUM(CASE WHEN status = 'completed successfully' THEN 0 ELSE 1 END) /
        COUNT(DISTINCT order_id),
        2
    ) AS bad_experience_pct
FROM
    order_details
WHERE
    DATE(order_timestamp) <= DATE(signup_timestamp) + INTERVAL '14 day';
```
*Note: I've updated `DATE_PART` to the more standard `EXTRACT` and adjusted the percentage calculation slightly to `100.0 * ...` to ensure floating-point division, which is a common practice for portability across different SQL databases.*

---

### 4. Explanation of the Query

This query uses a CTE to first prepare a dataset and then run a final calculation on it.

**Step 1: The `order_details` CTE**

1.  **`FROM orders AS o INNER JOIN customers AS c ...`**: It joins the `orders` and `customers` tables on `customer_id` to link each order to the customer who made it.
2.  **`WHERE EXTRACT(...)`**: It filters this joined data to keep only the records for customers who signed up in June (`MONTH = 6`) of 2022 (`YEAR = 2022`).
3.  **`SELECT ...`**: It creates a temporary result set named `order_details` containing the `order_id`, `status`, `order_timestamp`, and `signup_timestamp` for this specific group of orders.

**Step 2: The Final Calculation**

1.  **`FROM order_details`**: The main query now operates on the pre-filtered data from the CTE.
2.  **`WHERE DATE(order_timestamp) <= DATE(signup_timestamp) + INTERVAL '14 day'`**: This is a crucial second filter. It further reduces the dataset to include only orders that were placed **within 14 days** of the customer's signup date.
3.  **The Percentage Calculation**:
    *   `SUM(CASE WHEN status = 'completed successfully' THEN 0 ELSE 1 END)`: This is the numerator. It iterates through the remaining rows. If an order's status is good, it adds `0`. If it's anything else (a "bad experience"), it adds `1`. The `SUM` gives the total count of bad orders.
    *   `COUNT(DISTINCT order_id)`: This is the denominator. It counts the total number of unique orders that are being considered (i.e., from June 2022 signups, placed in the first 14 days).
    *   `100.0 * ... / ...`: The ratio of bad orders to total orders is calculated, and multiplying by `100.0` converts it to a percentage.
    *   `ROUND(..., 2)`: The final result is rounded to two decimal places.

---

### 5. Another SQL Method (Method 2: Single Combined Query)

You can achieve the same result without a CTE by combining all the logic into a single query. This version also uses a more index-friendly date range for better performance.

```sql
SELECT
    ROUND(
        100.0 *
        SUM(CASE WHEN o.status = 'completed successfully' THEN 0 ELSE 1 END) /
        COUNT(DISTINCT o.order_id),
        2
    ) AS bad_experience_pct
FROM
    orders AS o
INNER JOIN
    customers AS c ON o.customer_id = c.customer_id
WHERE
    c.signup_timestamp >= '2022-06-01'
    AND c.signup_timestamp < '2022-07-01'
    AND o.order_timestamp < c.signup_timestamp + INTERVAL '14 day';
```

---

### 6. Explanation of the Alternative Query

This method is more compact and can be more performant by allowing the database optimizer to consider all conditions at once.

1.  **`FROM ... INNER JOIN ...`**: The `JOIN` is the same as in the CTE.
2.  **`WHERE c.signup_timestamp >= '2022-06-01' AND c.signup_timestamp < '2022-07-01'`**:
    *   This is a more efficient, **SARGable** way to filter for customers who signed up in June 2022. By using a direct range comparison on the `signup_timestamp` column, the database can effectively use an index to find the relevant customers, avoiding a full table scan.
3.  **`AND o.order_timestamp < c.signup_timestamp + INTERVAL '14 day'`**:
    *   This combines the second filter directly into the main query. It compares the `order_timestamp` to the `signup_timestamp` for each row, keeping only orders within the 14-day window.
4.  **`SELECT ...`**: The percentage calculation in the `SELECT` clause is identical to the first method.

**Comparison:**
*   The **CTE method** is often easier to read, write, and debug because it separates the problem into clear, logical steps.
*   The **single query method** can be more performant, especially with the SARGable `WHERE` clause, as it gives the database planner full visibility into all constraints from the start. For this specific problem, both are excellent choices.
* 