---
Created: 2025-06-28T18:34
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Top 5 Streams
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Top 5 Streams.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
**SQL Schema**

```Plain
Table: orders
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| order_id    | int     |
| item_id     | int     |
| quantity    | int     |
| order_date  | date    |
+-------------+---------+

Table: catalog
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| item_id      | int     |
| product_id   | int     |
| product_group| var     |
| location     | var     |
+-------------+----------+
```

Write a query to return the product groups in the **US** that have no sales of any unit.

So I have to select the product group from catalog table where location is US and quantity is 0

  

```SQL
SELECT c.product_group,
FROM orders o
LEFT JOIN catalog c on o.item_id = c.item_id
WHERE o.quantity IS NULL AND c.location = 'US'
```

  

**Example**

```Plain
orders table:
+-------------+---------+-------------+--------------------+
| order_id    | item_id | quantity    | order_date         |
+-------------+---------+-------------+--------------------+
| 1           | 46      | 646         | 2019-01-01 9:00:00 |
| 2           | 63      | 343         | 2019-01-01 12:00:00|
| 3           | 23      | 987         | 2019-01-02 13:00:00|
| 4           | 24      | 234         | 2019-01-01 17:00:00|
| 5           | 53      | 854         | 2019-01-03 23:00:00|
+-------------+---------+-------------+---------+----------+

catalog table:
+---------+-------------+---------------+---------------+
| item_id | product_id  | product_group | location      |
+---------+-------------+---------------+---------------+
| 46      | 543         | A             | US            |
| 63      | 567         | B             | US            |
| 23      | 566         | B             | MX            |
| 24      | 563         | C             | CA            |
| 53      | 568         | D             | US            |
+---------+-------------+---------------+---------------+
```

  

---

**SQL Schema**

```Plain
Table: orders
+-----------------+---------+
| Column Name     | Type    |
+-----------------+---------+
|product_id       |int      |
|order_date       |date     |
|customer_id      |int      |
|units_sold       |int      |
+-----------------+---------+
```

```Plain
Table: product
+-----------------+---------+
| Column Name     | Type    |
+-----------------+---------+
|product_id       |int      |
|product_name     |var      |
|product_category |var      |
+-----------------+---------+
```

Write a query to **return the product names** that were ordered during the last 1 week. Order by product name ASC.

I need to return product names from product table, where order date is last 1 week

I have to order by product name ascending

```SQL
SELECT p.product_name
FROM product p
LEFT JOIN orders o ON o.product_id = p.product_id
WHERE order_date > DATEADD(DAY, -7, GETDATE()
ORDER BY o.product_name ASC;
```

  

**Example**

```Plain
Table: orders
+----------+-------------------------+-----------+----------+
|product_id|order_date               |customer_id|units_sold|
+----------+-------------------------+-----------+----------+
|10        |current_timestamp::DATE-8|463422     |100       |
|20        |current_timestamp::DATE-4|356784     |200       |
|30        |current_timestamp::DATE-1|456789     |90        |
+----------+-------------------------+-----------+----------+
```

```Plain
Table: product
+----------+------------+----------------+
|product_id|product_name|product_category|
+----------+------------+----------------+
|10        |alpha       |plastics        |
|20        |omega       |electronic      |
|30        |delta       |metal           |
+----------+------------+----------------+
```

**Output**

```Plain
+--------------+
|product_name  |
+--------------+
|delta         |
|omega         |
+--------------+
```

---

**SQL Schema**

```Plain
Table: orders
+-----------------+---------+
| Column Name     | Type    |
+-----------------+---------+
|product_id       |int      |
|order_date       |date     |
|customer_id      |int      |
|units_sold       |int      |
+-----------------+---------+

Table: product
+-----------------+---------+
| Column Name     | Type    |
+-----------------+---------+
|product_id       |int      |
|product_name     |var      |
|product_category |var      |
+-----------------+---------+
```

Your boss wants a report from the past week and asks you to write a query to **return the product names** with orders for more than 100 units.  
(Order by product name ASC.)  

```SQL
SELECT p.product_name
FROM orders o
LEFT JOIN product p ON o.product_id = p.product_id
WHERE o.order_date >= DATEADD(DAY,-7,GETDATE())
AND o.units_sold > 100
ORDER BY p.product_name ASC;
```

**Example**

```Plain
Table: orders
+----------+-------------------------+-----------+----------+
|product_id|order_date               |customer_id|units_sold|
+----------+-------------------------+-----------+----------+
|10        |current_timestamp::DATE-6|463422     |100       |
|20        |current_timestamp::DATE-5|356784     |200       |
|30        |current_timestamp::DATE-4|456789     |130       |
|40        |current_timestamp::DATE-3|463422     |130       |
|50        |current_timestamp::DATE-2|356784     |200       |
|60        |current_timestamp::DATE-1|456789     |400       |
+----------+-------------------------+-----------+----------+
```

```Plain
Table: products
+----------+------------+----------------+
|product_id|product_name|product_category|
+----------+------------+----------------+
|10        |alpha       |plastics        |
|20        |omega       |electronic      |
|30        |delta       |metal           |
|40        |charlie     |silver          |
|50        |trinity     |gold            |
|60        |echo        |waste           |
+----------+------------+----------------+
```

**Output**

```Plain
+---------------+
|product_name   |
+---------------+
|charlie        |
|delta          |
|echo           |
|trinity        |
|omega          |
+---------------+
```

---

**SQL Schema**

```Plain
Table: streams
+-----------------+---------+
| Column Name     | Type    |
+-----------------+---------+
|country          |var      |
|stream_date      |date     |
|stream_id        |int      |
|device_type      |var      |
|user_id          |var      |
|minutes_streamed |int      |
+-----------------+---------+
```

```Plain
Table: rentals
+-----------------+---------+
| Column Name     | Type    |
+-----------------+---------+
|country          |var      |
|rental_date      |date     |
|rental_id        |int      |
|user_id          |var      |
+-----------------+---------+
```

Write a query to **return the user and device type** for the top 5 streams by minutes in Japan in the **7 days** leading up to (and including) January 18th, 2022. (Hint: resolve ties by prioritizing the most recent stream date first.)

  

**Example**

```Plain
Table: streams
+-------+-----------+---------+-----------+---------+----------------+
|country|stream_date|stream_id|device_type|user_id  |minutes_streamed|
+-------+-----------+---------+-----------+---------+----------------+
|US     |1/11/2022  |921352   |telivision |WSFGN123 |12              |
|UK     |1/11/2022  |921315   |mobile     |FCVBJ123 |30              |
|US     |2/1/2021   |921315   |web browser|IJHGG123 |45              |
|US     |2/1/2021   |921316   |web browser|BGHJM123 |16              |
|US     |2/1/2021   |921317   |web browser|BGHJM124 |15              |
|UK     |1/12/2021  |971318   |web browser|BGHJM123 |100             |
|US     |1/12/2022  |951319   |mobile     |SDXAD123 |65              |
|US     |1/17/2022  |951320   |mobile     |SDXAD223 |10              |
|US     |1/17/2022  |951321   |mobile     |SDXAD323 |45              |
|US     |1/17/2022  |951320   |mobile     |SDXAD423 |13              |
|US     |1/17/2022  |951321   |mobile     |SDXAD523 |500             |
|JP     |1/12/2022  |951610   |telivision |SFGHG120 |15              |
|JP     |1/12/2022  |951611   |telivision |SFGHG121 |91              |
|JP     |1/12/2022  |951612   |telivision |SFGHG123 |44              |
|JP     |1/17/2022  |951613   |telivision |SFGHG133 |20              |
|JP     |1/16/2022  |951614   |telivision |SFGHG143 |44              |
|JP     |1/15/2022  |951615   |telivision |SFGHG153 |45              |
|JP     |1/17/2021  |951616   |telivision |SFGHG153 |44              |
|JP     |1/17/2022  |951617   |telivision |SFGHG153 |95              |
|US     |2/6/2021   |951618   |telivision |IJHGG123 |15              |
|US     |2/6/2021   |951619   |telivision |BGHJM123 |31              |
|US     |1/17/2022  |951620   |telivision |SDXAD523 |31              |
|US     |2/7/2021   |951621   |telivision |IJHGG123 |32              |
+-------+-----------+---------+-----------+---------+----------------+
```

