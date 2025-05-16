SELECT *
FROM customers
-- WHERE first_name REGEXP 'elka|ambur' -- OR first_name REGEXP 'ambur'  -- use elka|ambur
-- WHERE last_name REGEXP 'ey$|on$' -- OR last_name REGEXP 'on$' -- use |
WHERE last_name REGEXP '^my|se' -- OR last_name REGEXP 'se' use |
-- WHERE last_name REGEXP 'b[ru]' -- or use br|bu

-- SELECT *
-- FROM customers
-- WHERE last_name REGEXP '[gim]e'
-- WHERE last_name REGEXP 'field|mac' -> finding multiple words
-- WHERE last_name LIKE '%field' -> the same REGEXP 'field'

-- ^ beginning
-- $ end
-- | logical or
-- [abcd] match any single character listed inside
-- [a-h] ranged of characters
 