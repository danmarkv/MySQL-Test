-- Transaction Isolation Levels

SHOW VARIABLES LIKE 'transaction_isolation';
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- SESSION: for the current session or connection, GLOBAL: for all connections and future sessions



-- Concurrency and Locking

-- USE sql_store;

-- START TRANSACTION;
-- UPDATE customers
-- SET points = points + 10
-- WHERE customer_id = 1;
-- COMMIT; 



-- Creating Transactions

-- USE sql_store;

-- START TRANSACTION;

-- INSERT INTO orders (customer_id, order_date, status)
-- VALUES (1, '2019-01-01', 1);

-- INSERT INTO  order_items
-- VALUES (LAST_INSERT_ID(), 1, 1, 1);

-- ROLLBACK; -- or COMMIT;

-- A Transaction is a group of SQL statements that represent a single unit of work.



-- View/drop/alter Events

-- SHOW EVENTS; -- viewing
-- DROP EVENT IF EXISTS yearly_delete_stale_audit_rows; -- dropping
-- ALTER EVENT yearly_delete_stale_audit_rows DISABLE; -- altering DISABLE/ENABLE



-- Creating Events

-- DELIMITER $$

-- CREATE EVENT yearly_delete_stale_audit_rows
-- ON SCHEDULE
-- -- 	AT '2019-05-01' -- for executing only once
-- 	EVERY 1 YEAR STARTS '2019-01-01' ENDS '2029-01-01'
-- DO BEGIN
-- 	DELETE FROM payments_audit
--     WHERE action_date < NOW() - INTERVAL 1 YEAR; -- deletes all audits that are older than 1 year
-- END $$
-- DELIMITER ;

-- SHOW VARIABLES LIKE 'event%';
-- An EVENT is a task, or block of SQL code, that gets executed according to a schedule.



-- Using Triggers for Auditing

-- DELETE FROM payments
-- WHERE payment_id = 11;

-- INSERT INTO payments
-- VALUES (DEFAULT, 5, 3, '2019-01-01', 10, 1)

-- DELIMITER $$

-- DROP TRIGGER IF EXISTS payments_after_insert;

-- CREATE TRIGGER payments_after_insert
-- 	AFTER INSERT ON payments -- AFTER UPDATE/DELETE
--     FOR EACH ROW
-- BEGIN
-- 	UPDATE invoices
--     SET payment_total = payment_total + NEW.amount
--     WHERE invoice_id = NEW.invoice_id;
--     
--     INSERT INTO payments_audit
--     VALUES (NEW.client_id, NEW.date, NEW.amount, 'Insert', NOW());
-- END $$

-- DELIMITER ;



-- Viewing/Dropping Triggers

-- DROP TRIGGER IF EXISTS payments_after_insert; -- put in source control

-- SHOW TRIGGERS LIKE 'payments%' -- follow the convention to filter triggers easier. (table name)_(before/after)_(action)
-- SHOW TRIGGERS -- to show all triggers created



-- Creating Triggers

-- Create a trigger that gets fired when we delete a payment.

-- DELETE FROM payments
-- WHERE payment_id = 10;

-- DELIMITER $$
-- CREATE TRIGGER payments_after_delete
-- 	AFTER DELETE ON payments
--     FOR EACH ROW
-- BEGIN
-- 	UPDATE invoices
--     SET payment_total = payment_total - OLD.amount
--     WHERE invoice_id = OLD.invoice_id;
-- END$$
-- DELIMITER ;


-- INSERT INTO payments
-- VALUES (DEFAULT, 5, 3, '2019-01-01', 10, 1)

-- DELIMITER $$
-- CREATE TRIGGER payments_after_insert
-- 	AFTER INSERT ON payments -- AFTER UPDATE/DELETE
--     FOR EACH ROW
-- BEGIN
-- 	UPDATE invoices
--     SET payment_total = payment_total + NEW.amount
--     WHERE invoice_id = NEW.invoice_id;
-- END $$
-- DELIMITER ;

-- A trigger is a block of SQL code that automatically gets executed before or after an insert, update, or delete statement.


-- -------------------------------------------------------------------------------------------------------------------


