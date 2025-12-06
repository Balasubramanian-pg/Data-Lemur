---
Date: 2025-07-30
Difficulty: Easy
Title: App Click through Rate CTR
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Easy/App Click through Rate
  CTR.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Company: ''
Question Link: ''
Category: ''
Sub Category: ''
---
This is the same question as problem #1 in the SQL Chapter of [Ace the Data Science Interview](https://amzn.to/3kF79Fx)!

Assume you have an events table on Facebook app analytics. Write a query to calculate the click-through rate (CTR) for the app in 2022 and round the results to 2 decimal places.

Definition and note:

- Percentage of click-through rate (CTR) = 100.0 * Number of clicks / Number of impressions
- To avoid integer division, multiply the CTR by 100.0, not 100.

### `events` Table:

|Column Name|Type|
|---|---|
|app_id|integer|
|event_type|string|
|timestamp|datetime|

### `events` Example Input:

|app_id|event_type|timestamp|
|---|---|---|
|123|impression|07/18/2022 11:36:12|
|123|impression|07/18/2022 11:37:12|
|123|click|07/18/2022 11:37:42|
|234|impression|07/18/2022 14:15:12|
|234|click|07/18/2022 14:16:12|

### Example Output:

|app_id|ctr|
|---|---|
|123|50.00|
|234|100.00|

### Explanation

Let's consider an example of App 123. This app has a click-through rate (CTR) of 50.00% because out of the 2 impressions it received, it got 1 click.

To calculate the CTR, we divide the number of clicks by the number of impressions, and then multiply the result by 100.0 to express it as a percentage. In this case, 1 divided by 2 equals 0.5, and when multiplied by 100.0, it becomes 50.00%. So, the CTR of App 123 is 50.00%.

---
To calculate the click-through rate (CTR) for each app in 2022, you can use a SQL query with conditional aggregation. Here's how you can do it:

SQL

```
SELECT 
    app_id,
    ROUND(
        100.0 * 
        SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) / 
        SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 
    2) AS ctr
FROM 
    events
WHERE 
    STRFTIME('%Y', timestamp) = '2022'
GROUP BY 
    app_id;
```

However, the exact date function might vary depending on the SQL dialect you're using. Here are a few alternatives:

- For MySQL: `YEAR(timestamp) = 2022`

- For PostgreSQL: `EXTRACT(YEAR FROM timestamp) = 2022`

- For SQL Server: `YEAR(timestamp) = 2022`

Let's assume you're using a SQL dialect that supports the `YEAR()` function. The query would look like this:

SQL

```
SELECT 
    app_id,
    ROUND(
        100.0 * 
        SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) / 
        SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 
    2) AS ctr
FROM 
    events
WHERE 
    YEAR(timestamp) = 2022
GROUP BY 
    app_id;
```

This query will calculate the CTR for each app in 2022 and round the results to 2 decimal places.

One thing to note is that if an app has no impressions in 2022, the query will throw a division-by-zero error. To avoid this, you can add a filter to only include apps with impressions:

SQL

```
SELECT 
    app_id,
    ROUND(
        100.0 * 
        SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) / 
        SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 
    2) AS ctr
FROM 
    events
WHERE 
    YEAR(timestamp) = 2022
GROUP BY 
    app_id
HAVING 
    SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END) > 0;
```

This will ensure that only apps with at least one impression in 2022 are included in the results. If you want to include apps with no impressions and display a CTR of NULL or 0, you can use a different approach:

SQL

```
SELECT 
    app_id,
    ROUND(
        100.0 * 
        SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) / 
        NULLIF(SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 0), 
    2) AS ctr
FROM 
    events
WHERE 
    YEAR(timestamp) = 2022
GROUP BY 
    app_id;
```

In this version, the `NULLIF` function will return NULL if the denominator is 0, avoiding the division-by-zero error.