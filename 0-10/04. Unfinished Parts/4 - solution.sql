-- Solved on: PostgreSQL 14
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL;