---
Created: 2025-06-28T18:34
Area:
- Top-N Analysis
Key Functions:
- DENSE_RANK()
- OFFSET-FETCH
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Second Highest Salary_from_made_1
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Medium/Second Highest Salary_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Imagine you're an HR analyst at a tech company tasked with analyzing employee salaries. Your manager is keen on understanding the pay distribution and asks you to determine the second highest salary among all employees.

It's possible that multiple employees may share the same second highest salary. In case of duplicate, display the salary only once.

### `employee` Schema:

|   |   |   |
|---|---|---|
|column_name|type|description|
|employee_id|integer|The unique ID of the employee.|
|name|string|The name of the employee.|
|salary|integer|The salary of the employee.|
|department_id|integer|The department ID of the employee.|
|manager_id|integer|The manager ID of the employee.|

### `employee` Example Input:

|   |   |   |   |   |
|---|---|---|---|---|
|employee_id|name|salary|department_id|manager_id|
|1|Emma Thompson|3800|1|6|
|2|Daniel Rodriguez|2230|1|7|
|3|Olivia Smith|2000|1|8|

### Example Output:

second_highest_salary

---

2230

---

The output represents the second highest salary among all employees. In this case, the second highest salary is $2,230.

## Solution

Alright, I'm trying to solve this problem where I need to find the second highest salary from an employee table. The table has columns like employee_id, name, salary, department_id, and manager_id.

First, let's understand the problem. We have an employee table with their salaries. We need to find the second highest salary among all employees. If multiple employees have the same salary that happens to be the second highest, we should display that salary only once.

Given the example input:

|   |   |   |   |   |
|---|---|---|---|---|
|employee_id|name|salary|department_id|manager_id|
|1|Emma Thompson|3800|6|2|
|2|Daniel Rodriguez|2230|1|7|
|3|Olivia Smith|2000|1|8|

The salaries are: 3800, 2230, and 2000.

If we sort these in descending order: 3800, 2230, 2000.

The second highest salary here is 2230, which matches the expected output.

Now, how to write a SQL query to achieve this?

### Approach

1. **Extract distinct salaries**: Since multiple employees can have the same salary, we first get distinct salaries to avoid duplicates.
2. **Order salaries in descending order**: To find the second highest, we need the salaries sorted in descending order.
3. **Select the second row**: After sorting, the second row will give us the second highest salary.

But, we need to ensure that there are at least two distinct salaries to have a second highest. If there's only one distinct salary, or no salaries at all, we might need to handle that, but the problem says "display the salary only once," implying that there is at least one salary.

But, if there's only one salary, there is no second highest, so we might return NULL or nothing. But since the problem gives an example with a second highest, we can assume there are at least two distinct salaries in the input.

In SQL, we can use `DISTINCT` to get unique salaries, then order them in descending order, and then select the second row.

Here's how we can do it:

1. Use a subquery to get distinct salaries.
2. Order them in descending order.
3. Use LIMIT and OFFSET to get the second row.

For example:

```SQL
SELECT DISTINCT salary
FROM employee
ORDER BY salary DESC
LIMIT 1 OFFSET 1;
```

This query gets all distinct salaries, orders them from highest to lowest, skips the first row (the highest salary) with OFFSET 1, and then takes the next row (the second highest salary) with LIMIT 1.

