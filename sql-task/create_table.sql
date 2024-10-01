-- Таблица "Контрагенты"
CREATE TABLE counterparties (
    counterparty_id SERIAL PRIMARY KEY,        -- Уникальный идентификатор контрагента
    name VARCHAR(255) NOT NULL,                -- Имя контрагента
    registration_date DATE NOT NULL            -- Дата регистрации контрагента в системе
);

-- Таблица "Менеджеры" 
CREATE TABLE managers (
    manager_id SERIAL PRIMARY KEY,             -- Уникальный идентификатор менеджера
    name VARCHAR(255) NOT NULL                 -- Имя менеджера
);

-- Таблица "Счета"
CREATE TABLE invoices (
    invoice_id SERIAL PRIMARY KEY,             -- Уникальный идентификатор счета
    invoice_number VARCHAR(50) NOT NULL,       -- Номер счета (может повторяться в разные периоды)
    counterparty_id INT NOT NULL,              -- Ссылка на контрагента (foreign key на counterparties.counterparty_id)
    manager_id INT NOT NULL,                   -- Ссылка на менеджера (foreign key на managers.manager_id)
    issue_date DATE NOT NULL,                  -- Дата выставления счета
    total_amount DECIMAL(12, 2) NOT NULL,      -- Сумма счета
    description TEXT,                          -- Описание или детали счета
    PRIMARY KEY (invoice_id),
    FOREIGN KEY (counterparty_id) REFERENCES counterparties(counterparty_id),
    FOREIGN KEY (manager_id) REFERENCES managers(manager_id),
    
    INDEX idx_invoice_number (invoice_number),          -- Индекс по номеру счета
    INDEX idx_invoice_date (issue_date),                -- Индекс по дате счета
    INDEX idx_invoice_counterparty (counterparty_id),   -- Индекс по контрагенту
    INDEX idx_invoice_manager (manager_id)              -- Индекс по менеджеру
);

-- Таблица "Оплата счета" 
CREATE TABLE invoice_payments (
    payment_id SERIAL PRIMARY KEY,             -- Уникальный идентификатор записи об оплате
    invoice_id INT NOT NULL,                   -- Ссылка на счет (foreign key на invoices.invoice_id)
    payment_date DATE NOT NULL,                -- Дата оплаты
    payment_amount DECIMAL(12, 2) NOT NULL,    -- Сумма оплаты
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id),
    
    INDEX idx_payment_invoice_id (invoice_id),        -- Индекс по идентификатору счета
    INDEX idx_payment_date (payment_date)             -- Индекс по дате оплаты
);

-- Таблица "Отгрузки счета"
CREATE TABLE invoice_shipments (
    shipment_id SERIAL PRIMARY KEY,            -- Уникальный идентификатор отгрузки
    invoice_id INT NOT NULL,                   -- Ссылка на счет (foreign key на invoices.invoice_id)
    shipment_date DATE NOT NULL,               -- Дата отгрузки
    shipment_status VARCHAR(50) NOT NULL,      -- Статус отгрузки (например, 'Отгружено', 'В ожидании')
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id),
    
    INDEX idx_shipment_invoice_id (invoice_id),         -- Индекс по идентификатору счета
    INDEX idx_shipment_date (shipment_date)             -- Индекс по дате отгрузки
);

-- Индексы созданы только в таблицах, наполнение которых подразумевает большое количество данных, для ускорения запросов