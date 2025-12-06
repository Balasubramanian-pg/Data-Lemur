---
Created: 2025-06-28T18:34
Area:
- Sports
Key Functions:
- CTE
- ROW_NUMBER()
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Game Play Analysis 5
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Game Play Analysis
  5.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
### Problem Statement

Calculate for each installation date:

1. The number of players who installed the game on that date
2. The day 1 retention rate (percentage who logged in the next day)

### Table

**Activity table:**

```Plain
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-01 | 0            |
| 3         | 4         | 2016-07-03 | 5            |
+-----------+-----------+------------+--------------+
```

### Expected Output

```Plain
+------------+----------+----------------+
| install_dt | installs | Day1_retention |
+------------+----------+----------------+
| 2016-03-01 | 2        | 0.50           |
| 2017-06-25 | 1        | 0.00           |
+------------+----------+----------------+
```

### SQL Solution

```SQL
WITH t1 AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date) AS rnk,
           MIN(event_date) OVER(PARTITION BY player_id) AS install_dt,
           LEAD(event_date, 1) OVER(PARTITION BY player_id ORDER BY event_date) AS nxt
    FROM Activity
)

SELECT DISTINCT install_dt,
       COUNT(DISTINCT player_id) AS installs,
       ROUND(SUM(CASE WHEN nxt = event_date + 1 THEN 1 ELSE 0 END) /
             COUNT(DISTINCT player_id), 2) AS Day1_retention
FROM t1
WHERE rnk = 1
GROUP BY install_dt
ORDER BY install_dt;
```

### Explanation

1. **CTE (t1):**
    - Identifies each player's first login (install date) using `MIN()` window function
    - Uses `ROW_NUMBER()` to mark each player's login sequence
    - Uses `LEAD()` to find each player's next login date
2. **Main Query:**
    - Filters to only include each player's first login (`rnk = 1`)
    - Counts distinct players per install date for "installs"
    - Calculates retention by:
        - Checking if next login was exactly 1 day after install
        - Dividing retained players by total installs
        - Rounding to 2 decimal places
    - Orders results chronologically by install date

### Key Points

- Window functions efficiently track player sequences without self-joins
- `LEAD()` helps identify if a player returned the next day
- The CASE statement counts retained players (1 if returned, 0 otherwise)
- Division and rounding calculate the retention percentage
- DISTINCT ensures clean output with one row per install date

### Example Walkthrough

- **2016-03-01:**
    - Installs: Players 1 and 3 (total 2)
    - Retention: Only Player 1 returned next day (1/2 = 0.50)
- **2017-06-25:**
    - Installs: Player 2 (total 1)
    - Retention: Didn't return next day (0/1 = 0.00)
- Player 3's later login doesn't affect their retention calculation