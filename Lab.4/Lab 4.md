<div align="center">
  <strong>Міністерство освіти і науки України</strong><br>
  <strong>Національний технічний університет України</strong><br>
  <strong>«Київський політехнічний інститут імені Ігоря Сікорського»</strong><br><br>
  
  <h2>Лабораторна робота №4</h2>
  <h3>«Аналітичні SQL-запити (OLAP)»</h3><br>
  
  Київ 2026
</div>

<br>

**Роботу виконали:**
Студенти групи ІО-45, ІО-43
Ренцевич Д., Гапон А.

**Роботу перевірив:**
Русінов В.В.

---

## ЛАБОРАТОРНА РОБОТА № 4

**Тема:** Аналітичні SQL-запити (OLAP)

**Мета:** Набути практичних навичок написання аналітичних SQL-запитів (OLAP) для підсумовування тенденцій та створення звітів на базі розробленої схеми бази даних у PostgreSQL. Навчитися обчислювати зведену статистику за допомогою агрегатних функцій, групувати дані (GROUP BY), фільтрувати агреговані результати (HAVING), а також виконувати багатотабличні об'єднання (JOIN).

**Завдання:**

* Написати мінімум 4 запити, що містять агрегаційні функції (SUM, AVG, COUNT, MIN, MAX, GROUP BY).

* Написати мінімум 3 запити, що використовують різні типи джоінів (наприклад, INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN, CROSS JOIN) для об'єднання даних з кількох таблиць.

* Написати мінімум 3 запити з використанням підзапитів (вибірка з підзапитом у SELECT, WHERE, або HAVING).

* Виконати створені запити в PostgreSQL (pgAdmin) для власної бази даних та перевірити правильність виводу.

### Агрегаційні функції (SUM, AVG, COUNT, MIN, MAX, GROUP BY)

```SQL
-- 1. Підрахунок кількості кімнат за їхнім статусом (вільний, зайнятий, прибирання)
SELECT status, COUNT(*) AS rooms_count
FROM room
GROUP BY status;


-- 2. Загальна сума доходу від усіх проведених платежів
SELECT SUM(amount) AS total_revenue
FROM payment;


-- 3. Середня, мінімальна та максимальна базова вартість типів номерів
SELECT
   AVG(base_price) AS avg_price,
   MIN(base_price) AS min_price,
   MAX(base_price) AS max_price
FROM room_type;


-- 4. Загальна сума платежів по кожному бронюванню з фільтрацією (тільки ті, де сума > 2000)
SELECT booking_id, SUM(amount) AS total_paid
FROM payment
GROUP BY booking_id
HAVING SUM(amount) > 2000;
```

### Запити з використанням JOIN (INNER JOIN, LEFT JOIN, RIGHT JOIN):

```SQL
-- 5. INNER JOIN: Отримання списку гостей та дат їхніх бронювань
SELECT g.name, g.surname, b.check_in_date, b.check_out_date, b.booking_status
FROM guest g
INNER JOIN booking b ON g.guest_id = b.guest_id;


-- 6. LEFT JOIN: Виведення всіх типів номерів та кімнат, які до них належать
-- (навіть якщо для певного типу ще не додано жодної кімнати)
SELECT rt.type_name, r.room_number, r.status
FROM room_type rt
LEFT JOIN room r ON rt.type_id = r.type_id;


-- 7. RIGHT JOIN: Виведення всіх бронювань і прив'язаних до них платежів
-- (включаючи бронювання, які ще очікують оплати і не мають платежів)
SELECT b.booking_id, b.check_in_date, p.payment_id, p.amount
FROM payment p
RIGHT JOIN booking b ON p.booking_id = b.booking_id;
```

### Запити з використанням підзапитів (SELECT, WHERE, HAVING):

```SQL
-- 8. Підзапит у WHERE: Знайти платежі, сума яких перевищує середню суму платежу по всьому готелю
SELECT payment_id, amount, payment_date
FROM payment
WHERE amount > (SELECT AVG(amount) FROM payment);


-- 9. Підзапит у SELECT: Вивести імена всіх гостей і кількість їхніх бронювань окремою колонкою
SELECT
   name,
   surname,
   (SELECT COUNT(*) FROM booking b WHERE b.guest_id = g.guest_id) AS total_bookings
FROM guest g;


-- 10. Підзапит у HAVING: Знайти типи номерів (ID), де кількість наявних кімнат більша,
-- ніж середня кількість кімнат, що припадає на кожен тип.
SELECT type_id, COUNT(room_id) AS room_count
FROM room
GROUP BY type_id
HAVING COUNT(room_id) >= (
   SELECT AVG(cnt)
   FROM (SELECT COUNT(room_id) AS cnt FROM room GROUP BY type_id) sub
);
```

### Висновок:
Під час виконання лабораторної роботи №4 було набуто практичних навичок написання та виконання аналітичних SQL-запитів (OLAP) у СУБД PostgreSQL на базі розробленої реляційної схеми «Готель». На практиці було закріплено використання агрегатних функцій (SUM, AVG, COUNT, MIN, MAX) спільно з операторами GROUP BY та HAVING для обчислення зведеної статистики та фільтрації згрупованих даних. Крім того, успішно реалізовано вибірку даних з кількох пов'язаних таблиць за допомогою різних типів об'єднань (INNER JOIN, LEFT JOIN, RIGHT JOIN) , а також побудовано складні багаторівневі запити з використанням підзапитів у конструкціях SELECT, WHERE та HAVING. Виконані завдання дозволили перетворити початкові "сирі" дані бази на змістовну аналітичну інформацію, яка є основою для формування звітів та підсумовування тенденцій.


