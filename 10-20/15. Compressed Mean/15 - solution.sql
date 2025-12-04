-- Solved on: PostgreSQL 14
SELECT 
  ROUND((sum(total_qty)::numeric / sum(order_occurrences)), 1) as mean
FROM 
(SELECT 
  order_occurrences
  , item_count * order_occurrences as total_qty
FROM items_per_order) quantified_orders;