```Plain
Table: rentals
+-------+-----------+---------+---------+
|country|rental_date|rental_id|user_id  |
+-------+-----------+---------+---------+
|US     |1/11/2022  |123456   |WSFGN123 |
|UK     |1/15/2022  |678909   |FCVBJ123 |
|IN     |1/11/2022  |467432   |IJHGG123 |
|UK     |1/4/2022   |176543   |BGHJM123 |
|US     |2/2/2021   |7654331  |SDXAD123 |
|JP     |1/17/2022  |083456   |FGHG123  |
|JP     |1/17/2022  |083457   |SDXAD123 |
|JP     |2/1/2021   |083458   |SFGHG123 |
|US     |1/16/2022  |083459   |IJHGG123 |
|JP     |2/1/2021   |083460   |FCVBJ133 |
|JP     |2/1/2021   |083461   |FCVBJ143 |
|JP     |2/1/2019   |083462   |FCVBJ153 |
|JP     |2/7/2019   |083463   |FCVBJ153 |
+-------+-----------+---------+---------+
```

**Output**

```Plain
+---------+------------+
|user_id  |device_type |
+---------+------------+
|SFGHG153 |telivision  |
|SFGHG121 |telivision  |
|SFGHG153 |telivision  |
|SFGHG143 |telivision  |
|SFGHG123 |telivision  |
+---------+------------+
```

  

---

==**A complex Problem**==

This problem requires handling three cases:

1. Get the **latest status** for each customer at the **end of each month** in 2019.
2. If multiple records exist for a month, pick the **latest event_date** in that month.
3. If no records exist for a month, use the **latest prior record**.

---

### **Solution Approach**

1. **Generate a list of all months in 2019**.
2. **Find the latest record for each customer in each month**.
3. **Use a window function to carry forward the latest status from previous months if no record exists for a month**.

---

### **SQL Query**

```SQL
WITH MonthList AS (
    -- Generate all months in 2019
    SELECT DATEFROMPARTS(2019, num, 1) AS month_start
    FROM (VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12)) AS months(num)
),
RankedData AS (
    -- Assign row numbers based on latest event_date per customer per month
    SELECT
        c.customer_id,
        DATEFROMPARTS(YEAR(c.event_date), MONTH(c.event_date), 1) AS month_start,
        c.event_date,
        c.status,
        c.credit_limit,
        ROW_NUMBER() OVER (PARTITION BY c.customer_id, YEAR(c.event_date), MONTH(c.event_date)
                           ORDER BY c.event_date DESC) AS rn
    FROM customer_data c
    WHERE YEAR(c.event_date) = 2019
),
LatestPerMonth AS (
    -- Get the latest event within each month
    SELECT customer_id, month_start, event_date, status, credit_limit
    FROM RankedData
    WHERE rn = 1
),
AllMonths AS (
    -- Create a full dataset with all months per customer
    SELECT DISTINCT c.customer_id, m.month_start
    FROM customer_data c
    CROSS JOIN MonthList m
),
FinalData AS (
    -- Combine the actual monthly data and fill missing months with latest available data
    SELECT
        a.customer_id,
        a.month_start,
        l.event_date,
        l.status,
        l.credit_limit,
        -- Assign a ranking to pick the latest prior data if no exact match is found
        ROW_NUMBER() OVER (PARTITION BY a.customer_id, a.month_start ORDER BY l.event_date DESC) AS rn
    FROM AllMonths a
    LEFT JOIN LatestPerMonth l
        ON a.customer_id = l.customer_id
        AND l.month_start <= a.month_start
)
-- Pick the latest available record
SELECT customer_id, month_start, event_date, status, credit_limit
FROM FinalData
WHERE rn = 1
ORDER BY customer_id, month_start;
```

---

### **Explanation**

1. `**MonthList**`: Creates a list of months from January to December 2019.
2. `**RankedData**`: Assigns a rank to pick the latest event for each month.
3. `**LatestPerMonth**`: Extracts the most recent event per customer per month.
4. `**AllMonths**`: Ensures every customer has all 12 months available.
5. `**FinalData**`: Joins data with `LatestPerMonth`, carrying forward the last known status if missing.
6. **Final** `**SELECT**`: Picks the latest available record for each month.

---

### **Handling Edge Cases**

✔️ If a customer has multiple records in a month → **Picks the latest date**.

✔️ If a month has no record → **Uses the latest available prior record**.

✔️ If no prior record exists → **Data remains NULL** (Can be handled with a default value).

