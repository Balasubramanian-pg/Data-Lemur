-- Solved on: PostgreSQL 14
SELECT DISTINCT A.page_id FROM pages A
LEFT JOIN page_likes B on A.page_id = B.page_id
WHERE B.page_id IS NULL
ORDER BY page_id;