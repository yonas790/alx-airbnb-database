-- Total number of bookings by each user
SELECT 
    u.user_id, 
    u.first_name, 
    u.last_name, 
    COUNT(b.booking_id) AS total_bookings
FROM 
    users u
LEFT JOIN 
    bookings b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.first_name, u.last_name;

-- Ranking properties by number of bookings using window functions
WITH property_bookings AS (
    SELECT 
        p.property_id, 
        p.name, 
        COUNT(b.booking_id) AS booking_count
    FROM 
        properties p
    LEFT JOIN 
        bookings b ON p.property_id = b.property_id
    GROUP BY 
        p.property_id, p.name
)
SELECT 
    property_id, 
    name, 
    booking_count,
    ROW_NUMBER() OVER (ORDER BY booking_count DESC) AS row_num,
    RANK() OVER (ORDER BY booking_count DESC) AS rank
FROM 
    property_bookings
ORDER BY 
    booking_count DESC;