But, we need to consider cases where there might not be a second highest salary (e.g., all employees have the same salary, or there's only one employee).

In such cases, the query above would return an empty result set, which is fine because there is no second highest salary.

But, the problem's example has a result, so we can assume that in the given data, there is a second highest salary.

Let's see:

For the given example, the distinct salaries are 3800, 2230, 2000. Ordered descending: 3800, 2230, 2000. The second highest is 2230, which matches the expected output.

Thus, this query seems correct.

But, what if there are only two distinct salaries, and they are the same? For example, if all employees had salary 2000, then there's no second highest distinct salary. But, in that case, the query would return nothing, which is correct since there's no second highest (all are the same).

Similarly, if there's only one employee, or all have the same salary, there's no second highest, and the query would return nothing, which is correct.

Thus, the query seems correct.

But, let's think if there's any other edge case. What if there are multiple employees with the highest salary, and multiple with the second highest?

For example:

- salaries: 3000, 3000 (highest), 2000, 2000 (second highest), 1000  
    Here, the distinct salaries are 3000, 2000, 1000. Ordered descending:  
    3000, 2000, 1000. Second highest is 2000, which is correct.  
    

Thus, the query works correctly even with duplicates.

Therefore, the solution is:

```SQL
SELECT DISTINCT salary
FROM employee
ORDER BY salary DESC
LIMIT 1 OFFSET 1;
```

But, this will return a single-row result set with the second highest salary. If we want to name the column as in the output (second_highest_salary), we can do:

```SQL
SELECT DISTINCT salary AS second_highest_salary
FROM employee
ORDER BY salary DESC
LIMIT 1 OFFSET 1;
```

This should give us the desired output format.

For the given example, it would return:

## second_highest_salary

2230

Which matches the expected output.

But, let's think if there's any other edge case.

What if there are two highest salaries that are the same, and the rest are lower? For example: 3000, 3000, 2000. Then the distinct salaries are 3000, 2000. Ordered descending: 3000, 2000. The second highest is 2000, which is correct (since the two 3000s are the highest, and 2000 is next).

What if there's only one distinct salary? For example: 2000, 2000, 2000. Then distinct salaries is just 2000. Ordered descending is just 2000. OFFSET 1 would skip the first (and only) row, so the query returns nothing, which is correct since there's no second highest salary.

Thus, this query handles all cases correctly.

But, the problem mentions that it's possible that multiple employees share the same second highest salary, and we should display it only once. Our query already handles that because we're using DISTINCT to get unique salaries, and then ordering and picking the second one.

Thus, the final query is:

```SQL
SELECT DISTINCT salary AS second_highest_salary
FROM employee
ORDER BY salary DESC
LIMIT 1 OFFSET 1;
```

But, what if there are fewer than two distinct salaries? For example, if all employees have the same salary, or there's only one employee. In that case, there is no second highest salary, and the query would return no rows, which is correct.

But, if the problem expects us to return NULL or some default value when there's no second highest salary, we'd need to adjust the query. However, the problem's expected output shows a case where the query does return a value, and the problem statement doesn't mention handling cases with no second highest salary, so our query is correct as is.

But, sometimes in such problems, we're expected to return NULL if there's no second highest salary. For example, if the input was:

employee_id | name | salary | department_id | manager_id  
1 | A | 1000 | ... | ...  

Then there's only one salary, so no second highest, and we'd return NULL or nothing.

Our current query would return nothing in that case, which might be acceptable, but sometimes problems expect us to return NULL explicitly.

To handle that, we can use a more general approach with subqueries and LIMIT/OFFSET, but since the problem's example has a valid answer, and our query works for that, we can proceed with it.

But, to make it robust, we can wrap it in a query that returns NULL if there's no second highest salary. Here's how:

```SQL
SELECT
    (SELECT DISTINCT salary
     FROM employee
     ORDER BY salary DESC
     LIMIT 1 OFFSET 1) AS second_highest_salary;
```

But, if there's no second highest salary, the subquery returns no rows, and the outer query returns NULL for second_highest_salary, which is what we want in that case.

Let me test this with an example where all salaries are the same:

Suppose the employee table has:

employee_id | name | salary | department_id | manager_id  
1 | A | 1000 | ... | ...  
2 | B | 1000 | ... | ...  

Distinct salaries: 1000

Ordered descending: 1000

The subquery with OFFSET 1 would return no rows, so the outer query would return NULL, which is correct since there's no second highest salary.

Thus, this query is more robust.

Therefore, the final query is:

```SQL
SELECT
    (SELECT DISTINCT salary
     FROM employee
     ORDER BY salary DESC
     LIMIT 1 OFFSET 1) AS second_highest_salary;
```

For the given example input, it would return 2230 as expected.

But, let's see if we can write it without a subquery, using a self-join or something similar.

Alternative approach:

We can use a self-join to find salaries that are less than the maximum salary and are themselves the maximum in that subset.

But, a simpler way is to get all distinct salaries, order them descending, and then pick the second one if it exists.

Our initial query does that with LIMIT and OFFSET, which is efficient and concise.

Thus, the final answer is the query above.

But, let me think if there's another way to write this without LIMIT/OFFSET, which might not be supported in all SQL dialects.

Alternative using subqueries:

The second highest salary is the maximum salary that is less than the maximum salary.

But, if all salaries are the same, there is no second highest, and we'd want to return NULL.

Here's how we can write that:

```SQL
SELECT MAX(salary) AS second_highest_salary
FROM employee
WHERE salary < (SELECT MAX(salary) FROM employee);
```

This works if there is a salary less than the maximum. If all salaries are the same, then the subquery MAX(salary) equals all salaries, so the WHERE condition is false for all rows, and MAX(salary) returns NULL (since no rows satisfy the condition).

But, what if there are multiple employees with the maximum salary? For example, salaries 3000, 3000, 2000. The maximum is 3000, and the second highest is 2000.

The query would be:

SELECT MAX(salary) AS second_highest_salary  
FROM employee  
WHERE salary < (SELECT MAX(salary) FROM employee);  

Here, the subquery returns 3000, so the WHERE condition is salary < 3000, so we're looking at salaries 2000, and the MAX of that is 2000, which is correct.

If all salaries are equal to some value, say 1000, then the subquery returns 1000, and the WHERE condition is salary < 1000, which is false for all rows, so MAX(salary) returns NULL (since there are no qualifying rows), which is correct since there's no second highest salary.

Thus, this query is also correct and works in SQL dialects that don't support LIMIT/OFFSET (like some older versions of SQL Server).

But, our initial query with LIMIT/OFFSET is more straightforward and works in PostgreSQL, MySQL, SQLite, etc., so we can use that unless there are specific constraints.

Given that both approaches work, and the first one is more concise, we can stick with that.

Thus, the final query is:

```SQL
SELECT
    (SELECT DISTINCT salary
     FROM employee
     ORDER BY salary DESC
     LIMIT 1 OFFSET 1) AS second_highest_salary;
```

But, to match the exact expected output format (with the column name as given), and to handle the case where there's no second highest salary by returning NULL, this query is appropriate.

Therefore, the final answer is:

```SQL
SELECT
    (SELECT DISTINCT salary
     FROM employee
     ORDER BY salary DESC
     LIMIT 1 OFFSET 1) AS second_highest_salary;
```

But, looking back at the problem statement, it says that if there are duplicates for the second highest salary, we should display it only once. Our query already handles this because we're using DISTINCT to get unique salaries before ordering and picking the second one.

Thus, this query is correct.

But, let me think if there's any other edge case. Suppose the salaries are: 3000, 2000, 2000, 1000. The distinct salaries are 3000, 2000, 1000. Ordered descending: 3000, 2000, 1000. The second highest is 2000, and since there's only one distinct second highest salary (even if multiple employees have it), we display it once, which our query does (since we took distinct salaries first).

Thus, the query is correct.

But, in some SQL dialects, LIMIT/OFFSET might not be supported. For those, we can use the alternative approach with MAX and subquery as shown earlier.

For completeness, here's the query using the alternative approach:

```SQL
SELECT MAX(salary) AS second_highest_salary
FROM employee
WHERE salary < (SELECT MAX(salary) FROM employee);
```

Both queries should give the same result for valid inputs, with NULL returned when there's no second highest salary.

Given that, and since the problem expects a single value output (as in the example), either query would work, but the first one with LIMIT/OFFSET is more general as it doesn't assume anything about the distribution of salaries (e.g., that the second highest is strictly less than the max; consider case with salaries 3000, 3000, 2000: the second highest is 2000, which is less than the max 3000, so the alternative query works. But if the salaries were 3000, 3000, 3000, then there's no second highest, and both queries correctly return NULL).

