---
Created: 2025-06-28T18:34
Area:
- Statistical Aggregation
Key Functions:
- MOD
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Compressed Mode_from_made_1
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Medium/Compressed Mode_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
You're given a table containing the item count for each order on Alibaba, along with the frequency of orders that have the same item count. Write a query to retrieve the mode of the order occurrences.  
Additionally, if there are multiple item counts with the same mode, the results should be sorted in ascending order.  

Clarifications:

- `item_count`: Represents the number of items sold in each order.
- `order_occurrences`: Represents the frequency of orders with the corresponding number of items sold per order.
- For example, if there are 800 orders with 3 items sold in each order, the record would have an `item_count` of 3 and an `order_occurrences` of 800.

_Effective June 14th, 2023, the problem statement has been revised and additional clarification have been added for clarity._

### `items_per_order` Table:

|   |   |
|---|---|
|Column Name|Type|
|item_count|integer|
|order_occurrences|integer|

### `items_per_order` Example Input:

|   |   |
|---|---|
|item_count|order_occurrences|
|1|500|
|2|1000|
|3|800|

### Example Output:

mode


2


### Explanation:

Based on the example output, the `order_occurrences` value of 1000 corresponds to the highest frequency among all item counts.  
This means that item count of 2 has occurred 1000 times, making it the mode of order occurrences.  

Looking at this problem, I need to find the mode (most frequent value) of order occurrences. The mode is the `item_count` that has the highest `order_occurrences` value.

Let me break this down:

1. Find the maximum value in the `order_occurrences` column
2. Return all `item_count` values that have this maximum frequency
3. Sort results in ascending order if there are tiesThe solution works as follows:

**Step 1**: The subquery `SELECT MAX(order_occurrences) FROM items_per_order` finds the highest frequency value in the `order_occurrences` column.

**Step 2**: The main query filters the table to only include rows where `order_occurrences` equals this maximum value.

**Step 3**: We select the `item_count` for these rows and alias it as `mode`.

**Step 4**: Results are sorted by `item_count` in ascending order to handle cases where multiple item counts have the same maximum frequency.

For the given example:

- Item count 1 has 500 occurrences
- Item count 2 has 1000 occurrences (highest)
- Item count 3 has 800 occurrences

Since 1000 is the maximum frequency, item count 2 is the mode.

Alternative approach using window functions (if supported):

```SQL
-- Alternative solution using RANK()
WITH ranked_items AS (
    SELECT
        item_count,
        order_occurrences,
        RANK() OVER (ORDER BY order_occurrences DESC) as rank_num
    FROM items_per_order
)
SELECT item_count AS mode
FROM ranked_items
WHERE rank_num = 1
ORDER BY item_count ASC;
```

Both solutions will handle ties correctly by returning all item counts that share the maximum frequency.