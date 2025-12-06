---
Created: 2025-06-28T18:34
Area:
- MECE
Key Functions:
- CTE
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Report Contagious Data
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Report Contagious
  Data.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Here's the structured solution for Question 104:

### Problem Statement

Generate a report showing continuous periods of success or failure states for tasks between 2019-01-01 and 2019-12-31, with start and end dates for each period.

### Tables

**Failed table:**

```Plain
+-------------------+
| fail_date         |
+-------------------+
| 2018-12-28        |
| 2018-12-29        |
| 2019-01-04        |
| 2019-01-05        |
+-------------------+
```

**Succeeded table:**

```Plain
+-------------------+
| success_date      |
+-------------------+
| 2018-12-30        |
| 2018-12-31        |
| 2019-01-01        |
| 2019-01-02        |
| 2019-01-03        |
| 2019-01-06        |
+-------------------+
```

### Expected Output

```Plain
+--------------+--------------+--------------+
| period_state | start_date   | end_date     |
+--------------+--------------+--------------+
| succeeded    | 2019-01-01   | 2019-01-03   |
| failed       | 2019-01-04   | 2019-01-05   |
| succeeded    | 2019-01-06   | 2019-01-06   |
+--------------+--------------+--------------+
```

### SQL Solution

```SQL
WITH succeeded_periods AS (
    SELECT
        MIN(success_date) AS start_date,
        MAX(success_date) AS end_date,
        'succeeded' AS period_state
    FROM (
        SELECT
            success_date,
            DATE_SUB(success_date, INTERVAL ROW_NUMBER() OVER(ORDER BY success_date) DAY) AS date_group
        FROM Succeeded
        WHERE success_date BETWEEN '2019-01-01' AND '2019-12-31'
    ) AS grouped_success
    GROUP BY date_group
),

failed_periods AS (
    SELECT
        MIN(fail_date) AS start_date,
        MAX(fail_date) AS end_date,
        'failed' AS period_state
    FROM (
        SELECT
            fail_date,
            DATE_SUB(fail_date, INTERVAL ROW_NUMBER() OVER(ORDER BY fail_date) DAY) AS date_group
        FROM Failed
        WHERE fail_date BETWEEN '2019-01-01' AND '2019-12-31'
    ) AS grouped_fail
    GROUP BY date_group
)

SELECT
    period_state,
    start_date,
    end_date
FROM (
    SELECT * FROM succeeded_periods
    UNION ALL
    SELECT * FROM failed_periods
) AS combined_results
ORDER BY start_date;
```

### Explanation

1. **First CTE (succeeded_periods):**
    - Identifies continuous success periods using the date grouping technique
    - For each success date, subtracts its row number to create groups of consecutive dates
    - Groups by these date groups to find start and end dates for each success period
2. **Second CTE (failed_periods):**
    - Similarly identifies continuous failure periods
    - Uses the same technique of subtracting row numbers to group consecutive dates
    - Groups by date groups to find start and end dates for failure periods
3. **Main Query:**
    - Combines both success and failure periods
    - Orders results by start_date to show chronological sequence
    - Filters to only include dates within 2019

### Key Points

- Uses window functions with date arithmetic to identify consecutive dates
- Handles both success and failure states separately
- Combines results while maintaining chronological order
- Filters to only include the relevant year (2019)
- The technique works by creating identical values for consecutive dates when subtracting row numbers

### Date Grouping Technique

For example, consecutive dates 2019-01-01, 2019-01-02, 2019-01-03:

- 2019-01-01 - 1 day = 2018-12-31
- 2019-01-02 - 2 days = 2018-12-31
- 2019-01-03 - 3 days = 2018-12-31

All produce the same date group (2018-12-31), allowing them to be grouped together.