---
Created: 2025-06-28T18:34
Area:
- Statistical Aggregation
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Median
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Median.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Here's the structured solution for Question 107:

### Problem Statement

Find the median of all numbers in the Numbers table, where each number appears with a given frequency.

### Table

**Numbers table:**

```Plain
+----------+-------------+
|  Number  |  Frequency  |
+----------+-------------+
|  0       |  7          |
|  1       |  1          |
|  2       |  3          |
|  3       |  1          |
+----------+-------------+
```

### Expected Output

```Plain
+--------+
| median |
+--------+
| 0.0000 |
+--------+
```

### SQL Solution

```SQL
WITH t1 AS (
    SELECT
        *,
        SUM(frequency) OVER(ORDER BY number) AS cum_sum,
        (SUM(frequency) OVER())/2 AS middle
    FROM numbers
)

SELECT AVG(number) AS median
FROM t1
WHERE middle BETWEEN (cum_sum - frequency) AND cum_sum;
```

### Explanation

1. **CTE (t1):**
    - Calculates two key metrics:
        - `cum_sum`: Cumulative sum of frequencies ordered by number (running total)
        - `middle`: Half of the total frequency count (median position)
2. **Main Query:**
    - Filters rows where the median position falls within the range of:
        - `(cum_sum - frequency)` (start of current number's range)
        - `cum_sum` (end of current number's range)
    - Takes the average of numbers that satisfy this condition to:
        - Handle even-numbered datasets (returns average of two middle numbers)
        - Return single median value for odd-numbered datasets

### Key Points

- The solution works for both odd and even total frequencies
- Uses window functions to efficiently calculate running totals
- The BETWEEN condition correctly identifies the number(s) that contain the median position
- AVG() handles cases where the median might be between two numbers (even count) or exactly on one number (odd count)

### Example Walkthrough

For the given table:

- Total frequency = 7 + 1 + 3 + 1 = 12
- Middle position = 12/2 = 6
- The number 0 covers positions 1-7 (since its frequency is 7)
- Since 6 falls between (7-7=0) and 7, 0 is selected as the median
- The AVG() of 0 is 0.0000, which matches the expected output