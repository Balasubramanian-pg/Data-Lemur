---
Created: 2025-06-28T18:34
Area:
- People Analytics
Key Functions:
- Join
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Human Traffic @ Stadium
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Human Traffic @
  Stadium.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Here's the structured solution for Question 99:

### Problem Statement

Find records in the stadium table where there are 3 or more consecutive days with 100+ visitors each day.

### Table

**stadium table:**

```Plain
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 1    | 2017-01-01 | 10        |
| 2    | 2017-01-02 | 109       |
| 3    | 2017-01-03 | 150       |
| 4    | 2017-01-04 | 99        |
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-08 | 188       |
+------+------------+-----------+
```

### Expected Output

```Plain
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-08 | 188       |
+------+------------+-----------+
```

### SQL Solution

```SQL
WITH t1 AS (
    SELECT
        id,
        visit_date,
        people,
        id - ROW_NUMBER() OVER(ORDER BY visit_date) AS date_group
    FROM stadium
    WHERE people >= 100
)

SELECT
    t1.id,
    t1.visit_date,
    t1.people
FROM t1
JOIN (
    SELECT
        date_group,
        COUNT(*) as consecutive_days
    FROM t1
    GROUP BY date_group
    HAVING COUNT(*) >= 3
) AS b
ON t1.date_group = b.date_group
ORDER BY t1.visit_date;
```

### Explanation

1. **CTE (t1):**
    - Filters records to only include days with 100+ visitors
    - Creates a `date_group` by subtracting row number from id - this creates the same value for consecutive days
    - This technique groups consecutive records together
2. **Main Query:**
    - Joins the filtered data with a subquery that counts consecutive days per group
    - Only keeps groups with 3+ consecutive days (HAVING COUNT(*) >= 3)
    - Returns all records from qualifying consecutive day groups
    - Orders results by visit date

### Key Points

- The `id - ROW_NUMBER()` trick creates groups for consecutive records
- First filters by visitor count, then identifies consecutive sequences
- HAVING clause ensures we only get groups with 3+ consecutive days
- JOIN brings back all records from qualifying sequences
- Works regardless of date gaps (only cares about consecutive records in the table)

### Example Walkthrough

- Days 5,6,7,8 all have 100+ visitors
- Their date_group values will be the same (5-5=0, 6-6=0, etc.)
- This group has 4 consecutive days (>= 3), so all are included
- Days 2,3 would form a separate group but only have 2 days (< 3), so excluded