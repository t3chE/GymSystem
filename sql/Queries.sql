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
SELECT
    M.FirstName,
    M.LastName,
    M.Email,
    MP.PlanName,
    MP.Price
FROM
    Members M
JOIN
    MembershipPlans MP ON M.PlanID = MP.PlanID
WHERE
    MP.PlanName = 'Standard Monthly';

-- 8. Find classes taught by a specific trainer (e.g., 'Alice Johnson')
SELECT
    C.ClassName,
    C.ClassDate,
    C.StartTime,
    C.EndTime,
    T.FirstName,
    T.LastName
FROM
    Classes C
JOIN
    Trainers T ON C.TrainerID = T.TrainerID
WHERE
    T.FirstName = 'Alice' AND T.LastName = 'Johnson';

-- 9. Get all confirmed bookings for a specific member (e.g., MemberID 1)
SELECT
    B.BookingID,
    C.ClassName,
    C.ClassDate,
    C.StartTime,
    B.BookingDateTime
FROM
    Bookings B
JOIN
    Classes C ON B.ClassID = C.ClassID
WHERE
    B.MemberID = 1 AND B.BookingStatus = 'Confirmed'
ORDER BY
    C.ClassDate, C.StartTime;
