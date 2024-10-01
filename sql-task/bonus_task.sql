-- Для интеграции с внешней системой, добавим поля статуса оплаты и отгрузки в таблицу invoices:

ALTER TABLE invoices ADD COLUMN payment_status VARCHAR(50) DEFAULT 'Не оплачено';
ALTER TABLE invoices ADD COLUMN shipment_status VARCHAR(50) DEFAULT 'Не отгружено';

-- Индексы
CREATE INDEX idx_payment_status ON invoices (payment_status);
CREATE INDEX idx_shipment_status ON invoices (shipment_status);

-- Выборки
SELECT *
FROM invoices
WHERE payment_status = 'Полностью оплачено'
  AND shipment_status = 'Не отгружено';

SELECT *
FROM invoices
WHERE payment_status = 'Не оплачено'
  AND shipment_status = 'Отгружено';

SELECT *
FROM invoices
WHERE payment_status IN ('Не оплачено', 'Частично оплачено')
   OR shipment_status = 'Не отгружено';

-- Дополнительные метрики
-- Процент оплаченных счетов
SELECT 
    (COUNT(*) FILTER (WHERE payment_status = 'Полностью оплачено') * 100.0 / COUNT(*)) AS percent_fully_paid_invoices
FROM invoices;

-- Среднее время оплаты счета
SELECT 
    AVG(payment_date - issue_date) AS average_days_to_payment
FROM invoices
INNER JOIN invoice_payments ON invoices.invoice_id = invoice_payments.invoice_id
WHERE invoices.payment_status = 'Полностью оплачено';

-- Общая сумма неоплаченных счетов
SELECT 
    SUM(total_amount) AS total_unpaid_invoices
FROM invoices
WHERE payment_status = 'Не оплачено';

