-- Solved on: PostgreSQL 14
WITH cte_scored_candidates AS (
  SELECT 
    *
    , CASE WHEN UPPER(skill) = 'PYTHON' THEN 1
        WHEN UPPER(skill) = 'TABLEAU' THEN 2
        WHEN UPPER(skill) = 'POSTGRESQL' THEN 4
      END AS skill_score
  FROM candidates
)

SELECT candidate_id 
FROM cte_scored_candidates
GROUP BY candidate_id
HAVING SUM(skill_score) = 7;