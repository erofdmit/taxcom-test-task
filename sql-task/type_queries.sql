-- Последние 20 счетов, выставленных менеджером
SELECT *
FROM invoices
WHERE manager_id = <MANAGER_ID>
ORDER BY issue_date DESC
LIMIT 20;


-- Счета за календарные метрики
-- За прошлую неделю
SELECT *
FROM invoices
WHERE issue_date BETWEEN current_date - INTERVAL '1 week' AND current_date;

-- За прошлый месяц
SELECT *
FROM invoices
WHERE issue_date BETWEEN current_date - INTERVAL '1 month' AND current_date;

-- За прошлый год
SELECT *
FROM invoices
WHERE issue_date BETWEEN current_date - INTERVAL '1 year' AND current_date;


-- Поиск всех счетов по контрагенту
SELECT *
FROM invoices
WHERE counterparty_id = <COUNTERPARTY_ID>;


-- Поиск счета по номеру
SELECT *
FROM invoices
WHERE invoice_number = '<INVOICE_NUMBER>';


-- Открытие счета
INSERT INTO invoices (
    invoice_number,
    counterparty_id,
    manager_id,
    issue_date,
    total_amount,
    description
) VALUES (
    '<INVOICE_NUMBER>',           -- Номер счета
    1,                   -- Идентификатор контрагента
    2,                   -- Идентификатор менеджера
    '2024-10-01',        -- Дата выставления счета
    1000.00,             -- Сумма счета
    'Оплата за услуги'   -- Описание счета
)
