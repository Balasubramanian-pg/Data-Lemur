---
Date: 2025-07-30
Difficulty: Easy
Title: Well Paid Employees
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Easy/Well Paid Employees.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Company: ''
Question Link: ''
Category: ''
Sub Category: ''
---
Companies often perform salary analyses to ensure fair compensation practices. One useful analysis is to check if there are any employees earning more than their direct managers.

As a HR Analyst, you're asked to identify all employees who earn more than their direct managers. The result should include the employee's ID and name.

### `employee` Schema:

|column_name|type|description|
|---|---|---|
|employee_id|integer|The unique ID of the employee.|
|name|string|The name of the employee.|
|salary|integer|The salary of the employee.|
|department_id|integer|The department ID of the employee.|
|manager_id|integer|The manager ID of the employee.|

### `employee` Example Input:

|employee_id|name|salary|department_id|manager_id|
|---|---|---|---|---|
|1|Emma Thompson|3800|1|6|
|2|Daniel Rodriguez|2230|1|7|
|3|Olivia Smith|7000|1|8|
|4|Noah Johnson|6800|2|9|
|5|Sophia Martinez|1750|1|11|
|6|Liam Brown|13000|3|NULL|
|7|Ava Garcia|12500|3|NULL|
|8|William Davis|6800|2|NULL|

### Example Output:

|employee_id|employee_name|
|---|---|
|3|Olivia Smith|

The output shows that Olivia Smith earns $7,000, surpassing her manager, William David who earns $6,800.

To solve this problem, we can use a SQL query that joins the `employee` table to itself, comparing the salary of each employee to their manager's salary.

SQL Query

SQL

```
SELECT e1.employee_id, e1.name AS employee_name
FROM employee e1
JOIN employee e2 ON e1.manager_id = e2.employee_id
WHERE e1.salary > e2.salary;
```

How It Works

- We join the `employee` table to itself using the `manager_id` column in the first instance (`e1`) and the `employee_id` column in the second instance (`e2`). This allows us to compare each employee's salary to their manager's salary.

- We use the `WHERE` clause to filter the results and only include employees who earn more than their managers.

Example Use Case

Using the provided example input, the query would return the following result:

|employee_id|employee_name|
|---|---|
|3|Olivia Smith|

This result shows that Olivia Smith (employee_id = 3) earns $7,000, which is more than her manager, William Davis (employee_id = 8), who earns $6,800.

Let's consider another example.

Suppose we have another employee, Ethan White, with an employee_id of 10, who earns $8000 and reports to Liam Brown (employee_id = 6), who earns $13000. In this case, Ethan would not be included in the output because he earns less than his manager.

However, if we add another employee, let's say Alexander Lee with employee_id = 11, who earns $14000 and reports to Liam Brown (employee_id = 6), who earns $13000. Then Alexander would be included in the output.

The updated employee table would look like this:

|employee_id|name|salary|department_id|manager_id|
|---|---|---|---|---|
|1|Emma Thompson|3800|1|6|
|2|Daniel Rodriguez|2230|1|7|
|3|Olivia Smith|7000|1|8|
|4|Noah Johnson|6800|2|9|
|5|Sophia Martinez|1750|1|11|
|6|Liam Brown|13000|3|NULL|
|7|Ava Garcia|12500|3|NULL|
|8|William Davis|6800|2|NULL|
|9|Michael Davis|5000|2|NULL|
|10|Ethan White|8000|3|6|
|11|Alexander Lee|14000|3|6|

The SQL query remains the same:

SQL

```
SELECT e1.employee_id, e1.name AS employee_name
FROM employee e1
JOIN employee e2 ON e1.manager_id = e2.employee_id
WHERE e1.salary > e2.salary;
```

The output would be:

|employee_id|employee_name|
|---|---|
|3|Olivia Smith|
|11|Alexander Lee|

This shows that both Olivia Smith and Alexander Lee earn more than their respective managers.

Alternative Method Using Subqueries

Another way to solve this problem is by using subqueries. Here's an example SQL query:

SQL

```
SELECT employee_id, name AS employee_name
FROM employee
WHERE manager_id IN (SELECT employee_id FROM employee)
AND salary > (SELECT salary FROM employee WHERE employee_id = manager_id);
```

However, the above query is not efficient and might not work in all SQL dialects due to the correlated subquery in the `WHERE` clause.

A more efficient approach would be to use a subquery to get the manager's salary and then compare it with the employee's salary:

SQL

```
SELECT e1.employee_id, e1.name AS employee_name
FROM employee e1
WHERE e1.manager_id IS NOT NULL
AND e1.salary > (SELECT e2.salary FROM employee e2 WHERE e2.employee_id = e1.manager_id);
```

How It Works

- We select the `employee_id` and `name` from the `employee` table.

- We filter the results to only include employees who have a `manager_id` (i.e., they are not top-level managers).

- We use a subquery to get the salary of each employee's manager.

- We compare the employee's salary to their manager's salary and only include employees who earn more than their managers.

This query will produce the same results as the original join-based query. However, it might be less efficient for large datasets due to the subquery.