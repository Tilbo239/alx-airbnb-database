# AirBnB Database Requirements

## Overview
This document outlines the database requirements for the AirBnB-like property rental platform. The database is designed to support core functionalities including user management, property listings, bookings, payments, reviews, and messaging.

## Entity-Relationship Model

### Entities and Attributes

#### 1. User Entity
**Purpose:** Manages all platform users (guests, hosts, and administrators)

| Attribute | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| `user_id` | UUID | PRIMARY KEY, INDEXED | Unique identifier for each user |
| `first_name` | VARCHAR | NOT NULL | User's first name |
| `last_name` | VARCHAR | NOT NULL | User's last name |
| `email` | VARCHAR | UNIQUE, NOT NULL, INDEXED | User's email address |
| `password_hash` | VARCHAR | NOT NULL | Hashed password for security |
| `phone_number` | VARCHAR | NULL | Optional phone number |
| `role` | ENUM | NOT NULL | User role: `guest`, `host`, `admin` |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Account creation timestamp |

#### 2. Property Entity
**Purpose:** Stores information about rental properties listed on the platform

| Attribute | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| `property_id` | UUID | PRIMARY KEY, INDEXED | Unique identifier for each property |
| `host_id` | UUID | FOREIGN KEY, NOT NULL | References `User(user_id)` |
| `name` | VARCHAR | NOT NULL | Property name/title |
| `description` | TEXT | NOT NULL | Detailed property description |
| `location` | VARCHAR | NOT NULL | Property location/address |
| `price_per_night` | DECIMAL | NOT NULL | Nightly rental price |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Property listing creation time |
| `updated_at` | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Last modification time |

#### 3. Booking Entity
**Purpose:** Manages reservation records for properties

| Attribute | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| `booking_id` | UUID | PRIMARY KEY, INDEXED | Unique booking identifier |
| `property_id` | UUID | FOREIGN KEY, NOT NULL | References `Property(property_id)` |
| `user_id` | UUID | FOREIGN KEY, NOT NULL | References `User(user_id)` |
| `start_date` | DATE | NOT NULL | Check-in date |
| `end_date` | DATE | NOT NULL | Check-out date |
| `total_price` | DECIMAL | NOT NULL | Total booking cost |
| `status` | ENUM | NOT NULL | Booking status: `pending`, `confirmed`, `canceled` |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Booking creation time |

#### 4. Payment Entity
**Purpose:** Records payment transactions for bookings

| Attribute | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| `payment_id` | UUID | PRIMARY KEY, INDEXED | Unique payment identifier |
| `booking_id` | UUID | FOREIGN KEY, NOT NULL | References `Booking(booking_id)` |
| `amount` | DECIMAL | NOT NULL | Payment amount |
| `payment_date` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Payment processing time |
| `payment_method` | ENUM | NOT NULL | Payment method: `credit_card`, `paypal`, `stripe` |

#### 5. Review Entity
**Purpose:** Stores user reviews and ratings for properties

| Attribute | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| `review_id` | UUID | PRIMARY KEY, INDEXED | Unique review identifier |
| `property_id` | UUID | FOREIGN KEY, NOT NULL | References `Property(property_id)` |
| `user_id` | UUID | FOREIGN KEY, NOT NULL | References `User(user_id)` |
| `rating` | INTEGER | NOT NULL, CHECK (rating >= 1 AND rating <= 5) | Rating from 1-5 stars |
| `comment` | TEXT | NOT NULL | Written review comment |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Review creation time |

#### 6. Message Entity
**Purpose:** Facilitates communication between platform users

