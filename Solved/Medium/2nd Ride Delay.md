---
Date: 2025-07-30
Difficulty: Medium
Title: 2nd Ride Delay
Area: Interview Prep
Type: Interview Question
Status: Draft
Source: 03. Interview Prep/Interview Question/Data Lemur/Medium/2nd Ride Delay.md
Created: ''
Updated: ''
Tags: ''
Topic: ''
Company: ''
Question Link: ''
Category: ''
Sub Category: ''
---
Some riders create their Uber account the same day they book their first ride; the rider engagement team calls them “in-the-moment” users.

Press enter or click to view image in full size

![](https://miro.medium.com/v2/resize:fit:875/1*KGl9aGjLTGlo4FZjbBGFfw.jpeg)

Uber wants to know the average delay between the day of user sign-up and the day of their 2nd ride. Write a query to pull the average 2nd ride delay for “in-the-moment” Uber users. Round the answer to 2-decimal places.

**users** Table:

![](https://miro.medium.com/v2/resize:fit:580/1*rJ1MJF7eySkni7TUfCD0UA.png)

**rides** Table:

![](https://miro.medium.com/v2/resize:fit:545/1*hfD6BgFmwkrVakaYVnhkeA.png)

**Step 1:** We can join the `users` table with `rides` on `user_id` and pull results where the registration date and ride date are equal.

As there may have users with more than 1 ride on the first date, simply use `DISTINCT` to obtain the unique users. In addition, wrap the query into a CTE, so we can reuse the output later.
```sql
`WITH moment_users AS (`  
`SELECT DISTINCT users.user_id`  
`FROM users`  
`JOIN rides`  
`ON users.user_id = rides.user_id`  
`AND users.registration_date = rides.ride_date)`
```

**Step 2:** The question asks for the average delay between the first and second rides. That means we need to identify a trip number for each user’s rides. To do so, let’s create a new column with `ROW_NUMBER()` that enumerates trips per user.

Now, we need to set this up so we can compare each ride date to the previous one using row-wise subtraction. To accomplish this, we will use the `LAG` function to pull the date of the previous trip in a new column.

```sql
WITH moment_users AS (  
— Insert previous query here  
),  
rides_cte AS (  
SELECT rides.user_id, rides.ride_date,  
ROW_NUMBER() OVER (  
PARTITION BY users.user_id ORDER BY rides.ride_date) AS ride_nr,  
LAG(rides.ride_date) OVER (  
PARTITION BY users.user_id ORDER BY rides.ride_date) AS lag_ride_date  
FROM moment_users AS users  
LEFT JOIN rides  
ON users.user_id = rides.user_id  
)
```


**Step 3:** Lets subtract the `lag_ride_date` from `ride_date` to obtain the delay for each ride. Then wrap this subtraction in an `AVG` function to obtain the average of all ride delays.

Keep in mind that the task asked for the 2nd ride delay, so make sure to filter on results where the `ride_nr` is 2.

SELECT ROUND(AVG(ride_date — lag_ride_date),2) AS average_delay  
FROM rides_cte  
WHERE ride_nr = 2;

So the full solution would look like

```sql
 WITH moment_users AS ( 
 SELECT DISTINCT users.user_id 
 FROM users 
 JOIN rides
 ON users.user_id = rides.user_id
 AND users.registration_date = rides.ride_date
  ),
  rides_cte AS (  
 SELECT rides.user_id, rides.ride_date,  
 ROW_NUMBER() OVER (  
 PARTITION BY users.user_id ORDER BY rides.ride_date) AS ride_nr,  
 LAG(rides.ride_date) OVER (  
 PARTITION BY users.user_id ORDER BY rides.ride_date) AS lag_ride_date  
 FROM moment_users AS users  
 LEFT JOIN rides  
 ON users.user_id = rides.user_id  
  )
 SELECT ROUND(AVG(ride_date — lag_ride_date),2) AS average_delay  
 FROM rides_cte  
 WHERE ride_nr=2;
```


The output will be as follows.

Press enter or click to view image in full size

![](https://miro.medium.com/v2/resize:fit:875/1*WPTjTKzCnRF2G0pauVkUJQ.png)