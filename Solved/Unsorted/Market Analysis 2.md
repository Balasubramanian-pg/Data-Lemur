---
Created: 2025-06-28T18:34
Area:
- Statistical Aggregation
Key Functions:
- Recrusive CTEs
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Market Analysis 2
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Market Analysis
  2.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Here's the structured solution for Question 103:

### Problem Statement

For each user, determine if the brand of the second item they sold (by date) matches their favorite brand. If they sold fewer than two items, mark as "no".

### Tables

**Users table:**

```Plain
+---------+------------+----------------+
| user_id | join_date  | favorite_brand |
+---------+------------+----------------+
| 1       | 2019-01-01 | Lenovo         |
| 2       | 2019-02-09 | Samsung        |
| 3       | 2019-01-19 | LG             |
| 4       | 2019-05-21 | HP             |
+---------+------------+----------------+
```

**Orders table:**

```Plain
+----------+------------+---------+----------+-----------+
| order_id | order_date | item_id | buyer_id | seller_id |
+----------+------------+---------+----------+-----------+
| 1        | 2019-08-01 | 4       | 1        | 2         |
| 2        | 2019-08-02 | 2       | 1        | 3         |
| 3        | 2019-08-03 | 3       | 2        | 3         |
| 4        | 2019-08-04 | 1       | 4        | 2         |
| 5        | 2019-08-04 | 1       | 3        | 4         |
| 6        | 2019-08-05 | 2       | 2        | 4         |
+----------+------------+---------+----------+-----------+
```

**Items table:**

```Plain
+---------+------------+
| item_id | item_brand |
+---------+------------+
| 1       | Samsung    |
| 2       | Lenovo     |
| 3       | LG         |
| 4       | HP         |
+---------+------------+
```

### Expected Output

```Plain
+-----------+--------------------+
| seller_id | 2nd_item_fav_brand |
+-----------+--------------------+
| 1         | no                 |
| 2         | yes                |
| 3         | yes                |
| 4         | no                 |
+-----------+--------------------+
```

### SQL Solution

```SQL
WITH seller_orders AS (
    SELECT
        o.seller_id,
        o.order_date,
        i.item_brand,
        RANK() OVER(PARTITION BY o.seller_id ORDER BY o.order_date) AS sale_rank
    FROM orders o
    JOIN items i ON o.item_id = i.item_id
),

second_sales AS (
    SELECT
        u.user_id,
        CASE WHEN u.favorite_brand = so.item_brand THEN 'yes'
             ELSE 'no'
        END AS second_item_fav_brand
    FROM users u
    LEFT JOIN seller_orders so ON u.user_id = so.seller_id AND so.sale_rank = 2
)

SELECT
    u.user_id AS seller_id,
    COALESCE(ss.second_item_fav_brand, 'no') AS 2nd_item_fav_brand
FROM users u
LEFT JOIN second_sales ss ON u.user_id = ss.user_id
ORDER BY u.user_id;
```

### Explanation

1. **First CTE (seller_orders):**
    - Joins Orders and Items tables
    - Adds a rank to each sale by seller_id ordered by date
    - Identifies the chronological sequence of each seller's transactions
2. **Second CTE (second_sales):**
    - Joins Users with the ranked sales data
    - Compares the brand of the second sale (rank=2) with the user's favorite brand
    - Sets "yes" if they match, "no" if they don't
3. **Main Query:**
    - Joins all users with the second sales results
    - Uses COALESCE to return "no" for users who didn't make two sales
    - Orders results by user_id

### Key Points

- Uses window functions to rank sales chronologically per seller
- Handles users with fewer than two sales gracefully with LEFT JOIN and COALESCE
- Explicitly compares only the second sale's brand with the favorite brand
- Maintains all users in the output as required
- Clear CTE structure improves readability and debugging