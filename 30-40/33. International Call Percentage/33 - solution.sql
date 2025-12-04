-- Solved on: PostgreSQL 14
SELECT 
  ROUND(
    COUNT(
      CASE WHEN CALLER.country_id <> RECEIVER.country_id 
      THEN A.caller_id END
    ) * 100.0 / COUNT(A.caller_id)
  , 1) international_calls_pct
FROM phone_calls A
LEFT JOIN phone_info CALLER ON CALLER.caller_id = A.caller_id
LEFT JOIN phone_info RECEIVER ON RECEIVER.caller_id = A.receiver_id;