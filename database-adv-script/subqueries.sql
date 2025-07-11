-- ===============================
-- 1. NON-CORRELATED SUBQUERY
-- ===============================
-- Find all properties where the average rating is greater than 4.0
-- This is a non-correlated subquery because the inner query can be executed independently

SELECT 
    p.property_id,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight,
    p.created_at
FROM Property p
WHERE p.property_id IN (
    SELECT r.property_id
    FROM Review r
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
)
ORDER BY p.name;

-- Alternative approach using EXISTS (also non-correlated in this context)
SELECT 
    p.property_id,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight,
    p.created_at
FROM Property p
WHERE EXISTS (
    SELECT 1
    FROM Review r
    WHERE r.property_id = p.property_id
    GROUP BY r.property_id
    HAVING AVG(r.rating) > 4.0
)
ORDER BY p.name;

-- ===============================
-- 2. CORRELATED SUBQUERY
-- ===============================
-- Find users who have made more than 3 bookings
-- This is a correlated subquery because the inner query references the outer query's table

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    u.created_at
FROM "User" u
WHERE (
    SELECT COUNT(b.booking_id)
    FROM Booking b
    WHERE b.user_id = u.user_id  -- This creates the correlation
) > 3
ORDER BY u.last_name, u.first_name;

-- ===============================
-- BONUS: ADDITIONAL SUBQUERY EXAMPLES
-- ===============================

-- 3. NON-CORRELATED SUBQUERY: Properties with above-average price
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    (SELECT AVG(pricepernight) FROM Property) AS avg_price
FROM Property p
WHERE p.pricepernight > (
    SELECT AVG(pricepernight)
    FROM Property
)
ORDER BY p.pricepernight DESC;

-- 4. CORRELATED SUBQUERY: Users with their most recent booking
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    (
        SELECT MAX(b.start_date)
        FROM Booking b
        WHERE b.user_id = u.user_id
    ) AS most_recent_booking_date,
    (
        SELECT COUNT(b.booking_id)
        FROM Booking b
        WHERE b.user_id = u.user_id
    ) AS total_bookings
FROM "User" u
WHERE u.role = 'guest'
ORDER BY u.last_name, u.first_name;

-- 5. CORRELATED SUBQUERY: Properties with their latest review
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    (
        SELECT r.rating
        FROM Review r
        WHERE r.property_id = p.property_id
        ORDER BY r.created_at DESC
        LIMIT 1
    ) AS latest_rating,
    (
        SELECT r.comment
        FROM Review r
        WHERE r.property_id = p.property_id
        ORDER BY r.created_at DESC
        LIMIT 1
    ) AS latest_comment,
    (
        SELECT COUNT(r.review_id)
        FROM Review r
        WHERE r.property_id = p.property_id
    ) AS total_reviews
FROM Property p
ORDER BY p.name;

-- 6. COMPLEX CORRELATED SUBQUERY: Users who have spent more than the average booking amount
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    (
        SELECT SUM(b.total_price)
        FROM Booking b
        WHERE b.user_id = u.user_id
    ) AS total_spent,
    (
        SELECT AVG(total_price)
        FROM Booking
    ) AS avg_booking_amount
FROM "User" u
WHERE (
    SELECT COALESCE(SUM(b.total_price), 0)
    FROM Booking b
    WHERE b.user_id = u.user_id
) > (
    SELECT AVG(total_price)
    FROM Booking
)
ORDER BY total_spent DESC;