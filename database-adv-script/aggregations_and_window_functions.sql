-- ===============================
-- 1. AGGREGATION WITH COUNT AND GROUP BY
-- ===============================
-- Find the total number of bookings made by each user

SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.role,
    COUNT(b.booking_id) AS total_bookings,
    MIN(b.start_date) AS first_booking_date,
    MAX(b.start_date) AS last_booking_date,
    SUM(b.total_price) AS total_spent,
    AVG(b.total_price) AS avg_booking_amount
FROM "User" u
LEFT JOIN Booking b ON u.user_id = b.user_id
GROUP BY u.user_id, u.first_name, u.last_name, u.email, u.role
ORDER BY total_bookings DESC, total_spent DESC;

-- ===============================
-- 2. WINDOW FUNCTIONS FOR PROPERTY RANKING
-- ===============================
-- Rank properties based on the total number of bookings using ROW_NUMBER and RANK

SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    p.host_id,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_revenue,
    AVG(b.total_price) AS avg_booking_value,
    
    -- ROW_NUMBER: Assigns unique sequential numbers (no ties)
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_number_rank,
    
    -- RANK: Assigns same rank to ties, skips next rank
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank_by_bookings,
    
    -- DENSE_RANK: Assigns same rank to ties, doesn't skip next rank
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS dense_rank_by_bookings,
    
    -- PERCENT_RANK: Shows percentile ranking (0 to 1)
    PERCENT_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS percent_rank,
    
    -- Rank by revenue within each location
    RANK() OVER (PARTITION BY p.location ORDER BY SUM(b.total_price) DESC) AS rank_by_revenue_in_location
    
FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id
GROUP BY p.property_id, p.name, p.location, p.pricepernight, p.host_id
ORDER BY total_bookings DESC, total_revenue DESC;

-- ===============================
-- 3. ADVANCED AGGREGATION EXAMPLES
-- ===============================

-- Monthly booking trends with running totals
SELECT 
    DATE_TRUNC('month', b.start_date) AS booking_month,
    COUNT(b.booking_id) AS monthly_bookings,
    SUM(b.total_price) AS monthly_revenue,
    AVG(b.total_price) AS avg_monthly_booking_value,
    
    -- Running total of bookings
    SUM(COUNT(b.booking_id)) OVER (ORDER BY DATE_TRUNC('month', b.start_date)) AS running_total_bookings,
    
    -- Running total of revenue
    SUM(SUM(b.total_price)) OVER (ORDER BY DATE_TRUNC('month', b.start_date)) AS running_total_revenue,
    
    -- Month-over-month growth
    LAG(COUNT(b.booking_id), 1) OVER (ORDER BY DATE_TRUNC('month', b.start_date)) AS prev_month_bookings,
    
    -- Calculate growth percentage
    CASE 
        WHEN LAG(COUNT(b.booking_id), 1) OVER (ORDER BY DATE_TRUNC('month', b.start_date)) > 0 THEN
            ROUND(
                ((COUNT(b.booking_id) - LAG(COUNT(b.booking_id), 1) OVER (ORDER BY DATE_TRUNC('month', b.start_date))) * 100.0 / 
                 LAG(COUNT(b.booking_id), 1) OVER (ORDER BY DATE_TRUNC('month', b.start_date))), 2
            )
        ELSE NULL
    END AS month_over_month_growth_percent

FROM Booking b
WHERE b.status = 'confirmed'
GROUP BY DATE_TRUNC('month', b.start_date)
ORDER BY booking_month;

-- ===============================
-- 4. USER SEGMENTATION WITH WINDOW FUNCTIONS
-- ===============================
-- Segment users based on booking frequency and spending

WITH user_stats AS (
    SELECT 
        u.user_id,
        u.first_name,
        u.last_name,
        u.email,
        COUNT(b.booking_id) AS total_bookings,
        COALESCE(SUM(b.total_price), 0) AS total_spent,
        COALESCE(AVG(b.total_price), 0) AS avg_booking_value
    FROM "User" u
    LEFT JOIN Booking b ON u.user_id = b.user_id AND b.status = 'confirmed'
    WHERE u.role = 'guest'
    GROUP BY u.user_id, u.first_name, u.last_name, u.email
)
SELECT 
    user_id,
    first_name,
    last_name,
    email,
    total_bookings,
    total_spent,
    avg_booking_value,
    
    -- Quartile ranking by total bookings
    NTILE(4) OVER (ORDER BY total_bookings DESC) AS booking_quartile,
    
    -- Quartile ranking by total spending
    NTILE(4) OVER (ORDER BY total_spent DESC) AS spending_quartile,
    
    -- User segments based on activity
    CASE 
        WHEN total_bookings >= 10 THEN 'VIP Customer'
        WHEN total_bookings >= 5 THEN 'Frequent Customer'
        WHEN total_bookings >= 1 THEN 'Regular Customer'
        ELSE 'Inactive Customer'
    END AS customer_segment,
    
    -- Percentile ranking
    PERCENT_RANK() OVER (ORDER BY total_spent DESC) AS spending_percentile

FROM user_stats
ORDER BY total_spent DESC, total_bookings DESC;

-- ===============================
-- 5. PROPERTY PERFORMANCE ANALYSIS
-- ===============================
-- Analyze property performance with multiple metrics

SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    
    -- Basic metrics
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_revenue,
    AVG(b.total_price) AS avg_booking_value,
    
    -- Review metrics
    COUNT(r.review_id) AS total_reviews,
    AVG(r.rating) AS avg_rating,
    
    -- Occupancy calculation (assuming 365 days available per year)
    CASE 
        WHEN COUNT(b.booking_id) > 0 THEN
            ROUND((SUM(b.end_date - b.start_date) * 100.0 / 365), 2)
        ELSE 0
    END AS estimated_occupancy_rate,
    
    -- Window functions for ranking
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS popularity_rank,
    ROW_NUMBER() OVER (ORDER BY SUM(b.total_price) DESC) AS revenue_rank,
    ROW_NUMBER() OVER (ORDER BY AVG(r.rating) DESC) AS rating_rank,
    
    -- Rank within location
    RANK() OVER (PARTITION BY p.location ORDER BY COUNT(b.booking_id) DESC) AS local_popularity_rank,
    
    -- Performance score (weighted combination)
    (
        (COUNT(b.booking_id) * 0.4) + 
        (COALESCE(AVG(r.rating), 0) * 20 * 0.3) + 
        (SUM(b.total_price) / 1000 * 0.3)
    ) AS performance_score

FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id AND b.status = 'confirmed'
LEFT JOIN Review r ON p.property_id = r.property_id
GROUP BY p.property_id, p.name, p.location, p.pricepernight
ORDER BY performance_score DESC;

-- ===============================
-- 6. BOOKING STATUS ANALYSIS
-- ===============================
-- Analyze booking patterns by status with window functions

SELECT 
    b.status,
    COUNT(*) AS total_bookings,
    SUM(b.total_price) AS total_value,
    AVG(b.total_price) AS avg_booking_value,
    
    -- Percentage of total bookings
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2
    ) AS percentage_of_total,
    
    -- Percentage of total revenue
    ROUND(
        SUM(b.total_price) * 100.0 / SUM(SUM(b.total_price)) OVER (), 2
    ) AS percentage_of_revenue,
    
    -- Running total
    SUM(COUNT(*)) OVER (ORDER BY COUNT(*) DESC) AS running_total_bookings

FROM Booking b
GROUP BY b.status
ORDER BY total_bookings DESC;