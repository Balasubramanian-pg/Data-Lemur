---
Date: 2025-07-30
Difficulty: Easy
Title: Cards Issued Difference
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Easy/Cards Issued Difference.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Company: ''
Question Link: ''
Category: ''
Sub Category: ''
---
Your team at JPMorgan Chase is preparing to launch a new credit card, and to gain some insights, you're analyzing how many credit cards were issued each month.

Write a query that outputs the name of each credit card and the difference in the number of issued cards between the month with the highest issuance cards and the lowest issuance. Arrange the results based on the largest disparity.

### `monthly_cards_issued` Table:

|Column Name|Type|
|---|---|
|card_name|string|
|issued_amount|integer|
|issue_month|integer|
|issue_year|integer|

### `monthly_cards_issued` Example Input:

|card_name|issued_amount|issue_month|issue_year|
|---|---|---|---|
|Chase Freedom Flex|55000|1|2021|
|Chase Freedom Flex|60000|2|2021|
|Chase Freedom Flex|65000|3|2021|
|Chase Freedom Flex|70000|4|2021|
|Chase Sapphire Reserve|170000|1|2021|
|Chase Sapphire Reserve|175000|2|2021|
|Chase Sapphire Reserve|180000|3|2021|

### Example Output:

|card_name|difference|
|---|---|
|Chase Freedom Flex|15000|
|Chase Sapphire Reserve|10000|

Chase Freedom Flex's best month was 70k cards issued and the worst month was 55k cards, so the difference is 15k cards.

Chase Sapphire Reserve’s best month was 180k cards issued and the worst month was 170k cards, so the difference is 10k cards.

### Query to Calculate Difference in Issued Cards

To solve this problem, we'll use a SQL query that calculates the difference between the maximum and minimum issued amounts for each card. We'll use subqueries to find these maximum and minimum values.
```SQL
SELECT 
  card_name,
  MAX(issued_amount) - MIN(issued_amount) AS difference
FROM 
  monthly_cards_issued
GROUP BY 
  card_name
ORDER BY 
  difference DESC;
```

Explanation

- **Group by Card Name**: We group the rows in the `monthly_cards_issued` table by `card_name` to calculate the maximum and minimum issued amounts for each card.

- **Calculate Difference**: We use `MAX(issued_amount)` and `MIN(issued_amount)` to find the highest and lowest issuance amounts for each card, and then subtract the minimum from the maximum to get the difference.

- **Order Results**: Finally, we order the results by the difference in descending order, so cards with the largest disparity appear at the top.

Example Usage

If we run this query on the provided example input, we'll get the following output:

|card_name|difference|
|---|---|
|Chase Freedom Flex|15000|
|Chase Sapphire Reserve|10000|

This output matches the expected result, showing the difference in issued cards between the best and worst months for each card.

### Alternative Method Using Window Functions

We can also use window functions to find the maximum and minimum issued amounts for each card, and then calculate the difference.

```sql
WITH ranked_cards AS (
  SELECT 
    card_name,
    issued_amount,
    MAX(issued_amount) OVER (PARTITION BY card_name) AS max_issued,
    MIN(issued_amount) OVER (PARTITION BY card_name) AS min_issued
  FROM 
    monthly_cards_issued
)
SELECT DISTINCT 
  card_name,
  max_issued - min_issued AS difference
FROM 
  ranked_cards
ORDER BY 
  difference DESC;
```

Explanation

- **Common Table Expression (CTE)**: We define a CTE `ranked_cards` that uses window functions to find the maximum and minimum issued amounts for each card.

- **Window Functions**: We use `MAX` and `MIN` with `OVER (PARTITION BY card_name)` to calculate the maximum and minimum issued amounts for each card.

- **Calculate Difference**: We select distinct `card_name` and calculate the difference between `max_issued` and `min_issued`.

- **Order Results**: Finally, we order the results by the difference in descending order.

This query produces the same output as the previous one:

|card_name|difference|
|---|---|
|Chase Freedom Flex|15000|
|Chase Sapphire Reserve|10000|