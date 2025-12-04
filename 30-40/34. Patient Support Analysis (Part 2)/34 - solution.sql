-- Solved on: PostgreSQL 14
SELECT 
  ROUND(COUNT (CASE WHEN call_category = 'n/a' OR call_category IS NULL THEN case_id END) * 100.0
  / COUNT(*), 1)
FROM callers;