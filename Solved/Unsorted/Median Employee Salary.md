---
Created: 2025-06-28T18:34
Area:
- Statistical Aggregation
Key Functions:
- NTILE()
- PERCENTILE_CONT()
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Median Employee Salary
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Median Employee
  Salary.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Here's the structured solution for Question 105:

### Problem Statement

Find the median salary for each company in the Employee table. The median is the middle value when salaries are ordered, or the average of two middle values for even counts.

### Table

**Employee table:**

```Plain
+-----+------------+--------+
| Id  | Company    | Salary |
+-----+------------+--------+
| 1   | A          | 2341   |
| 2   | A          | 341    |
| 3   | A          | 15     |
| 4   | A          | 15314  |
| 5   | A          | 451    |
| 6   | A          | 513    |
| 7   | B          | 15     |
| 8   | B          | 13     |
| 9   | B          | 1154   |
| 10  | B          | 1345   |
| 11  | B          | 1221   |
| 12  | B          | 234    |
| 13  | C          | 2345   |
| 14  | C          | 2645   |
| 15  | C          | 2645   |
| 16  | C          | 2652   |
| 17  | C          | 65     |
+-----+------------+--------+
```

### Expected Output

```Plain
+-----+------------+--------+
| Id  | Company    | Salary |
+-----+------------+--------+
| 5   | A          | 451    |
| 6   | A          | 513    |
| 12  | B          | 234    |
| 9   | B          | 1154   |
| 14  | C          | 2645   |
+-----+------------+--------+
```

### SQL Solution

```SQL
WITH ranked_employees AS (
    SELECT
        Id,
        Company,
        Salary,
        ROW_NUMBER() OVER(PARTITION BY Company ORDER BY Salary) AS salary_rank,
        COUNT(*) OVER(PARTITION BY Company) AS employee_count
    FROM Employee
)

SELECT
    Id,
    Company,
    Salary
FROM ranked_employees
WHERE salary_rank BETWEEN employee_count/2.0 AND employee_count/2.0 + 1
ORDER BY Company, Salary;
```

### Explanation

1. **CTE (ranked_employees):**
    - Assigns a rank to each employee's salary within their company
    - Calculates the total number of employees per company
    - Uses window functions to avoid modifying the original table
2. **Main Query:**
    - Filters to only include rows where the salary rank falls in the median position(s)
    - For odd counts: Returns the single middle row
    - For even counts: Returns the two middle rows (which will be averaged in application)
    - Orders results by company and salary for clarity

### Key Points

- Handles both odd and even employee counts correctly
- Uses window functions for efficient calculation without temporary tables
- The BETWEEN condition captures either one or two median values
- Works for any number of companies and employees
- Preserves original IDs for reference in the output

### Median Calculation Logic

- For Company A (6 employees): Returns ranks 3 and 4 (positions 6/2=3 and 6/2+1=4)
- For Company B (6 employees): Returns ranks 3 and 4
- For Company C (5 employees): Returns rank 3 (position (5+1)/2=3)

Note: The actual median would be the average of the two middle values for even counts, but this query returns both values which can be averaged in application code if needed.