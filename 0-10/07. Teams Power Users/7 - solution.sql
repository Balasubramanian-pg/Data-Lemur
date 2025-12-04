-- Solved on: PostgreSQL 14
SELECT 
  sender_id, count(distinct message_id) as message_count
FROM messages
WHERE 
  DATE_PART('year', sent_date) = 2022
  AND DATE_PART('month', sent_date) = 8
GROUP BY sender_id
ORDER BY 2 DESC
LIMIT 2;