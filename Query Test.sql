SELECT *
FROM orders o
JOIN customers c
	ON o.customer_id = c.customer_id
  
-- Implicit Join Syntax
-- SELECT *
-- FROM orders o, customers c
-- WHERE o.customer_id = c.customer_id

-- BEWARE OF IMPLICIT JOIN SYNTAX because it can cause CROSS JOIN
-- BETTER TO USE EXPLICIT JOIN SYNTAX