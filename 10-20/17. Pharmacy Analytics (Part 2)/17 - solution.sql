-- Solved on: PostgreSQL 14
WITH cte_drugs_with_losses AS (
  SELECT 
    *, 1 as drug_count, cogs - total_sales losses
  FROM pharmacy_sales
  WHERE cogs - total_sales > 0
)

SELECT
  manufacturer
  , SUM(drug_count) AS drug_count
  , SUM(losses) AS total_loss
FROM cte_drugs_with_losses
GROUP BY manufacturer
ORDER BY 3 DESC;