-- Partitioning Strategy for Bookings Table

-- Drop existing bookings table if it exists
DROP TABLE IF EXISTS bookings;

-- Create partitioned bookings table with start_date in PRIMARY KEY
CREATE TABLE bookings (
    booking_id UUID,
    start_date DATE NOT NULL,
    property_id UUID,
    user_id UUID,
    end_date DATE NOT NULL,
    total_price DECIMAL NOT NULL,
    status booking_status NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (booking_id, start_date)
) PARTITION BY RANGE (start_date);

-- Create partition for each year
CREATE TABLE bookings_2023 PARTITION OF bookings
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE bookings_2024 PARTITION OF bookings
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE bookings_2025 PARTITION OF bookings
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Add foreign key constraints after partitioning
ALTER TABLE bookings 
    ADD CONSTRAINT fk_bookings_property 
    FOREIGN KEY (property_id) 
    REFERENCES properties(property_id);

ALTER TABLE bookings 
    ADD CONSTRAINT fk_bookings_user 
    FOREIGN KEY (user_id) 
    REFERENCES users(user_id);

-- Example Insert to demonstrate partitioning
INSERT INTO bookings (
    booking_id, 
    start_date, 
    property_id, 
    user_id, 
    end_date, 
    total_price, 
    status
) VALUES (
    uuid_generate_v4(),
    '2024-07-15',
    (SELECT property_id FROM properties LIMIT 1),
    (SELECT user_id FROM users LIMIT 1),
    '2024-07-20',
    1250.00,
    'confirmed'
);

-- Performance Test Query
EXPLAIN ANALYZE
SELECT * FROM bookings 
WHERE start_date BETWEEN '2024-01-01' AND '2024-12-31';