🚀 **This ensures an accurate, gap-free status report for all months in 2019!** 🚀

---

Here are the answers to the questions you faced in your phone interview rounds:

---

### **Data Engineering Questions**

### **1. What is partitioning?**

Partitioning is the process of dividing a large dataset into smaller, more manageable parts (partitions) to improve query performance. It reduces the amount of data scanned by queries by filtering based on partition columns.

### **2. What is the difference between OLAP vs. OLTP?**

- **OLAP (Online Analytical Processing)**: Used for analytics and reporting. It involves complex queries on large datasets and is optimized for reading and aggregations. Example: Data warehouses.
- **OLTP (Online Transaction Processing)**: Used for real-time transactional workloads. It involves frequent read-write operations on normalized databases. Example: Banking systems.

### **3. What is a cube?**

A cube (OLAP cube) is a multi-dimensional data structure that allows fast retrieval of aggregated data for analytical queries. It precomputes aggregations and stores data in multiple dimensions (e.g., sales by region, product, and time).

### **4. What are the file formats used in Hadoop?**

Common Hadoop file formats include:

- **Text-based**: CSV, JSON, XML
- **Binary**: Avro, ORC, Parquet
- **Sequence Files**: Used for key-value pair storage in Hadoop

### **5. What is partitioning in Hive?**

Partitioning in Hive organizes tables into partitions based on column values (e.g., `year=2023, month=01`). It improves query performance by reducing the amount of data scanned.

### **6. What are the different compression formats in Hive?**

Common Hive compression formats include:

- **Gzip (.gz)**
- **Snappy** (fastest, used in Parquet/ORC)
- **Bzip2 (.bz2)**
- **LZO (Splittable, used in HDFS for large data)**

---

### **SQL Questions**

### **7. Find the top-selling items (SQL query).**

```SQL
SELECT product_id, SUM(units_sold) AS total_sales
FROM orders
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 1;
```

This finds the top-selling item based on total units sold.

### **8. Sum of an array in SQL (assuming an array column in PostgreSQL).**

```SQL
SELECT id, SUM(unnest(array_column)) AS total_sum
FROM table_name
GROUP BY id;
```

For databases without array support, you'd need to normalize the data.

### **9. Sum of two numbers (SQL query).**

```SQL
SELECT num1 + num2 AS sum FROM table_name;
```

If using variables:

```SQL
SELECT 5 + 10 AS sum;
```

---

### **Behavioral Questions**

### **10. What is tracing?**

Tracing is a debugging and monitoring technique used to track requests as they flow through a system. It's common in distributed systems (e.g., OpenTelemetry, AWS X-Ray) to trace API calls and latency issues.

### **11. What best practice compromise did you make to deliver a product on time?**

Example Answer:

_"In one project, we had a strict deadline for launching a data pipeline. The best practice was to implement full data validation at every stage, but it would have delayed the release. Instead, we prioritized critical checks and implemented a post-deployment monitoring system to identify anomalies. This allowed us to meet the deadline while ensuring data integrity over time."_

---

Hi folks, just wanna share a few sql questions I had on a recent Amazon Data Scientist phone interview

there are 2 tables: STREAMS and TITLES

```SQL
STREAMS table
USER_ID
TITLE_ID
STREAM_TIMESTART
STREAM_MINUTES
Key for this table is (USER_ID,TITLE_ID,STREAM_TIMESTART)

TITLES table

TITLE_ID
GENRE
NAME
LAUNCH_DATE

Key for this table is TITLE_ID
```

1. Find the number of times of each movie (title) was streamed and the total minutes streamed and the movie's genre in the month of December 2018.  
    My solution: Straightforward  
    `join` and `group by`
2. Find the name and title id of the first movie streamed by each user each day.  
    My solution: Window function parition by  
    `USER_ID` and `date(STREAM_TIMESTART)` and order by `STREAM_TIMESTART` here, taking `row_number()==1`.
3. Find the total minutes streamed for each movie within the first 28 days since the movie's launch date.  
    My solution: I did a  
    `join` with a filter `LAUNCH_DATE + INTERVAL 28 DAYS >= date(STREAM_TIMESTART)` here but the interviewer did not seemed to like/understand this  
    approach and kept asking me for an alternative approach. I guess he  
    found it unintuitive? Anyone else got another idea please?  
    

---