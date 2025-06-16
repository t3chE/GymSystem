-- Use the GymDB database
USE GymDB;

-- ==============================================================================
-- View: ActiveMembers
-- Description: Shows details of all members whose membership is currently active
--              (MembershipEndDate is today or in the future).
-- ==============================================================================
DROP VIEW IF EXISTS ActiveMembers;
CREATE VIEW ActiveMembers AS
SELECT
    M.MemberID,
    M.FirstName,
    M.LastName,
    M.Email,
    M.Phone,
    MP.PlanName,
    MP.Price AS CurrentPlanPrice,
    M.MembershipStartDate,
    M.MembershipEndDate,
    M.OustandingBalance
FROM
    Members M
JOIN
    MembershipPlans MP ON M.PlanID = MP.PlanID
WHERE
    M.MembershipEndDate >= CURRENT_DATE();
    
-- ==============================================================================
-- View: UpcomingClasses
-- Description: Displays information about classes scheduled for today or in the future,
--              including trainer details and remaining capacity.
-- ==============================================================================
DROP VIEW IF EXISTS UpcomingClasses;
CREATE VIEW UpcomingClasses AS
SELECT
    C.ClassID,
    C.ClassName,
    C.ClassDescription,
    C.ClassDate,
    C.StartTime,
    C.EndTime,
    T.FirstName AS TrainerFirstName,
    T.LastName AS TrainerLastName,
    T.Specialisation,
    C.MaxCapacity,
    C.CurrentBookings,
    (C.MaxCapacity - C.CurrentBookings) AS AvailableSlots
FROM
    Classes C
JOIN
    Trainers T ON C.TrainerID = T.TrainerID
WHERE
    C.ClassDate >= CURRENT_DATE()
ORDER BY
    C.ClassDate, C.StartTime;

