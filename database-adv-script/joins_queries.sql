-- INNER JOIN: Retrieve bookings with user details
SELECT 
    b.booking_id, 
    b.start_date, 
    b.end_date, 
    b.total_price, 
    u.first_name, 
    u.last_name, 
    u.email
FROM 
    bookings b
INNER JOIN 
    users u ON b.user_id = u.user_id;

-- LEFT JOIN: Retrieve all properties with their reviews (including properties without reviews)
SELECT 
    p.property_id, 
    p.name, 
    p.description, 
    r.review_id, 
    r.rating, 
    r.comment
FROM 
    properties p
LEFT JOIN 
    reviews r ON p.property_id = r.property_id;

-- FULL OUTER JOIN: Retrieve all users and bookings 
-- Note: Not all databases support FULL OUTER JOIN directly
-- This is an emulation using LEFT and RIGHT joins
SELECT 
    u.user_id, 
    u.first_name, 
    u.last_name, 
    b.booking_id, 
    b.start_date, 
    b.end_date
FROM 
    users u
LEFT JOIN 
    bookings b ON u.user_id = b.user_id
UNION
SELECT 
    u.user_id, 
    u.first_name, 
    u.last_name, 
    b.booking_id, 
    b.start_date, 
    b.end_date
FROM 
    users u
RIGHT JOIN 
    bookings b ON u.user_id = b.user_id
WHERE 
    u.user_id IS NULL;