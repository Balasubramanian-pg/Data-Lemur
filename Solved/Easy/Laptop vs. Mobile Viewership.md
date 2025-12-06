---
Date: 2025-07-30
Difficulty: Easy
Company:
- NY Times
Title: Laptop vs. Mobile Viewership
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Easy/Laptop vs. Mobile Viewership.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Question Link: ''
Category: ''
Sub Category: ''
---
Assume you're given the table on user viewership categorised by device type where the three types are laptop, tablet, and phone.

Write a query that calculates the total viewership for laptops and mobile devices where mobile is defined as the sum of tablet and phone viewership. Output the total viewership for laptops as `laptop_reviews` and the total viewership for mobile devices as `mobile_views`.

_Effective 15 April 2023, the solution has been updated with a more concise and easy-to-understand approach._

### `viewership` Table

|Column Name|Type|
|---|---|
|user_id|integer|
|device_type|string ('laptop', 'tablet', 'phone')|
|view_time|timestamp|

### `viewership` Example Input

|user_id|device_type|view_time|
|---|---|---|
|123|tablet|01/02/2022 00:00:00|
|125|laptop|01/07/2022 00:00:00|
|128|laptop|02/09/2022 00:00:00|
|129|phone|02/09/2022 00:00:00|
|145|tablet|02/24/2022 00:00:00|

### Example Output

|laptop_views|mobile_views|
|---|---|
|2|3|

### Explanation

Based on the example input, there are a total of 2 laptop views and 3 mobile views.

To calculate the total viewership for laptops and mobile devices, you can use the following SQL query:

```SQL
SELECT 
    SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views,
    SUM(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END) AS mobile_views
FROM viewership;
```

This query works as follows:

- **Conditional SUM**: The `CASE` expression checks the `device_type` column and returns 1 if the condition is met, and 0 otherwise. The `SUM` function then adds up these values to get the total count.

- **Laptop views**: The first `CASE` expression counts the number of rows where `device_type` is 'laptop'.

- **Mobile views**: The second `CASE` expression counts the number of rows where `device_type` is either 'tablet' or 'phone', which represents mobile devices.

Alternatively, you can use a more concise approach using `COUNT` with `FILTER` clause (if supported by your SQL dialect):
```SQL
SELECT 
    COUNT(*) FILTER (WHERE device_type = 'laptop') AS laptop_views,
    COUNT(*) FILTER (WHERE device_type IN ('tablet', 'phone')) AS mobile_views
FROM viewership;
```

Or, if your SQL dialect supports `PIVOT` or similar functionality, you can use that as well. However, the `CASE` expression approach is widely supported and easy to understand.