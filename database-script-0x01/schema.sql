-- Enable the UUID extension if using PostgreSQL
-- Uncomment if necessary:
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ===============================
-- USER TABLE
-- ===============================
CREATE TABLE "User" (
    user_id UUID PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role VARCHAR(10) CHECK (role IN ('guest', 'host', 'admin')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_email ON "User"(email);

-- ===============================
-- PROPERTY TABLE
-- ===============================
CREATE TABLE Property (
    property_id UUID PRIMARY KEY,
    host_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    pricepernight DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_property_host FOREIGN KEY (host_id) REFERENCES "User"(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_property_host_id ON Property(host_id);

-- ===============================
-- BOOKING TABLE
-- ===============================
CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(10) CHECK (status IN ('pending', 'confirmed', 'canceled')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_booking_property FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE,
    CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_booking_user_id ON Booking(user_id);

-- ===============================
-- PAYMENT TABLE
-- ===============================
CREATE TABLE Payment (
    payment_id UUID PRIMARY KEY,
    booking_id UUID NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(20) CHECK (payment_method IN ('credit_card', 'paypal', 'stripe')) NOT NULL,

    CONSTRAINT fk_payment_booking FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE
);

CREATE INDEX idx_payment_booking_id ON Payment(booking_id);

-- ===============================
-- REVIEW TABLE
-- ===============================
CREATE TABLE Review (
    review_id UUID PRIMARY KEY,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5) NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_review_property FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE,
    CONSTRAINT fk_review_user FOREIGN KEY (user_id) REFERENCES "User"(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_review_property_id ON Review(property_id);
CREATE INDEX idx_review_user_id ON Review(user_id);

-- ===============================
-- MESSAGE TABLE
-- ===============================
CREATE TABLE Message (
    message_id UUID PRIMARY KEY,
    sender_id UUID NOT NULL,
    recipient_id UUID NOT NULL,
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_message_sender FOREIGN KEY (sender_id) REFERENCES "User"(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_message_recipient FOREIGN KEY (recipient_id) REFERENCES "User"(user_id) ON DELETE CASCADE
);

CREATE INDEX idx_message_sender_id ON Message(sender_id);
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);
