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
