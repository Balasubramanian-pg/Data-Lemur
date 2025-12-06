---
Date: 2025-07-30
Difficulty: Easy
Title: IBM db2 Product Analytics
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Easy/IBM db2 Product Analytics.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Company: ''
Question Link: ''
Category: ''
Sub Category: ''
---
IBM is analyzing how their employees are utilizing the Db2 database by tracking the SQL queries executed by their employees. The objective is to generate data to populate a histogram that shows the number of unique queries run by employees during the third quarter of 2023 (July to September). Additionally, it should count the number of employees who did not run any queries during this period.

Display the number of unique queries as histogram categories, along with the count of employees who executed that number of unique queries.

### `queries` Schema:

|Column Name|Type|Description|
|---|---|---|
|employee_id|integer|The ID of the employee who executed the query.|
|query_id|integer|The unique identifier for each query (Primary Key).|
|query_starttime|datetime|The timestamp when the query started.|
|execution_time|integer|The duration of the query execution in seconds.|

### `queries` Example Input:

Assume that the table below displays all queries made from July 1, 2023 to 31 July, 2023:

|employee_id|query_id|query_starttime|execution_time|
|---|---|---|---|
|226|856987|07/01/2023 01:04:43|2698|
|132|286115|07/01/2023 03:25:12|2705|
|221|33683|07/01/2023 04:34:38|91|
|240|17745|07/01/2023 14:33:47|2093|
|110|413477|07/02/2023 10:55:14|470|

### `employees` Schema:

Assume that the table below displays all employees in the table:

|Column Name|Type|Description|
|---|---|---|
|employee_id|integer|The ID of the employee who executed the query.|
|full_name|string|The full name of the employee.|
|gender|string|The gender of the employee.|

### `employees` Example Input:

|employee_id|full_name|gender|
|---|---|---|
|1|Judas Beardon|Male|
|2|Lainey Franciotti|Female|
|3|Ashbey Strahan|Male|

### Example Output:

|unique_queries|employee_count|
|---|---|
|0|191|
|1|46|
|2|12|
|3|1|

The output indicates that 191 employees did not run any queries, 46 employees ran exactly 1 unique queries, 12 employees ran 2 unique queries, and so on.

To generate the histogram of unique queries run by employees during the third quarter of 2023, you can use the following SQL query:

```sql
WITH query_counts AS (
    SELECT 
        employee_id,
        COUNT(DISTINCT query_id) AS unique_query_count
    FROM queries
    WHERE query_starttime >= '2023-07-01' AND query_starttime < '2023-10-01'
    GROUP BY employee_id
),
employee_counts AS (
    SELECT 
        COALESCE(unique_query_count, 0) AS unique_queries,
        COUNT(employee_id) AS employee_count
    FROM (
        SELECT employee_id FROM employees
    ) AS all_employees
    LEFT JOIN query_counts
    ON all_employees.employee_id = query_counts.employee_id
    GROUP BY COALESCE(unique_query_count, 0)
)
SELECT 
    unique_queries,
    employee_count
FROM employee_counts
ORDER BY unique_queries ASC;
```

This query works as follows:

- **Count unique queries per employee**: The `query_counts` CTE counts the number of unique queries each employee ran during the third quarter of 2023.

- **Count employees per unique query count**: The `employee_counts` CTE joins the `employees` table with the `query_counts` CTE to include employees who did not run any queries. It then groups the employees by their unique query count and counts the number of employees in each group.

- **Output the histogram**: The final query outputs the number of unique queries as histogram categories, along with the count of employees who executed that number of unique queries.

Note that the `COALESCE` function is used to replace `NULL` values with 0, which represents employees who did not run any queries. The `LEFT JOIN` ensures that all employees are included in the count, even if they did not run any queries.