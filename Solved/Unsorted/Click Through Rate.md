---
Created: 2025-06-28T18:34
Area:
- Statistical Aggregation
- Time-Based Segmentation
Key Functions:
- Round
- Timestamp
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Click Through Rate
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Click Through Rate.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Assume you have an events table on Facebook app analytics. Write a  
query to calculate the click-through rate (CTR) for the app in 2022 and  
round the results to 2 decimal places.  

Definition and note:

- Percentage of click-through rate (CTR) = 100.0 * Number of clicks / Number of impressions
- To avoid integer division, multiply the CTR by 100.0, not 100.

### `events` Table:

|   |   |
|---|---|
|Column Name|Type|
|app_id|integer|
|event_type|string|
|timestamp|datetime|

### `events` Example Input:

|   |   |   |
|---|---|---|
|app_id|event_type|timestamp|
|123|impression|07/18/2022 11:36:12|
|123|impression|07/18/2022 11:37:12|
|123|click|07/18/2022 11:37:42|
|234|impression|07/18/2022 14:15:12|
|234|click|07/18/2022 14:16:12|

### Example Output:

|   |   |
|---|---|
|app_id|ctr|
|123|50.00|
|234|100.00|

### Explanation

Let's consider an example of App 123. This app has a click-through rate (CTR) of 50.00% because out of the 2 impressions it received, it  
got 1 click.  

To calculate the CTR, we divide the number of clicks by the number of impressions, and then multiply the result by 100.0 to express it as a percentage. In this case, 1 divided by 2 equals 0.5, and when multiplied by 100.0, it becomes 50.00%. So, the CTR of App 123 is 50.00%.

## Understanding the Problem

First, I need to understand what's being asked. We have an events table that records app analytics data for Facebook. The table has columns for app_id, event_type (which can be 'impression' or 'click'), and a timestamp.

The goal is to calculate the click-through rate (CTR) for each app in 2022. CTR is defined as the percentage of clicks relative to impressions, calculated as:

CTR=100.0×Number of clicks/ Number of impressions \text{CTR} = 100.0 \times \frac{\text{Number of clicks}}{\text{Number of impressions}}

CTR=100.0×Number of impressions/ Number of clicks

The results should be rounded to two decimal places.

### Step 1: Filter Data for 2022

First, I need to filter the data to only include events from the year 2022. This can be done by checking the timestamp column. The condition would be:

```SQL
WHERE timestamp >= '2022-01-01' AND timestamp < '2023-01-01'
```

This ensures that we only consider data from the entire year of 2022.

### Step 2: Count Clicks and Impressions

Next, I need to count the number of clicks and impressions for each app. This can be done using conditional aggregation.

For clicks:

```SQL
 SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END)
```

For impressions:

```SQL
SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END)
```

These expressions will count the number of 'click' and 'impression' events for each app.

### Step 3: Calculate CTR

Now, I need to calculate the CTR using the formula provided. The formula is:

CTR=100.0×Number of clicks/Number of impressions \text{CTR} = 100.0 \times \frac{\text{Number of clicks}}{\text{Number of impressions}}

CTR=100.0×Number of impressions/Number of clicks

But I need to ensure that I don't divide by zero if there are no impressions. To handle this, I can use the `NULLIF` function, which returns NULL if the denominator is zero, preventing division by zero.

So, the calculation becomes:

```SQL
 100.0 * SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) /
NULLIF(SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 0)
```

### Step 4: Round the Results

The problem asks to round the results to two decimal places. This can be done using the `ROUND` function:

```SQL
 ROUND(
    100.0 * SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) /
    NULLIF(SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 0),
    2
) AS ctr
```

### Step 5: Group by app_id

Finally, I need to group the results by `app_id` to get the CTR for each app individually.

### Final Query

Putting it all together, the final query is:

```SQL
 SELECT
    app_id,
    ROUND(
        100.0 * SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) /
        NULLIF(SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 0),
        2
    ) AS ctr
FROM
    events
WHERE
    timestamp >= '2022-01-01' AND timestamp < '2023-01-01'
GROUP BY
    app_id;
```

### Explanation of the Query

1. **Filtering**: The `WHERE` clause filters the data to include only events from 2022.
2. **Grouping**: The `GROUP BY app_id` clause groups the data by `app_id`, so we can calculate the CTR for each app separately.
3. **Counting**: The `SUM(CASE WHEN ...)` expressions count the number of clicks and impressions for each app.
4. **Calculating CTR**: The CTR is calculated by dividing the number of clicks by the number of impressions, multiplying by 100.0, and using `NULLIF` to avoid division by zero.
5. **Rounding**: The `ROUND` function ensures that the CTR is rounded to two decimal places.

This query will produce the desired output, showing the CTR for each app in 2022, rounded to two decimal places.

```SQL
SELECT
    app_id,
    ROUND(
        100.0 * SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) /
        NULLIF(SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 0),
        2
    ) AS ctr
FROM
    events
WHERE
    timestamp >= '2022-01-01' AND timestamp < '2023-01-01'
GROUP BY
    app_id;
```