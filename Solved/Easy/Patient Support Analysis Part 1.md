---
Date: 2025-07-30
Difficulty: Easy
Title: Patient Support Analysis Part 1
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Easy/Patient Support Analysis
  Part 1.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Company: ''
Question Link: ''
Category: ''
Sub Category: ''
---
UnitedHealth Group (UHG) has a program called Advocate4Me, which allows policy holders (or, members) to call an advocate and receive support for their health care needs – whether that's claims and benefits support, drug coverage, pre- and post-authorisation, medical records, emergency assistance, or member portal services.

Write a query to find how many UHG policy holders made three, or more calls, assuming each call is identified by the `case_id` column.

If you like this question, try out [Patient Support Analysis (Part 2)](https://datalemur.com/questions/uncategorized-calls-percentage)!

### `callers` Table:

|**Column Name**|**Type**|
|---|---|
|policy_holder_id|integer|
|case_id|varchar|
|call_category|varchar|
|call_date|timestamp|
|call_duration_secs|integer|

### `callers` Example Input:

|policy_holder_id|case_id|call_category|call_date|call_duration_secs|
|---|---|---|---|---|
|1|f1d012f9-9d02-4966-a968-bf6c5bc9a9fe|emergency assistance|2023-04-13T19:16:53Z|144|
|1|41ce8fb6-1ddd-4f50-ac31-07bfcce6aaab|authorisation|2023-05-25T09:09:30Z|815|
|2|9b1af84b-eedb-4c21-9730-6f099cc2cc5e|claims assistance|2023-01-26T01:21:27Z|992|
|2|8471a3d4-6fc7-4bb2-9fc7-4583e3638a9e|emergency assistance|2023-03-09T10:58:54Z|128|
|2|38208fae-bad0-49bf-99aa-7842ba2e37bc|benefits|2023-06-05T07:35:43Z|619|

### Example Output:

|**policy_holder_count**|
|---|
|1|

### Explanation:

The only caller who made three, or more calls is policy holder ID 2.

To find the number of UHG policy holders who made three or more calls, you can use the following SQL query:

SQL

```
SELECT COUNT(*) AS policy_holder_count
FROM (
    SELECT policy_holder_id
    FROM callers
    GROUP BY policy_holder_id
    HAVING COUNT(DISTINCT case_id) >= 3
) AS frequent_callers;
```

This query works as follows:

- **Count distinct calls per policy holder**: The subquery groups the `callers` table by `policy_holder_id` and counts the number of distinct `case_id` values for each policy holder.

- **Filter policy holders with 3+ calls**: The HAVING clause filters the results to include only policy holders who made three or more calls.

- **Count the number of frequent callers**: The outer query counts the number of policy holders who meet the condition.

Note that we use `COUNT(DISTINCT case_id)` to count the number of distinct calls, assuming that each `case_id` represents a unique call. If there are duplicate `case_id` values for some reason, this will ensure that we count each call only once.