| Attribute | Type | Constraints | Description |
|-----------|------|-------------|-------------|
| `message_id` | UUID | PRIMARY KEY, INDEXED | Unique message identifier |
| `sender_id` | UUID | FOREIGN KEY, NOT NULL | References `User(user_id)` |
| `recipient_id` | UUID | FOREIGN KEY, NOT NULL | References `User(user_id)` |
| `message_body` | TEXT | NOT NULL | Message content |
| `sent_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Message sending time |

### Entity Relationships

#### Primary Relationships

1. **User ↔ Property (Host Relationship)**
   - **Type:** One-to-Many (1:M)
   - **Description:** A user with role 'host' can own multiple properties
   - **Foreign Key:** `Property.host_id` → `User.user_id`

2. **User ↔ Booking (Guest Relationship)**
   - **Type:** One-to-Many (1:M)
   - **Description:** A user can make multiple bookings
   - **Foreign Key:** `Booking.user_id` → `User.user_id`

3. **Property ↔ Booking**
   - **Type:** One-to-Many (1:M)
   - **Description:** A property can have multiple bookings over time
   - **Foreign Key:** `Booking.property_id` → `Property.property_id`

4. **Booking ↔ Payment**
   - **Type:** One-to-One (1:1)
   - **Description:** Each booking has exactly one payment record
   - **Foreign Key:** `Payment.booking_id` → `Booking.booking_id`

5. **User ↔ Review (Reviewer Relationship)**
   - **Type:** One-to-Many (1:M)
   - **Description:** A user can write multiple reviews
   - **Foreign Key:** `Review.user_id` → `User.user_id`

6. **Property ↔ Review**
   - **Type:** One-to-Many (1:M)
   - **Description:** A property can receive multiple reviews
   - **Foreign Key:** `Review.property_id` → `Property.property_id`

7. **User ↔ Message (Sender)**
   - **Type:** One-to-Many (1:M)
   - **Description:** A user can send multiple messages
   - **Foreign Key:** `Message.sender_id` → `User.user_id`

8. **User ↔ Message (Recipient)**
   - **Type:** One-to-Many (1:M)
   - **Description:** A user can receive multiple messages
   - **Foreign Key:** `Message.recipient_id` → `User.user_id`

### Database Constraints

#### User Table Constraints
- **Unique Constraints:**
  - `email` must be unique across all users
- **Check Constraints:**
  - `role` must be one of: `guest`, `host`, `admin`
- **Not Null Constraints:**
  - `first_name`, `last_name`, `email`, `password_hash`, `role`

#### Property Table Constraints
- **Foreign Key Constraints:**
  - `host_id` must reference a valid `User.user_id`
  - User referenced by `host_id` should have role `host` or `admin`
- **Check Constraints:**
  - `price_per_night` must be greater than 0
- **Not Null Constraints:**
  - `host_id`, `name`, `description`, `location`, `price_per_night`

#### Booking Table Constraints
- **Foreign Key Constraints:**
  - `property_id` must reference a valid `Property.property_id`
  - `user_id` must reference a valid `User.user_id`
- **Check Constraints:**
  - `status` must be one of: `pending`, `confirmed`, `canceled`
  - `end_date` must be greater than `start_date`
  - `total_price` must be greater than 0
- **Not Null Constraints:**
  - `property_id`, `user_id`, `start_date`, `end_date`, `total_price`, `status`

#### Payment Table Constraints
- **Foreign Key Constraints:**
  - `booking_id` must reference a valid `Booking.booking_id`
- **Check Constraints:**
  - `payment_method` must be one of: `credit_card`, `paypal`, `stripe`
  - `amount` must be greater than 0
- **Not Null Constraints:**
  - `booking_id`, `amount`, `payment_method`

#### Review Table Constraints
- **Foreign Key Constraints:**
  - `property_id` must reference a valid `Property.property_id`
  - `user_id` must reference a valid `User.user_id`
- **Check Constraints:**
  - `rating` must be between 1 and 5 (inclusive)
- **Not Null Constraints:**
  - `property_id`, `user_id`, `rating`, `comment`
- **Business Logic Constraints:**
  - A user should only be able to review properties they have booked

#### Message Table Constraints
- **Foreign Key Constraints:**
  - `sender_id` must reference a valid `User.user_id`
  - `recipient_id` must reference a valid `User.user_id`
- **Check Constraints:**
  - `sender_id` cannot equal `recipient_id` (users cannot message themselves)
- **Not Null Constraints:**
  - `sender_id`, `recipient_id`, `message_body`

### Indexing Strategy

#### Primary Indexes (Automatic)
All primary keys are automatically indexed:
- `User.user_id`
- `Property.property_id`
- `Booking.booking_id`
- `Payment.payment_id`
- `Review.review_id`
- `Message.message_id`

#### Additional Indexes for Performance
- **User Table:**
  - `email` (UNIQUE INDEX) - for login authentication
  - `role` - for role-based queries

- **Property Table:**
  - `host_id` - for finding properties by host
  - `location` - for location-based searches
  - `price_per_night` - for price range queries

- **Booking Table:**
  - `property_id` - for finding bookings by property
  - `user_id` - for finding user's bookings
  - `status` - for filtering by booking status
  - `start_date, end_date` - for date range queries

- **Payment Table:**
  - `booking_id` - for finding payment by booking

- **Review Table:**
  - `property_id` - for finding reviews by property
  - `user_id` - for finding reviews by user
  - `rating` - for rating-based queries

- **Message Table:**
  - `sender_id` - for finding sent messages
  - `recipient_id` - for finding received messages
  - `sent_at` - for chronological ordering

### Business Rules and Logic

#### User Management
- Users can have multiple roles (guest can also be host)
- Email addresses must be unique across the platform
- Password must be stored as hash for security

#### Property Management
- Only users with 'host' or 'admin' role can create properties
- Properties cannot be deleted if they have active bookings
- Price updates should not affect existing confirmed bookings

#### Booking Management
- Users cannot book their own properties
- Bookings cannot overlap for the same property
- Booking dates must be in the future
- Total price should match: (end_date - start_date) × price_per_night

#### Payment Processing
- Payment must be completed before booking confirmation
- Payment amount must match booking total_price
- Failed payments should update booking status to 'canceled'

#### Review System
- Users can only review properties they have successfully booked
- One review per user per property
- Reviews can only be submitted after check-out date
- Ratings must be integer values between 1-5

#### Messaging System
- Users can only message each other if they have a booking relationship
- Message history should be preserved even if bookings are canceled
- System should prevent spam/abuse through rate limiting

### Data Integrity and Security

#### Data Validation
- All email addresses must follow valid email format
- Phone numbers should follow international format standards

#### Security Considerations
- Passwords must be hashed using strong algorithms 
- Sensitive financial data should be encrypted at rest
- API access should be rate-limited and authenticated



---

## Implementation Notes

This requirements document serves as the foundation for implementing the AirBnB database schema. All constraints, relationships, and business rules outlined here should be enforced at the database level where possible, with additional validation implemented in the application layer.

The design prioritizes data integrity, performance, and scalability to support a growing property rental platform while maintaining strict consistency and security standards.

[CONSULT THE ER DIAGRAM](https://drive.google.com/file/d/11-bOdyA3ARHu_QYT3flTYNnvCMpHl2HC/view?usp=sharing)