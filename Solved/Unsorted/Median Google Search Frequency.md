---
Created: 2025-06-28T18:34
Area:
- Statistical Aggregation
Key Functions:
- MEDIAN()
- Window Function
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Median Google Search Frequency
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Median Google Search
  Frequency.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Google's marketing team is making a Superbowl commercial and needs a  
simple statistic to put on their TV ad: the median number of searches a  
person made last year.  

However, at Google scale, querying the 2 trillion searches is too  
costly. Luckily, you have access to the summary table which tells you  
the number of searches made last year and how many Google users fall  
into that bucket.  

Write a query to report the median of searches made by a user. Round the median to one decimal point.

### `search_frequency` Table:

|   |   |
|---|---|
|Column Name|Type|
|searches|integer|
|num_users|integer|

### `search_frequency` Example Input:

|   |   |
|---|---|
|searches|num_users|
|1|2|
|2|2|
|3|3|
|4|1|

### Example Output:

median

---

2.5

---

By expanding the search_frequency table, we get [1, 1, 2, 2, 3, 3, 3, 4] which has a median of 2.5 searches per user.

  

Looking at this problem, I need to find the median from a frequency table. The key insight is that I need to:

1. Calculate the total number of users
2. Find the median position(s)
3. Determine which search values correspond to those positions
4. Calculate the median accordinglyThe solution works as follows:

**Step 1**: Calculate the total number of users using CTE `user_totals`.

**Step 2**: Create cumulative counts using CTE `cumulative_counts`:

- Use a window function to get running totals of users
- This tells us how many users have made ≤ X searches

**Step 3**: Determine median positions using CTE `median_positions`:

- For odd total users: median is at position (n+1)/2
- For even total users: median is average of positions n/2 and n/2+1

**Step 4**: Find the actual search values using CTE `median_values`:

- Use subqueries to find the first search value where cumulative_users ≥ median position
- This gives us the search counts that correspond to our median positions

**Step 5**: Calculate the final median:

- Average the two median values and round to 1 decimal place

**Example walkthrough**:

- Data: [1,1,2,2,3,3,3,4] (expanded from frequency table)
- Total users: 8 (even number)
- Median positions: 4th and 5th values
- 4th value = 2, 5th value = 3
- Median = (2 + 3) / 2 = 2.5

**Cumulative counts for example**:

- searches=1: cumulative=2 users
- searches=2: cumulative=4 users
- searches=3: cumulative=7 users
- searches=4: cumulative=8 users

For position 4: first searches where cumulative ≥ 4 is searches=2  
For position 5: first searches where cumulative ≥ 5 is searches=3  

The key insight is using cumulative sums to convert the frequency table back into positional data without actually expanding the table.

```SQL
-- Solution: Find median number of searches per user from frequency table
WITH user_totals AS (
  SELECT SUM(num_users) AS total_users
  FROM search_frequency
),
cumulative_counts AS (
  SELECT 
    searches,
    num_users,
    SUM(num_users) OVER (ORDER BY searches) AS cumulative_users
  FROM search_frequency
),
median_positions AS (
  SELECT 
    total_users,
    CASE 
      WHEN total_users % 2 = 1 THEN (total_users + 1) / 2.0
      ELSE total_users / 2.0
    END AS median_pos1,
    CASE 
      WHEN total_users % 2 = 1 THEN (total_users + 1) / 2.0
      ELSE (total_users / 2.0) + 1
    END AS median_pos2
  FROM user_totals
),
median_values AS (
  SELECT 
    mp.total_users,
    mp.median_pos1,
    mp.median_pos2,
    -- Find the search value for first median position
    (SELECT searches 
     FROM cumulative_counts cc1 
     WHERE cc1.cumulative_users >= mp.median_pos1 
     ORDER BY cc1.searches 
     LIMIT 1) AS median_val1,
    -- Find the search value for second median position  
    (SELECT searches 
     FROM cumulative_counts cc2 
     WHERE cc2.cumulative_users >= mp.median_pos2 
     ORDER BY cc2.searches 
     LIMIT 1) AS median_val2
  FROM median_positions mp
)

SELECT 
  ROUND((median_val1 + median_val2) / 2.0, 1) AS median
FROM median_values;
```