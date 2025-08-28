# Airbnb Database Schema (PostgreSQL)

This repository contains the PostgreSQL database schema for an Airbnb-like booking platform.  
It models **users, properties, bookings, payments, reviews, and messages** with proper constraints, indexes, and UUID-based primary keys.

---

## 🚀 Features
- **UUID Primary Keys** using `uuid-ossp` extension.
- **Normalized schema** with relationships between users, properties, bookings, payments, reviews, and messages.
- **Foreign key constraints** to ensure referential integrity.
- **Check constraints** for controlled values (`role`, `status`, `payment_method`, `rating`).
- **Automatic timestamps** for record creation.
- **Indexes** on frequently queried columns for performance.

---

## 📦 Database Entities

### 1. Users
Stores all users (guests, hosts, admins).

| Column         | Type     | Constraints |
|----------------|----------|-------------|
| user_id        | UUID     | PK, default `uuid_generate_v4()` |
| first_name     | VARCHAR  | NOT NULL |
| last_name      | VARCHAR  | NOT NULL |
| email          | VARCHAR  | UNIQUE, NOT NULL |
| password_hash  | VARCHAR  | NOT NULL |
| phone_number   | VARCHAR  | NULL |
| role           | ENUM     | guest, host, admin |
| created_at     | TIMESTAMP| Default: current timestamp |

🔑 **Indexes**: `email`

---

### 2. Properties
Represents listings owned by hosts.

| Column       | Type     | Constraints |
|--------------|----------|-------------|
| property_id  | UUID     | PK |
| host_id      | UUID     | FK → users(user_id), ON DELETE CASCADE |
| name         | VARCHAR  | NOT NULL |
| description  | TEXT     | NOT NULL |
| location     | VARCHAR  | NOT NULL |
| pricepernight| DECIMAL  | NOT NULL |
| created_at   | TIMESTAMP| Default: current timestamp |
| updated_at   | TIMESTAMP| Default: current timestamp |

🔑 **Indexes**: `property_id`

---

### 3. Bookings
Reservations made by users for properties.

| Column       | Type     | Constraints |
|--------------|----------|-------------|
| booking_id   | UUID     | PK |
| property_id  | UUID     | FK → properties(property_id), ON DELETE SET DEFAULT |
| user_id      | UUID     | FK → users(user_id), ON DELETE SET DEFAULT |
| start_date   | DATE     | NOT NULL |
| end_date     | DATE     | NOT NULL |
| total_price  | DECIMAL  | NOT NULL |
| status       | ENUM     | pending, confirmed, canceled |
| created_at   | TIMESTAMP| Default: current timestamp |

🔑 **Indexes**: `booking_id`, `property_id`

---

### 4. Payments
Payments made for bookings.

| Column       | Type     | Constraints |
|--------------|----------|-------------|
| payment_id   | UUID     | PK |
| booking_id   | UUID     | FK → bookings(booking_id), UNIQUE, ON DELETE CASCADE |
| amount       | DECIMAL  | NOT NULL |
| payment_date | TIMESTAMP| Default: current timestamp |
| payment_method| ENUM    | credit_card, paypal, stripe |

🔑 **Indexes**: `booking_id`

---

### 5. Reviews
Guest reviews for properties.

| Column       | Type     | Constraints |
|--------------|----------|-------------|
| review_id    | UUID     | PK |
| property_id  | UUID     | FK → properties(property_id), ON DELETE SET DEFAULT |
| user_id      | UUID     | FK → users(user_id), ON DELETE SET DEFAULT |
| rating       | INTEGER  | CHECK (1–5) |
| comment      | TEXT     | NOT NULL |
| created_at   | TIMESTAMP| Default: current timestamp |

---

### 6. Messages
Direct messages between users.

| Column       | Type     | Constraints |
|--------------|----------|-------------|
| message_id   | UUID     | PK |
| sender_id    | UUID     | FK → users(user_id), ON DELETE SET DEFAULT |
| recipient_id | UUID     | FK → users(user_id), ON DELETE SET DEFAULT |
| message_body | TEXT     | NOT NULL |
| sent_at      | TIMESTAMP| Default: current timestamp |

---

## ⚡ Notes
- `ON DELETE SET DEFAULT` requires **default UUID placeholders** (e.g., `'user-deleted'` or `'property-deleted'`).  
  - You should create "dummy" records for deleted users/properties and assign those IDs.  
- `updated_at` does not auto-update in PostgreSQL.  
  - You can use a **trigger** to update it automatically on row modification.
- All `UUID`s are generated via `uuid_generate_v4()`.

---

## 🛠 Setup Instructions
1. Enable the UUID extension:
   ```sql
   CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