Thus, the first query is more straightforward and works in most modern SQL dialects.

Therefore, the final answer is:

```SQL
SELECT
    (SELECT DISTINCT salary
     FROM employee
     ORDER BY salary DESC
     LIMIT 1 OFFSET 1) AS second_highest_salary;
```

But, to ensure compatibility with SQL dialects that don't support LIMIT/OFFSET (like older SQL Server versions), we can use the alternative approach:

```SQL
SELECT MAX(salary) AS second_highest_salary
FROM employee
WHERE salary < (SELECT MAX(salary) FROM employee);
```

Given that both work, and the first one is more general (works for cases where there might be gaps in salary values, though in this scenario both are equivalent), we can use the first one if LIMIT/OFFSET is supported, or the second one otherwise.

Since the problem doesn't specify the SQL dialect, and LIMIT/OFFSET is commonly supported, we'll use the first approach.

Thus, the final query is:

```SQL
SELECT
    (SELECT DISTINCT salary
     FROM employee
     ORDER BY salary DESC
     LIMIT 1 OFFSET 1) AS second_highest_salary;
```

But, to match the exact expected output format in the problem (with the column name as given), and to handle cases where there's no second highest salary by returning nothing (which is fine, since the problem doesn't specify handling NULL explicitly), the first query is sufficient.

