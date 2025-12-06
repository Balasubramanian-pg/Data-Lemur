---
Date: 2025-07-30
Difficulty: Easy
Company:
- Facebook
Title: Page With No Likes
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Easy/Page With No Likes.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Question Link: ''
Category: ''
Sub Category: ''
---
Assume you're given two tables containing data about Facebook Pages and their respective likes (as in "Like a Facebook Page").

Write a query to return the IDs of the Facebook pages that have zero likes. The output should be sorted in ascending order based on the page IDs.

### `pages` Table:

|**Column Name**|**Type**|
|---|---|
|page_id|integer|
|page_name|varchar|

### `pages` Example Input:

|**page_id**|**page_name**|
|---|---|
|20001|SQL Solutions|
|20045|Brain Exercises|
|20701|Tips for Data Analysts|

### `page_likes` Table:

|**Column Name**|**Type**|
|---|---|
|user_id|integer|
|page_id|integer|
|liked_date|datetime|

### `page_likes` Example Input:

|**user_id**|**page_id**|**liked_date**|
|---|---|---|
|111|20001|04/08/2022 00:00:00|
|121|20045|03/12/2022 00:00:00|
|156|20001|07/25/2022 00:00:00|

### Example Output:

|**page_id**|
|---|
|20701|

The dataset you are querying against may have different input & output - **this is just an example**!

To find the Facebook pages with zero likes, you can use a SQL query with a LEFT JOIN and a WHERE clause to filter out pages that have likes. Here's how you can do it:


```sql
SELECT p.page_id
FROM pages p
LEFT JOIN page_likes pl
ON p.page_id = pl.page_id
WHERE pl.page_id IS NULL
ORDER BY p.page_id ASC;
```

This query works as follows:

- **LEFT JOIN**: The LEFT JOIN combines rows from the `pages` table with rows from the `page_likes` table where the `page_id` matches. If there is no match, the result will contain NULL values for the `page_likes` columns.

- **Filter out pages with likes**: The WHERE clause filters out pages that have likes by checking for NULL values in the `page_id` column of the `page_likes` table. If `page_id` is NULL, it means the page does not have any likes.

- **Sort the output**: The ORDER BY clause sorts the output in ascending order based on the `page_id`.

Alternatively, you can use a NOT IN or NOT EXISTS clause to achieve the same result:

``` sql
SELECT page_id
FROM pages
WHERE page_id NOT IN (SELECT page_id FROM page_likes)
ORDER BY page_id ASC;
```

Or:

```SQL
SELECT p.page_id
FROM pages p
WHERE NOT EXISTS (
    SELECT 1
    FROM page_likes pl
    WHERE pl.page_id = p.page_id
)
ORDER BY p.page_id ASC;
```

All of these queries will return the same result: the IDs of the Facebook pages that have zero likes, sorted in ascending order.