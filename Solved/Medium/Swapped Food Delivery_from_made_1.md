---
Created: 2025-06-28T18:34
Area:
- MECE
Key Functions:
- CTE
- LEAD & LAG
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Swapped Food Delivery_from_made_1
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Medium/Swapped Food Delivery_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Zomato is a leading online food delivery service that connects users with various restaurants and cuisines, allowing them to browse menus, place orders, and get meals delivered to their doorsteps.

Recently, Zomato encountered an issue with their delivery system. Due to an error in the delivery driver instructions, each item's order was  
swapped with the item in the subsequent row. As a data analyst, you're asked to correct this swapping error and return the proper pairing of  
order ID and item.  

If the last item has an odd order ID, it should remain as the last item in the corrected data. For example, if the last item is Order ID 7 Tandoori Chicken, then it should remain as Order ID 7 in the corrected  
data.  

In the results, return the correct pairs of order IDs and items.

### `orders` Schema:

|   |   |   |
|---|---|---|
|column_name|type|description|
|order_id|integer|The ID of each Zomato order.|
|item|string|The name of the food item in each order.|

### `orders` Example Input:

Here's a sample of the initial incorrect data:

|   |   |
|---|---|
|order_id|item|
|1|Chow Mein|
|2|Pizza|
|3|Pad Thai|
|4|Butter Chicken|
|5|Eggrolls|
|6|Burger|
|7|Tandoori Chicken|

### `orders` Example Output:

The corrected data should look like this:

|   |   |
|---|---|
|corrected_order_id|item|
|1|Pizza|
|2|Chow Mein|
|3|Butter Chicken|
|4|Pad Thai|
|5|Burger|
|6|Eggrolls|
|7|Tandoori Chicken|

Order ID 1 is now associated with Pizza and Order ID 2 is paired with Chow Mein. This adjustment ensures that each order is correctly aligned with its respective item, addressing the initial swapping error.

Order ID 7 remains unchanged and is still associated with Tandoori Chicken. This preserves the order sequence ensuring that the last odd order ID remains unaltered.


Looking at this problem, I need to understand the swapping pattern:

- Each item was swapped with the item in the subsequent row
- So order 1's item went to order 2, order 2's item went to order 3, etc.
- The last item (if it has an odd order ID) stays in place

To correct this, I need to:

1. For even order IDs: get the item from the previous order
2. For odd order IDs: get the item from the next order (except for the last odd order)
3. Keep the last odd order unchangedThis query corrects the swapping error by:
4. **CTE (**`**max_order**`**)**: Finds the maximum order ID to identify the last order
5. **Main Query Logic**:
    - **Even order IDs**: Uses `LAG(item)` to get the item from the previous row (correcting the forward swap)
    - **Odd order IDs that are the last order**: Keeps the original item unchanged
    - **Other odd order IDs**: Uses `LEAD(item)` to get the item from the next row (correcting the forward swap)
6. **Window Functions**:
    - `LAG(item) OVER (ORDER BY order_id)`: Gets the item from the previous order
    - `LEAD(item) OVER (ORDER BY order_id)`: Gets the item from the next order
    - Both ordered by `order_id` to maintain sequence

**Tracing through the example**:

- Order 1 (odd, not last): Gets item from order 2 → Pizza
- Order 2 (even): Gets item from order 1 → Chow Mein
- Order 3 (odd, not last): Gets item from order 4 → Butter Chicken
- Order 4 (even): Gets item from order 3 → Pad Thai
- Order 5 (odd, not last): Gets item from order 6 → Burger
- Order 6 (even): Gets item from order 5 → Eggrolls
- Order 7 (odd, last): Keeps original item → Tandoori Chicken

This perfectly matches the expected output, correcting the delivery system's swapping error while preserving the last odd order unchanged.

```SQL
WITH max_order AS (
  SELECT MAX(order_id) AS max_id
  FROM orders
)

SELECT 
  order_id AS corrected_order_id,
  CASE 
    WHEN order_id % 2 = 0 THEN 
      LAG(item) OVER (ORDER BY order_id)
    WHEN order_id % 2 = 1 AND order_id = (SELECT max_id FROM max_order) THEN 
      item
    ELSE 
      LEAD(item) OVER (ORDER BY order_id)
  END AS item
FROM orders
ORDER BY order_id;
```