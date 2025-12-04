-- Solved on: PostgreSQL 14
SELECT 
  COALESCE(A.user_id, B.user_id)
  , CASE WHEN B.paid IS NULL THEN 'CHURN'
      ELSE CASE WHEN A.status = 'CHURN' THEN 'RESURRECT'
        WHEN A.user_id IS NULL THEN 'NEW'  
        ELSE 'EXISTING' END
    END AS new_status
FROM advertiser A
FULL JOIN daily_pay B on A.user_id = B.user_id
ORDER BY 1;