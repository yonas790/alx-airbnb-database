
-- Extension to support uuid_generate_v4() function
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Insert locations
INSERT INTO "locations" (location_id, country, state, city, postal_code, lat, lng) VALUES
	(uuid_generate_v4(), 'Ethiopia', 'Addis Ababa', 'Addis Ababa', '1000', 9.03, 38.74),
	(uuid_generate_v4(), 'Ethiopia', 'Amahara', 'Bahir Dar', '6000', 11.59364, 37.39077);

-- Insert users with different roles
INSERT INTO users (user_id, first_name, last_name, email, password_hash, phone_number, role) VALUES
    (uuid_generate_v4(), 'Yonas', 'Tesera', 'yonas@example.com', 'hashed_password_1', '+1234567890', 'host'),
    (uuid_generate_v4(), 'Kirubel', 'Alehegn', 'kirubel@example.com', 'hashed_password_2', '+9876543210', 'guest'),
    (uuid_generate_v4(), 'Rezina', 'Henok', 'rezina@example.com', 'hashed_password_3', '+1122334455', 'host'),
    (uuid_generate_v4(), 'Wubamlak', 'Mengesha', 'wubamlak@example.com', 'hashed_password_4', '+5544332211', 'guest'),
    (uuid_generate_v4(), 'Teshager', 'Mezigebu', 'teshe@example.com', 'hashed_password_5', '+9988776655', 'admin');

-- Insert properties
INSERT INTO properties (property_id, host_id, name, description, location, pricepernight) VALUES
    (uuid_generate_v4(), 
     (SELECT user_id FROM users WHERE first_name = 'Yonas'), 
     'Sharaton', 
     'Beautiful downtown loft with amazing city views', 
     (SELECT location_id FROM locations WHERE city = 'Addis Ababa'), 
     7000.00),
    (uuid_generate_v4(), 
     (SELECT user_id FROM users WHERE first_name = 'Kirubel'), 
     'EBS Studio Apartment', 
     'Modern studio in the heart of Bole', 
     (SELECT location_id FROM locations WHERE city = 'Addis Ababa'), 
     10000.00),
    (uuid_generate_v4(), 
     (SELECT user_id FROM users WHERE first_name = 'Yonas'), 
     'City View Condo', 
     'Spacious condo with panoramic lake views', 
     (SELECT location_id FROM locations WHERE city = 'Bahir Dar'), 
     40000.00);

-- Insert bookings
INSERT INTO bookings (booking_id, property_id, user_id, start_date, end_date, total_price, status) VALUES
    (uuid_generate_v4(), 
     (SELECT property_id FROM properties WHERE name = 'sharaton'), 
     (SELECT user_id FROM users WHERE first_name = 'Rezina'), 
     '2025-06-25', '2025-06-30', 14000.00, 'confirmed'),
    (uuid_generate_v4(), 
     (SELECT property_id FROM properties WHERE name = 'EBS Studio Apartment'), 
     (SELECT user_id FROM users WHERE first_name = 'Wubamlak'), 
     '2025-06-25', '2025-06-30', 10000.00, 'confirmed');

-- Insert payments
INSERT INTO payments (payment_id, booking_id, amount, payment_method) VALUES
    (uuid_generate_v4(), 
     (SELECT booking_id FROM bookings WHERE total_price = 14000.00), 
     14000, 'credit_card'),
    (uuid_generate_v4(), 
     (SELECT booking_id FROM bookings WHERE total_price = 10000.00), 
     10000.00, 'paypal');

-- Insert reviews
INSERT INTO reviews (review_id, property_id, user_id, rating, comment) VALUES
    (uuid_generate_v4(), 
     (SELECT property_id FROM properties WHERE name = 'sharaton'), 
     (SELECT user_id FROM users WHERE first_name = 'Irene'), 
     4, 'Great stay, very comfortable and clean!'),
    (uuid_generate_v4(), 
     (SELECT property_id FROM properties WHERE name = 'EBS Studio Apartment'), 
     (SELECT user_id FROM users WHERE first_name = 'Faith'), 
     5, 'Perfect location and amazing amenities!');

-- Insert messages
INSERT INTO messages (message_id, sender_id, recipient_id, message_body) VALUES
    (uuid_generate_v4(), 
     (SELECT user_id FROM users WHERE first_name = 'Yonas'), 
     (SELECT user_id FROM users WHERE first_name = 'Kirubel'), 
     'Hi, I have a question about the booking.'),
    (uuid_generate_v4(), 
     (SELECT user_id FROM users WHERE first_name = 'Wubamlak'), 
     (SELECT user_id FROM users WHERE first_name = 'Rezina'), 
     'Can you provide more details about the property?');
