# SQL Join Queries for Airbnb-Style Database

This directory contains SQL join queries for an Airbnb-style property rental database. The queries demonstrate different types of JOIN operations and their practical applications.

## Database Schema Overview

The database consists of the following main tables:
- **User**: Stores user information (guests, hosts, admins)
- **Property**: Stores property listings
- **Booking**: Stores reservation information
- **Payment**: Stores payment transactions
- **Review**: Stores property reviews
- **Message**: Stores user communications

## Query Examples

### 1. INNER JOIN: Bookings with User Information

**Purpose**: Retrieve all bookings along with complete user details for customers who made those bookings.

**Use Case**: 
- Generate booking reports with customer information
- Customer service operations
- Booking management dashboards

**Query Highlights**:
- Returns only bookings that have valid users
- Excludes orphaned bookings (if any exist)
- Includes booking details and user profile information

**Sample Result**:
```
booking_id | start_date | total_price | first_name | last_name | email
-----------|------------|-------------|------------|-----------|-------
uuid-123   | 2024-03-15 | 250.00      | John       | Doe       | john@email.com
uuid-456   | 2024-03-20 | 180.00      | Jane       | Smith     | jane@email.com
```

### 2. LEFT JOIN: Properties with Reviews

**Purpose**: Retrieve all properties and their reviews, including properties that haven't been reviewed yet.

**Use Case**:
- Property listing pages showing all reviews
- Property performance analysis
- Identifying properties that need more reviews
- Marketing insights

**Query Highlights**:
- Shows ALL properties, even those without reviews
- Properties without reviews show NULL for review columns
- Includes reviewer information when available
- Useful for finding properties that need review encouragement

**Sample Result**:
```
property_name | location | rating | comment | reviewer_first_name
--------------|----------|--------|---------|--------------------
Beach House   | Miami    | 5      | Amazing!| John
Mountain Cabin| Denver   | 4      | Great   | Jane
City Apartment| NYC      | NULL   | NULL    | NULL
```

### 3. FULL OUTER JOIN: Users and Bookings

**Purpose**: Retrieve all users and all bookings, showing the complete picture of user activity.

**Use Case**:
- User engagement analysis
- Identifying inactive users
- Data quality checks for orphaned records
- Complete user activity reports

**Query Highlights**:
- Shows ALL users, even those who never made a booking
- Shows ALL bookings, even orphaned ones (if any exist)
- Users without bookings show NULL for booking columns
- Useful for user retention analysis

**Sample Result**:
```
first_name | last_name | email | booking_id | start_date | total_price
-----------|-----------|-------|------------|------------|------------
John       | Doe       | john@ | uuid-123   | 2024-03-15 | 250.00
Jane       | Smith     | jane@ | NULL       | NULL       | NULL
NULL       | NULL      | NULL  | uuid-789   | 2024-04-01 | 300.00
```

## Key JOIN Concepts Demonstrated

### INNER JOIN
- **Returns**: Only records that have matching values in both tables
- **Best for**: When you need data that exists in both tables
- **Example**: Bookings with valid users

### LEFT JOIN
- **Returns**: All records from the left table, and matched records from the right table
- **Best for**: When you want all records from the primary table, with optional related data
- **Example**: All properties, with reviews when available

### FULL OUTER JOIN
- **Returns**: All records from both tables, with NULLs where no match exists
- **Best for**: Complete data analysis, finding orphaned records
- **Example**: All users and all bookings, regardless of relationships

## Running the Queries

1. Ensure you have the database schema set up using `schema.sql`
2. Execute the queries in your preferred SQL client
3. Modify the SELECT columns based on your specific needs

