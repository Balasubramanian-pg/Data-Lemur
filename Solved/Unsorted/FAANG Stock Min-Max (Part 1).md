---
Created: 2025-06-28T18:34
Area:
- Statistical Aggregation
Key Functions:
- CTE
- Inner Join
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: FAANG Stock Min-Max (Part 1)
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/FAANG Stock Min-Max
  (Part 1).md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
The Bloomberg terminal is the go-to resource for financial professionals, offering convenient access to a wide array of financial datasets. As a Data Analyst at Bloomberg, you have access to historical data on stock performance.

Currently, you're analyzing the highest and lowest open prices for each FAANG stock by month over the years.

For each FAANG stock, display the ticker symbol, the month and year ('Mon-YYYY') with the corresponding highest and lowest open prices (refer to the Example Output format). Ensure that the results are sorted by ticker symbol.

### `stock_prices` Schema:

|   |   |   |
|---|---|---|
|Column Name|Type|Description|
|date|datetime|The specified date (mm/dd/yyyy) of the stock data.|
|ticker|varchar|The stock ticker symbol (e.g., AAPL) for the corresponding company.|
|open|decimal|The opening price of the stock at the start of the trading day.|
|high|decimal|The highest price reached by the stock during the trading day.|
|low|decimal|The lowest price reached by the stock during the trading day.|
|close|decimal|The closing price of the stock at the end of the trading day.|

### `stock_prices` Example Input:

Note that the table below displays randomly selected AAPL data.

|   |   |   |   |   |   |
|---|---|---|---|---|---|
|date|ticker|open|high|low|close|
|01/31/2023 00:00:00|AAPL|142.28|142.70|144.34|144.29|
|02/28/2023 00:00:00|AAPL|146.83|147.05|149.08|147.41|
|03/31/2023 00:00:00|AAPL|161.91|162.44|165.00|164.90|
|04/30/2023 00:00:00|AAPL|167.88|168.49|169.85|169.68|
|05/31/2023 00:00:00|AAPL|176.76|177.33|179.35|177.25|

### Example Output:

|   |   |   |   |   |
|---|---|---|---|---|
|ticker|highest_mth|highest_open|lowest_mth|lowest_open|
|AAPL|May-2023|176.76|Jan-2023|142.28|

Apple Inc. (AAPL) achieved its highest opening price of $176.76 in May 2023 and its lowest opening price of $142.28 in January 2023.

---

Looking at this problem, I need to:

1. Extract month-year from the date in 'Mon-YYYY' format
2. Find the highest and lowest open prices for each ticker across all months
3. Identify which months these extremes occurred in
4. Format the output as specifiedThis query analyzes FAANG stock performance by:
5. **CTE (**`**monthly_data**`**)**:
    - Uses `TO_CHAR(date, 'Mon-YYYY')` to format dates as 'Mon-YYYY' (e.g., 'Jan-2023')
    - Uses `ROW_NUMBER()` to rank each stock's open prices:
        - `highest_rank`: Ranks open prices in descending order (highest first)
        - `lowest_rank`: Ranks open prices in ascending order (lowest first)
    - Partitions by `ticker` to rank within each stock
6. **CTE (**`**highest_open**`**)**:
    - Filters for `highest_rank = 1` to get the record with the highest open price for each ticker
    - Captures the month and open price when the highest occurred
7. **CTE (**`**lowest_open**`**)**:
    - Filters for `lowest_rank = 1` to get the record with the lowest open price for each ticker
    - Captures the month and open price when the lowest occurred
8. **Final Query**:
    - Joins the highest and lowest data by ticker
    - Orders results by ticker symbol as requested

**Tracing through the example**:

- **AAPL**: Highest open of 176.76 in May-2023, lowest open of 142.28 in Jan-2023

The query handles multiple FAANG stocks and identifies the specific months when each stock reached its highest and lowest opening prices, providing valuable insights for financial analysis on the Bloomberg terminal.

```SQL
WITH monthly_data AS (
  SELECT 
    ticker,
    TO_CHAR(date, 'Mon-YYYY') AS month_year,
    open,
    ROW_NUMBER() OVER (PARTITION BY ticker ORDER BY open DESC) AS highest_rank,
    ROW_NUMBER() OVER (PARTITION BY ticker ORDER BY open ASC) AS lowest_rank
  FROM stock_prices
),
highest_open AS (
  SELECT 
    ticker,
    month_year AS highest_mth,
    open AS highest_open
  FROM monthly_data
  WHERE highest_rank = 1
),
lowest_open AS (
  SELECT 
    ticker,
    month_year AS lowest_mth,
    open AS lowest_open
  FROM monthly_data
  WHERE lowest_rank = 1
)

SELECT 
  h.ticker,
  h.highest_mth,
  h.highest_open,
  l.lowest_mth,
  l.lowest_open
FROM highest_open h
INNER JOIN lowest_open l ON h.ticker = l.ticker
ORDER BY h.ticker;
```