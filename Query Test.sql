USE sql_invoicing;

SELECT
	p.date,
    p.invoice_id,
    p.amount,
    c.name,
    pm.name
-- 	c.client_id,
--     c.name,
--     p.date,
--     pm.name
FROM payments p
JOIN clients c
	ON p.client_id = c.client_id
JOIN payment_methods pm
	ON p.payment_method = pm.payment_method_id

-- USE sql_store;

-- SELECT
-- 	o.order_id,
--     o.order_date,
--     c.first_name,
--     c.last_name,
--     os.name AS status
-- FROM orders o
-- JOIN customers c
-- 	ON o.customer_id = c.customer_id
-- JOIN order_statuses os
-- 	ON o.status = os.order_status_id
 