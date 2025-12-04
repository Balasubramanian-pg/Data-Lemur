-- Solved on: PostgreSQL 14
SELECT count(policy_holder_id) policy_holder_count FROM (
  SELECT policy_holder_id
  FROM callers
  GROUP BY policy_holder_id
  HAVING count(distinct case_id) >= 3
) three_times_callers;