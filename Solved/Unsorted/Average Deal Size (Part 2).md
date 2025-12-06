---
Created: null
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Average Deal Size (Part 2)
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Average Deal Size
  (Part 2).md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Of course! This is a great, straightforward query that highlights a common business calculation. It also provides a nice opportunity to discuss the mathematical components of an average.

Here is the complete breakdown.

***

### 1. The Question

The business question being asked by this SQL query is:

**"What is the average deal size across all of our contracts, rounded to two decimal places?"**

The query defines a "deal size" as the `yearly_seat_cost` multiplied by the `num_seats` for a single contract.

---

### 2. Table Schema

The query references a single table, `contracts`. A plausible schema for this table would be:

```sql
-- Table: contracts
-- Stores information about each sales contract with a customer.
CREATE TABLE contracts (
    contract_id       INT PRIMARY KEY,        -- Unique identifier for the contract
    customer_id       INT NOT NULL,           -- ID of the customer for this contract
    num_seats         INT NOT NULL,           -- The number of user seats purchased
    yearly_seat_cost  DECIMAL(10, 2) NOT NULL,-- The cost per seat per year
    start_date        DATE,                   -- The start date of the contract
    status            VARCHAR(20)             -- e.g., 'Active', 'Expired', 'Cancelled'
);
```

---

### 3. Structured SQL Query (Method 1: Using `AVG`)

This is your original query, formatted for clarity. It is the most direct and readable way to ask for an average.

```sql
SELECT
    ROUND(AVG(yearly_seat_cost * num_seats), 2) AS average_deal_size
FROM
    contracts;
```

---

### 4. Explanation of the Query

This query calculates a single aggregate value for the entire `contracts` table. The calculation happens from the inside out.

1.  **`FROM contracts`**
    *   The query targets the `contracts` table as its data source.

2.  **`yearly_seat_cost * num_seats`**
    *   For **each row** in the `contracts` table, the database first performs this multiplication. This computes the total value (the "deal size") for that individual contract.

3.  **`AVG(...)`**
    *   The `AVG()` aggregate function then takes all of these individual deal size values (one from each row) and calculates their statistical average.

4.  **`ROUND(..., 2)`**
    *   The result of the `AVG()` function is then passed to the `ROUND()` function, which rounds the number to two decimal places, making it suitable for displaying as a monetary value.

5.  **`AS average_deal_size`**
    *   Finally, the resulting single value is placed into a column named `average_deal_size`. Since there is no `GROUP BY` clause, the query returns just one row and one column.

---

### 5. Another SQL Method (Method 2: Using `SUM` and `COUNT`)

An alternative way to calculate an average is to manually perform the underlying math: `Average = Total Sum / Total Count`. This can sometimes provide more clarity on the components of the calculation.

```sql
SELECT
    ROUND(
        SUM(yearly_seat_cost * num_seats) / COUNT(*),
        2
    ) AS average_deal_size
FROM
    contracts;
```

---

### 6. Explanation of the Alternative Query

This query arrives at the exact same result by breaking the average calculation into its fundamental parts.

1.  **`SUM(yearly_seat_cost * num_seats)`**
    *   This part first calculates the deal size for each row (`yearly_seat_cost * num_seats`) and then adds them all together using `SUM()`. This gives you the **total value of all contracts combined**.

2.  **`COUNT(*)`**
    *   This simply counts the **total number of rows** (i.e., total number of contracts) in the table.

3.  **`SUM(...) / COUNT(*)`**
    *   The query then divides the total value of all contracts by the total number of contracts. This division is the mathematical definition of an average.

4.  **`ROUND(..., 2) AS average_deal_size`**
    *   Just like in the first method, the result is rounded to two decimal places and given the alias `average_deal_size`.

**Comparison:**
*   **Method 1 (`AVG`)** is more declarative. You are telling the database "I want the average," and it handles the details. It is generally the preferred and more readable method.
*   **Method 2 (`SUM`/`COUNT`)** is more explicit about the mathematical operation. Both methods are functionally identical and will likely have the same performance in most database systems.