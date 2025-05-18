SELECT *, quantity * unit_price AS total_price
FROM order_items
WHERE order_id = 2
ORDER BY total_price DESC

-- SELECT first_name, last_name, 10 AS points
-- FROM customers
-- ORDER BY 1, 2
-- -- ORDER BY state, first_name
 