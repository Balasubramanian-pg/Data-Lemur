---
Created: 2025-06-28T18:34
Area:
- Statistical Aggregation
Key Functions:
- CTE
- Case
- Round
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Sending VS Opening Snaps
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Sending VS Opening
  Snaps.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
This is the same question as problem #25 in the SQL Chapter of [Ace the Data Science Interview](https://amzn.to/3kF79Fx)!

Assume you're given tables with information on Snapchat users, including their ages and time spent sending and opening snaps.

Write a query to obtain a breakdown of the time spent sending vs.  
opening snaps as a percentage of total time spent on these activities  
grouped by age group. Round the percentage to 2 decimal places in the  
output.  

Notes:

- Calculate the following percentages:
    - time spent sending / (Time spent sending + Time spent opening)
    - Time spent opening / (Time spent sending + Time spent opening)
- To avoid integer division in percentages, multiply by 100.0 and not 100.

_Effective April 15th, 2023, the solution has been updated and optimised._

### `activities` Table

|   |   |
|---|---|
|Column Name|Type|
|activity_id|integer|
|user_id|integer|
|activity_type|string ('send', 'open', 'chat')|
|time_spent|float|
|activity_date|datetime|

### `activities` Example Input

|   |   |   |   |   |
|---|---|---|---|---|
|activity_id|user_id|activity_type|time_spent|activity_date|
|7274|123|open|4.50|06/22/2022 12:00:00|
|2425|123|send|3.50|06/22/2022 12:00:00|
|1413|456|send|5.67|06/23/2022 12:00:00|
|1414|789|chat|11.00|06/25/2022 12:00:00|
|2536|456|open|3.00|06/25/2022 12:00:00|

### `age_breakdown` Table

|   |   |
|---|---|
|Column Name|Type|
|user_id|integer|
|age_bucket|string ('21-25', '26-30', '31-25')|

### `age_breakdown` Example Input

|   |   |
|---|---|
|user_id|age_bucket|
|123|31-35|
|456|26-30|
|789|21-25|

### Example Output

|   |   |   |
|---|---|---|
|age_bucket|send_perc|open_perc|
|26-30|65.40|34.60|
|31-35|43.75|56.25|

### Explanation

Using the age bucket 26-30 as example, the time spent sending snaps was 5.67 and the time spent opening snaps was 3.

To calculate the percentage of time spent sending snaps, we divide the time spent sending snaps by the total time spent on sending and opening snaps, which is 5.67 + 3 = 8.67.

So, the percentage of time spent sending snaps is 5.67 / (5.67 + 3) = 65.4%, and the percentage of time spent opening snaps is 3 / (5.67 + 3) = 34.6%.

  

Alright, I have this problem about analyzing Snapchat user activities, specifically the time spent sending versus opening snaps, broken down by age groups. The goal is to calculate, for each age group, the percentage of total time spent on sending and opening snaps.

### Understanding the Problem

We have two tables:

