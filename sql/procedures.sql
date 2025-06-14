-- Change the delimiter to allow `DELIMITER $$` and `DELIMITER ;` within the procedure definition
DELIMITER $$

-- ==============================================================================
-- Procedure: AddNewMember
-- Description: Adds a new member to the Members table.
--              Calculates the MembershipEndDate based on the Plan's duration.
-- Parameters:
--   p_FirstName: First name of the member.
--   p_LastName: Last name of the member.
--   p_Email: Unique email of the member.
--   p_Phone: Phone number of the member.
--   p_Address: Address of the member.
--   p_DateOfBirth: Date of birth of the member.
--   p_PlanID: ID of the membership plan (FK to MembershipPlans).
--   p_MembershipStartDate: Start date of the membership.
-- ==============================================================================
DROP PROCEDURE IF EXISTS AddNewMember$$
CREATE PROCEDURE AddNewMember(
    IN p_FirstName VARCHAR(50),
    IN p_LastName VARCHAR(50),
    IN p_Email VARCHAR(100),
    IN p_Phone VARCHAR(20),
    IN p_Address VARCHAR(255),
    IN p_DateOfBirth DATE,
    IN p_PlanID INT,
    IN p_MembershipStartDate DATE
)
BEGIN
    DECLARE v_DurationMonths INT;
    DECLARE v_MembershipEndDate DATE;

    -- Retrieve the duration of the selected plan
    SELECT DurationMonths
    INTO v_DurationMonths
    FROM MembershipPlans
    WHERE PlanID = p_PlanID;

    -- Calculate the MembershipEndDate
    SET v_MembershipEndDate = DATE_ADD(p_MembershipStartDate, INTERVAL v_DurationMonths MONTH);

    -- Insert the new member
    INSERT INTO Members (
        FirstName,
        LastName,
        Email,
        Phone,
        Address,
        DateOfBirth,
        PlanID,
        MembershipStartDate,
        MembershipEndDate,
        OustandingBalance -- Default is 0.00, so no need to specify here unless overridden
    ) VALUES (
        p_FirstName,
        p_LastName,
        p_Email,
        p_Phone,
        p_Address,
        p_DateOfBirth,
        p_PlanID,
        p_MembershipStartDate,
        v_MembershipEndDate,
        0.00 -- Explicitly setting to 0.00 to be clear, though it's the default
    );

    SELECT 'Member added successfully!' AS Message, LAST_INSERT_ID() AS MemberID;
END$$
