# Description
A MySQL database schema and sample data for a gym management system.

## Project Overview
This repository contains the SQL scripts and documentation for a relational database designed for an gym management platform. The database schema supports managing membership plans, members, trainers, classes, and more.

## Features
-   **Normalized Schema:** Designed using third normal form (3NF) principles to minimize data redundancy.
-   **Referential Integrity:** Enforced with foreign keys to maintain data consistency.
-   **Sample Data:** Includes `data.sql` to populate the database with example records for testing.
-   **Stored Procedures & Functions:** Examples like `add_new_member`, `update_Membership_plan`.
-   **Queries:** Common queries such as `get details of members on specific plan`, or `find the most popular class`.
-   **Views:** Pre-defined views for common reporting needs.

## Database Schema
- **GymSystem ER diagram:**

![ER Diagram](image.png)

## Getting Started

### Prerequisites
-   MySQL Server (version 8.0 or higher)
-   A MySQL client (MySQL Workbench, DBeaver, or command-line client)

### Installation
1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/t3chE/GymSystem.git](https://github.com/t3chE/GymSystem.git)
    cd GymSystem
    ```
2.  **Connect to your MySQL server.**
3.  **Execute the schema script:**
    ```sql
    -- In your MySQL client or terminal:
    SOURCE schema.sql;
    ```
    (Alternatively, copy and paste the contents of `schema.sql` into your client and execute.)
4.  **Execute the data script (optional):**
    ```sql
    -- After creating the schema:
    USE your_database_name; -- Replace with the name you defined in schema.sql
    SOURCE data.sql;
    ```