However, to explicitly handle the case where there's no second highest salary by returning NULL, the first query already does that (if no second highest, the subquery returns no rows, and the outer query returns NULL for the column).

Thus, the final query is:

```SQL
SELECT
    (SELECT DISTINCT salary
     FROM employee
     ORDER BY salary DESC
     LIMIT 1 OFFSET 1) AS second_highest_salary;
```

But, looking back at the problem's example output, it's just a single value (2230), with the column name second_highest_salary, which matches our query's output format.

Therefore, the correct query is:

```SQL
SELECT
    (SELECT DISTINCT salary
     FROM employee
     ORDER BY salary DESC
     LIMIT 1 OFFSET 1) AS second_highest_salary;
```

But, to ensure that if there's no second highest salary, we return NULL (rather than an empty result set), we can wrap it in a query that returns NULL if the subquery returns no rows.

In most SQL dialects, if the subquery returns no rows, the outer query would return NULL for that column, which is what we want.

For example, in PostgreSQL, MySQL, SQLite, if the subquery returns no rows, the outer query will have NULL in that column.

Let me test this in a hypothetical scenario where all employees have the same salary, say 1000.

Then, DISTINCT salaries is just 1000. Ordered descending is just 1000. LIMIT 1 OFFSET 1 would skip the first (and only) row, so the subquery returns no rows, and the outer query returns NULL for second_highest_salary, which is correct since there's no second highest salary.

Thus, the query is correct.

But, if the SQL dialect doesn't implicitly return NULL in this case (though most do), we might need to adjust. But in most cases, the query as written will work correctly.

Therefore, the final answer is:

```SQL
SELECT
    (SELECT DISTINCT salary
     FROM employee
     ORDER BY salary DESC
     LIMIT 1 OFFSET 1) AS second_highest_salary;
```

But, for completeness, here's a version that explicitly handles the case where there's no second highest salary by returning NULL, which might be clearer in intent:

```SQL
SELECT MAX(salary) AS second_highest_salary
FROM employee
WHERE salary < (SELECT MAX(salary) FROM employee);
```

But, this version would return NULL if there's no salary less than the maximum (i.e., all salaries are the same), which is correct.

Both queries are correct, but the first one with LIMIT/OFFSET is more general and works even if there are gaps in salary values (though in this scenario both are equivalent).

Given that, and since LIMIT/OFFSET is widely supported, we'll proceed with the first query.

However, the second query is also correct and might be more compatible with certain SQL dialects that don't support LIMIT/OFFSET.

Given that the problem's expected output is a single value, and both queries would produce that for the given example, either is acceptable. We'll use the first one for its generality.

But, looking at common SQL interview problem solutions, the approach with MAX and subquery is more frequently seen for this type of problem (second highest salary), likely due to broader compatibility.

Thus, the most robust and widely compatible query is:

```SQL
SELECT MAX(salary) AS second_highest_salary
FROM employee
WHERE salary < (SELECT MAX(salary) FROM employee);
```

This query:

1. Finds the maximum salary in a subquery.
2. Finds the maximum salary that is strictly less than the maximum salary from the subquery.
3. If all salaries are the same, the WHERE condition filters out all  
    rows, so MAX(salary) returns NULL, which is correct since there's no  
    second highest salary.  
    

This matches all edge cases and is compatible with most SQL dialects.

Therefore, the final answer is:

```SQL
SELECT MAX(salary) AS second_highest_salary
FROM employee
WHERE salary < (SELECT MAX(salary) FROM employee);
```

But, let me think if there's any case where this fails.

What if the salaries are 3000, 3000, 2000? The max salary is 3000. The WHERE condition is salary < 3000, so we consider 2000, and MAX of that is 2000, which is correct.

What if salaries are 3000, 2000, 2000? The max is 3000, so we consider 2000 and 2000, and MAX is 2000, which is correct.

What if salaries are 3000, 3000, 2000, 2000? Same as above, correct.

What if all salaries are 3000? Then WHERE salary < 3000 is false for all rows, so MAX returns NULL, which is correct.

Thus, this query is correct and robust.

Therefore, the final SQL query to solve the problem is:

```SQL
SELECT MAX(salary) AS second_highest_salary
FROM employee
WHERE salary < (SELECT MAX(salary) FROM employee);
```

This will return the second highest distinct salary, or NULL if there is no second highest salary (i.e., all salaries are the same).