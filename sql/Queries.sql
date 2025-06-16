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

-- 10. Calculate the total outstanding balance across all members
SELECT
    SUM(OustandingBalance) AS TotalOutstandingBalance
FROM
    Members;

-- 11. Find classes with available slots (using the UpcomingClasses view)
SELECT
    ClassName,
    ClassDate,
    StartTime,
    EndTime,
    AvailableSlots
FROM
    UpcomingClasses
WHERE
    AvailableSlots > 0
ORDER BY
    ClassDate, StartTime;
  
-- 12. List all active members (using the ActiveMembers view)
SELECT
    MemberID,
    FirstName,
    LastName,
    Email,
    PlanName,
    MembershipEndDate
FROM
    ActiveMembers
ORDER BY
    MembershipEndDate ASC;

-- 13. Get a summary of a member's bookings (using the MemberBookingsSummary view)
SELECT
    ClassName,
    ClassDate,
    StartTime,
    TrainerFirstName,
    TrainerLastName,
    BookingStatus,
    Attendance
FROM
    MemberBookingsSummary
WHERE
    MemberID = 1
ORDER BY
    ClassDate DESC, StartTime DESC;
-- 14. List members who have an outstanding balance (using the MembersWithOutstandingBalance view)
SELECT
    FirstName,
    LastName,
    Email,
    OustandingBalance,
    PlanName
FROM
    MembersWithOutstandingBalance;

-- 15. Count the number of members per membership plan
SELECT
    MP.PlanName,
    COUNT(M.MemberID) AS NumberOfMembers
FROM
    MembershipPlans MP
LEFT JOIN
    Members M ON MP.PlanID = M.PlanID
GROUP BY
    MP.PlanName
ORDER BY
    NumberOfMembers DESC;

-- 16. Get the average price of all membership plans
SELECT
    AVG(Price) AS AveragePlanPrice
FROM
    MembershipPlans;

-- 17. Find the most popular class (by number of bookings)
SELECT
    C.ClassName,
    COUNT(B.BookingID) AS TotalBookings
FROM
    Classes C
JOIN
    Bookings B ON C.ClassID = B.ClassID
GROUP BY
    C.ClassName
ORDER BY
    TotalBookings DESC
LIMIT 1;

-- 18. List all payments made by a specific member (e.g., MemberID 1)
SELECT
    P.PaymentID,
    P.Amount,
    P.PaymentDate,
    P.PaymentMethod,
    P.PaymentDescription
FROM
    Payments P
WHERE
    P.MemberID = 1
ORDER BY
    P.PaymentDate DESC;