-- Other Conventions

-- Stick to the convetions based on your company
-- procGetRiskFactor, getRiskFactor, get_risk_factor
-- DELIMITER $$ or //



-- Using Functions

-- DROP FUNCTION IF EXISTS get_risk_factor_for_client;

-- SELECT
-- 	client_id,
--     name,
--     get_risk_factor_for_client(client_id) AS risk_factor -- put Functions in source control
-- FROM clients



-- **Using Local Variables**

-- Local variable. as soon as the stored procedure is finished, it is freed up
-- DROP PROCEDURE IF EXISTS get_risk_factor; 

-- DELIMITER $$
-- CREATE PROCEDURE get_risk_factor()
-- BEGIN
-- -- risk_factor = invoices_total / invoices_count * 5
-- 	DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
--     DECLARE invoices_total DECIMAL(9,2);
--     DECLARE invoices_count INT;

-- 	SELECT COUNT(*), SUM(invoice_total)
--     INTO invoices_count, invoices_total
--     FROM invoices i;
--     
--     SET risk_factor = invoices_total / invoices_count * 5;
--     
--     SELECT risk_factor;
-- END$$
-- DELIMITER ;

-- User or session variables. these will be in memory during the entire client's session. only when the client disconnects will it be freed up
-- SET @invoices_count = 0; -- defining a variable, prefix them with an @



-- **Output Parameters**

-- DROP PROCEDURE IF EXISTS get_unpaid_invoices_for_client; 

-- DELIMITER $$
-- CREATE PROCEDURE get_unpaid_invoices_for_client
-- (
-- 	client_id INT,
--     OUT invoices_count INT, -- avoid using these unless absolutely necessary
--     OUT invoices_total DECIMAL(9, 2)
-- )
-- BEGIN
-- 	SELECT COUNT(*), SUM(invoice_total)
--     INTO invoices_count, invoices_total
--     FROM invoices i
--     WHERE i.client_id = client_id AND
-- 		payment_total = 0;
-- END$$
-- DELIMITER ;



-- **Parameter Validation**

-- DROP PROCEDURE IF EXISTS make_payment;

-- DELIMITER $$
-- CREATE PROCEDURE get_payments
-- (
-- 	invoice_id INT,
--     payment_amount DECIMAL(9, 2),
--     payment_date DATE
-- )
-- BEGIN
-- 	IF payment_amount <= 0 THEN
-- 		SIGNAL SQLSTATE '22003' SET MESSAGE_TEXT = 'Invalid payment amount.';
-- 	END IF;
--     
-- 	UPDATE invoices i
--     SET
-- 		i.payment_total = payment_amount,
--         i.payment_date = payment_date
-- 	WHERE i.invoice_id = invoice_id;
-- END$$
-- DELIMITER ;



-- **Using Parameters with default values**

-- DROP PROCEDURE IF EXISTS get_payments;

-- DELIMITER $$
-- CREATE PROCEDURE get_payments
-- (
-- 	client_id INT,
--     payment_method_id TINYINT
-- )
-- BEGIN

-- 	SELECT * FROM payments p
--     WHERE p.client_id = IFNULL(client_id, p.client_id) AND
--     p.payment_method = IFNULL(payment_method_id, p.payment_method);
--     

-- END$$
-- DELIMITER ;

-- DROP PROCEDURE IF EXISTS get_clients_by_state;

-- DELIMITER $$
-- CREATE PROCEDURE get_clients_by_state
-- (
-- 	state CHAR(2)
-- )
-- BEGIN

-- 	SELECT * FROM clients c
-- 	WHERE c.state = IFNULL(state, c.state);
-- END$$
-- DELIMITER ;



-- **Using Paramters in the Stored Procedures**

-- DROP PROCEDURE IF EXISTS get_invoices_by_client

-- DELIMITER $$
-- CREATE PROCEDURE get_invoices_by_client
-- (
-- 	client_id INT
-- )
-- BEGIN
-- 	SELECT * FROM invoices i
--     WHERE i.client_id = client_id;
-- END$$
-- DELIMITER ;

