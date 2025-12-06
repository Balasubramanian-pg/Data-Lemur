---
Date: 2025-07-30
Difficulty: Easy
Title: Duplicate Job Listings
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Easy/Duplicate Job Listings.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Company: ''
Question Link: ''
Category: ''
Sub Category: ''
---
This is the same question as problem #8 in the SQL Chapter of [Ace the Data Science Interview](https://amzn.to/3kF79Fx)!

Assume you're given a table containing job postings from various companies on the LinkedIn platform. Write a query to retrieve the count of companies that have posted duplicate job listings.

Definition:

- Duplicate job listings are defined as two job listings within the same company that share identical titles and descriptions.

### `job_listings` Table:

|Column Name|Type|
|---|---|
|job_id|integer|
|company_id|integer|
|title|string|
|description|string|

### `job_listings` Example Input:

|job_id|company_id|title|description|
|---|---|---|---|
|248|827|Business Analyst|Business analyst evaluates past and current business data with the primary goal of improving decision-making processes within organizations.|
|149|845|Business Analyst|Business analyst evaluates past and current business data with the primary goal of improving decision-making processes within organizations.|
|945|345|Data Analyst|Data analyst reviews data to identify key insights into a business's customers and ways the data can be used to solve problems.|
|164|345|Data Analyst|Data analyst reviews data to identify key insights into a business's customers and ways the data can be used to solve problems.|
|172|244|Data Engineer|Data engineer works in a variety of settings to build systems that collect, manage, and convert raw data into usable information for data scientists and business analysts to interpret.|

### Example Output:

|duplicate_companies|
|---|
|1|

### Explanation:

There is one company ID 345 that posted duplicate job listings. The duplicate listings, IDs 945 and 164 have identical titles and descriptions.

Retrieving Companies with Duplicate Job Listings

To solve this problem, you can use a combination of the `GROUP BY` and `HAVING` clauses in SQL. The idea is to group the job listings by `company_id`, `title`, and `description`, and then count the number of rows in each group. If the count is greater than 1, it means there are duplicate job listings for that company.

```SQL
SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM (
  SELECT company_id
  FROM job_listings
  GROUP BY company_id, title, description
  HAVING COUNT(job_id) > 1
) AS duplicate_listings;
```

Explanation

- The subquery groups the `job_listings` table by `company_id`, `title`, and `description`.

- The `HAVING COUNT(job_id) > 1` clause filters the groups to only include those with more than one row, i.e., duplicate job listings.

- The outer query counts the number of distinct `company_id`s in the subquery's result set, which represents the number of companies with duplicate job listings.

This query will return the count of companies that have posted duplicate job listings, as required.

Alternative Method: Using Window Function

You can also use a window function to solve this problem. The idea is to count the number of rows for each `company_id`, `title`, and `description` combination, and then count the number of companies that have a count greater than 1.

```SQL
WITH duplicate_listings AS (
  SELECT company_id,
         COUNT(*) OVER (PARTITION BY company_id, title, description) AS listing_count
  FROM job_listings
)
SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM duplicate_listings
WHERE listing_count > 1;
```

Explanation

- The Common Table Expression (CTE) `duplicate_listings` uses the `COUNT(*) OVER (PARTITION BY company_id, title, description)` window function to count the number of rows for each `company_id`, `title`, and `description` combination.

- The outer query counts the number of distinct `company_id`s in the CTE's result set where the `listing_count` is greater than 1, which represents the number of companies with duplicate job listings.

This query will also return the count of companies that have posted duplicate job listings.

Alternative Method: Using EXISTS Clause

You can use the `EXISTS` clause to check for duplicate job listings within each company.

```SQL
SELECT COUNT(DISTINCT j1.company_id) AS duplicate_companies
FROM job_listings j1
WHERE EXISTS (
  SELECT 1
  FROM job_listings j2
  WHERE j1.company_id = j2.company_id
    AND j1.title = j2.title
    AND j1.description = j2.description
    AND j1.job_id != j2.job_id
);
```

Explanation

- The subquery in the `EXISTS` clause checks for the existence of another row in the `job_listings` table with the same `company_id`, `title`, and `description`, but a different `job_id`.

- The outer query counts the number of distinct `company_id`s that have at least one duplicate job listing.

This query will also return the count of companies that have posted duplicate job listings.