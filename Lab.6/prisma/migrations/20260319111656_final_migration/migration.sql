-- CreateTable
CREATE TABLE "room_type" (
    "type_id" SERIAL NOT NULL,
    "type_name" VARCHAR(50) NOT NULL,
    "base_price" DECIMAL(8,2) NOT NULL,

    CONSTRAINT "room_type_pkey" PRIMARY KEY ("type_id")
);

-- CreateTable
CREATE TABLE "guest" (
    "guest_id" SERIAL NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "surname" VARCHAR(50) NOT NULL,
    "passport_details" VARCHAR(50) NOT NULL,
    "phone" VARCHAR(20),
    "email" VARCHAR(100),
    "is_vip" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "guest_pkey" PRIMARY KEY ("guest_id")
);

-- CreateTable
CREATE TABLE "room" (
    "room_id" SERIAL NOT NULL,
    "room_number" VARCHAR(10) NOT NULL,
    "status" VARCHAR(20) DEFAULT 'вільний',
    "type_id" INTEGER,

    CONSTRAINT "room_pkey" PRIMARY KEY ("room_id")
);

-- CreateTable
CREATE TABLE "booking" (
    "booking_id" SERIAL NOT NULL,
    "check_in_date" DATE NOT NULL,
    "check_out_date" DATE NOT NULL,
    "booking_status" VARCHAR(20) DEFAULT 'підтверджено',
    "guest_id" INTEGER,
    "room_id" INTEGER,

    CONSTRAINT "booking_pkey" PRIMARY KEY ("booking_id")
);

-- CreateTable
CREATE TABLE "payment" (
    "payment_id" SERIAL NOT NULL,
    "amount" DECIMAL(8,2) NOT NULL,
    "payment_date" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "booking_id" INTEGER,

    CONSTRAINT "payment_pkey" PRIMARY KEY ("payment_id")
);

-- CreateTable
CREATE TABLE "review" (
    "review_id" SERIAL NOT NULL,
    "rating" INTEGER NOT NULL,
    "comment" TEXT,
    "guest_id" INTEGER NOT NULL,
    "room_id" INTEGER NOT NULL,

    CONSTRAINT "review_pkey" PRIMARY KEY ("review_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "guest_passport_details_key" ON "guest"("passport_details");

-- CreateIndex
CREATE UNIQUE INDEX "guest_email_key" ON "guest"("email");

-- CreateIndex
CREATE UNIQUE INDEX "room_room_number_key" ON "room"("room_number");

-- AddForeignKey
ALTER TABLE "room" ADD CONSTRAINT "room_type_id_fkey" FOREIGN KEY ("type_id") REFERENCES "room_type"("type_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "booking" ADD CONSTRAINT "booking_guest_id_fkey" FOREIGN KEY ("guest_id") REFERENCES "guest"("guest_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "booking" ADD CONSTRAINT "booking_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "room"("room_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment" ADD CONSTRAINT "payment_booking_id_fkey" FOREIGN KEY ("booking_id") REFERENCES "booking"("booking_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "review" ADD CONSTRAINT "review_guest_id_fkey" FOREIGN KEY ("guest_id") REFERENCES "guest"("guest_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "review" ADD CONSTRAINT "review_room_id_fkey" FOREIGN KEY ("room_id") REFERENCES "room"("room_id") ON DELETE CASCADE ON UPDATE CASCADE;
