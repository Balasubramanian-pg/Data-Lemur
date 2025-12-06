---
Created: 2025-06-28T18:34
Area:
- People Analytics
Key Functions:
- CTE
- Inner Join
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Histogram of Users and Purchases_from_made_1
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Medium/Histogram of Users
  and Purchases_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
This is the same question as problem #13 in the SQL Chapter of [Ace the Data Science Interview](https://amzn.to/3kF79Fx)!

Assume you're given a table on Walmart user transactions. Based on their most recent transaction date, write a query that retrieve the users along with the number of products they bought.

Output the user's most recent transaction date, user ID, and the number of products, sorted in chronological order by the transaction date.

### `user_transactions` Table:

|   |   |
|---|---|
|Column Name|Type|
|product_id|integer|
|user_id|integer|
|spend|decimal|
|transaction_date|timestamp|

### `user_transactions` Example Input:

|   |   |   |   |
|---|---|---|---|
|product_id|user_id|spend|transaction_date|
|3673|123|68.90|07/08/2022 12:00:00|
|9623|123|274.10|07/08/2022 12:00:00|
|1467|115|19.90|07/08/2022 12:00:00|
|2513|159|25.00|07/08/2022 12:00:00|
|1452|159|74.50|07/10/2022 12:00:00|

### Example Output:

|   |   |   |
|---|---|---|
|transaction_date|user_id|purchase_count|
|07/08/2022 12:00:00|115|1|
|07/08/2022 12:00:000|123|2|
|07/10/2022 12:00:00|159|1|

Looking at this problem, I need to:

1. Find each user's most recent transaction date
2. Count how many products they bought on that most recent date
3. Sort the results chronologically by transaction date

Let me break this down step by step:The solution uses a Common Table Expression (CTE) approach:

**Step 1**: The CTE `user_max_dates` finds each user's most recent transaction date by grouping by `user_id` and taking the `MAX(transaction_date)`.

**Step 2**: The main query joins the original table with the CTE to filter only the transactions that occurred on each user's most recent date. This is done by matching both `user_id` and `transaction_date`.

**Step 3**: We then group by `transaction_date` and `user_id` and count the products (`COUNT(product_id)`) to get the number of products purchased on that most recent date.

**Step 4**: Finally, we sort by `transaction_date` in chronological order.

The key insight is that we need to filter transactions to only include those from each user's most recent date, then count the products for those filtered transactions. The CTE approach makes this logic clear and efficient.

For the given example data:

- User 115 has max date 07/08/2022 with 1 product
- User 123 has max date 07/08/2022 with 2 products
- User 159 has max date 07/10/2022 with 1 product (only counting the most recent date, not 07/08)

```SQL
-- Solution: Find users' most recent transaction date and product count
WITH user_max_dates AS (
  SELECT 
    user_id,
    MAX(transaction_date) as max_transaction_date
  FROM user_transactions
  GROUP BY user_id
)

SELECT 
  ut.transaction_date,
  ut.user_id,
  COUNT(ut.product_id) as purchase_count
FROM user_transactions ut
INNER JOIN user_max_dates umd 
  ON ut.user_id = umd.user_id 
  AND ut.transaction_date = umd.max_transaction_date
GROUP BY ut.transaction_date, ut.user_id
ORDER BY ut.transaction_date;
```