-- String Functions

-- SELECT LENGTH('sky') -- returns the length of string
-- UPPER() returns the uppercase
-- LOWER() returns the lowercase
-- SELECT LTRIM('    Sky') -- clears the spaces on the left side RTRIM for the opposite side; TRIM() for the all sides
-- SELECT LEFT('Kindergarten', 6) -- returns all characters from the left up to the given number, RIGHT() for all chars from the right
-- SELECT SUBSTRING('Kindergarten', 3, 5) -- nderg returns all characters from char 3 and 5 chars afterwards
-- SELECT LOCATE('n', 'Kindergarten') -- 3 returns the placement of the n which is 3; LOCATE('garten') returns 7
-- SELECT REPLACE('Kindergarten', 'garten', 'garden') -- Kindergarden
SELECT CONCAT('first', 'last') -- firstlast



-- Numeric Functions

-- SELECT ROUND(5.7355, 2) -- 5.74 rounds up the number and keeps only 2 numbers because of the given
-- SELECT TRUNCATE(5.7345, 2) -- 5.73 removes the remaining numbers and keeps only 2 numbers after the decimal place
-- SELECT CEILING(6.2) -- 7 returns the smallest integer that is greater than or equal to the given
-- SELECT FLOOR(6.2) -- 6 returns the largest integer that is less than or equal to the given
-- SELECT ABS(5.2) -- gives the absolute number
-- SELECT RAND() -- gives a random number between 0 and 1


-- -------------------------------------------------------------------------------------------------------------------


-- Subqueries in the FROM Clause

-- SELECT *
-- FROM (
-- 	SELECT
-- 		client_id,
-- 		name,
-- 		(SELECT SUM(invoice_total)
-- 			FROM invoices
-- 			WHERE client_id = c.client_id) AS total_sales,
-- 		(SELECT AVG(invoice_total) FROM invoices) AS average,
-- 		(SELECT total_sales - average) AS difference
-- 	FROM clients c
-- ) AS sales_summary
-- WHERE total_sales IS NOT NULL



-- Subqueries in the SELECT Clause

-- SELECT
-- 	client_id,
--     name,
--     (SELECT SUM(invoice_total)
-- 		FROM invoices
-- 		WHERE client_id = c.client_id) AS total_sales,
-- 	(SELECT AVG(invoice_total) FROM invoices) AS average,
-- 	(SELECT total_sales - average) AS difference
-- 	FROM clients c

-- SELECT
-- 	invoice_id,
--     invoice_total,
--     (SELECT AVG(invoice_total)
-- 		FROM invoices) AS invoice_average,
-- 	invoice_total - (SELECT invoice_average) AS difference
-- FROM invoices



-- The EXISTS Operator

-- Find the products that have never been ordered
-- USE sql_store;
-- SELECT *
-- FROM products p
-- WHERE NOT EXISTS (
-- 	SELECT product_id
--     FROM order_items
--     WHERE product_id = p.product_id
-- )
-- WHERE product_id NOT IN (
-- 	SELECT product_id
--     FROM order_items
-- )

-- Select clients that have an invoice
-- SELECT *
-- FROM clients c
-- WHERE EXISTS (
-- 	SELECT client_id
--     FROM invoices
--     WHERE client_id = c.client_id
-- )
-- WHERE client_id IN ( -- the WHERE IN way
-- 	SELECT client_id
--     FROM invoices
-- )
-- JOIN invoices i USING (client_id) -- the JOIN way



-- Correlated Subqueries

-- Get invoices that are larger than the client's average invoice amount
-- USE sql_invoicing;
-- SELECT *
-- FROM invoices i
-- WHERE invoice_total > (
-- 	SELECT AVG(invoice_total)
--     FROM invoices
--     WHERE client_id = i.client_id
-- )

-- Select employees whose salary is above the average in their office
-- Psuedo code:
-- for each employee; calculate the avg salary for employee.office; return the employee if salary > avg
-- USE sql_hr;
-- SELECT *
-- FROM employees e
-- WHERE salary > (
-- 	SELECT
-- 		AVG(salary)
-- 	FROM employees
--     WHERE office_id = e.office_id
-- )



-- The ANY or SOME Keyword

-- Select products that were sold by the unit (quantity = 1)
-- USE sql_invoicing;

-- SELECT * 
-- FROM invoices
-- WHERE invoice_total > ALL (
-- 	SELECT invoice_total
--     FROM invoices
--     WHERE client_id = 3
-- )

-- SELECT *
-- FROM clients
-- WHERE client_id = ANY (
-- 	SELECT client_id
-- 	FROM invoices
-- 	GROUP BY client_id
-- 	HAVING COUNT(*) >= 2
-- )
-- IS EQUIVALENT BELOW
-- WHERE client_id IN (
-- 	SELECT client_id
-- 	FROM invoices
-- 	GROUP BY client_id
-- 	HAVING COUNT(*) >= 2
-- )



-- The ALL Keyword

-- Select invoices larger than all invoices of client 3
-- USE sql_invoicing;

-- SELECT * 
-- FROM invoices
-- WHERE invoice_total > ALL (
-- 	SELECT invoice_total
--     FROM invoices
--     WHERE client_id = 3
-- )

