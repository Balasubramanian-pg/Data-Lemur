-- Solved on: PostgreSQL 14
WITH total AS (
  SELECT 
    SUM(num_users) AS n
  FROM search_frequency
)

, termed AS (
  SELECT
    *, SUM(num_users) OVER (ORDER BY searches) term_number
  FROM search_frequency
)

, mid_terms AS (
  SELECT * FROM termed
  WHERE term_number >= (
    SELECT CASE WHEN n % 2 = 0 THEN (n/2)
      ELSE (n+1)/2 END mid_term
    FROM total
  )
  AND term_number <= (
    SELECT CASE WHEN n % 2 = 0 THEN (n/2) + 1
      ELSE (n+1)/2 END mid_term
    FROM total
  )
)

, exploded_mid_terms AS (
  SELECT searches
  FROM mid_terms
  GROUP BY searches, GENERATE_SERIES(1, num_users)
  ORDER BY 1 DESC
  LIMIT 2
)

SELECT 
  ROUND(AVG(searches), 1) AS median
FROM exploded_mid_terms;