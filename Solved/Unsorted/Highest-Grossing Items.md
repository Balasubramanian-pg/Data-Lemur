---
Created: 2025-06-28T18:34
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Highest-Grossing Items
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Highest-Grossing
  Items.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
This is the same question as problem #12 in the SQL Chapter of [Ace the Data Science Interview](https://amzn.to/3kF79Fx)!

Assume you're given a table containing data on Amazon customers and their spending on products in different category, write a query to identify the top two highest-grossing products within each category in the year 2022. The output should include the category, product, and total spend.

### `product_spend` Table:

|   |   |
|---|---|
|Column Name|Type|
|category|string|
|product|string|
|user_id|integer|
|spend|decimal|
|transaction_date|timestamp|

### `product_spend` Example Input:

|   |   |   |   |   |
|---|---|---|---|---|
|category|product|user_id|spend|transaction_date|
|appliance|refrigerator|165|246.00|12/26/2021 12:00:00|
|appliance|refrigerator|123|299.99|03/02/2022 12:00:00|
|appliance|washing machine|123|219.80|03/02/2022 12:00:00|
|electronics|vacuum|178|152.00|04/05/2022 12:00:00|
|electronics|wireless headset|156|249.90|07/08/2022 12:00:00|
|electronics|vacuum|145|189.00|07/15/2022 12:00:00|

### Example Output:

|   |   |   |
|---|---|---|
|category|product|total_spend|
|appliance|refrigerator|299.99|
|appliance|washing machine|219.80|
|electronics|vacuum|341.00|
|electronics|wireless headset|249.90|

### Explanation:

Within the "appliance" category, the top two highest-grossing products are "refrigerator" and "washing machine."

In the "electronics" category, the top two highest-grossing products are "vacuum" and "wireless headset."

---

Looking at this problem, I need to:

1. Filter for transactions in 2022
2. Calculate total spend per product within each category
3. Rank products by total spend within each category
4. Select the top 2 products per categoryThis query solves the problem using a multi-step approach with CTEs:
5. **First CTE (**`**product_totals**`**)**:
    - Filters for 2022 transactions using `EXTRACT(YEAR FROM transaction_date) = 2022`
    - Groups by `category` and `product` to calculate `SUM(spend)` as `total_spend`
6. **Second CTE (**`**ranked_products**`**)**:
    - Uses `ROW_NUMBER()` window function to rank products within each category
    - `PARTITION BY category` ensures ranking is done separately for each category
    - `ORDER BY total_spend DESC` ranks products from highest to lowest spend
7. **Final SELECT**:
    - Filters for `rank <= 2` to get the top 2 products per category
    - Orders results by `category` and `total_spend DESC` for clean output

**Tracing through the example**:

- **Appliance category**: refrigerator ($299.99) and washing machine ($219.80)
- **Electronics category**: vacuum ($152.00 + $189.00 = $341.00) and wireless headset ($249.90)

The query correctly identifies the top 2 highest-grossing products within each category for 2022, matching the expected output format.

  

  

```SQL
Looking at this problem, I need to:

1. Filter for transactions in 2022
2. Calculate total spend per product within each category
3. Rank products by total spend within each category
4. Select the top 2 products per categoryThis query solves the problem using a multi-step approach with CTEs:

1. **First CTE (`product_totals`)**:
   - Filters for 2022 transactions using `EXTRACT(YEAR FROM transaction_date) = 2022`
   - Groups by `category` and `product` to calculate `SUM(spend)` as `total_spend`

2. **Second CTE (`ranked_products`)**:
   - Uses `ROW_NUMBER()` window function to rank products within each category
   - `PARTITION BY category` ensures ranking is done separately for each category
   - `ORDER BY total_spend DESC` ranks products from highest to lowest spend

3. **Final SELECT**:
   - Filters for `rank <= 2` to get the top 2 products per category
   - Orders results by `category` and `total_spend DESC` for clean output

**Tracing through the example**:
- **Appliance category**: refrigerator ($299.99) and washing machine ($219.80)
- **Electronics category**: vacuum ($152.00 + $189.00 = $341.00) and wireless headset ($249.90)

The query correctly identifies the top 2 highest-grossing products within each category for 2022, matching the expected output format.
```

  

```SQL
WITH product_totals AS (
  SELECT 
    category,
    product,
    SUM(spend) AS total_spend
  FROM product_spend
  WHERE EXTRACT(YEAR FROM transaction_date) = 2022
  GROUP BY category, product
),
ranked_products AS (
  SELECT 
    category,
    product,
    total_spend,
    ROW_NUMBER() OVER (
      PARTITION BY category 
      ORDER BY total_spend DESC
    ) AS rank
  FROM product_totals
)

SELECT 
  category,
  product,
  total_spend
FROM ranked_products
WHERE rank <= 2
ORDER BY category, total_spend DESC;
```