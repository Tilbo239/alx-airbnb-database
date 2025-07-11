-- ===============================
-- 1. INNER JOIN: All bookings with their respective users
-- ===============================
-- This query retrieves all bookings along with the user information
-- for users who made those bookings. Only bookings with valid users will be returned.

SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role
FROM Booking b
INNER JOIN "User" u ON b.user_id = u.user_id
ORDER BY b.created_at DESC;

-- ===============================
-- 2. LEFT JOIN: All properties with their reviews (including properties with no reviews)
-- ===============================
-- This query retrieves all properties and their reviews.
-- Properties without reviews will still appear in the result with NULL values for review columns.

SELECT 
    p.property_id,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight,
    p.created_at AS property_created_at,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_created_at,
    u.first_name AS reviewer_first_name,
    u.last_name AS reviewer_last_name
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
LEFT JOIN "User" u ON r.user_id = u.user_id
ORDER BY p.name, r.created_at DESC;

-- ===============================
-- 3. FULL OUTER JOIN: All users and all bookings
-- ===============================
-- This query retrieves all users and all bookings, even if:
-- - A user has no bookings (user info will show, booking columns will be NULL)
-- - A booking is not linked to a user (booking info will show, user columns will be NULL)

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    u.created_at AS user_created_at,
    b.booking_id,
    b.property_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    b.created_at AS booking_created_at
FROM "User" u
FULL OUTER JOIN Booking b ON u.user_id = b.user_id
ORDER BY 
    CASE 
        WHEN u.user_id IS NULL THEN 1 
        ELSE 0 
    END,
    u.last_name,
    u.first_name,
    b.created_at DESC;