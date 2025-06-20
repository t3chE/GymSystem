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

### Installation and Execution
1.  **Clone the repository:**
    ```bash
    git clone https://github.com/t3chE/GymSystem.git
    cd GymSystem
    ```

2.  **Connect to your MySQL server.**


3.  **Execute the schema script:**
    ```sql
    -- In your MySQL client or terminal:
    SOURCE schema.sql;
    ```
    This script will create the 'gymdb' database and all necessary tables. It contains all the Data Definition Language (DDL) statements.`
    (Alternatively, copy and paste the contents of `schema.sql` into your client and execute.)


4.  **Execute the data script:**
    ```sql
    -- After creating the schema:
    USE gym_db; 
    SOURCE data.sql;
    ```
    This script will populate the database with initial sample or default data once the schema is created. It containd Data Manipulation Language (DML) statements.


5. **Add Procedures and Views (Optional):**
    ```sql
    -- If applicable, execute `procedures.sql` and `views.sql`:
    SOURCE procedures.sql;
           views.sql;
    ```
    The procurement file holds all your stored procedures. Stored procedures are pre-compiled SQL code blocks that perform specific tasks, often involving multiple SQL statements. They can improve performance and security.

    The views file defines the database views. Views are virtual tables based on the result-set of a SQL query. They are used to simplify complex queries, restrict data access, or provide a consistent interface to data that might change over time.


6. **Execute the queries script:**
    ```sql
    -- Once all other scripts have been run:
    SOURCE queries.sql;
    ```
    This file is more flexible, often used for ad-hoc testing or providing examples for other developers. It can contain frequently used SELECT queries, UPDATE examples, DELETE examples, or even just comments explaining common ways to interact with the data. 


7. **Add User Privileges and Access Controls:**
    ```sql
    -- Finally add security features:
    SOURCE sequrity.sql;
    ```
    MySQL script that uses GRANT and REVOKE statements to set up the user privileges for your specified roles: Admin, Trainer, Receptionist/Front-Desk, and Reporting.


    Contact
    -	[https://github.com/t3chE](https://github.com/t3chE)
    -	[https://www.linkedin.com/in/linkgus/](https://www.linkedin.com/in/linkgus/)

