---
Created: 2025-06-28T18:34
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Supercloud Platform
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Supercloud Platform.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
A Microsoft Azure Supercloud customer is defined as a customer who has purchased at least one product from every product category listed in the `products` table.

Write a query that identifies the customer IDs of these Supercloud customers.

### `customer_contracts` Table:

|   |   |
|---|---|
|Column Name|Type|
|customer_id|integer|
|product_id|integer|
|amount|integer|

### `customer_contracts` Example Input:

|   |   |   |
|---|---|---|
|customer_id|product_id|amount|
|1|1|1000|
|1|3|2000|
|1|5|1500|
|2|2|3000|
|2|6|2000|

### `products` Table:

|   |   |
|---|---|
|Column Name|Type|
|product_id|integer|
|product_category|string|
|product_name|string|

### `products` Example Input:

|   |   |   |
|---|---|---|
|product_id|product_category|product_name|
|1|Analytics|Azure Databricks|
|2|Analytics|Azure Stream Analytics|
|4|Containers|Azure Kubernetes Service|
|5|Containers|Azure Service Fabric|
|6|Compute|Virtual Machines|
|7|Compute|Azure Functions|

### Example Output:

customer_id


1


### Explanation:

Customer 1 bought from Analytics, Containers, and Compute categories of Azure, and thus is a Supercloud customer. Customer 2 isn't a Supercloud customer, since they don't buy any container services from Azure.

  

Looking at this problem, I need to identify customers who have purchased at least one product from every product category. This means:

1. Find all distinct product categories
2. For each customer, count how many different categories they've purchased from
3. A Supercloud customer must have purchased from ALL categoriesThis query identifies Supercloud customers by:
4. **First CTE (**`**total_categories**`**)**:
    - Counts the total number of distinct product categories available
    - From the example: Analytics, Containers, Compute = 3 categories
5. **Second CTE (**`**customer_categories**`**)**:
    - Joins `customer_contracts` with `products` to get category information
    - Groups by `customer_id` and counts distinct categories each customer has purchased from
    - Uses `COUNT(DISTINCT p.product_category)` to avoid double-counting if a customer bought multiple products from the same category
6. **Main Query**:
    - Uses `CROSS JOIN` to combine each customer's category count with the total available categories
    - Filters for customers where `categories_purchased = total_count`
    - Only customers who purchased from ALL categories are Supercloud customers

**Tracing through the example**:

- **Customer 1**: Purchased products 1 (Analytics), 3 (Containers), 5 (Containers) → 2 distinct categories (Analytics, Containers)
- **Customer 2**: Purchased products 2 (Analytics), 6 (Compute) → 2 distinct categories (Analytics, Compute)

Wait, let me check the example data again. Looking at the input:

- Customer 1: products 1, 3, 5
- Customer 2: products 2, 6

But product 3 isn't in the products table example. Let me assume there's missing data and that Customer 1 actually purchased from all 3 categories (Analytics, Containers, Compute) while Customer 2 only purchased from 2 categories, which explains why only Customer 1 is a Supercloud customer.

The query logic is correct for identifying customers who have purchased from every available product category.

  

```SQL
WITH total_categories AS (
  SELECT COUNT(DISTINCT product_category) AS total_count
  FROM products
),
customer_categories AS (
  SELECT 
    cc.customer_id,
    COUNT(DISTINCT p.product_category) AS categories_purchased
  FROM customer_contracts cc
  INNER JOIN products p ON cc.product_id = p.product_id
  GROUP BY cc.customer_id
)

SELECT customer_id
FROM customer_categories cc
CROSS JOIN total_categories tc
WHERE cc.categories_purchased = tc.total_count
ORDER BY customer_id;
```