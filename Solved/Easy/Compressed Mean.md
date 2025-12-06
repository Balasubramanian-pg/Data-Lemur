---
Date: 2025-07-30
Difficulty: Easy
Title: Compressed Mean
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Easy/Compressed Mean.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Company: ''
Question Link: ''
Category: ''
Sub Category: ''
---
You're trying to find the mean number of items per order on Alibaba, rounded to 1 decimal place using tables which includes information on the count of items in each order (`item_count` table) and the corresponding number of orders for each item count (`order_occurrences` table).

### `items_per_order` Table:

|Column Name|Type|
|---|---|
|item_count|integer|
|order_occurrences|integer|

### `items_per_order` Example Input:

|item_count|order_occurrences|
|---|---|
|1|500|
|2|1000|
|3|800|
|4|1000|

There are a total of 500 orders with one item per order, 1000 orders with two items per order, and 800 orders with three items per order."

### Example Output:

|mean|
|---|
|2.7|

## Explanation

Let's calculate the arithmetic average:

Total items = `(1*500) + (2*1000) + (3*800) + (4*1000) = 8900`

Total orders = `500 + 1000 + 800 + 1000 = 3300`

Mean = `8900 / 3300 = 2.7`

To find the mean number of items per order, you can use SQL to calculate the total items and total orders, then divide the total items by the total orders. Here's how you can do it:

```SQL
SELECT ROUND(SUM(item_count * order_occurrences) / SUM(order_occurrences), 1) AS mean
FROM items_per_order;
```

This query works as follows:

- `SUM(item_count * order_occurrences)` calculates the total number of items.

- `SUM(order_occurrences)` calculates the total number of orders.

- The total number of items is divided by the total number of orders to get the mean.

- `ROUND(..., 1)` rounds the mean to 1 decimal place.