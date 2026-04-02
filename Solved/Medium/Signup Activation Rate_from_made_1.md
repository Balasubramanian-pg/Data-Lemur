---
Created: 2025-06-28T18:34
Company:
- null
Difficulty: null
Status: Draft
Category: null
Sub Category: null
Question Link: null
Title: Signup Activation Rate_from_made_1
Area: Interview Prep
Type: Interview Question
Source: 03. Interview Prep/Interview Question/Data Lemur/Medium/Signup Activation
  Rate_from_made_1.md
Updated: ''
Tags: ''
Topic: ''
Date: ''
---
New TikTok users sign up with their emails. They confirmed their signup by replying to the text confirmation to activate their accounts.  
Users may receive multiple text messages for account confirmation until they have confirmed their new account.  

A senior analyst is interested to know the activation rate of specified users in the `emails` table. Write a query to find the activation rate. Round the percentage to 2 decimal places.

Definitions:

- `emails` table contain the information of user signup details.
- `texts` table contains the users' activation information.

Assumptions:

- The analyst is interested in the activation rate of specific users in the `emails` table, which may not include all users that could potentially be found in the `texts` table.
- For example, user 123 in the `emails` table may not be in the `texts` table and vice versa.

_Effective April 4th 2023, we added an assumption to the question to provide additional clarity._

### `emails` Table:

|   |   |
|---|---|
|**Column Name**|**Type**|
|email_id|integer|
|user_id|integer|
|signup_date|datetime|

### `emails` Example Input:

|   |   |   |
|---|---|---|
|**email_id**|**user_id**|**signup_date**|
|125|7771|06/14/2022 00:00:00|
|236|6950|07/01/2022 00:00:00|
|433|1052|07/09/2022 00:00:00|

### `texts` Table:

|   |   |
|---|---|
|**Column Name**|**Type**|
|text_id|integer|
|email_id|integer|
|signup_action|varchar|

### `texts` Example Input:

|   |   |   |
|---|---|---|
|**text_id**|**email_id**|**signup_action**|
|6878|125|Confirmed|
|6920|236|Not Confirmed|
|6994|236|Confirmed|

'Confirmed' in `signup_action` means the user has activated their account and successfully completed the signup process.

### Example Output:

**confirm_rate**


0.67


### Explanation:

67% of users have successfully completed their signup and activated their accounts. The remaining 33% have not yet replied to the text to confirm their signup.


Looking at this problem, I need to:

1. Calculate the activation rate for users in the `emails` table
2. A user is activated if they have at least one "Confirmed" text in the `texts` table
3. The rate should be rounded to 2 decimal places

Let me trace through the example:

- User 125777 (email_id 1): Has text with "Confirmed" → Activated
- User 366950 (email_id 2): Has texts with "Not Confirmed" and "Confirmed" → Activated (at least one confirmed)
- User 331052 (email_id 3): No texts → Not activated

So 2 out of 3 users are activated = 2/3 = 0.67This query calculates the activation rate by:

1. **LEFT JOIN**: Joins `emails` with `texts` to include all users from the emails table, even those without any text confirmations
2. **Numerator**: `COUNT(DISTINCT CASE WHEN t.signup_action = 'Confirmed' THEN e.email_id END)`
    - Counts distinct email_ids that have at least one "Confirmed" text
    - Uses `CASE WHEN` to only count email_ids with confirmed actions
    - `DISTINCT` ensures each user is counted only once, even if they have multiple "Confirmed" texts
3. **Denominator**: `COUNT(DISTINCT e.email_id)`
    - Counts all distinct users in the emails table
4. **Percentage Calculation**:
    - Multiplies by `100.0` (not `100`) to avoid integer division
    - Uses `ROUND(..., 2)` to round to 2 decimal places

**Key Points**:

- The LEFT JOIN ensures we consider all users from the emails table
- A user is considered activated if they have at least one "Confirmed" text
- Users with no texts or only "Not Confirmed" texts are not activated
- The result is expressed as a percentage (0.67 = 67%)

This approach correctly handles the scenario where users may have multiple text messages and ensures we're calculating the activation rate specifically for users in the emails table.

```SQL
SELECT 
  ROUND(
    COUNT(DISTINCT CASE WHEN t.signup_action = 'Confirmed' THEN e.email_id END) * 100.0 / COUNT(DISTINCT e.email_id),
    2
  ) AS confirm_rate
FROM emails e
LEFT JOIN texts t ON e.email_id = t.email_id;
```