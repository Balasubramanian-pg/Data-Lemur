---
Created: 2025-06-28T18:34
Area:
- Statistical Aggregation
Key Functions:
- Inner Join
- Round
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: International Call Percentage_from_made_1
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Medium/International Call
  Percentage_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
A phone call is considered an international call when the person calling is in a different country than the person receiving the call.

What percentage of phone calls are international? Round the result to 1 decimal.

Assumption:

- The `caller_id` in `phone_info` table refers to both the caller and receiver.

### `phone_calls` Table:

|   |   |
|---|---|
|Column Name|Type|
|caller_id|integer|
|receiver_id|integer|
|call_time|timestamp|

### `phone_calls` Example Input:

|   |   |   |
|---|---|---|
|caller_id|receiver_id|call_time|
|1|2|2022-07-04 10:13:49|
|1|5|2022-08-21 23:54:56|
|5|1|2022-05-13 17:24:06|
|5|6|2022-03-18 12:11:49|

### `phone_info` Table:

|   |   |
|---|---|
|Column Name|Type|
|caller_id|integer|
|country_id|integer|
|network|integer|
|phone_number|string|

### `phone_info` Example Input:

|   |   |   |   |
|---|---|---|---|
|caller_id|country_id|network|phone_number|
|1|US|Verizon|+1-212-897-1964|
|2|US|Verizon|+1-703-346-9529|
|3|US|Verizon|+1-650-828-4774|
|4|US|Verizon|+1-415-224-6663|
|5|IN|Vodafone|+91 7503-907302|
|6|IN|Vodafone|+91 2287-664895|

### Example Output:

international_calls_pct

---

50.0

---

### Explanation

There is a total of 4 calls with 2 of them being international calls (from caller_id 1 => receiver_id 5, and caller_id 5 => receiver_id

1). Thus, 2/4 = 50.0%

Looking at this problem, I need to:

1. Join the phone_calls table with phone_info twice (once for caller, once for receiver)
2. Compare the countries of caller and receiver to identify international calls
3. Calculate the percentage of international callsThe solution works as follows:

**Step 1**: Join the `phone_calls` table with `phone_info` twice:

- First join (`caller_info`) matches `pc.caller_id` with `caller_info.caller_id` to get the caller's country
- Second join (`receiver_info`) matches `pc.receiver_id` with `receiver_info.caller_id` to get the receiver's country

**Step 2**: Use a `CASE` statement to identify international calls:

- If `caller_info.country_id != receiver_info.country_id`, it's an international call (count as 1)
- Otherwise, it's a domestic call (count as 0)

**Step 3**: Calculate the percentage:

- `SUM()` of the CASE statement gives us the total number of international calls
- `COUNT(*)` gives us the total number of calls
- Multiply by 100.0 to convert to percentage
- `ROUND(..., 1)` rounds to 1 decimal place

For the given example:

- Call 1→2: US→US (domestic)
- Call 1→5: US→IN (international) ✓
- Call 5→1: IN→US (international) ✓
- Call 5→6: IN→IN (domestic)

Result: 2 international calls out of 4 total = 50.0%

The key insight is that the `caller_id` column in `phone_info` represents the unique identifier for each phone user, whether they are making or receiving a call.

```SQL
-- Solution: Calculate percentage of international phone calls
SELECT 
  ROUND(
    100.0 * SUM(
      CASE 
        WHEN caller_info.country_id != receiver_info.country_id THEN 1 
        ELSE 0 
      END
    ) / COUNT(*), 
    1
  ) AS international_calls_pct
FROM phone_calls pc
INNER JOIN phone_info caller_info 
  ON pc.caller_id = caller_info.caller_id
INNER JOIN phone_info receiver_info 
  ON pc.receiver_id = receiver_info.caller_id;
```