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

-- ==============================================================================
-- Procedure: UpdateMemberPlan
-- Description: Updates a member's membership plan and recalculates the end date.
-- Parameters:
--   p_MemberID: ID of the member to update.
--   p_NewPlanID: New plan ID for the member (FK to MembershipPlans).
--   p_NewMembershipStartDate: New start date for the membership (can be same as old).
-- ==============================================================================
DROP PROCEDURE IF EXISTS UpdateMemberPlan$$
CREATE PROCEDURE UpdateMemberPlan(
    IN p_MemberID INT,
    IN p_NewPlanID INT,
    IN p_NewMembershipStartDate DATE
)
BEGIN
    DECLARE v_DurationMonths INT;
    DECLARE v_NewMembershipEndDate DATE;
    DECLARE v_MemberExists INT;
    DECLARE v_PlanExists INT;

    -- Check if member exists
    SELECT COUNT(*) INTO v_MemberExists FROM Members WHERE MemberID = p_MemberID;
    IF v_MemberExists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: MemberID does not exist.';
    END IF;

    -- Check if new plan exists
    SELECT COUNT(*) INTO v_PlanExists FROM MembershipPlans WHERE PlanID = p_NewPlanID;
    IF v_PlanExists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: New PlanID does not exist.';
    END IF;

    -- Retrieve the duration of the new plan
    SELECT DurationMonths
    INTO v_DurationMonths
    FROM MembershipPlans
    WHERE PlanID = p_NewPlanID;

    -- Calculate the new MembershipEndDate
    SET v_NewMembershipEndDate = DATE_ADD(p_NewMembershipStartDate, INTERVAL v_DurationMonths MONTH);

    -- Update member's plan details
    UPDATE Members
    SET
        PlanID = p_NewPlanID,
        MembershipStartDate = p_NewMembershipStartDate,
        MembershipEndDate = v_NewMembershipEndDate
    WHERE MemberID = p_MemberID;

    SELECT 'Member plan updated successfully!' AS Message;
END$$
