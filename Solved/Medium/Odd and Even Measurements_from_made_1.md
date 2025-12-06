---
Created: 2025-06-28T18:34
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Odd and Even Measurements_from_made_1
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Medium/Odd and Even Measurements_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
This is the same question as problem #28 in the SQL Chapter of [Ace the Data Science Interview](https://amzn.to/3kF79Fx)!

Assume you're given a table with measurement values obtained from a Google sensor over multiple days with measurements taken multiple times  
within each day.  

Write a query to calculate the sum of odd-numbered and even-numbered measurements separately for a particular day and display the results in  
two different columns. Refer to the Example Output below for the desired format.  

Definition:

- Within a day, measurements taken at 1st, 3rd, and 5th times are considered odd-numbered measurements, and measurements taken at 2nd,  
    4th, and 6th times are considered even-numbered measurements.  
    

_Effective April 15th, 2023, the question and solution for this question have been revised._

### `measurements` Table:

|   |   |
|---|---|
|Column Name|Type|
|measurement_id|integer|
|measurement_value|decimal|
|measurement_time|datetime|

### `measurements` Example Input:

|   |   |   |
|---|---|---|
|measurement_id|measurement_value|measurement_time|
|131233|1109.51|07/10/2022 09:00:00|
|135211|1662.74|07/10/2022 11:00:00|
|523542|1246.24|07/10/2022 13:15:00|
|143562|1124.50|07/11/2022 15:00:00|
|346462|1234.14|07/11/2022 16:45:00|

### Example Output:

|   |   |   |
|---|---|---|
|measurement_day|odd_sum|even_sum|
|07/10/2022 00:00:00|2355.75|1662.74|
|07/11/2022 00:00:00|1124.50|1234.14|

### Explanation

Based on the results,

- On 07/10/2022, the sum of the odd-numbered measurements is 2355.75, while the sum of the even-numbered measurements is 1662.74.
- On 07/11/2022, there are only two measurements available. The sum of the odd-numbered measurements is 1124.50, and the sum of the  
    even-numbered measurements is 1234.14.  
    

The dataset you are querying against may have different input & output - **this is just an example**!

  

Looking at this problem, I need to:

1. Group measurements by day
2. Assign row numbers to measurements within each day (ordered by measurement time)
3. Classify measurements as odd-numbered (1st, 3rd, 5th, etc.) or even-numbered (2nd, 4th, 6th, etc.)
4. Sum the values separately for odd and even numbered measurementsThis query solves the problem by:
5. **CTE (**`**numbered_measurements**`**)**:
    - Extracts the date from `measurement_time` using `DATE()` function
    - Uses `ROW_NUMBER()` window function to assign sequential numbers to measurements within each day
    - `PARTITION BY DATE(measurement_time)` ensures numbering restarts for each day
    - `ORDER BY measurement_time` ensures measurements are numbered chronologically
6. **Main Query**:
    - Uses conditional aggregation with `CASE WHEN` statements
    - **Odd-numbered measurements**: `measurement_order % 2 = 1` (1st, 3rd, 5th, etc.)
    - **Even-numbered measurements**: `measurement_order % 2 = 0` (2nd, 4th, 6th, etc.)
    - `SUM()` calculates the total for each category
    - Groups by `measurement_day` to get results per day

**Tracing through the example**:

**07/10/2022**:

- 1st measurement (09:00): 1109.51 → odd
- 2nd measurement (11:00): 1662.74 → even
- 3rd measurement (13:15): 1246.24 → odd
- Odd sum: 1109.51 + 1246.24 = 2355.75
- Even sum: 1662.74

**07/11/2022**:

- 1st measurement (15:00): 1124.50 → odd
- 2nd measurement (16:45): 1234.14 → even
- Odd sum: 1124.50
- Even sum: 1234.14

This matches the expected output perfectly!

  

```SQL
WITH numbered_measurements AS (
  SELECT 
    DATE(measurement_time) AS measurement_day,
    measurement_value,
    ROW_NUMBER() OVER (
      PARTITION BY DATE(measurement_time) 
      ORDER BY measurement_time
    ) AS measurement_order
  FROM measurements
)

SELECT 
  measurement_day,
  SUM(CASE WHEN measurement_order % 2 = 1 THEN measurement_value ELSE 0 END) AS odd_sum,
  SUM(CASE WHEN measurement_order % 2 = 0 THEN measurement_value ELSE 0 END) AS even_sum
FROM numbered_measurements
GROUP BY measurement_day
ORDER BY measurement_day;
```