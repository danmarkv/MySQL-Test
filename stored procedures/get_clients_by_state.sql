DROP PROCEDURE IF EXISTS get_clients_by_state -- it's good practice to move stored procedures to separate files

DELIMITER $$
CREATE PROCEDURE get_clients_by_state
(
	state CHAR(2)
)
BEGIN
	SELECT * FROM clients c
    WHERE c.state = state;
END$$
DELIMITER ;