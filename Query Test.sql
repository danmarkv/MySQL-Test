SELECT
	name,
    unit_price,
    unit_price * 1.1 AS new_price
FROM products

/*
SELECT DISTINCT state, customer_id
FROM customers
*/

/*
SELECT 
	last_name, 
    first_name, 
    points, 
    (points + 10) * 100 AS discount_factor
FROM customers
*/
