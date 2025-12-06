---
Date: 2025-07-30
Difficulty: Easy
Company:
- Twitter
Title: Histogram of Tweets
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Easy/Histogram of Tweets.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Question Link: ''
Category: ''
Sub Category: ''
---
Assume you're given a table Twitter tweet data, write a query to obtain a histogram of tweets posted per user in 2022. Output the tweet count per user as the bucket and the number of Twitter users who fall into that bucket.

In other words, group the users by the number of tweets they posted in 2022 and count the number of users in each group.

### `tweets` Table:

|Column Name|Type|
|---|---|
|tweet_id|integer|
|user_id|integer|
|msg|string|
|tweet_date|timestamp|

### `tweets` Example Input:

|tweet_id|user_id|msg|tweet_date|
|---|---|---|---|
|214252|111|Am considering taking Tesla private at $420. Funding secured.|12/30/2021 00:00:00|
|739252|111|Despite the constant negative press covfefe|01/01/2022 00:00:00|
|846402|111|Following @NickSinghTech on Twitter changed my life!|02/14/2022 00:00:00|
|241425|254|If the salary is so competitive why won’t you tell me what it is?|03/01/2022 00:00:00|
|231574|148|I no longer have a manager. I can't be managed|03/23/2022 00:00:00|

### Example Output:

|tweet_bucket|users_num|
|---|---|
|1|2|
|2|1|

### Explanation:

Based on the example output, there are two users who posted only one tweet in 2022, and one user who posted two tweets in 2022. The query groups the users by the number of tweets they posted and displays the number of users in each group.

To obtain a histogram of tweets posted per user in 2022, you can use the following SQL query:

```SQL
SELECT 
    tweet_count AS tweet_bucket,
    COUNT(*) AS users_num
FROM (
    SELECT 
        user_id,
        COUNT(tweet_id) AS tweet_count
    FROM tweets
    WHERE EXTRACT(YEAR FROM tweet_date) = 2022
    GROUP BY user_id
) AS user_tweet_counts
GROUP BY tweet_count
ORDER BY tweet_count ASC;
```

This query works as follows:

- **Filter tweets by year**: The subquery filters the tweets table to only include rows where the tweet_date is in the year 2022.

- **Count tweets per user**: The subquery groups the filtered rows by user_id and counts the number of tweets each user posted.

- **Group users by tweet count**: The outer query groups the users by their tweet count and counts the number of users in each group.

- **Output the histogram**: The outer query outputs the tweet count per user as the bucket and the number of Twitter users who fall into that bucket.

When you run this query on the provided example input, it will return the expected output:

|tweet_bucket|users_num|
|---|---|
|1|2|
|2|1|
