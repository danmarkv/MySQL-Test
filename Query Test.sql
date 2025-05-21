CREATE TABLE invoice_archived AS
SELECT
	i.invoice_id,
    i.number,
    c.name,
    i.invoice_total,
    i.payment_total,
    i.invoice_date,
    i.due_date,
    i.payment_date
FROM invoices i
LEFT JOIN clients c
	ON i.client_id = c.client_id -- use USING (client_id)
WHERE payment_date -- can also use (IS NOT NULL)