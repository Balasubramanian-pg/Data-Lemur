---
Company:
- Alibaba
Created: null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Compressed Median_from_made_1
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Hard/Compressed Median_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
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

The dataset you are querying against may have different input & output - **this is just an example**!

To get the **mean number of items per order** from the `items_per_order` table, you can use this SQL:

```sql
SELECT 
  ROUND(SUM(item_count * order_occurrences) * 1.0 / SUM(order_occurrences), 1) AS mean
FROM 
  items_per_order;
```

**Explanation:**

- `item_count * order_occurrences` gives total items for that group.
    
- `SUM(...) / SUM(order_occurrences)` gives the average.
    
- Multiply by `1.0` to force floating point division.
    
- `ROUND(..., 1)` limits the result to 1 decimal place.
    

This works with any dataset in the same structure.
