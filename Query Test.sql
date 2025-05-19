SELECT
	p.product_id,
    p.name,
    oi.quantity
FROM products p
LEFT JOIN order_items oi
	ON p.product_id = oi.product_id

-- LEFT JOIN shows the all the records in the LEFT table, which is the table after the FROM clause, whether the ON condition is true or not
-- RIGHT JOIN shows the all the records in the RIGHT table, which is the afte the JOIN clause
-- OUTER is option if using LEFT/RIGHT JOIN
-- INNER is optional if using JOIN

-- SELECT
-- 	c.customer_id,
--     c.first_name,
--     o.order_id
-- FROM customers c
-- LEFT JOIN orders o
-- 	ON c.customer_id = o.customer_id
-- ORDER BY c.customer_id

