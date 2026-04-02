---
Created: 2025-06-28T18:34
Area:
- Statistical Aggregation
Key Functions:
- CTE
- LAG()
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Repeated Payments_from_made_1
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Hard/Repeated Payments_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
Sometimes, payment transactions are repeated by accident; it could be due to user error, API failure or a retry error that causes a credit card to be charged twice.

Using the transactions table, identify any payments made at the same merchant with the same credit card for the same amount within 10 minutes of each other. Count such repeated payments.

**Assumptions:**

- The first transaction of such payments should not be counted as a repeated payment. This means, if there are two transactions performed by a merchant with the same credit card and for the same amount within 10 minutes, there will only be 1 repeated payment.

### `transactions` Table:

|   |   |
|---|---|
|**Column Name**|**Type**|
|transaction_id|integer|
|merchant_id|integer|
|credit_card_id|integer|
|amount|integer|
|transaction_timestamp|datetime|

### `transactions` Example Input:

|   |   |   |   |   |
|---|---|---|---|---|
|**transaction_id**|**merchant_id**|**credit_card_id**|**amount**|**transaction_timestamp**|
|1|101|1|100|09/25/2022 12:00:00|
|2|101|1|100|09/25/2022 12:08:00|
|3|101|1|100|09/25/2022 12:28:00|
|4|102|2|300|09/25/2022 12:00:00|
|6|102|2|400|09/25/2022 14:00:00|

### Example Output:

**payment_count**


1


### Explanation

Within 10 minutes after Transaction 1, Transaction 2 is conducted at Merchant 1 using the same credit card for the same amount. This is the only instance of repeated payment in the given sample data.

Since Transaction 3 is completed after Transactions 2 and 1, each of which occurs after 20 and 28 minutes, respectively hence it does not meet the repeated payments' conditions. Whereas, Transactions 4 and 6 have different amounts.

  

Looking at this problem, I need to identify duplicate payments that occur within 10 minutes of each other with the same merchant, credit card, and amount. The key is that only the subsequent transactions (not the first one) should be counted as repeated payments.This query identifies repeated payments by:

1. **CTE (**`**ranked_transactions**`**)**:
    - Uses `LAG()` window function to get the previous transaction timestamp
    - Partitions by `merchant_id`, `credit_card_id`, and `amount` to group identical transaction types
    - Orders by `transaction_timestamp` to maintain chronological sequence
    - For each transaction, `prev_transaction_time` contains the timestamp of the previous identical transaction
2. **Main Query**:
    - Filters for transactions where `prev_transaction_time IS NOT NULL` (excludes first transactions of each group)
    - Checks if the current transaction occurred within 10 minutes of the previous identical transaction
    - Uses `INTERVAL '10 minutes'` to add 10 minutes to the previous transaction time
    - Counts all transactions that meet the repeated payment criteria

**Key Logic**:

- Only subsequent transactions are counted (first transaction is never a "repeat")
- Transactions must match on merchant, credit card, and amount
- Time difference must be ≤ 10 minutes

**Tracing through the example**:

- **Transaction 1** (12:00): First transaction for merchant 1, card 1, $100 → Not counted
- **Transaction 2** (12:08): Same merchant/card/amount, 8 minutes after Transaction 1 → Repeated payment ✓
- **Transaction 3** (12:28): Same merchant/card/amount, 20 minutes after Transaction 2 → Not within 10 minutes
- **Transactions 4, 6**: Different amounts → Not considered repeats

Result: 1 repeated payment (Transaction 2), matching the expected output.

```SQL
WITH ranked_transactions AS (
  SELECT 
    transaction_id,
    merchant_id,
    credit_card_id,
    amount,
    transaction_timestamp,
    LAG(transaction_timestamp) OVER (
      PARTITION BY merchant_id, credit_card_id, amount 
      ORDER BY transaction_timestamp
    ) AS prev_transaction_time
  FROM transactions
)

SELECT 
  COUNT(*) AS payment_count
FROM ranked_transactions
WHERE prev_transaction_time IS NOT NULL
  AND transaction_timestamp <= prev_transaction_time + INTERVAL '10 minutes';
```