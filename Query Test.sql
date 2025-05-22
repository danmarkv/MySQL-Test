
UPDATE orders
SET
	comments = 'Gold Customer'
WHERE customer_id IN 
			(SELECT customer_id
            FROM customers
            WHERE points > 3000)

-- UPDATE invoices
-- SET 
-- 	payment_total = invoice_total * 0.5,
-- 	payment_date = due_date
-- WHERE payment_date IS NULL
--     
-- -- WHERE client_id IN 
-- -- 			(SELECT client_id
-- -- 			FROM clients
-- -- 			WHERE state IN ('CA', 'NY'))

