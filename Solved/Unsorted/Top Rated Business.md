---
Created: null
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Top Rated Business
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Top Rated Business.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Of course! This is a great query that calculates aggregate statistics over an entire table using conditional logic. It's a perfect example of generating a summary report.

Here is the complete breakdown.


### 1. The Question

The business question being asked by this SQL query is:

**"Across all reviews, what is the total count of 'top-rated' reviews (defined as 4 or 5 stars), and what percentage of all reviews do these top-rated reviews represent?"**

The query will produce a single row with two columns: the absolute number of top reviews and their percentage of the total.


### 2. Table Schema

The query references a single table, `reviews`. A plausible schema for this table would be:

```sql
-- Table: reviews
-- Stores a record for every review submitted for a business.
CREATE TABLE reviews (
    review_id     INT PRIMARY KEY,
    business_id   INT NOT NULL,           -- The ID of the business being reviewed
    user_id       INT NOT NULL,           -- The ID of the user who wrote the review
    review_stars  INT NOT NULL,           -- The star rating given (e.g., 1 to 5)
    review_date   DATE
);

-- An index on the review_stars column could slightly improve performance.
CREATE INDEX idx_reviews_stars ON reviews (review_stars);
```
*Note: The query's column alias `business_num` is slightly misleading, as the query counts the number of top-rated *reviews*, not the number of top-rated *businesses*. My explanation will focus on what the query actually does.*


### 3. Structured SQL Query (Method 1: Conditional `SUM` and `COUNT`)

This is your original query, which is a very robust and clear way to perform this calculation.

```sql
SELECT
    -- This counts the number of top-rated reviews
    SUM(CASE WHEN review_stars IN (4, 5) THEN 1 ELSE 0 END) AS business_num,
    
    -- This calculates the percentage of top-rated reviews
    ROUND(
        100 *
        (
            SUM(CASE WHEN review_stars IN (4, 5) THEN 1 ELSE 0 END)::NUMERIC
            / COUNT(business_id)
        ),
        2
    ) AS top_business_pct
FROM
    reviews;
```


### 4. Explanation of the Query

This query calculates two summary metrics over the entire `reviews` table in a single pass.

1.  **`FROM reviews`**: The query specifies the `reviews` table as the data source.
2.  **`SUM(...) AS business_num`**: This is a conditional count.
    *   The `CASE` statement is evaluated for every single row. It returns a `1` if `review_stars` is 4 or 5, and a `0` otherwise.
    *   The `SUM()` function then adds up all these 1s and 0s, giving a total count of only the top-rated reviews.
3.  **The Percentage Calculation**:
    *   **Numerator**: `SUM(CASE ... END)::NUMERIC` is the exact same calculation as above, giving the count of top-rated reviews. The `::NUMERIC` is a PostgreSQL-specific cast to ensure that the division results in a decimal number (floating-point division) rather than an integer.
    *   **Denominator**: `COUNT(business_id)` counts the total number of reviews in the table (assuming `business_id` is never `NULL`).
    *   **`... / ...`**: The division gives the ratio of top reviews to total reviews (e.g., 0.85).
    *   **`100 * ...`**: Multiplies the ratio by 100 to convert it into a percentage (e.g., 85.0).
    *   **`ROUND(..., 2)`**: Rounds the final percentage to two decimal places for clean presentation.
4.  Since there is no `GROUP BY` clause, the query aggregates over the entire table and returns a single summary row.


### 5. Another SQL Method (Method 2: Using `AVG` for Percentage)

A more concise and elegant way to calculate a percentage is to use the `AVG` function on a flag of 1s and 0s.

```sql
SELECT
    SUM(CASE WHEN review_stars IN (4, 5) THEN 1 ELSE 0 END) AS business_num,
    ROUND(
        100.0 * AVG(CASE WHEN review_stars IN (4, 5) THEN 1.0 ELSE 0.0 END),
        2
    ) AS top_business_pct
FROM
    reviews;
```


### 6. Explanation of the Alternative Query

This method leverages a mathematical property of the `AVG` function to simplify the percentage calculation.

1.  **`business_num` calculation**: This part is identical to the first method, using `SUM` to get the total count of top-rated reviews.
2.  **`top_business_pct` calculation**:
    *   `CASE WHEN review_stars IN (4, 5) THEN 1.0 ELSE 0.0 END`: This `CASE` statement creates a "flag" for each row. It returns a numeric `1.0` for a top-rated review and `0.0` for any other review.
    *   **`AVG(...)`**: This is the clever part. The average of a series of 1s and 0s is mathematically equivalent to the percentage of 1s in that series. For example, if you have 8 top reviews and 2 other reviews, the series is `(1,1,1,1,1,1,1,1,0,0)`. The `AVG` is `8 / 10 = 0.8`, which is the direct ratio you need for the percentage.
    *   **`100.0 * ...`**: We multiply the result of the `AVG` function by `100.0` to convert the decimal ratio (0.8) into a percentage (80.0). Using `100.0` also ensures the entire calculation is done using floating-point numbers.
    *   **`ROUND(..., 2)`**: The final result is rounded as before.

This `AVG` trick is a very common and efficient pattern in SQL for calculating percentages. Both methods are highly performant as they only require a single pass over the data.