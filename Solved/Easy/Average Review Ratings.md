---
Date: 2025-07-30
Difficulty: Easy
Title: Average Review Ratings
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Easy/Average Review Ratings.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Company: ''
Question Link: ''
Category: ''
Sub Category: ''
---
Given the reviews table, write a query to retrieve the average star rating for each product, grouped by month. The output should display the month as a numerical value, product ID, and average star rating rounded to two decimal places. Sort the output first by month and then by product ID.

P.S. If you've read the [Ace the Data Science Interview](https://amzn.to/3kF79Fx), and liked it, consider writing us a review?

### `reviews` Table:

|**Column Name**|**Type**|
|---|---|
|review_id|integer|
|user_id|integer|
|submit_date|datetime|
|product_id|integer|
|stars|integer (1-5)|

### `reviews` Example Input:

|**review_id**|**user_id**|**submit_date**|**product_id**|**stars**|
|---|---|---|---|---|
|6171|123|06/08/2022 00:00:00|50001|4|
|7802|265|06/10/2022 00:00:00|69852|4|
|5293|362|06/18/2022 00:00:00|50001|3|
|6352|192|07/26/2022 00:00:00|69852|3|
|4517|981|07/05/2022 00:00:00|69852|2|

### Example Output:

|**mth**|**product**|**avg_stars**|
|---|---|---|
|6|50001|3.50|
|6|69852|4.00|
|7|69852|2.50|

### Explanation

Product 50001 received two ratings of 4 and 3 in the month of June (6th month), resulting in an average star rating of 3.5.

SQL Query to Retrieve Average Star Rating

To solve this problem, you can use the following SQL query:

```SQL
SELECT 
    EXTRACT(MONTH FROM submit_date) AS mth,
    product_id AS product,
    ROUND(AVG(stars), 2) AS avg_stars
FROM 
    reviews
GROUP BY 
    EXTRACT(MONTH FROM submit_date),
    product_id
ORDER BY 
    mth,
    product;
```

This query works as follows:

- **Extract Month**: The `EXTRACT(MONTH FROM submit_date)` function extracts the month from the `submit_date` column.

- **Group By**: The query groups the results by the extracted month and `product_id`.

- **Average Calculation**: The `AVG(stars)` function calculates the average star rating for each group.

- **Rounding**: The `ROUND(AVG(stars), 2)` function rounds the average star rating to two decimal places.

- **Sorting**: The `ORDER BY` clause sorts the output first by month and then by product ID.

Note that the exact SQL syntax might vary depending on the database management system being used. The above query is written in standard SQL syntax and should work with most modern databases.

If you're using MySQL, you might need to use the `MONTH()` function instead of `EXTRACT(MONTH FROM )`:

```SQL
SELECT 
    MONTH(submit_date) AS mth,
    product_id AS product,
    ROUND(AVG(stars), 2) AS avg_stars
FROM 
    reviews
GROUP BY 
    MONTH(submit_date),
    product_id
ORDER BY 
    mth,
    product;
```

Alternative SQL Query

Here's another way to write the SQL query using the `DATEPART()` function or `strftime()` function depending on the database management system:

**For SQL Server:**

```SQL
SELECT 
    DATEPART(MONTH, submit_date) AS mth,
    product_id AS product,
    ROUND(AVG(stars * 1.0), 2) AS avg_stars
FROM 
    reviews
GROUP BY 
    DATEPART(MONTH, submit_date),
    product_id
ORDER BY 
    mth,
    product;
```

**For SQLite:**

```SQL
SELECT 
    STRFTIME('%m', submit_date) AS mth,
    product_id AS product,
    ROUND(AVG(stars * 1.0), 2) AS avg_stars
FROM 
    reviews
GROUP BY 
    STRFTIME('%m', submit_date),
    product_id
ORDER BY 
    mth,
    product;
```

**For PostgreSQL (alternative method):**

```SQL
SELECT 
    EXTRACT(MONTH FROM submit_date)::integer AS mth,
    product_id AS product,
    ROUND(AVG(stars), 2) AS avg_stars
FROM 
    reviews
GROUP BY 
    EXTRACT(MONTH FROM submit_date)::integer,
    product_id
ORDER BY 
    mth,
    product;
```

These queries work similarly to the previous one, but use different functions to extract the month from the `submit_date` column.

The `* 1.0` in `AVG(stars * 1.0)` is used to ensure that the average calculation is done using decimal numbers, not integers. This is necessary in some databases where the `AVG()` function returns an integer result if the input is an integer column.