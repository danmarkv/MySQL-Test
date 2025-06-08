CREATE OR REPLACE VIEW sales_by_client AS -- save Views in SQL files and put them on source control as a best practice
SELECT
	c.client_id,
    c.name,
    SUM(invoice_total) AS total_sales
FROM clients c
JOIN invoices i USING (client_id)
GROUP BY client_id, name