-- SELECT *
-- FROM invoices
-- WHERE invoice_total > (
-- 	SELECT MAX(invoice_total)
-- 	FROM invoices
-- 	WHERE client_id = 3
-- )



-- Subqueries vs Joins

-- SELECT DISTINCT -- using Joins (find out which one is more readable)
-- 		customer_id, 
--         first_name, 
--         last_name
-- FROM customers c
-- JOIN orders o USING (customer_id)
-- JOIN order_items oi USING (order_id)
-- WHERE oi.product_id =3

-- SELECT -- using Subqueries
-- 	* 
-- FROM customers
-- WHERE customer_id IN (
-- 	SELECT o.customer_id
--     FROM order_items oi
--     JOIN orders o USING (order_id)
--     WHERE product_id = 3)

-- Find clients without invoices

-- SELECT *
-- FROM clients
-- WHERE client_id NOT IN (
-- 	SELECT DISTINCT client_id
-- 	FROM invoices
-- )

-- this subquery can also be used above
-- (SELECT *
-- FROM clients
-- LEFT JOIN invoices USING (client_id)
-- WHERE invoice_id IS NULL)


-- The IN Operator

-- USE sql_invoicing;

-- SELECT *
-- FROM clients
-- WHERE client_id NOT IN (
-- 	SELECT DISTINCT client_id
-- 	FROM invoices
-- )

-- Find the products that have never been ordered

-- USE sql_store;

-- SELECT *
-- FROM products
-- WHERE product_id NOT IN (
-- 	SELECT DISTINCT product_id
-- 	FROM order_items
-- )



-- Subqueries

-- USE sql_hr;

-- SELECT *
-- FROM employees
-- WHERE salary > (
-- 	SELECT
--     AVG(salary)
--     FROM employees)

-- Find products that are more
-- expensive than Lettuce (id = 3)

-- SELECT *
-- FROM products
-- WHERE unit_price > (
-- 	SELECT unit_price
--     FROM products
--     WHERE product_id = 3
-- )



-- The ROLLUP operator

-- SELECT
-- 	pm.name AS payment_method,
--     SUM(p.amount) AS total
-- FROM payments p
-- JOIN payment_methods pm
-- 	ON p.payment_method = pm.payment_method_id
-- GROUP BY pm.name WITH ROLLUP

-- SELECT
-- 	state,
--     city,
--     SUM(invoice_total) AS total_sales
-- FROM invoices i
-- JOIN clients c USING (client_id)
-- GROUP BY state, city WITH ROLLUP



-- WRITING COMPLEX QUERY



-- The HAVING clause

-- SELECT
-- 	c.customer_id,
--     c.first_name,
--     c.last_name,
--     SUM(oi.quantity * oi.unit_price) AS total_sales
-- FROM customers c
-- JOIN orders o USING (customer_id)
-- JOIN order_items oi USING (order_id)
-- WHERE state = 'VA'
-- GROUP BY customer_id
-- HAVING total_sales > 100

-- -- SELECT
-- -- 	client_id,
-- --     SUM(invoice_total) AS total_sales,
-- --     COUNT(*) AS number_of_invoices
-- -- FROM invoices
-- -- GROUP BY client_id
-- -- HAVING total_sales > 500 AND number_of_invoices > 5



-- The GROUP BY clause

-- SELECT
-- 	date,
--     pm.name AS payment_method,
-- 	SUM(amount) AS total_payments
-- FROM payments p
-- JOIN payment_methods pm
-- 	ON p.payment_method = pm.payment_method_id
-- GROUP BY date, payment_method
-- ORDER BY date

-- SELECT
-- 	state,
--     city,
-- 	SUM(invoice_total) AS total_sales
-- FROM invoices i
-- JOIN clients USING (client_id)
-- GROUP BY state, city



-- AGGREGATE FUNCTIONS

-- SELECT
-- 	'First half of 2019' AS date_range,
-- 	SUM(invoice_total) AS total_sales,
--     SUM(payment_total) AS total_payments,
--     SUM(invoice_total - payment_total) AS what_we_expect
-- FROM invoices
-- 	WHERE invoice_date BETWEEN '2019-01-01' AND '2019-06-30'
-- UNION
-- SELECT
-- 	'Second half of 2019' AS date_range,
-- 	SUM(invoice_total) AS total_sales,
--     SUM(payment_total) AS total_payments,
--     SUM(invoice_total - payment_total) AS what_we_expect
-- FROM invoices
-- 	WHERE invoice_date BETWEEN '2019-07-01' AND '2019-12-31'
-- UNION
-- SELECT
-- 	'Total' AS date_range,
-- 	SUM(invoice_total) AS total_sales,
--     SUM(payment_total) AS total_payments,
--     SUM(invoice_total - payment_total) AS what_we_expect
-- FROM invoices
-- 	WHERE invoice_date BETWEEN '2019-01-01' AND '2019-12-31'
	
-- SELECT 
-- 	MAX(invoice_total) AS highest,
-- 	MIN(invoice_total) AS lowest,
--     AVG(invoice_total) AS average,
--     SUM(invoice_total * 1.1) AS total,
-- 	COUNT(DISTINCT client_id) AS total_records
-- FROM invoices
-- WHERE invoice_date > '2019-07-01'

-- List of Aggregates
-- MAX()
-- MIN()
-- AVG()
-- SUM()
-- COUNT()