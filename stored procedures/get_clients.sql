DROP PROCEDURE IF EXISTS get_clients -- it's good practice to move stored procedures to separate files

DELIMITER $$
CREATE PROCEDURE get_clients()
BEGIN
	SELECT * FROM clients;
END$$
DELIMITER ;