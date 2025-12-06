---
Created: 2025-06-28T18:34
Area:
- Rank
Key Functions:
- CTE
- Window Function
Company:
- JP Morgan
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Card Launch Success_from_made_1
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Medium/Card Launch Success_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Your team at JPMorgan Chase is soon launching a new credit card. You are asked to estimate how many cards you'll issue in the first month.

Before you can answer this question, you want to first get some perspective on how well new credit card launches typically do in their first month.

Write a query that outputs the name of the credit card, and how many cards were issued in its launch month. The launch month is the earliest record in the `monthly_cards_issued` table for a given card. Order the results starting from the biggest issued amount.

### `monthly_cards_issued` Table:

|   |   |
|---|---|
|Column Name|Type|
|issue_month|integer|
|issue_year|integer|
|card_name|string|
|issued_amount|integer|

### `monthly_cards_issued` Example Input:

|   |   |   |   |
|---|---|---|---|
|issue_month|issue_year|card_name|issued_amount|
|1|2021|Chase Sapphire Reserve|170000|
|2|2021|Chase Sapphire Reserve|175000|
|3|2021|Chase Sapphire Reserve|180000|
|3|2021|Chase Freedom Flex|65000|
|4|2021|Chase Freedom Flex|70000|

### Example Output:

|   |   |
|---|---|
|card_name|issued_amount|
|Chase Sapphire Reserve|170000|
|Chase Freedom Flex|65000|

### Explanation

Chase Sapphire Reserve card was launched on 1/2021 with an issued amount of 170,000 cards and the Chase Freedom Flex card was launched on 3/2021 with an issued amount of 65,000 cards.

  

Looking at this problem, I need to:

1. Find the launch month for each credit card (earliest record for each card)
2. Get the issued amount for that specific launch month
3. Sort by issued amount in descending orderThe solution uses a CTE approach to handle the launch date identification correctly:

**Step 1**: The CTE `card_launch_dates` finds each card's launch date by:

- Finding the minimum `issue_year` for each card
- Within that minimum year, finding the minimum `issue_month`

**Step 2**: The main query joins the original table with the CTE to get only the records that match each card's exact launch month and year.

**Step 3**: We select the `card_name` and `issued_amount` for these launch records.

**Step 4**: Results are ordered by `issued_amount` in descending order (biggest first).

For the given example:

- Chase Sapphire Reserve: Launch date is 1/2021 with 170,000 cards issued
- Chase Freedom Flex: Launch date is 3/2021 with 65,000 cards issued

Alternative solution using window functions:

```SQL
-- Alternative solution using ROW_NUMBER()
WITH ranked_records AS (
  SELECT
    card_name,
    issued_amount,
    ROW_NUMBER() OVER (
      PARTITION BY card_name
      ORDER BY issue_year ASC, issue_month ASC
    ) as row_num
  FROM monthly_cards_issued
)

SELECT
  card_name,
  issued_amount
FROM ranked_records
WHERE row_num = 1
ORDER BY issued_amount DESC;
```

Both approaches correctly identify the launch month as the chronologically earliest record for each card.
