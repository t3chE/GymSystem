-- Use the GymDB database
USE GymDB;

-- ==============================================================================
-- Common Queries for GymDB Database
-- ==============================================================================

-- 1. Select all members
SELECT *
FROM Members;

-- 2. Select all membership plans
SELECT *
FROM MembershipPlans;

-- 3. Select all trainers
SELECT *
FROM Trainers;

-- 4. Select all classes
SELECT *
FROM Classes;

-- 5. Select all bookings
SELECT *
FROM Bookings;

-- 6. Select all payments
SELECT *
FROM Payments;

-- 7. Get details of members on a specific plan (e.g., 'Standard Monthly')
