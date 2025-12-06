---
Date: 2025-07-30
Difficulty: Hard
Title: Active User Retention
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Hard/Active User Retention.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Company: ''
Question Link: ''
Category: ''
Sub Category: ''
---
Assume you're given a table containing information on Facebook user actions. Write a query to obtain number of monthly active users (MAUs) in July 2022, including the month in numerical format "1, 2, 3".

Hint:

- An active user is defined as a user who has performed actions such as 'sign-in', 'like', or 'comment' in both the current month and the previous month.

### `user_actions` Table:

|   |   |
|---|---|
|Column Name|Type|
|user_id|integer|
|event_id|integer|
|event_type|string ("sign-in, "like", "comment")|
|event_date|datetime|

### `user_actions`Example Input:

|   |   |   |   |
|---|---|---|---|
|user_id|event_id|event_type|event_date|
|445|7765|sign-in|05/31/2022 12:00:00|
|742|6458|sign-in|06/03/2022 12:00:00|
|445|3634|like|06/05/2022 12:00:00|
|742|1374|comment|06/05/2022 12:00:00|
|648|3124|like|06/18/2022 12:00:00|

### Example Output for June 2022:

|   |   |
|---|---|
|month|monthly_active_users|
|6|1|

### Example

In June 2022, there was only one monthly active user (MAU) with the `user_id` 445.

Please note that the output provided is for June 2022 as the `user_actions` table only contains event dates for that month. You should adapt the solution accordingly for July 2022.

  

Looking at this problem, I need to find users who were active in both July 2022 AND June 2022 (the previous month). A user is considered a Monthly Active User (MAU) for July 2022 if they performed actions in both months.The solution works as follows:

**Step 1**: Create a CTE `july_users` to get all distinct users who had any activity in July 2022.

**Step 2**: Create a CTE `june_users` to get all distinct users who had any activity in June 2022 (the previous month).

**Step 3**: Use an `INNER JOIN` between the two CTEs to find users who appear in BOTH months - these are the Monthly Active Users for July 2022.

**Step 4**: Count the number of such users and return the result with month = 7.

**Key Points**:

- MAU for July 2022 requires activity in BOTH July 2022 AND June 2022
- We use `DISTINCT user_id` in each CTE to avoid counting the same user multiple times even if they had multiple actions in a month
- The `INNER JOIN` ensures we only count users who were active in both months
- `EXTRACT(YEAR FROM event_date) = 2022 AND EXTRACT(MONTH FROM event_date) = 7` filters for July 2022

Alternative approach using conditional aggregation:

```SQL
-- Alternative solution using conditional aggregation
 SELECT
 7 AS month,
 COUNT(DISTINCT user_id) AS monthly_active_users
 FROM user_actions
 WHERE user_id IN (
  SELECT user_id
  FROM user_actions
  WHERE EXTRACT(YEAR FROM event_date) = 2022
    AND EXTRACT(MONTH FROM event_date) = 7
  GROUP BY user_id
)
AND user_id IN (
  SELECT user_id
  FROM user_actions
  WHERE EXTRACT(YEAR FROM event_date) = 2022
    AND EXTRACT(MONTH FROM event_date) = 6
  GROUP BY user_id
);
```

Both approaches will correctly identify users who were active in both the current month (July) and the previous month (June).