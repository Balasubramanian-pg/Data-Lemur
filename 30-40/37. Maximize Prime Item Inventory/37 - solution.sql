-- Solved on: PostgreSQL 14
WITH cte_per_item_area AS (
  SELECT 
    item_type
    , SUM(square_footage) AS total_sqft
    , COUNT(*) AS item_count
  FROM inventory
  GROUP BY item_type
)

, prime_occupied_area AS (  
  SELECT  
    item_type,
    total_sqft,
    FLOOR(500000/total_sqft) AS prime_item_combination_count,
    (FLOOR(500000/total_sqft) * item_count) AS prime_item_count
  FROM cte_per_item_area  
  WHERE item_type = 'prime_eligible'
)

, remaining_area AS (
  SELECT
    500000 - (prime_item_combination_count * total_sqft) AS non_prime_area
  FROM prime_occupied_area
)

, non_prime_occupied_area AS (
  SELECT  
    item_type,
    total_sqft,
    FLOOR((SELECT non_prime_area FROM remaining_area)
      / total_sqft) AS non_prime_item_combination_count,
    (FLOOR((SELECT non_prime_area FROM remaining_area)
    /total_sqft) * item_count) AS non_prime_item_count
  FROM cte_per_item_area  
  WHERE item_type = 'not_prime'
)

SELECT item_type, non_prime_item_count AS item_count
FROM non_prime_occupied_area
UNION
SELECT item_type, prime_item_count AS item_count
FROM prime_occupied_area
ORDER BY 1 DESC
;