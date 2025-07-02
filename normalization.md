# Database Normalization Report

## ✔️ Objective
To analyze and normalize the initial database schema for a property rental system in order to:
- Eliminate data redundancy
- Ensure consistency and data integrity
- Achieve compliance with the Third Normal Form (3NF)

---

## 🔍 Key Normalization Issues Identified

### ✅ 1NF Violation
- The `location` field in the `Property` table contained composite values (e.g., full address as a string. eg: N'Djamena, Chad, Gassi, street 19930).
- This violated the First Normal Form (1NF), which requires each field to hold only atomic values.

### ✅ 3NF Violations
- The `role` field in the `User` table introduced a transitive dependency, where attributes (e.g., permissions) could depend on the role label.
- Similarly, storing address data directly in the `Property` table could lead to transitive dependencies and duplication.

### ✅ Data Redundancy
- Repetition of address information across multiple properties.
- Repetition of user roles such as 'admin', 'guest', 'host' with no centralized management.

---

## 🛠️ Major Improvements Made

### 🆕 New Tables Added

- **`Address`**: 
  - Decomposed the full location into atomic components (`street`, `city`, `state`, `zip_code`, `country`).
  - Linked to the `Property` table using a foreign key.
  
- **`Role`**:
  - Separated role definitions from the `User` table.
  - Makes it easy to manage permissions and extend roles in the future.
  
- **`Property_Category`**:
  - Classifies properties into types like 'apartment', 'villa', 'house', etc.
  - Enhances search/filter functionality.

### 🔄 Enhanced Existing Tables

- **`User`**:
  - Replaced the `role` ENUM with a `role_id` foreign key referencing the `Role` table.
  
- **`Property`**:
  - Replaced the `location` string with an `address_id` foreign key.
  - Added `category_id` to link to the `Property_Category` table.

- **`Booking`**:
  - Added `price_per_night_snapshot` to preserve historical pricing.
  - Added `guest_count` to improve analytics and reservation logic.

---

## ✅ Benefits Achieved

- **Full 3NF Compliance**:
  - Eliminated all transitive dependencies and ensured each non-key attribute depends only on the primary key.

- **Reduced Redundancy**:
  - Address and role information are now stored once and referenced via foreign keys.

- **Improved Data Integrity**:
  - Use of foreign keys ensures valid and consistent references across tables.

- **Enhanced Maintainability**:
  - Updates to addresses or roles reflect automatically across related records.

- **Better Scalability**:
  - New roles, property categories, or address components can be added without restructuring the entire schema.

---

## 🧱 Final Schema Overview (Simplified)

### User
- `user_id` (PK)
- `first_name`, `last_name`, `email`, `password_hash`
- `phone_number`
- `role_id` (FK → Role)

### Role
- `role_id` (PK)
- `role_name` (e.g., guest, host, admin)

### Property
- `property_id` (PK)
- `host_id` (FK → User)
- `name`, `description`
- `address_id` (FK → Address)
- `category_id` (FK → Property_Category)

### Address
- `address_id` (PK)
- `street`, `city`, `state`, `zip_code`, `country`

### Property_Category
- `category_id` (PK)
- `category_name` (e.g., apartment, house, villa)

### Booking
- `booking_id` (PK)
- `property_id` (FK → Property)
- `user_id` (FK → User)
- `start_date`, `end_date`
- `price_per_night_snapshot`, `total_price`
- `guest_count`
- `status`

### Payment, Review, Message
- Remain unchanged but include FKs to maintain referential integrity.

---


