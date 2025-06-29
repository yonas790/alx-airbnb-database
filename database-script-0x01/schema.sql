
CREATE TYPE "role" AS ENUM (
  'guest',
  'host',
  'admin'
);

CREATE TYPE "booking_status" AS ENUM (
  'pending',
  'confirmed',
  'canceled'
);

CREATE TYPE "payment_method" AS ENUM (
  'credit_card',
  'paypal',
  'stripe'
);

CREATE TABLE IF NOT EXISTS "users" (
  "user_id" uuid PRIMARY KEY,
  "first_name" varchar NOT NULL,
  "last_name" varchar NOT NULL,
  "email" varchar UNIQUE NOT NULL,
  "password_hash" varchar NOT NULL,
  "phone_number" varchar,
  "role" role NOT NULL,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS "properties" (
  "property_id" uuid PRIMARY KEY,
  "host_id" uuid,
  "name" varchar NOT NULL,
  "description" text NOT NULL,
  "location" uuid,
  "pricepernight" decimal NOT NULL,
  "created_at" timestamp DEFAULT (now()),
  "updated_at" timestamp
);

CREATE TABLE IF NOT EXISTS "locations" (
  "location_id" uuid PRIMARY KEY,
  "country" varchar NOT NULL,
  "state" varchar,
  "city" varchar,
  "postal_code" varchar,
  "lat" decimal NOT NULL,
  "lng" decimal NOT NULL
);

CREATE TABLE IF NOT EXISTS "bookings" (
  "booking_id" uuid PRIMARY KEY,
  "property_id" uuid,
  "user_id" uuid,
  "start_date" date NOT NULL,
  "end_date" date NOT NULL,
  "total_price" decimal NOT NULL,
  "status" booking_status NOT NULL,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS "payments" (
  "payment_id" uuid PRIMARY KEY,
  "booking_id" uuid,
  "amount" decimal NOT NULL,
  "payment_date" timestamp DEFAULT (now()),
  "payment_method" payment_method NOT NULL
);

CREATE TABLE IF NOT EXISTS "reviews" (
  "review_id" uuid PRIMARY KEY,
  "property_id" uuid,
  "user_id" uuid,
  "rating" integer NOT NULL,
  "comment" text NOT NULL,
  "created_at" timestamp DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS "messages" (
  "message_id" uuid PRIMARY KEY,
  "sender_id" uuid,
  "recipient_id" uuid,
  "message_body" text NOT NULL,
  "sent_at" timestamp DEFAULT (now())
);

CREATE INDEX IF NOT EXISTS "idx_user_email" ON "users" ("email");

CREATE INDEX IF NOT EXISTS "idx_property_location" ON "properties" ("location");

CREATE INDEX IF NOT EXISTS "idx_property_host" ON "properties" ("host_id");

CREATE INDEX IF NOT EXISTS "idx_booking_guest" ON "bookings" ("user_id");

CREATE INDEX IF NOT EXISTS "idx_booking_property" ON "bookings" ("property_id");

CREATE INDEX IF NOT EXISTS "idx_payment_booking" ON "payments" ("booking_id");


COMMENT ON COLUMN "properties"."updated_at" IS 'On Update set `now()';

COMMENT ON COLUMN "reviews"."rating" IS '1 < value < 5';

ALTER TABLE "properties" ADD FOREIGN KEY ("host_id") REFERENCES "users" ("user_id");

ALTER TABLE "properties" ADD FOREIGN KEY ("location") REFERENCES "locations" ("location_id");

ALTER TABLE "bookings" ADD FOREIGN KEY ("property_id") REFERENCES "properties" ("property_id");

ALTER TABLE "bookings" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "payments" ADD FOREIGN KEY ("booking_id") REFERENCES "bookings" ("booking_id");

ALTER TABLE "reviews" ADD FOREIGN KEY ("property_id") REFERENCES "properties" ("property_id");

ALTER TABLE "reviews" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "messages" ADD FOREIGN KEY ("sender_id") REFERENCES "users" ("user_id");

ALTER TABLE "messages" ADD FOREIGN KEY ("recipient_id") REFERENCES "users" ("user_id");
