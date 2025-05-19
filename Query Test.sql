SELECT
    o.order_id,
    o.order_date,
    c.first_name,
    sh.name AS shipper,
    os.name AS status
FROM customers c
JOIN orders o
	ON c.customer_id = o.customer_id
LEFT JOIN shippers sh
	ON o.shipper_id = sh.shipper_id
JOIN order_statuses os
	ON o.status = os.order_status_id
ORDER BY c.customer_id