1. `activities`: Contains records of user activities with columns:
    - `activity_id`: Unique identifier for each activity.
    - `user_id`: ID of the user who performed the activity.
    - `activity_type`: Type of activity ('send', 'open', 'chat').
    - `time_spent`: Time spent on the activity in some unit (likely seconds or minutes, but the exact unit isn't specified).
    - `activity_date`: Date and time when the activity occurred.
2. `age_breakdown`: Contains the age group information for users with columns:
    - `user_id`: ID of the user.
    - `age_bucket`: Age group of the user (e.g., '21-25', '26-30', '31-35').

The task is to:

1. For each age group (`age_bucket`), calculate the total time spent sending snaps and the total time spent opening snaps.
2. For each age group, calculate the percentage of total time (sending + opening) spent on sending and on opening.
    - Send percentage = (total time spent sending) / (total time spent sending + total time spent opening) * 100
    - Open percentage = (total time spent opening) / (total time spent sending + total time spent opening) * 100
3. Round the percentages to 2 decimal places.
4. Only consider activities of type 'send' and 'open'. The 'chat'  
    activities should be ignored since the problem is about sending and  
    opening snaps.  
    

Given the example input:

**activities Table:**

|   |   |   |   |   |
|---|---|---|---|---|
|activity_id|user_id|activity_type|time_spent|activity_date|
|7274|123|open|4.500|06/22/2022 12:00:00|
|2425|123|send|3.500|06/22/2022 12:00:00|
|1413|456|send|5.670|06/23/2022 12:00:00|
|1414|789|chat|11.000|06/25/2022 12:00:00|
|2536|456|open|3.000|06/25/2022 12:00:00|

**age_breakdown Table:**

|   |   |
|---|---|
|user_id|age_bucket|
|123|31-35|
|456|26-30|
|789|21-25|

**Expected Output:**

|   |   |   |
|---|---|---|
|age_bucket|send_perc|open_perc|
|26-30|65.40|34.60|
|31-35|43.75|56.25|

Let's verify this with the given example.

For age group '26-30' (user_id 456):

- Time spent sending: 5.67 (from activity_id 1413)
- Time spent opening: 3.00 (from activity_id 2536)
- Total time: 5.67 + 3.00 = 8.67
- Send percentage: 5.67 / 8.67 * 100 ≈ 65.40
- Open percentage: 3.00 / 8.67 * 100 ≈ 34.60

For age group '31-35' (user_id 123):

- Time spent sending: 3.50 (from activity_id 2425)
- Time spent opening: 4.50 (from activity_id 7274)
- Total time: 3.50 + 4.50 = 8.00
- Send percentage: 3.50 / 8.00 * 100 = 43.75
- Open percentage: 4.50 / 8.00 * 100 = 56.25

Note that the 'chat' activity for user_id 789 is ignored since we're only concerned with 'send' and 'open' activities.

Thus, the expected output is correct based on this calculation.

### Approach

1. **Filter Relevant Activities**: We only need activities where `activity_type` is 'send' or 'open'. We can ignore 'chat' and any other types.
2. **Join with Age Breakdown**: Join the filtered activities with the `age_breakdown` table to associate each activity with an age group.
3. **Aggregate Time by Age Group and Activity Type**: For each age group, calculate the total time spent on sending and the total time spent on opening.
4. **Calculate Percentages**: For each age group, compute:
    - Total time spent: sum(time spent sending) + sum(time spent opening)
    - Percentage spent sending: (total time sending) / (total time) * 100
    - Percentage spent opening: (total time opening) / (total time) * 100
5. **Round Percentages**: Round the percentages to 2 decimal places.
6. **Output**: Return the age group, send percentage, and open percentage for each age group.

### Detailed Steps and SQL Query

1. **Join Tables**: Join the `activities` table with the `age_breakdown` table on `user_id`.
2. **Filter Activities**: Filter to include only 'send' and 'open' activities.
3. **Group and Aggregate**: Group by age_bucket and activity_type, and sum the time_spent for each group.
4. **Pivot the Data**: For each age_bucket, we need the  
    sum of time_spent where activity_type is 'send' and where it's 'open'.  
    This can be done by grouping by age_bucket and using conditional  
    aggregation (e.g., SUM(CASE WHEN activity_type = 'send' THEN time_spent  
    ELSE 0 END)).  
    
5. **Calculate Percentages**: For each age_bucket, calculate the total time (sum of send and open times), then compute the percentages.
6. **Round and Output**: Round the percentages to 2 decimal places and output the results.

Here's the SQL query implementing these steps:

```SQL
WITH time_by_age_activity AS (
    SELECT
        ab.age_bucket,
        a.activity_type,
        SUM(a.time_spent) AS total_time
    FROM
        activities a
    JOIN
        age_breakdown ab ON a.user_id = ab.user_id
    WHERE
        a.activity_type IN ('send', 'open')
    GROUP BY
        ab.age_bucket, a.activity_type
),
time_totals AS (
    SELECT
        age_bucket,
        SUM(CASE WHEN activity_type = 'send' THEN total_time ELSE 0 END) AS send_time,
        SUM(CASE WHEN activity_type = 'open' THEN total_time ELSE 0 END) AS open_time
    FROM
        time_by_age_activity
    GROUP BY
        age_bucket
)
SELECT
    age_bucket,
    ROUND(100.0 * send_time / (send_time + open_time), 2) AS send_perc,
    ROUND(100.0 * open_time / (send_time + open_time), 2) AS open_perc
FROM
    time_totals
```

But, let's walk through this step by step with the example data to ensure correctness.

**Step 1: Join and Filter Activities**

We join the `activities` and `age_breakdown` tables and filter for activity_type in ('send', 'open').

For the example input, the relevant activities are:

|   |   |   |   |   |
|---|---|---|---|---|
|activity_id|user_id|activity_type|time_spent|age_bucket|
|7274|123|open|4.500|31-35|
|2425|123|send|3.500|31-35|
|1413|456|send|5.670|26-30|
|2536|456|open|3.000|26-30|

**Step 2: Aggregate Time by Age Group and Activity Type**

We group by age_bucket and activity_type, and sum the time_spent.

For the example, this would give:

|   |   |   |
|---|---|---|
|age_bucket|activity_type|total_time|
|31-35|open|4.500|
|31-35|send|3.500|
|26-30|send|5.670|
|26-30|open|3.000|

**Step 3: Pivot the Data to Get Total Send and Open Times per Age Group**

We group by age_bucket and compute the sum of send times and open times separately.

For the example:

|   |   |   |
|---|---|---|
|age_bucket|send_time|open_time|
|31-35|3.500|4.500|
|26-30|5.670|3.000|

**Step 4: Calculate Percentages**

For age group '26-30':

- send_time = 5.670
- open_time = 3.000
- total_time = 5.670 + 3.000 = 8.670
- send_perc = (5.670 / 8.670) * 100 ≈ 65.40
- open_perc = (3.000 / 8.670) * 100 ≈ 34.60

For age group '31-35':

- send_time = 3.500
- open_time = 4.500
- total_time = 3.500 + 4.500 = 8.000
- send_perc = (3.500 / 8.000) * 100 = 43.75
- open_perc = (4.500 / 8.000) * 100 = 56.25

This matches the expected output exactly.

**Final Query**

Putting it all together, the SQL query is:

```SQL
WITH time_by_age_activity AS (
    SELECT
        ab.age_bucket,
        a.activity_type,
        SUM(a.time_spent) AS total_time
    FROM
        activities a
    JOIN
        age_breakdown ab ON a.user_id = ab.user_id
    WHERE
        a.activity_type IN ('send', 'open')
    GROUP BY
        ab.age_bucket, a.activity_type
),
time_totals AS (
    SELECT
        age_bucket,
        SUM(CASE WHEN activity_type = 'send' THEN total_time ELSE 0 END) AS send_time,
        SUM(CASE WHEN activity_type = 'open' THEN total_time ELSE 0 END) AS open_time
    FROM
        time_by_age_activity
    GROUP BY
        age_bucket
)
SELECT
    age_bucket,
    ROUND(100.0 * send_time / NULLIF(send_time + open_time, 0), 2) AS send_perc,
    ROUND(100.0 * open_time / NULLIF(send_time + open_time, 0), 2) AS open_perc
FROM
    time_totals;
```

Note that I added `NULLIF(send_time + open_time, 0)` to avoid division by zero in case there's an age group with no 'send' or 'open' activities. This ensures that if the total time is zero (unlikely in practice, but good to handle), the division doesn't cause an error. However, in the given problem and example, this case doesn't arise.

But, in the given data, all age groups have both send and open activities, so division by zero isn't an issue here. However, it's good practice to handle it.

But, in the example, all age groups have some send and open activities, so the denominator won't be zero.

Thus, the final query is:

```SQL
WITH time_by_age_activity AS (
    SELECT
        ab.age_bucket,
        a.activity_type,
        SUM(a.time_spent) AS total_time
    FROM
        activities a
    JOIN
        age_breakdown ab ON a.user_id = ab.user_id
    WHERE
        a.activity_type IN ('send', 'open')
    GROUP BY
        ab.age_bucket, a.activity_type
),
time_totals AS (
    SELECT
        age_bucket,
        SUM(CASE WHEN activity_type = 'send' THEN total_time ELSE 0 END) AS send_time,
        SUM(CASE WHEN activity_type = 'open' THEN total_time ELSE 0 END) AS open_time
    FROM
        time_by_age_activity
    GROUP BY
        age_bucket
)
SELECT
    age_bucket,
    ROUND(100.0 * send_time / (send_time + open_time), 2) AS send_perc,
    ROUND(100.0 * open_time / (send_time + open_time), 2) AS open_perc
FROM
    time_totals;
```

But, looking back at the example, user_id 789 has a 'chat' activity, which we're ignoring, and that user is in age group '21-25'. Since that age group has no 'send' or 'open' activities, it won't appear in the output, which is correct since we only have data for '26-30' and '31-35' age groups in the 'send' and 'open' activities.

Thus, the query is correct and matches the expected output.

But, let me double-check if we're missing anything.

In the example, user_id 789 is in age group '21-25' and has only 'chat' activities, so that age group has no 'send' or 'open' activities. Thus, it won't appear in the output, which is correct since we're only interested in age groups with 'send' and 'open' activities.

But, if an age group has only 'send' or only 'open' activities, the query would still work because the denominator would be just the non-zero time (either send or open), and the percentage for the zero time would be 0 (but since both are needed for the denominator, if one is zero and the other is non-zero, the percentages would be 100% for the non-zero one and 0% for the other).

But, in the given problem, since we're only considering age groups that have both 'send' and 'open' activities (based on the example), but in reality, an age group might have only one type of activity. For example, if an age group has only 'send' activities, then the open_perc would be 0, and send_perc would be 100.

But, in our query, if an age group has only 'send' activities, then open_time would be 0, and send_perc would be 100.0 (since open_time is 0, so total time is just send_time, and 100*send_time/send_time = 100).

Similarly, if an age group has only 'open' activities, then send_time would be 0, and open_perc would be 100.0, and send_perc would be 0.0 (but actually, if send_time is 0 and open_time is non-zero, then the calculation would give 0 for send_perc and 100 for open_perc, which is correct).

But, if an age group has no 'send' or 'open' activities at all, it won't appear in time_totals (since the inner query time_by_age_activity would have no rows for that age_bucket), so it won't appear in the output, which is correct since we're only interested in age groups that have at least some 'send' or 'open' activities.

But, if an age group has both 'send' and 'open' activities with zero time (unlikely in practice), we'd have division by zero. But in our query, we didn't add NULLIF, which could cause an error if send_time + open_time = 0.

But in the given data, that's not the case, but to make the query robust, we should add NULLIF to avoid division by zero.

Thus, the correct query is:

```SQL
WITH time_by_age_activity AS (
    SELECT
        ab.age_bucket,
        a.activity_type,
        SUM(a.time_spent) AS total_time
    FROM
        activities a
    JOIN
        age_breakdown ab ON a.user_id = ab.user_id
    WHERE
        a.activity_type IN ('send', 'open')
    GROUP BY
        ab.age_bucket, a.activity_type
),
time_totals AS (
    SELECT
        age_bucket,
        SUM(CASE WHEN activity_type = 'send' THEN total_time ELSE 0 END) AS send_time,
        SUM(CASE WHEN activity_type = 'open' THEN total_time ELSE 0 END) AS open_time
    FROM
        time_by_age_activity
    GROUP BY
        age_bucket
)
SELECT
    age_bucket,
    ROUND(100.0 * send_time / NULLIF(send_time + open_time, 0), 2) AS send_perc,
    ROUND(100.0 * open_time / NULLIF(send_time + open_time, 0), 2) AS open_perc
FROM
    time_totals;
```

This handles the division by zero case gracefully by returning NULL if the total time is zero (which can't happen in the given problem context since if there are any activities, the total time must be positive, unless all time_spent values are zero, which seems unlikely but is possible).

But, in the given problem, since we're ignoring 'chat' activities, and only considering 'send' and 'open', and assuming that at least one of these exists for an age group to appear in the output, division by zero won't occur in practice. But, it's good