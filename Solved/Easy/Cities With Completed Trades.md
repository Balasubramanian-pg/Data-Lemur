---
Date: 2025-07-30
Difficulty: Easy
Title: Cities With Completed Trades
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Easy/Cities With Completed
  Trades.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Company: ''
Question Link: ''
Category: ''
Sub Category: ''
---
This is the same question as problem #2 in the SQL Chapter of [Ace the Data Science Interview](https://amzn.to/3kF79Fx)!

Assume you're given the tables containing completed trade orders and user details in a Robinhood trading system.

Write a query to retrieve the top three cities that have the highest number of completed trade orders listed in descending order. Output the city name and the corresponding number of completed trade orders.

### `trades` Table:

|Column Name|Type|
|---|---|
|order_id|integer|
|user_id|integer|
|quantity|integer|
|status|string ('Completed', 'Cancelled')|
|date|timestamp|
|price|decimal (5, 2)|

### `trades` Example Input:

|order_id|user_id|quantity|status|date|price|
|---|---|---|---|---|---|
|100101|111|10|Cancelled|08/17/2022 12:00:00|9.80|
|100102|111|10|Completed|08/17/2022 12:00:00|10.00|
|100259|148|35|Completed|08/25/2022 12:00:00|5.10|
|100264|148|40|Completed|08/26/2022 12:00:00|4.80|
|100305|300|15|Completed|09/05/2022 12:00:00|10.00|
|100400|178|32|Completed|09/17/2022 12:00:00|12.00|
|100565|265|2|Completed|09/27/2022 12:00:00|8.70|

### `users` Table:

|Column Name|Type|
|---|---|
|user_id|integer|
|city|string|
|email|string|
|signup_date|datetime|

### `users` Example Input:

|user_id|city|email|signup_date|
|---|---|---|---|
|111|San Francisco|[rrok10@gmail.com](mailto:rrok10@gmail.com)|08/03/2021 12:00:00|
|148|Boston|[sailor9820@gmail.com](mailto:sailor9820@gmail.com)|08/20/2021 12:00:00|
|178|San Francisco|[harrypotterfan182@gmail.com](mailto:harrypotterfan182@gmail.com)|01/05/2022 12:00:00|
|265|Denver|[shadower_@hotmail.com](mailto:shadower_@hotmail.com)|02/26/2022 12:00:00|
|300|San Francisco|[houstoncowboy1122@hotmail.com](mailto:houstoncowboy1122@hotmail.com)|06/30/2022 12:00:00|

### Example Output:

|city|total_orders|
|---|---|
|San Francisco|3|
|Boston|2|
|Denver|1|

In the given dataset, San Francisco has the highest number of completed trade orders with 3 orders. Boston holds the second position with 2 orders, and Denver ranks third with 1 order.

I'll provide solutions to both SQL problems.

Problem 1: Retrieve the count of companies that have posted duplicate job listings

To solve this problem, we can use a subquery to identify the duplicate job listings and then count the distinct companies.

```SQL
SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM (
  SELECT company_id
  FROM job_listings
  GROUP BY company_id, title, description
  HAVING COUNT(job_id) > 1
) AS duplicate_listings;
```

This query works as follows:

- The subquery groups the job listings by company_id, title, and description.

- The HAVING clause filters the groups to only include those with more than one job_id, i.e., the duplicate job listings.

- The outer query counts the distinct company_id in the subquery result.

Problem 2: Retrieve the top three cities that have the highest number of completed trade orders

To solve this problem, we can join the trades table with the users table on the user_id column and then group the result by city.

```SQL
SELECT u.city, COUNT(t.order_id) AS total_orders
FROM trades t
JOIN users u ON t.user_id = u.user_id
WHERE t.status = 'Completed'
GROUP BY u.city
ORDER BY total_orders DESC
LIMIT 3;
```

This query works as follows:

- The JOIN clause combines the trades table with the users table on the user_id column.

- The WHERE clause filters the trades to only include those with a status of 'Completed'.

- The GROUP BY clause groups the result by city.

- The COUNT function counts the number of orders for each city.

- The ORDER BY clause sorts the result in descending order by total_orders.

- The LIMIT clause limits the result to the top three cities.