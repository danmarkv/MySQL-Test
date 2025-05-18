USE sql_inventory;

SELECT *
FROM sql_store.order_items oi
JOIN products p
	ON oi.product_id = p.product_id

-- prefix only when the table isn't on the database

-- USE sql_store;

-- SELECT *
-- FROM order_items oi
-- JOIN sql_inventory.products p
-- 	ON oi.product_id = p.product_id
 