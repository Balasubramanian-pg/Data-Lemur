---
Created: 2025-06-28T18:34
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Advertiser Status
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Unsorted/Advertiser Status.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
You're provided with two tables: the `advertiser` table contains information about advertisers and their respective payment status, and the `daily_pay` table contains the current payment information for advertisers, and it only includes advertisers who have made payments.

Write a query to update the payment status of Facebook advertisers based on the information in the `daily_pay` table. The output should include the user ID and their current payment status, sorted by the user id.

The payment status of advertisers can be classified into the following categories:

- New: Advertisers who are newly registered and have made their first payment.
- Existing: Advertisers who have made payments in the past and have recently made a current payment.
- Churn: Advertisers who have made payments in the past but have not made any recent payment.
- Resurrect: Advertisers who have not made a recent payment but may  
    have made a previous payment and have made a payment again recently.  
    

Before proceeding with the question, it is important to understand the possible transitions in the advertiser's status based on the payment status. The following table provides a summary of these transitions:

|   |   |   |   |
|---|---|---|---|
|#|Current Status|Updated Status|Payment on Day T|
|1|NEW|EXISTING|Paid|
|2|NEW|CHURN|Not paid|
|3|EXISTING|EXISTING|Paid|
|4|EXISTING|CHURN|Not paid|
|5|CHURN|RESURRECT|Paid|
|6|CHURN|CHURN|Not paid|
|7|RESURRECT|EXISTING|Paid|
|8|RESURRECT|CHURN|Not paid|

- "Current Status" column: Represents the advertiser's current status.
- "Payment Status" column: Represents the updated payment status based on the conditions
- "Payment on Day T" column: Indicates whether the advertiser made a payment on a specific day (T) or not.

The transitions between payment statuses in the provided table can be summarized as follows:

- Rows 2, 4, 6, and 8: If an advertiser does not make a payment on day T, regardless of their previous status, their payment status transitions to "CHURN" as the updated status.
- Rows 1, 3, 5, and 7: If an advertiser makes a payment on day T, the status is updated to either "EXISTING" or "RESURRECT" based on their previous status. If the previous status was "CHURN," the updated status is "RESURRECT." For any other previous status, the updated status is "EXISTING."

### `advertiser` Table:

|   |   |
|---|---|
|Column Name|Type|
|user_id|string|
|status|string|

### `advertiser` Example Input:

|   |   |
|---|---|
|user_id|status|
|bing|NEW|
|yahoo|NEW|
|alibaba|EXISTING|

### `daily_pay` Table:

|   |   |
|---|---|
|Column Name|Type|
|user_id|string|
|paid|decimal|

### `daily_pay` Example Input:

|   |   |
|---|---|
|user_id|paid|
|yahoo|45.00|
|alibaba|100.00|
|target|13.00|

### Example Output:

|   |   |
|---|---|
|user_id|new_status|
|bing|CHURN|
|yahoo|EXISTING|
|alibaba|EXISTING|

### Explanation:

- The advertiser "bing" is classified as "CHURN" because no payment record is found in the `daily_pay` table.
- The advertiser "yahoo" is labeled as "EXISTING" since they have made a recent payment, as indicated by the presence of their payment record.
- Similarly, the advertiser "alibaba" is also classified as "EXISTING" due to their recent payment.

  

Looking at this problem, I need to understand the status transition rules and apply them based on whether an advertiser made a payment or not.

Let me analyze the transition rules:

- If an advertiser made a payment (appears in daily_pay):
    - If current status is "CHURN" → new status is "RESURRECT"
    - If current status is anything else → new status is "EXISTING"
- If an advertiser did not make a payment (not in daily_pay):
    - Regardless of current status → new status is "CHURN"The solution works as follows:

**Step 1**: Use a `LEFT JOIN` between `advertiser` and `daily_pay` tables:

- This ensures we get all advertisers, whether they made a payment or not
- If an advertiser made a payment, `dp.user_id` will have a value
- If an advertiser didn't make a payment, `dp.user_id` will be NULL

**Step 2**: Apply the status transition logic using a `CASE` statement:

- **No payment made** (`dp.user_id IS NULL`): Status becomes "CHURN"
- **Payment made + previous status was "CHURN"**: Status becomes "RESURRECT"
- **Payment made + any other previous status**: Status becomes "EXISTING"

**Step 3**: Sort results by `user_id` as requested.

**Example walkthrough**:

- **bing**: Not in daily_pay → NULL join → Status becomes "CHURN"
- **yahoo**: In daily_pay + previous status "NEW" → Status becomes "EXISTING"
- **alibaba**: In daily_pay + previous status "EXISTING" → Status remains "EXISTING"

**Key transition rules summary**:

- **Made Payment**: CHURN → RESURRECT, anything else → EXISTING
- **No Payment**: anything → CHURN

The `LEFT JOIN` is crucial here because it preserves all advertisers from the `advertiser` table while allowing us to detect who made payments (non-NULL) versus who didn't (NULL).

```SQL
-- Solution: Update Facebook advertiser payment status based on daily payments
SELECT 
  a.user_id,
  CASE 
    WHEN dp.user_id IS NULL THEN 'CHURN'  -- No payment made
    WHEN a.status = 'CHURN' THEN 'RESURRECT'  -- Was churned, now paid
    ELSE 'EXISTING'  -- Made payment, any other previous status
  END AS new_status
FROM advertiser a
LEFT JOIN daily_pay dp ON a.user_id = dp.user_id
ORDER BY a.user_id;
```