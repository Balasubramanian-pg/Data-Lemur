---
Created: 2025-06-28T18:34
Area:
- School
Key Functions:
- CTE
- MIN/MAX
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Quiet Students
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Quiet Students.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Here's the structured solution for Question 106:

### Problem Statement

Find students who never scored either the highest or lowest score in any exam they took (called "quiet" students). Exclude students who never took any exams.

### Tables

**Student table:**

```Plain
+-------------+---------------+
| student_id  | student_name  |
+-------------+---------------+
| 1           | Daniel        |
| 2           | Jade          |
| 3           | Stella        |
| 4           | Jonathan      |
| 5           | Will          |
+-------------+---------------+
```

**Exam table:**

```Plain
+------------+--------------+-----------+
| exam_id    | student_id   | score     |
+------------+--------------+-----------+
| 10         | 1            | 70        |
| 10         | 2            | 80        |
| 10         | 3            | 90        |
| 20         | 1            | 80        |
| 30         | 1            | 70        |
| 30         | 3            | 80        |
| 30         | 4            | 90        |
| 40         | 1            | 60        |
| 40         | 2            | 70        |
| 40         | 4            | 80        |
+------------+--------------+-----------+
```

### Expected Output

```Plain
+-------------+---------------+
| student_id  | student_name  |
+-------------+---------------+
| 2           | Jade          |
+-------------+---------------+
```

### SQL Solution

```SQL
WITH t1 AS (
    SELECT student_id
    FROM (
        SELECT *,
               MIN(score) OVER(PARTITION BY exam_id) AS least,
               MAX(score) OVER(PARTITION BY exam_id) AS most
        FROM exam
    ) a
    WHERE least = score OR most = score
)

SELECT DISTINCT student_id, student_name
FROM exam
JOIN student USING (student_id)
WHERE student_id != ALL(SELECT student_id FROM t1)
ORDER BY student_id;
```

### Explanation

1. **CTE (t1):**
    - Identifies students who scored either the minimum or maximum in any exam
    - Uses window functions to find min/max scores per exam
    - Filters to keep only rows where the student's score equals the min or max
2. **Main Query:**
    - Joins the Exam and Student tables
    - Excludes students found in t1 (those who were min/max scorers in any exam)
    - Ensures we only include students who took at least one exam (via the JOIN)
    - Orders results by student_id

### Key Points

- Uses `!= ALL()` to exclude students who were ever min/max scorers
- The JOIN implicitly filters out students who never took exams
- Window functions efficiently calculate min/max per exam
- DISTINCT ensures each quiet student appears only once in results

### Example Walkthrough

- Student 1: Scored min or max in all exams (not quiet)
- Student 2: Never scored min or max in any exam (quiet)
- Student 3: Scored max in exam 10 (not quiet)
- Student 4: Scored max in exams 30 and 40 (not quiet)
- Student 5: Never took any exam (excluded)
- Result correctly identifies only Student 2 (Jade) as quiet