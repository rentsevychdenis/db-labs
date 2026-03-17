-- Додавання нових даних (INSERT)

-- Додаємо нову категорію
INSERT INTO room_type (type_name, description, base_price) 
VALUES ('Economy', 'Бюджетний варіант без вікна', 600.00);

-- Додаємо нового гостя
INSERT INTO guest (name, surname, passport_details, phone, email) 
VALUES ('Анна', 'Шевченко', 'TT998877', '+380990001122', 'shevchenko@example.com');

-- Додаємо нову кімнату
INSERT INTO room (room_number, status, type_id) 
VALUES ('402', 'вільний', 4);

-- Додаємо нове бронювання
INSERT INTO booking (check_in_date, check_out_date, booking_status, guest_id, room_id) 
VALUES ('2026-06-15', '2026-06-20', 'підтверджено', 4, 4);

-- Додаємо новий платіж
INSERT INTO payment (amount, payment_date, booking_id) 
VALUES (3000.00, '2026-06-10 09:00:00', 4);

-- Вибірка даних (SELECT)

-- Отримання контактів конкретного гостя
SELECT name, surname, phone, email 
FROM guest 
WHERE name = 'Анна';

-- Пошук усіх вільних номерів
SELECT room_number, status 
FROM room 
WHERE status = 'вільний';

-- Перевірка платежів, сума яких більша за 2000
SELECT payment_id, amount, payment_date 
FROM payment 
WHERE amount > 2000;

-- Оновлення даних (UPDATE)

-- Змінюємо статус кімнати (наприклад, гість заїхав у номер 402)
UPDATE room 
SET status = 'зайнятий' 
WHERE room_number = '402';

-- Оновлюємо номер телефону гостя з конкретним паспортом
UPDATE guest 
SET phone = '+380991112233' 
WHERE passport_details = 'TT998877';

-- Безпечне видалення (DELETE)

-- 1. Видаляємо платіж
DELETE FROM payment WHERE booking_id = 4;

-- 2. Видаляємо бронювання
DELETE FROM booking WHERE booking_id = 4;

-- 3. Видаляємо гостя
DELETE FROM guest WHERE passport_details = 'TT998877';