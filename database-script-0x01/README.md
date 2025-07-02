# Airbnb Database Schema

This project defines a normalized SQL schema for an Airbnb-like platform.

## 🧱 Entities

The database consists of six main entities:

1. **User**
2. **Property**
3. **Booking**
4. **Payment**
5. **Review**
6. **Message**

## 🛠️ Features

- UUID-based primary keys for all tables
- Enum-like constraints for role, booking status, and payment method
- Timestamps for creation and updates
- Indexed email, foreign keys, and commonly queried fields for performance
- Referential integrity with cascading deletions

## 🗃️ Table Overview

### `User`
- Holds account information for guests, hosts, and admins.

### `Property`
- Details about listings posted by hosts.

### `Booking`
- User reservations for properties.

### `Payment`
- Tracks payments linked to bookings.

### `Review`
- Feedback left by users for properties.

### `Message`
- Private communication between users.

## 📥 How to Use

1. Ensure your database supports `UUID`. For PostgreSQL, enable the extension:
   ```sql
   CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