-- DROP PROCEDURE IF EXISTS get_clients_by_state -- it's good practice to move stored procedures to separate files

-- DELIMITER $$
-- CREATE PROCEDURE get_clients_by_state
-- (
-- 	state CHAR(2)
-- )
-- BEGIN
-- 	SELECT * FROM clients c
--     WHERE c.state = state;
-- END$$
-- DELIMITER ;



-- **Dropping Stored Procedures**

-- DROP PROCEDURE IF EXISTS get_clients -- it's good practice to move stored procedures to separate files

-- DELIMITER $$
-- CREATE PROCEDURE get_clients()
-- BEGIN
-- 	SELECT * FROM clients;
-- END$$
-- DELIMITER ;



-- Creating a Stored Procedure

-- DELIMITER $$
-- CREATE PROCEDURE get_invoices_with_balance()
-- BEGIN
-- 	SELECT *
--     FROM invoices_with_balance
--     WHERE balance > 0;
-- END$$
-- DELIMITER ;

-- CALL get_clients() -- calling the stored procedure

-- DELIMITER $$ -- use DELIMITER to get rid of the errors
-- CREATE PROCEDURE get_clients()
-- BEGIN
-- 	SELECT * FROM clients;
-- END$$

-- DELIMITER ;


-- -------------------------------------------------------------------------------------------------------------------


-- The other benefits of Views

-- VIEWS help:
-- simplify queries
-- reduce the impact of changes
-- restrict access to the data
-- BE AWARE OF THESE BUT DON'T BLINDLY APPLY TO EVERY SITUATION



-- The WITH CHECK OPTION Clause

-- UPDATE invoices_with_balance -- creates an error
-- SET payment_total = invoice_total
-- WHERE invoice_id = 3

-- CREATE OR REPLACE VIEW invoices_with_balance AS -- added WITH CHECK OPTION, which prevents you from modifying rows in such ways that it won't be displayed/it will be deleted from the view.
-- SELECT
-- 	invoice_id,
--     number,
--     client_id,
--     invoice_total,
--     payment_total,
--     invoice_total - payment_total AS balance,
--     invoice_date,
--     due_date,
--     payment_date
-- FROM invoices
-- WHERE (invoice_total - payment_total) > 0
-- WITH CHECK OPTION

-- UPDATE invoices_with_balance
-- SET payment_total = invoice_total
-- WHERE invoice_id = 2

-- Updatable Views

-- UPDATE invoices_with_balance
-- SET due_date = DATE_ADD(due_date, INTERVAL 2 DAY)
-- WHERE invoice_id = 2

-- DELETE FROM invoices_with_balance -- we can delete a row in the view from here
-- WHERE invoice_id = 1

-- CREATE OR REPLACE VIEW invoices_with_balance AS 
-- SELECT
-- 	invoice_id,
--     number,
--     client_id,
--     invoice_total,
--     payment_total,
--     invoice_total - payment_total AS balance,
--     invoice_date,
--     due_date,
--     payment_date
-- FROM invoices
-- WHERE (invoice_total - payment_total) > 0

-- if the view doesn't have any of the list below, that view is an UPDATABLE VIEW:
-- DISTINCT
-- Aggregate Functions
-- GROUP BY / HAVING
-- UNION



-- Dropping Views

-- CREATE OR REPLACE VIEW sales_by_client AS -- save Views in SQL files and put them on source control as a best practice
-- SELECT
-- 	c.client_id,
--     c.name,
--     SUM(invoice_total) AS total_sales
-- FROM clients c
-- JOIN invoices i USING (client_id)
-- GROUP BY client_id, name

-- DROP VIEW sales_by_client



-- Creating Views

-- USE sql_invoicing;

-- CREATE VIEW clients_balance AS 
-- SELECT
-- 	c.client_id,
--     c.name,
--     SUM(i.invoice_total - i.payment_total) AS balance
-- FROM clients c
-- JOIN invoices i USING (client_id)
-- GROUP BY c.client_id, name

-- SELECT *
-- FROM sales_by_client
-- JOIN clients USING (client_id)

