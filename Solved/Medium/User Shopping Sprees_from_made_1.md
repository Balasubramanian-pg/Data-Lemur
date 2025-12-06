---
Created: 2025-06-28T18:34
Area:
- MECE
- Rolling Aggregations
Key Functions:
- Recrusive CTEs
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: User Shopping Sprees_from_made_1
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Medium/User Shopping Sprees_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
In an effort to identify high-value customers, Amazon asked for your help to obtain data about users who go on shopping sprees. A shopping spree occurs when a user makes purchases on 3 or more consecutive days.

List the user IDs who have gone on at least 1 shopping spree in ascending order.

### `transactions` Table:

|   |   |
|---|---|
|**Column Name**|**Type**|
|user_id|integer|
|amount|float|
|transaction_date|timestamp|

### `transactions` Example Input:

|   |   |   |
|---|---|---|
|user_id|amount|transaction_date|
|1|9.99|08/01/2022 10:00:00|
|1|55|08/17/2022 10:00:00|
|2|149.5|08/05/2022 10:00:00|
|2|4.89|08/06/2022 10:00:00|
|2|34|08/07/2022 10:00:00|

### Example Output:

user_id

---

2

---

### Explanation

In this example, `user_id` 2 is the only one who has gone on a shopping spree.

  

Looking at this problem, I need to identify users who made purchases on 3 or more consecutive days. This requires:

1. Get distinct transaction dates for each user (since multiple transactions on the same day count as one day)
2. Identify consecutive date sequences for each user
3. Find sequences of 3 or more consecutive days
4. Return users who have at least one such sequence

The key insight is to use the difference between the transaction date and a row number sequence to group consecutive dates together.This query identifies shopping spree users through a multi-step approach:

1. **CTE (**`**daily_transactions**`**)**:
    - Gets distinct user-date combinations using `DATE(transaction_date)`
    - Eliminates multiple transactions on the same day, counting each day only once
2. **CTE (**`**consecutive_groups**`**)**:
    - Uses the "date minus row number" technique to group consecutive dates
    - `ROW_NUMBER()` assigns sequential numbers to dates for each user
    - `DATE_SUB(transaction_date, INTERVAL ROW_NUMBER() ... DAY)` creates a group identifier
    - Consecutive dates will have the same `group_date` value
3. **CTE (**`**consecutive_counts**`**)**:
    - Counts how many consecutive days are in each group
    - Groups by `user_id` and `group_date` to get the length of each consecutive sequence
4. **CTE (**`**shopping_spree_users**`**)**:
    - Filters for groups with 3 or more consecutive days (`consecutive_days >= 3`)
    - Uses `DISTINCT` since a user might have multiple shopping sprees
5. **Final Query**:
    - Returns user IDs in ascending order

**How the consecutive grouping works**:

- If user 2 has transactions on 8/5, 8/6, 8/7:
    - 8/5: row 1 → group_date = 8/5 - 1 day = 8/4
    - 8/6: row 2 → group_date = 8/6 - 2 days = 8/4
    - 8/7: row 3 → group_date = 8/7 - 3 days = 8/4
- All three dates have the same group_date (8/4), indicating they're consecutive
- The count for this group is 3, qualifying as a shopping spree

This approach correctly identifies users with 3+ consecutive shopping days, regardless of how many transactions they made each day.

  

```SQL
WITH daily_transactions AS (
  SELECT DISTINCT 
    user_id,
    DATE(transaction_date) AS transaction_date
  FROM transactions
),
consecutive_groups AS (
  SELECT 
    user_id,
    transaction_date,
    DATE_SUB(transaction_date, INTERVAL ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) DAY) AS group_date
  FROM daily_transactions
),
consecutive_counts AS (
  SELECT 
    user_id,
    group_date,
    COUNT(*) AS consecutive_days
  FROM consecutive_groups
  GROUP BY user_id, group_date
),
shopping_spree_users AS (
  SELECT DISTINCT user_id
  FROM consecutive_counts
  WHERE consecutive_days >= 3
)

SELECT user_id
FROM shopping_spree_users
ORDER BY user_id;
```