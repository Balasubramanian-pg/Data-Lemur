---
Created: 2025-06-28T18:34
Area:
- Time-Based Comparison
Key Functions:
- (Current-Prev)/Prev
- LAG()
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Y-on-Y Growth Rate
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Y-on-Y Growth Rate.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Assume you're given a table containing information about Wayfair user transactions for different products. Write a query to calculate the [year-on-year growth rate](https://www.fundera.com/blog/year-over-year-growth) for the total spend of each product, grouping the results by product ID.

The output should include the year in ascending order, product ID, current year's spend, previous year's spend and year-on-year growth percentage, rounded to 2 decimal places.

### `user_transactions` Table:

|   |   |
|---|---|
|Column Name|Type|
|transaction_id|integer|
|product_id|integer|
|spend|decimal|
|transaction_date|datetime|

### `user_transactions` Example Input:

|   |   |   |   |
|---|---|---|---|
|transaction_id|product_id|spend|transaction_date|
|1341|123424|1500.60|12/31/2019 12:00:00|
|1423|123424|1000.20|12/31/2020 12:00:00|
|1623|123424|1246.44|12/31/2021 12:00:00|
|1322|123424|2145.32|12/31/2022 12:00:00|

### Example Output:

|   |   |   |   |   |
|---|---|---|---|---|
|year|product_id|curr_year_spend|prev_year_spend|yoy_rate|
|2019|123424|1500.60|NULL|NULL|
|2020|123424|1000.20|1500.60|-33.35|
|2021|123424|1246.44|1000.20|24.62|
|2022|123424|2145.32|1246.44|72.12|

### Explanation:

Product ID 123424 is analyzed for multiple years: 2019, 2020, 2021, and 2022.

- In the year 2020, the current year's spend is 1000.20, and there is  
    no previous year's spend recorded (indicated by an empty cell).  
    
- In the year 2021, the current year's spend is 1246.44, and the previous year's spend is 1000.20.
- In the year 2022, the current year's spend is 2145.32, and the previous year's spend is 1246.44.

To calculate the year-on-year growth rate, we compare the current year's spend with the previous year's spend.For instance, the spend grew by 24.62% from 2020 to 2021, indicating a positive growth rate.


Looking at this problem, I need to:

1. Calculate total spend per product per year
2. Get the previous year's spend for each product
3. Calculate year-on-year growth rate
4. Handle cases where there's no previous year dataThe solution works as follows:

**Step 1**: Create a CTE `yearly_spend` to:

- Extract the year from `transaction_date`
- Group by year and product_id
- Sum the total spend for each product in each year

**Step 2**: Create a CTE `spend_with_previous` to:

- Use the `LAG()` window function to get the previous year's spend for each product
- Partition by `product_id` and order by `year` to ensure we get the correct previous year for each product

**Step 3**: In the final SELECT:

- Round current and previous year spend to 2 decimal places
- Calculate year-on-year growth rate using the formula: `((current - previous) / previous) * 100`
- Handle NULL cases when there's no previous year data
- Round the growth rate to 2 decimal places
- Order by year ascending, then by product_id

**Formula for YoY Growth Rate**:

```Plain
YoY Growth % = ((Current Year Spend - Previous Year Spend) / Previous Year Spend) × 100
```

For the example:

- 2019: No previous year → NULL growth rate
- 2020: (1000.20 - 1500.60) / 1500.60 × 100 = -33.35%
- 2021: (1246.44 - 1000.20) / 1000.20 × 100 = 24.62%
- 2022: (2145.32 - 1246.44) / 1246.44 × 100 = 72.12%

The key insight is using `LAG()` with `PARTITION BY product_id` to get each product's previous year spend, ensuring we compare the correct years for each individual product.

  

```SQL
-- Solution: Calculate year-on-year growth rate for Wayfair products
WITH yearly_spend AS (
  SELECT 
    EXTRACT(YEAR FROM transaction_date) AS year,
    product_id,
    SUM(spend) AS total_spend
  FROM user_transactions
  GROUP BY EXTRACT(YEAR FROM transaction_date), product_id
),
spend_with_previous AS (
  SELECT 
    year,
    product_id,
    total_spend AS curr_year_spend,
    LAG(total_spend) OVER (
      PARTITION BY product_id 
      ORDER BY year
    ) AS prev_year_spend
  FROM yearly_spend
)

SELECT 
  year,
  product_id,
  ROUND(curr_year_spend, 2) AS curr_year_spend,
  ROUND(prev_year_spend, 2) AS prev_year_spend,
  CASE 
    WHEN prev_year_spend IS NULL THEN NULL
    ELSE ROUND(
      ((curr_year_spend - prev_year_spend) / prev_year_spend) * 100, 
      2
    )
  END AS yoy_rate
FROM spend_with_previous
ORDER BY year ASC, product_id;
```