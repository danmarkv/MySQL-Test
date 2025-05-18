SELECT order_id, p.product_id, name, quantity, o.unit_price
FROM products p
JOIN order_items o
	ON p.product_id = o.product_id

-- SELECT order_id, o.customer_id, first_name, last_name
-- FROM orders o
-- JOIN customers c
-- 	ON o.customer_id = c.customer_id
 