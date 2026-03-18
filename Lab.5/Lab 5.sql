-- 1. Видаляємо старі таблиці, якщо вони є (щоб не було помилок)
DROP TABLE IF EXISTS payment CASCADE;
DROP TABLE IF EXISTS booking CASCADE;
DROP TABLE IF EXISTS room CASCADE;
DROP TABLE IF EXISTS guest CASCADE;
DROP TABLE IF EXISTS room_type CASCADE;

-- 2. Створюємо таблиці у 3-й нормальній формі (3NF)
CREATE TABLE room_type (
    type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    description TEXT,
    base_price NUMERIC(8,2) NOT NULL CHECK (base_price > 0)
);

CREATE TABLE guest (
    guest_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    surname VARCHAR(50) NOT NULL,
    passport_details VARCHAR(50) UNIQUE NOT NULL,
    phone VARCHAR(20),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE room (
    room_id SERIAL PRIMARY KEY,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    status VARCHAR(20) DEFAULT 'вільний',
    type_id INTEGER REFERENCES room_type(type_id) ON DELETE RESTRICT
);

CREATE TABLE booking (
    booking_id SERIAL PRIMARY KEY,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    booking_status VARCHAR(20) DEFAULT 'підтверджено',
    guest_id INTEGER REFERENCES guest(guest_id) ON DELETE CASCADE,
    room_id INTEGER REFERENCES room(room_id) ON DELETE RESTRICT,
    CONSTRAINT chk_dates CHECK (check_out_date > check_in_date)
);

CREATE TABLE payment (
    payment_id SERIAL PRIMARY KEY,
    amount NUMERIC(8,2) NOT NULL CHECK (amount > 0),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    booking_id INTEGER REFERENCES booking(booking_id) ON DELETE CASCADE
);

-- 3. Додаємо тестові дані
INSERT INTO room_type (type_name, description, base_price) VALUES 
('Стандарт', 'Звичайний номер для двох', 1500.00),
('Люкс', 'Номер підвищеного комфорту', 3000.00);

INSERT INTO guest (name, surname, passport_details, phone, email) VALUES 
('Олександр', 'Іванов', 'AB123456', '+380501234567', 'ivanov@email.com'),
('Марія', 'Петренко', 'CD987654', '+380679876543', 'maria.p@email.com');

INSERT INTO room (room_number, status, type_id) VALUES 
('101', 'вільний', 1),
('205', 'зайнятий', 2);

INSERT INTO booking (check_in_date, check_out_date, booking_status, guest_id, room_id) VALUES 
('2026-05-01', '2026-05-05', 'підтверджено', 1, 1),
('2026-05-10', '2026-05-12', 'завершено', 2, 2);

INSERT INTO payment (amount, booking_id) VALUES 
(6000.00, 1),
(6000.00, 2);

-- 4. ВИВОДИМО ДАНІ В КОНСОЛЬ! 
SELECT 
    b.booking_id AS "№ Бронювання",
    g.name || ' ' || g.surname AS "Гість",
    r.room_number AS "Кімната",
    rt.type_name AS "Категорія",
    b.check_in_date AS "Дата заїзду",
    b.check_out_date AS "Дата виїзду"
FROM booking b
JOIN guest g ON b.guest_id = g.guest_id
JOIN room r ON b.room_id = r.room_id
JOIN room_type rt ON r.type_id = rt.type_id;