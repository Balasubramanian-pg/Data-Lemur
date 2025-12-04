-- Solved on: PostgreSQL 14
WITH cte_user_tweets as (
  SELECT user_id, count(tweet_id) as tweet_count 
  FROM tweets
  WHERE DATE_PART('year',tweet_date) = 2022
  GROUP BY user_id
)
SELECT 
  tweet_count as tweet_bucket
  , count(user_id) as users_num
FROM cte_user_tweets
GROUP BY tweet_count;