const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  console.log("=== Початок тестування нової бази даних ===");

  // 1. Створюємо кімнату (бо ми скидали базу, вона зараз порожня)
  const newRoom = await prisma.room.create({
    data: {
      room_number: "101-VIP",
      status: "вільний"
    }
  });
  
  // 2. Створюємо гостя з новим полем is_vip
  const newGuest = await prisma.guest.create({
    data: {
      name: "Олександр",
      surname: "Тестовий",
      passport_details: "AB123456",
      is_vip: true // Тестуємо наше нове поле!
    }
  });

  console.log(`✅ Створено гостя VIP: ${newGuest.name} ${newGuest.surname}`);

  // 3. Додаємо відгук у нашу НОВУ таблицю review
  const newReview = await prisma.review.create({
    data: {
      rating: 5,
      comment: "Чудовий готель, міграції Prisma працюють ідеально!",
      guest_id: newGuest.guest_id,
      room_id: newRoom.room_id
    }
  });
  console.log("\n✅ Додано новий відгук:");
  console.log(newReview);

  // 4. Виводимо всі відгуки
  const allReviews = await prisma.review.findMany({
    include: {
      guest: true,
      room: true
    }
  });
  console.log("\n📋 Всі відгуки в базі даних:");
  console.dir(allReviews, { depth: null });

  console.log("\n=== Тестування завершено успішно ===");
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });