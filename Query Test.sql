-- IMPLICIT CROSS JOIN
SELECT
	p.name AS products,
    sh.name AS shipper
FROM products p, shippers sh

-- EXPLICIT CROSS JOIN
-- SELECT
-- 	p.name AS products,
--     sh.name AS shipper
-- FROM products p
-- CROSS JOIN shippers sh

-- SELECT
-- 	c.first_name AS customer,
--     p.name AS product
-- FROM customers c -- adding (, products p) is IMPLICIT CROSS JOIN
-- CROSS JOIN products p -- EXPLICIT CROSS JOIN
-- ORDER BY c.first_name