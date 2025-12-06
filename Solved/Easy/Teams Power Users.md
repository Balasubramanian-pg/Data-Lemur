---
Date: 2025-07-30
Difficulty: Easy
Title: Teams Power Users
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Easy/Teams Power Users.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Company: ''
Question Link: ''
Category: ''
Sub Category: ''
---
Write a query to identify the top 2 Power Users who sent the highest number of messages on Microsoft Teams in August 2022. Display the IDs of these 2 users along with the total number of messages they sent. Output the results in descending order based on the count of the messages.

Assumption:

- No two users have sent the same number of messages in August 2022.

### `messages` Table:

|**Column Name**|**Type**|
|---|---|
|message_id|integer|
|sender_id|integer|
|receiver_id|integer|
|content|varchar|
|sent_date|datetime|

### `messages` Example Input:

|**message_id**|**sender_id**|**receiver_id**|**content**|**sent_date**|
|---|---|---|---|---|
|901|3601|4500|You up?|08/03/2022 00:00:00|
|902|4500|3601|Only if you're buying|08/03/2022 00:00:00|
|743|3601|8752|Let's take this offline|06/14/2022 00:00:00|
|922|3601|4500|Get on the call|08/10/2022 00:00:00|

### Example Output:

|**sender_id**|**message_count**|
|---|---|
|3601|2|
|4500|1|

The dataset you are querying against may have different input & output - **this is just an example**!

To solve this problem, you can use the SQL query below. This query will filter messages sent in August 2022, count the number of messages sent by each user, and then return the top 2 users with the highest message count.

SQL

```
SELECT 
    sender_id,
    COUNT(message_id) as message_count
FROM 
    messages
WHERE 
    EXTRACT(MONTH FROM sent_date) = 8 AND 
    EXTRACT(YEAR FROM sent_date) = 2022
GROUP BY 
    sender_id
ORDER BY 
    message_count DESC
LIMIT 2;
```

This query works as follows:

- The `WHERE` clause filters the messages to include only those sent in August 2022.

- The `GROUP BY` clause groups the remaining messages by `sender_id`.

- The `COUNT(message_id)` expression counts the number of messages sent by each user.

- The `ORDER BY` clause sorts the results in descending order based on the message count.

- The `LIMIT 2` clause returns only the top 2 users with the highest message count.

Note that the exact SQL syntax might vary depending on the database management system being used. The above query uses standard SQL syntax that should work with most modern databases. However, if you're using a specific database system like MySQL or PostgreSQL, you might need to adjust the date extraction function accordingly.

For example, in MySQL, you would use the `MONTH()` and `YEAR()` functions directly:

SQL

```
SELECT 
    sender_id,
    COUNT(message_id) as message_count
FROM 
    messages
WHERE 
    MONTH(sent_date) = 8 AND 
    YEAR(sent_date) = 2022
GROUP BY 
    sender_id
ORDER BY 
    message_count DESC
LIMIT 2;
```

In PostgreSQL, the original query should work as is, or you could use the `EXTRACT` function with the `FROM` clause specifying the date part to extract, as shown in the original query.

Alternatively, you could also use date range comparison for better performance, especially if there's an index on the `sent_date` column:

SQL

```
SELECT 
    sender_id,
    COUNT(message_id) as message_count
FROM 
    messages
WHERE 
    sent_date >= '2022-08-01 00:00:00' AND 
    sent_date < '2022-09-01 00:00:00'
GROUP BY 
    sender_id
ORDER BY 
    message_count DESC
LIMIT 2;
```

Here's another method to achieve the same result using a subquery or Common Table Expression (CTE) with the `RANK()` or `DENSE_RANK()` function:

SQL

```
WITH ranked_messages AS (
    SELECT 
        sender_id,
        COUNT(message_id) as message_count,
        RANK() OVER (ORDER BY COUNT(message_id) DESC) as rank
    FROM 
        messages
    WHERE 
        sent_date >= '2022-08-01 00:00:00' AND 
        sent_date < '2022-09-01 00:00:00'
    GROUP BY 
        sender_id
)
SELECT 
    sender_id,
    message_count
FROM 
    ranked_messages
WHERE 
    rank <= 2;
```

This query works as follows:

- The CTE (`ranked_messages`) calculates the message count for each sender and assigns a rank based on the count in descending order.

- The outer query selects the `sender_id` and `message_count` for the top 2 ranked senders.

Using `RANK()` or `DENSE_RANK()` can be useful if there are ties in the message count, and you want to return all users with the same rank. If you strictly want to return only 2 rows even in case of ties, you can use `ROW_NUMBER()` instead:

SQL

```
WITH ranked_messages AS (
    SELECT 
        sender_id,
        COUNT(message_id) as message_count,
        ROW_NUMBER() OVER (ORDER BY COUNT(message_id) DESC) as row_num
    FROM 
        messages
    WHERE 
        sent_date >= '2022-08-01 00:00:00' AND 
        sent_date < '2022-09-01 00:00:00'
    GROUP BY 
        sender_id
)
SELECT 
    sender_id,
    message_count
FROM 
    ranked_messages
WHERE 
    row_num <= 2;
```