<div align="center">
  <strong>Міністерство освіти і науки України</strong><br>
  <strong>Національний технічний університет України</strong><br>
  <strong>«Київський політехнічний інститут імені Ігоря Сікорського»</strong><br><br>
  
  <h2>Лабораторна робота №6</h2>
  <h3>«Міграції схем за допомогою Prisma ORM»</h3><br>
  
  Київ 2026
</div>

<br>

**Роботу виконали:**
Студенти групи ІО-45, ІО-43
Ренцевич Д., Гапон А.

**Роботу перевірив:**
Русінов В.В.

---

## 1. Додавання нової таблиці `review`

**Що змінилося:** Було створено абсолютно нову таблицю `review` для зберігання відгуків гостей. Вона містить оцінку (`rating`), текстовий коментар (`comment`), а також зовнішні ключі для зв'язку з таблицями `guest` (хто залишив відгук) та `room` (про яку кімнату). Також додано відповідні зв'язки (relations) у існуючі моделі `guest` та `room`.

**Схема до:**
*(Модель `review` не існувала)*

**Схема після:**
```prisma
model review {
  review_id Int     @id @default(autoincrement())
  rating    Int
  comment   String?
  guest_id  Int
  room_id   Int
  guest     guest   @relation(fields: [guest_id], references: [guest_id], onDelete: Cascade)
  room      room    @relation(fields: [room_id], references: [room_id], onDelete: Cascade)
}
```

## 2. Додавання поля is_vip до таблиці guest

**Що змінилося:** Для ідентифікації особливих клієнтів у таблицю guest було додано нове поле is_vip логічного типу (Boolean). Щоб не порушити існуючі дані, для поля встановлено значення за замовчуванням false.

**Схема до:**
```prisma
model guest {
  guest_id         Int       @id @default(autoincrement())
  name             String    @db.VarChar(50)
  surname          String    @db.VarChar(50)
  passport_details String    @unique @db.VarChar(50)
  phone            String?   @db.VarChar(20)
  email            String?   @unique @db.VarChar(100)
  booking          booking[]
}
```

**Схема після:**
```prisma
model guest {
  guest_id         Int       @id @default(autoincrement())
  name             String    @db.VarChar(50)
  surname          String    @db.VarChar(50)
  passport_details String    @unique @db.VarChar(50)
  phone            String?   @db.VarChar(20)
  email            String?   @unique @db.VarChar(100)
  is_vip           Boolean   @default(false) // Нове поле
  booking          booking[]
  review           review[]  // Зв'язок з новою таблицею
}
```

## 3. Видалення поля description з таблиці room_type

**Що змінилося:** Задля оптимізації структури бази даних з таблиці room_type було видалено зайве поле description.

**Схема до:**
```prisma
model room_type {
  type_id     Int       @id @default(autoincrement())
  type_name   String    @db.VarChar(50)
  description String?   @db.Text
  base_price  Decimal   @db.Decimal(8, 2)
  room        room[]
}
```

**Схема після:**
```prisma
model room_type {
  type_id    Int       @id @default(autoincrement())
  type_name  String    @db.VarChar(50)
  base_price Decimal   @db.Decimal(8, 2)
  room       room[]
}
```