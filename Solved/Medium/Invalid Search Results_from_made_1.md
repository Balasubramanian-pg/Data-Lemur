---
Company:
- Google
Difficulty: Intermediate
Created: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Invalid Search Results_from_made_1
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Medium/Invalid Search Results_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---

### 1. The Question

The business question being asked by this SQL query is:

**"What is the overall invalid search result percentage for each country? The raw data provides search volumes and invalid rates per category, so we need to aggregate these to find the unified country-level percentage."**


### 2. Table Schema

The query references a single table, `search_category`. This table likely contains pre-aggregated data for different search categories within each country. A plausible schema would be:

```sql
-- Table: search_category
-- Stores aggregated search metrics for different categories within each country.
CREATE TABLE search_category (
    country            VARCHAR(100) NOT NULL,
    search_category  VARCHAR(255) NOT NULL,
    num_search         BIGINT,                 -- Total number of searches for this category
    invalid_result_pct DECIMAL(5, 2)           -- The percentage of invalid results for this category
);

-- A composite index would be beneficial for the GROUP BY clause.
CREATE INDEX idx_search_country ON search_category (country);
```


### 3. Structured SQL Query (Method 1: Using a Common Table Expression - CTE)

This is your original query, formatted for clarity. It's a very readable and logical way to solve the problem.

```sql
-- Step 1: Calculate the total number of searches and the total number of invalid searches for each country.
WITH search_details AS (
    SELECT
        country,
        SUM(num_search) AS total_search,
        SUM(num_search * (invalid_result_pct / 100.0)) AS invalid_searches
    FROM
        search_category
    WHERE
        num_search IS NOT NULL
        AND invalid_result_pct IS NOT NULL
    GROUP BY
        country
)
-- Step 2: Use the aggregated numbers to calculate the final country-level percentage.
SELECT
    country,
    total_search,
    ROUND((invalid_searches / total_search) * 100.0, 2) AS invalid_result_pct
FROM
    search_details;
```


### 4. Explanation of the Query

This query uses a two-step approach with a CTE to first "reconstitute" the raw counts before calculating the final percentage.

**Step 1: The `search_details` CTE**

1.  **`FROM search_category WHERE ... IS NOT NULL`**: It starts by reading from the `search_category` table and filtering out any rows with missing data to prevent calculation errors. This is good data hygiene.
2.  **`GROUP BY country`**: It groups all the rows by country, so the `SUM` functions will operate on all categories within a single country.
3.  **`SUM(num_search) AS total_search`**: This is a straightforward sum of all searches across all categories for a given country.
4.  **`SUM(num_search * (invalid_result_pct / 100.0)) AS invalid_searches`**: This is the most critical part. It calculates the total *number* of invalid searches.
    *   `invalid_result_pct / 100.0`: Converts the percentage for a category (e.g., `5.0`) into its decimal equivalent (e.g., `0.05`). Using `100.0` ensures floating-point division.
    *   `num_search * (...)`: For each category row, it calculates the raw count of invalid searches (e.g., 1000 searches * 0.05 = 50 invalid searches).
    *   `SUM(...)`: It then adds up these raw counts from all categories within the country to get the total number of invalid searches.

**Step 2: The Final `SELECT` Statement**

1.  **`FROM search_details`**: This query runs on the temporary, aggregated data from the CTE.
2.  **`ROUND((invalid_searches / total_search) * 100.0, 2)`**: This calculates the final weighted average percentage for the entire country.
    *   `invalid_searches / total_search`: Divides the total number of invalid searches by the total number of searches to get the overall invalid ratio.
    *   `* 100.0`: Converts this ratio back into a percentage.
    *   `ROUND(..., 2)`: Rounds the final result to two decimal places for clean presentation.


### 5. Another SQL Method (Method 2: Single Aggregation Query)

You can achieve the same result without a CTE by performing all calculations in a single query block. This is more compact but can be less readable for complex formulas.

```sql
SELECT
    country,
    SUM(num_search) AS total_search,
    ROUND(
        SUM(num_search * (invalid_result_pct / 100.0)) -- Numerator: Total invalid searches
        / SUM(num_search)                              -- Denominator: Total searches
        * 100.0,
        2
    ) AS invalid_result_pct
FROM
    search_category
WHERE
    num_search IS NOT NULL
    AND invalid_result_pct IS NOT NULL
GROUP BY
    country;
```


### 6. Explanation of the Alternative Query

This method performs the same logic but combines the calculation of the components and the final percentage into a single step.

1.  **`FROM ... WHERE ... GROUP BY ...`**: The filtering and grouping are identical to the first method.
2.  **`SELECT ...`**: The `SELECT` clause now contains all the logic.
    *   `SUM(num_search) AS total_search`: The total search count is calculated as before.
    *   **The `ROUND(...)` clause**: This single, large expression calculates the final weighted percentage directly.
        *   The numerator, `SUM(num_search * (invalid_result_pct / 100.0))`, calculates the total number of invalid searches.
        *   The denominator, `SUM(num_search)`, calculates the total number of searches.
        *   The division, multiplication by `100.0`, and rounding are all performed within the same expression.

**Comparison:**
*   The **CTE method** is often preferred because it separates the logic into clear, understandable steps. It's easier to debug, as you can run the CTE's query independently to check the intermediate results (`total_search` and `invalid_searches`).
*   The **single query method** is more concise. For this specific problem, performance will likely be identical, so the choice is primarily about readability and coding style.