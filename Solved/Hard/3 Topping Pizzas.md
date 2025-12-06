---
Date: 2025-07-30
Difficulty: Hard
Title: 3 Topping Pizzas
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Hard/3 Topping Pizzas.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Company: ''
Question Link: ''
Category: ''
Sub Category: ''
---

You’re a consultant for a major pizza chain that will be running a promotion where all 3-topping pizzas will be sold for a fixed price, and are trying to understand the costs involved.

Given a list of pizza toppings, consider all the possible 3-topping pizzas, and print out the total cost of those 3 toppings. Sort the results with the highest total cost on the top followed by pizza toppings in ascending order.

Break ties by listing the ingredients in alphabetical order, starting from the first ingredient, followed by the second and third.

_P.S. Be careful with the spacing (or lack of) between each ingredient. Refer to our Example Output._

**Notes:**

- Do not display pizzas where a topping is repeated. For example, ‘Pepperoni,Pepperoni,Onion Pizza’.
- Ingredients must be listed in alphabetical order. For example, 'Chicken,Onions,Sausage'. 'Onion,Sausage,Chicken' is not acceptable.

### `pizza_toppings` Table:

|**Column Name**|**Type**|
|---|---|
|topping_name|varchar(255)|
|ingredient_cost|decimal(10,2)|

### `pizza_toppings` Example Input:

|**topping_name**|**ingredient_cost**|
|---|---|
|Pepperoni|0.50|
|Sausage|0.70|
|Chicken|0.55|
|Extra Cheese|0.40|

### Example Output:

|**pizza**|**total_cost**|
|---|---|
|Chicken,Pepperoni,Sausage|1.75|
|Chicken,Extra Cheese,Sausage|1.65|
|Extra Cheese,Pepperoni,Sausage|1.60|
|Chicken,Extra Cheese,Pepperoni|1.45|

### Explanation

There are four different combinations of the three toppings. Cost of the pizza with toppings Chicken, Pepperoni and Sausage is $0.55 + $0.50 + $0.70 = $1.75.

Additionally, they are arranged alphabetically; in the dictionary, the chicken comes before pepperoni and pepperoni comes before sausage.

The dataset you are querying against may have different input & output - **this is just an example**!

## Solution
---
To solve this problem, we need to generate all possible combinations of 3 distinct pizza toppings, calculate their total cost, and then sort the results based on the total cost in descending order. If there are ties in the total cost, we sort the toppings in alphabetical order.

Here's a SQL query that accomplishes this:

```sql
WITH combinations AS (
    SELECT
        t1.topping_name AS topping1,
        t2.topping_name AS topping2,
        t3.topping_name AS topping3,
        t1.ingredient_cost + t2.ingredient_cost + t3.ingredient_cost AS total_cost
    FROM
        pizza_toppings t1
    CROSS JOIN
        pizza_toppings t2
    CROSS JOIN
        pizza_toppings t3
    WHERE
        t1.topping_name < t2.topping_name AND
        t2.topping_name < t3.topping_name
)
SELECT
    CONCAT(topping1, ',', topping2, ',', topping3) AS pizza,
    total_cost
FROM
    combinations
ORDER BY
    total_cost DESC,
    topping1 ASC,
    topping2 ASC,
    topping3 ASC;
```

### Explanation:

1. **Combinations CTE**:
    
    - We use a self-cross join to generate all possible combinations of three distinct toppings.
    - The `WHERE` clause ensures that we only consider combinations where the toppings are in alphabetical order and distinct (i.e., `t1.topping_name < t2.topping_name < t3.topping_name`).
2. **Main Query**:
    
    - We concatenate the three topping names into a single string to form the pizza name.
    - We calculate the total cost of each pizza by summing the ingredient costs.
    - We order the results by `total_cost` in descending order to have the most expensive pizzas first.
    - We further sort by `topping1`, `topping2`, and `topping3` in ascending order to ensure alphabetical order in case of ties in total cost.

This query will give you the desired output as specified in the problem statement.

Certainly! Another way to approach this problem in SQL is to use a recursive Common Table Expression (CTE) to generate combinations of toppings. This method is a bit more complex but demonstrates another way to handle combinations in SQL.

Here's how you can do it:

 ```sql
 WITH RECURSIVE topping_combinations AS (
    -- Base case: single topping
    SELECT
        topping_name,
        ingredient_cost,
        1 AS level,
        topping_name AS combination,
        CAST(topping_name AS VARCHAR(255)) AS sorted_combination,
        ingredient_cost AS total_cost
    FROM
        pizza_toppings

    UNION ALL

    -- Recursive case: combine with additional toppings
    SELECT
        tc.topping_name || ',' || pt.topping_name,
        tc.ingredient_cost + pt.ingredient_cost,
        tc.level + 1,
        CASE
            WHEN tc.topping_name < pt.topping_name THEN tc.combination || ',' || pt.topping_name
            ELSE tc.combination
        END,
        CASE
            WHEN tc.topping_name < pt.topping_name THEN tc.sorted_combination || ',' || pt.topping_name
            ELSE tc.sorted_combination
        END,
        tc.total_cost + pt.ingredient_cost
    FROM
        topping_combinations tc
    JOIN
        pizza_toppings pt
    ON
        pt.topping_name > RIGHT(tc.topping_name, LENGTH(tc.topping_name) - LENGTH(REPLACE(tc.topping_name, ',', '')))
    WHERE
        tc.level < 3
)
SELECT
    sorted_combination AS pizza,
    total_cost
FROM
    topping_combinations
WHERE
    level = 3
ORDER BY
    total_cost DESC,
    sorted_combination ASC;

```

### Explanation:

1. **Base Case**:
    
    - We start with each individual topping as a base case for our recursive CTE. Each topping is its own combination with a `level` of 1.
2. **Recursive Case**:
    
    - We join the current combinations with additional toppings that come after the last topping in the current combination (to ensure alphabetical order).
    - We concatenate the new topping to the combination and update the total cost.
    - We use the `level` to control the recursion depth, ensuring we only generate combinations of up to 3 toppings.
3. **Main Query**:
    
    - We select only those combinations where the `level` is 3, meaning we have combinations of exactly three toppings.
    - We order the results by `total_cost` in descending order and by `sorted_combination` in ascending order to ensure the output is as required.

This recursive approach is more complex and may not be as efficient as the cross join method for this specific problem, but it demonstrates how recursive CTEs can be used to generate combinations in SQL.