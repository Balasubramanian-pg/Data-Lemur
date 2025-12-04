-- Solved on: PostgreSQL 14
SELECT 
  CONCAT(A.topping_name,',',B.topping_name,',', C.topping_name) AS pizza
  , A.ingredient_cost + B.ingredient_cost + C.ingredient_cost AS total_cost
FROM pizza_toppings A
CROSS JOIN pizza_toppings B
CROSS JOIN pizza_toppings C
WHERE 
  A.topping_name < B.topping_name
  AND B.topping_name < C.topping_name
ORDER BY 2 DESC, 1;