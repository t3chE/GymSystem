-- MySQL Script for User Privileges and Access Control
-- Database: gym_db
-- Tables: Members, Trainers, Classes, MembershipPlans, Bookings, Payments, TrainerAvailability

-- IMPORTANT: Replace 'your_admin_password', 'your_trainer_password',
-- 'your_frontdesk_password', and 'your_reporter_password' with strong, unique passwords.
-- Also, consider changing 'localhost' to the specific IP address or hostname
-- from which these users will connect for added security, or '%' for any host if necessary.

-- -----------------------------------------------------------
-- 1. Create Users
--    If these users already exist, you can skip these CREATE USER statements
--    or use ALTER USER to change their passwords if needed.
-- -----------------------------------------------------------

CREATE USER 'gym_admin'@'localhost' IDENTIFIED BY 'your_admin_password';
CREATE USER 'trainer_user'@'localhost' IDENTIFIED BY 'your_trainer_password';
CREATE USER 'front_desk_user'@'localhost' IDENTIFIED BY 'your_frontdesk_password';
CREATE USER 'reporter'@'localhost' IDENTIFIED BY 'your_reporter_password';

-- -----------------------------------------------------------
-- 2. Grant Privileges based on Principle of Least Privilege
-- -----------------------------------------------------------

-- 2.1. Admin Role (gym_admin)
-- A highly privileged user with ALL PRIVILEGES on the entire gym_db database.
-- Responsible for database maintenance, schema changes, and user management.
GRANT ALL PRIVILEGES ON gym_db.* TO 'gym_admin'@'localhost';
-- Optionally, grant specific privileges needed for user management if not ALL PRIVILEGES is desired:
-- GRANT CREATE USER, GRANT OPTION ON *.* TO 'gym_admin'@'localhost';
-- For this scenario, ALL PRIVILEGES on gym_db.* implies these within the database scope.

-- 2.2. Trainer Role (trainer_user)
-- Trainers can view member, plan, booking, and payment info.
-- They can manage their assigned classes and availability.
GRANT SELECT ON gym_db.Members TO 'trainer_user'@'localhost';
GRANT SELECT ON gym_db.MembershipPlans TO 'trainer_user'@'localhost';
GRANT SELECT ON gym_db.Bookings TO 'trainer_user'@'localhost';
GRANT SELECT ON gym_db.Payments TO 'trainer_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON gym_db.Classes TO 'trainer_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON gym_db.TrainerAvailability TO 'trainer_user'@'localhost';
-- DELETE access is restricted as per the principle of least privilege.

-- 2.3. Receptionist/Front-Desk Role (front_desk_user)
-- These users manage member registration, bookings, and payments.
-- They need SELECT on Classes and Trainers to assist members effectively.
GRANT SELECT, INSERT, UPDATE ON gym_db.Members TO 'front_desk_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON gym_db.Bookings TO 'front_desk_user'@'localhost';
-- As requested, DELETE access is limited, possibly only for Bookings.
GRANT DELETE ON gym_db.Bookings TO 'front_desk_user'@'localhost';
GRANT SELECT, INSERT, UPDATE ON gym_db.Payments TO 'front_desk_user'@'localhost';
-- Grant SELECT on Classes and Trainers for practical front-desk operations.
GRANT SELECT ON gym_db.Classes TO 'front_desk_user'@'localhost';
GRANT SELECT ON gym_db.Trainers TO 'front_desk_user'@'localhost';

-- 2.4. Reporting Role (reporter)
-- A dedicated user with SELECT privileges on all relevant tables to generate reports,
-- but no modification rights.
GRANT SELECT ON gym_db.Members TO 'reporter'@'localhost';
GRANT SELECT ON gym_db.Trainers TO 'reporter'@'localhost';
GRANT SELECT ON gym_db.Classes TO 'reporter'@'localhost';
GRANT SELECT ON gym_db.MembershipPlans TO 'reporter'@'localhost';
GRANT SELECT ON gym_db.Bookings TO 'reporter'@'localhost';
GRANT SELECT ON gym_db.Payments TO 'reporter'@'localhost';
GRANT SELECT ON gym_db.TrainerAvailability TO 'reporter'@'localhost';

-- -----------------------------------------------------------
-- 3. Apply the changes
--    It's crucial to run FLUSH PRIVILEGES after making changes to the GRANT tables
--    for the new privileges to take effect immediately without restarting MySQL.
-- -----------------------------------------------------------

FLUSH PRIVILEGES;

-- -----------------------------------------------------------
-- 4. (Optional) Revoke Privileges Example
--    Use REVOKE if you need to remove permissions from a user.
--    For instance, if a trainer should no longer manage classes:
-- -----------------------------------------------------------

-- REVOKE INSERT, UPDATE ON gym_db.Classes FROM 'trainer_user'@'localhost';
-- FLUSH PRIVILEGES;

-- -----------------------------------------------------------
-- 5. (Optional) Drop User Example
--    Use DROP USER to remove a user entirely.
-- -----------------------------------------------------------

-- DROP USER 'old_user'@'localhost';
-- FLUSH PRIVILEGES;