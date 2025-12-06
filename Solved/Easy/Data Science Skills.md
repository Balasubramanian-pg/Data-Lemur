---
Date: 2025-07-30
Difficulty: Easy
Company:
- Google
Title: Data Science Skills
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Easy/Data Science Skills.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Question Link: ''
Category: ''
Sub Category: ''
---
Given a table of candidates and their skills, you're tasked with finding the candidates best suited for an open Data Science job. You want to find candidates who are proficient in Python, Tableau, and PostgreSQL.

Write a query to list the candidates who possess all of the required skills for the job. Sort the output by candidate ID in ascending order.

**Assumption:**

- There are no duplicates in the `candidates` table.

### `candidates` Table:

|**Column Name**|**Type**|
|---|---|
|candidate_id|integer|
|skill|varchar|

### `candidates` Example Input:

|**candidate_id**|**skill**|
|---|---|
|123|Python|
|123|Tableau|
|123|PostgreSQL|
|234|R|
|234|PowerBI|
|234|SQL Server|
|345|Python|
|345|Tableau|

### Example Output:

|**candidate_id**|
|---|
|123|

### Explanation

Candidate 123 is displayed because they have Python, Tableau, and PostgreSQL skills. 345 isn't included in the output because they're missing one of the required skills: PostgreSQL.

To find the candidates with all the required skills, you can use a SQL query with a GROUP BY and HAVING clause. Here's how you can do it:

```SQL
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(DISTINCT skill) = 3
ORDER BY candidate_id ASC;
```

This query works as follows:

- **Filter the skills**: The WHERE clause filters the table to only include rows where the skill is one of the required skills.

- **Group by candidate**: The GROUP BY clause groups the filtered rows by candidate_id.

- **Count distinct skills**: The COUNT(DISTINCT skill) function counts the number of distinct skills each candidate has. The HAVING clause ensures that only candidates with all 3 required skills are included.

- **Sort the output**: The ORDER BY clause sorts the output by candidate_id in ascending order.

When you run this query on the provided example input, it will return candidate_id 123, which is the only candidate with all the required skills.