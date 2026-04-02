---
Created: 2025-06-28T18:34
Area:
- Statistical Aggregation
Key Functions:
- HAVING
- Subquery
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Patient Support Analysis (Part 1)
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Patient Support
  Analysis (Part 1).md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
UnitedHealth Group (UHG) has a program called Advocate4Me, which allows policy holders (or, members) to call an advocate and receive support for their health care needs – whether that's claims and benefits support, drug coverage, pre- and post-authorisation, medical records, emergency assistance, or member portal services.

Write a query to find how many UHG policy holders made three, or more calls, assuming each call is identified by the `case_id` column.

If you like this question, try out [Patient Support Analysis (Part 2)](https://datalemur.com/questions/uncategorized-calls-percentage)!

### `callers` Table:

|   |   |
|---|---|
|**Column Name**|**Type**|
|policy_holder_id|integer|
|case_id|varchar|
|call_category|varchar|
|call_date|timestamp|
|call_duration_secs|integer|

### `callers` Example Input:

|   |   |   |   |   |
|---|---|---|---|---|
|policy_holder_id|case_id|call_category|call_date|call_duration_secs|
|1|f1d012f9-9d02-4966-a968-bf6c5bc9a9fe|emergency assistance|2023-04-13T19:16:53Z|144|
|1|41ce8fb6-1ddd-4f50-ac31-07bfcce6aaab|authorisation|2023-05-25T09:09:30Z|815|
|2|9b1af84b-eedb-4c21-9730-6f099cc2cc5e|claims assistance|2023-01-26T01:21:27Z|992|
|2|8471a3d4-6fc7-4bb2-9fc7-4583e3638a9e|emergency assistance|2023-03-09T10:58:54Z|128|
|2|38208fae-bad0-49bf-99aa-7842ba2e37bc|benefits|2023-06-05T07:35:43Z|619|

### Example Output:

**policy_holder_count**


1


### Explanation:

The only caller who made three, or more calls is policy holder ID 2.


### Approach

1. **Identify Unique Calls**: Since each call is identified by the `case_id` column, we need to count the number of distinct `case_id` values for each policy holder. This ensures that duplicate entries for the same call (if any) are not counted multiple times.
2. **Filter Policy Holders with Three or More Calls**: We then need to find out how many policy holders have three or more distinct calls. This involves grouping the data by `policy_holder_id` and then filtering those groups that have three or more distinct `case_id` values.
3. **Count the Resulting Policy Holders**: Finally, we count the number of policy holders that meet the criteria of having three or more distinct calls.

### Solution Code

```SQL
SELECT COUNT(*) AS policy_holder_count
FROM (
    SELECT policy_holder_id
    FROM callers
    GROUP BY policy_holder_id
    HAVING COUNT(DISTINCT case_id) >= 3
) AS frequent_callers;
```

### Explanation

1. **Subquery (**`**frequent_callers**`**)**:
    - The inner query groups the data by `policy_holder_id`.
    - For each group, it counts the number of distinct `case_id` values, which represents the number of unique calls made by each policy holder.
    - The `HAVING` clause filters out groups (policy holders) that have fewer than three distinct calls.
2. **Main Query**:
    - The outer query counts the number of policy holders that remain after the filtering in the subquery, which gives the total number of policy holders who made three or more unique calls.

This approach efficiently identifies policy holders who meet the criteria by leveraging grouping and counting distinct values, ensuring accurate and meaningful results.