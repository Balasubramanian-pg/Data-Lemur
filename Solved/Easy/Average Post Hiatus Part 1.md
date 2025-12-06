---
Date: 2025-07-30
Difficulty: Easy
Title: Average Post Hiatus Part 1
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Easy/Average Post Hiatus
  Part 1.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Company: ''
Question Link: ''
Category: ''
Sub Category: ''
---
Given a table of Facebook posts, for each user who posted at least twice in 2021, write a query to find the number of days between each user’s first post of the year and last post of the year in the year 2021. Output the user and number of the days between each user's first and last post.

p.s. If you've read the [Ace the Data Science Interview](https://www.amazon.com/dp/0578973839?ref_=pe_3052080_397514860) and liked it, consider writing us a review?

### `posts` Table:

|Column Name|Type|
|---|---|
|user_id|integer|
|post_id|integer|
|post_content|text|
|post_date|timestamp|

### `posts` Example Input:

|user_id|post_id|post_content|post_date|
|---|---|---|---|
|151652|599415|Need a hug|07/10/2021 12:00:00|
|661093|624356|Bed. Class 8-12. Work 12-3. Gym 3-5 or 6. Then class 6-10. Another day that's gonna fly by. I miss my girlfriend|07/29/2021 13:00:00|
|004239|784254|Happy 4th of July!|07/04/2021 11:00:00|
|661093|442560|Just going to cry myself to sleep after watching Marley and Me.|07/08/2021 14:00:00|
|151652|111766|I'm so done with covid - need travelling ASAP!|07/12/2021 19:00:00|

### Example Output:

| user_id | days_between |
| ------- | ------------ |
| 151652  | 2            |
| 661093  | 21           |
Query to Find Days Between First and Last Post in 2021

To solve this problem, we'll use SQL to query the `posts` table. We'll first filter the posts to only include those made in 2021, then find the minimum and maximum post dates for each user who posted at least twice. Finally, we'll calculate the difference between these two dates.

SQL

```
SELECT 
    user_id,
    DATE_PART('day', MAX(post_date) - MIN(post_date)) AS days_between
FROM 
    posts
WHERE 
    EXTRACT(YEAR FROM post_date) = 2021
GROUP BY 
    user_id
HAVING 
    COUNT(post_id) >= 2;
```

This query works as follows:

- **Filter posts to 2021**: The `WHERE` clause uses `EXTRACT(YEAR FROM post_date)` to get the year from each `post_date` and filters the results to only include posts made in 2021.

- **Group by user**: The `GROUP BY` clause groups the remaining posts by `user_id`.

- **Find users with at least two posts**: The `HAVING` clause filters the grouped results to only include users who have made at least two posts.

- **Calculate days between first and last post**: The `SELECT` clause uses `MIN(post_date)` and `MAX(post_date)` to find the first and last post dates for each user, then subtracts the two dates to find the difference. `DATE_PART('day', ...)` is used to get the difference in days.

Note that the exact SQL syntax may vary depending on the database management system being used. The above query is written for PostgreSQL.

For MySQL, you can use the following query:

SQL

```
SELECT 
    user_id,
    DATEDIFF(MAX(post_date), MIN(post_date)) AS days_between
FROM 
    posts
WHERE 
    YEAR(post_date) = 2021
GROUP BY 
    user_id
HAVING 
    COUNT(post_id) >= 2;
```


## Alternative Query to Find Days Between First and Last Post in 2021

Another way to solve this problem is to use subqueries or Common Table Expressions (CTEs) to first find the minimum and maximum post dates for each user, and then calculate the difference between these two dates.

SQL

```
WITH user_post_dates AS (
    SELECT 
        user_id,
        MIN(post_date) AS first_post_date,
        MAX(post_date) AS last_post_date
    FROM 
        posts
    WHERE 
        EXTRACT(YEAR FROM post_date) = 2021
    GROUP BY 
        user_id
    HAVING 
        COUNT(post_id) >= 2
)
SELECT 
    user_id,
    DATE_PART('day', last_post_date - first_post_date) AS days_between
FROM 
    user_post_dates;
```

This query works similarly to the previous one, but it breaks the calculation into two steps:

- **Find first and last post dates**: The CTE `user_post_dates` finds the minimum and maximum post dates for each user who posted at least twice in 2021.

- **Calculate days between**: The main query calculates the difference between the first and last post dates for each user.

This approach can be useful if you need to perform additional calculations or filtering on the first and last post dates.

For MySQL, you can use the following query:

```SQL
WITH user_post_dates AS (
    SELECT 
        user_id,
        MIN(post_date) AS first_post_date,
        MAX(post_date) AS last_post_date
    FROM 
        posts
    WHERE 
        YEAR(post_date) = 2021
    GROUP BY 
        user_id
    HAVING 
        COUNT(post_id) >= 2
)
SELECT 
    user_id,
    DATEDIFF(last_post_date, first_post_date) AS days_between
FROM 
    user_post_dates;
```

## Another Query to Find Days Between First and Last Post in 2021

You can also use window functions to find the first and last post dates for each user, and then aggregate the results.

```SQL
WITH ranked_posts AS (
    SELECT 
        user_id,
        post_date,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY post_date) AS first_post,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY post_date DESC) AS last_post
    FROM 
        posts
    WHERE 
        EXTRACT(YEAR FROM post_date) = 2021
)
SELECT 
    user_id,
    MAX(CASE WHEN last_post = 1 THEN post_date END) - MIN(CASE WHEN first_post = 1 THEN post_date END) AS days_between
FROM 
    ranked_posts
GROUP BY 
    user_id
HAVING 
    COUNT(*) >= 2;
```

However, a more efficient way would be to use `MIN` and `MAX` window functions directly:

```SQL
WITH post_date_bounds AS (
    SELECT 
        user_id,
        MIN(post_date) OVER (PARTITION BY user_id) AS first_post_date,
        MAX(post_date) OVER (PARTITION BY user_id) AS last_post_date,
        COUNT(*) OVER (PARTITION BY user_id) AS post_count
    FROM 
        posts
    WHERE 
        EXTRACT(YEAR FROM post_date) = 2021
)
SELECT DISTINCT 
    user_id,
    DATE_PART('day', last_post_date - first_post_date) AS days_between
FROM 
    post_date_bounds
WHERE 
    post_count >= 2;
```

This query works by:

- **Finding first and last post dates**: The CTE `post_date_bounds` uses window functions to find the minimum and maximum post dates for each user.

- **Counting posts**: It also counts the number of posts for each user.

- **Filtering users with at least two posts**: The main query filters the results to only include users who have made at least two posts.

- **Calculating days between**: Finally, it calculates the difference between the first and last post dates for each user.

For MySQL, you can use the following query:

```SQL
WITH post_date_bounds AS (
    SELECT 
        user_id,
        MIN(post_date) OVER (PARTITION BY user_id) AS first_post_date,
        MAX(post_date) OVER (PARTITION BY user_id) AS last_post_date,
        COUNT(*) OVER (PARTITION BY user_id) AS post_count
    FROM 
        posts
    WHERE 
        YEAR(post_date) = 2021
)
SELECT DISTINCT 
    user_id,
    DATEDIFF(last_post_date, first_post_date) AS days_between
FROM 
    post_date_bounds
WHERE 
    post_count >= 2;
```