-- CREATE VIEW sales_by_client AS 
-- SELECT
-- 	c.client_id,
--     c.name,
--     SUM(invoice_total) AS total_sales
-- FROM clients c
-- JOIN invoices i USING (client_id)
-- GROUP BY client_id, name


-- -------------------------------------------------------------------------------------------------------------------


-- CASE Operator

-- SELECT
-- 	CONCAT(first_name, ' ', last_name) AS customer,
--     points,
--     CASE
-- 		WHEN points > 3000 THEN 'Gold'
--         WHEN points >= 2000 THEN 'Silver'
--         ELSE 'Bronze'
-- 	END AS category
-- FROM customers

-- SELECT
-- 	order_id,
--     order_date,
--     CASE
-- 		WHEN YEAR(order_date) = YEAR('2019-01-01') THEN 'Active'
--         WHEN YEAR(order_date) = YEAR('2019-01-01') - 1 THEN 'Last Year'
--         WHEN YEAR(order_date) < YEAR('2019-01-01') - 1 THEN 'Archived'
--         ELSE 'Future'
-- 	END AS category
-- FROM orders



-- IF Function

-- SELECT
-- 	product_id,
--     name,
--     COUNT(*) AS orders,
--     IF(COUNT(*) > 1, 'Many times', 'Once') AS frequency
-- FROM products
-- JOIN order_items USING (product_id)
-- GROUP BY product_id

-- SELECT
-- 	order_id,
--     order_date,
--     IF(YEAR(order_date) = YEAR('2019-01-01'), 'Active', 'Archive') AS category
-- FROM orders



-- IFNULL and COALESCE Functions

-- USE sql_store;

-- SELECT 
-- 	CONCAT(first_name, ' ', last_name) AS customer,
--     IFNULL(phone, 'Unknown') AS phone -- or COALESCE(phone, 'Unknown')
-- FROM customers

-- SELECT 
-- 	order_id,
--     COALESCE(shipper_id, comments, 'Not assigned') AS shipper -- returns the first non-null value in the list e.g. shipper_id and commentsclients
--     -- IFNULL(shipper_id, 'Not assigned') AS shipper
-- FROM orders



-- Calculating Dates and Times

-- SELECT DATE_ADD(NOW(), INTERVAL 1 YEAR) -- (NOW(), INTERVAL 1 DAY/YEAR)
-- SELECT DATE_SUB(NOW(), INTERVAL 1 DAY) -- or DATE_ADD(NOW(), INTERVAL -1 DAY)
-- SELECT DATEDIFF('2019-01-05', '2019-01-01') -- 4 returns the day
-- SELECT TIME_TO_SEC('09:00') - TIME_TO_SEC('09:02')



-- Formatting Dates and Times

-- SELECT DATE_FORMAT(NOW(), '%M %D %Y') -- '2019-03-23' search for "mysql date format string"
-- SELECT TIME_FORMAT(NOW(), '%H:%i %p')



-- Date Functions 

-- SELECT NOW(), CURDATE(), CURTIME()
-- SELECT YEAR(NOW()) -- MONTH/DAY/HOUR/MINUTE/SECOND() returns int
-- SELECT MONTHNAME(NOW()) -- DAYNAME() returns string
-- SELECT EXTRACT(YEAR FROM NOW())
-- SELECT *
-- FROM orders
-- WHERE YEAR(order_date) <= YEAR(NOW())



-- String Functions

-- SELECT LENGTH('sky') -- returns the length of string
-- UPPER() returns the uppercase
-- LOWER() returns the lowercase
-- SELECT LTRIM('    Sky') -- clears the spaces on the left side RTRIM for the opposite side; TRIM() for the all sides
-- SELECT LEFT('Kindergarten', 6) -- returns all characters from the left up to the given number, RIGHT() for all chars from the right
-- SELECT SUBSTRING('Kindergarten', 3, 5) -- nderg returns all characters from char 3 and 5 chars afterwards
-- SELECT LOCATE('n', 'Kindergarten') -- 3 returns the placement of the n which is 3; LOCATE('garten') returns 7
-- SELECT REPLACE('Kindergarten', 'garten', 'garden') -- Kindergarden
-- SELECT CONCAT('first', 'last') -- firstlast



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