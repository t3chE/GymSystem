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

-- ==============================================================================
DROP PROCEDURE IF EXISTS BookClass$$
CREATE PROCEDURE BookClass(
    IN p_MemberID INT,
    IN p_ClassID INT
)
BEGIN
    DECLARE v_MaxCapacity INT;
    DECLARE v_CurrentBookings INT;
    DECLARE v_NextBookingID INT;
    DECLARE v_MemberExists INT;
    DECLARE v_ClassExists INT;

    -- Check if member exists
    SELECT COUNT(*) INTO v_MemberExists FROM Members WHERE MemberID = p_MemberID;
    IF v_MemberExists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: MemberID does not exist.';
    END IF;

    -- Check if class exists and get its capacity details
    SELECT MaxCapacity, CurrentBookings INTO v_MaxCapacity, v_CurrentBookings
    FROM Classes
    WHERE ClassID = p_ClassID;

    IF v_MaxCapacity IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: ClassID does not exist.';
    ELSEIF v_CurrentBookings >= v_MaxCapacity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Class is already full.';
    ELSE
        -- Generate a unique BookingID (assuming no AUTO_INCREMENT on BookingID)
        -- Start from 1000 if no bookings exist, otherwise max + 1
        SELECT IFNULL(MAX(BookingID), 1000) + 1 INTO v_NextBookingID FROM Bookings;

        -- Insert the new booking
        INSERT INTO Bookings (BookingID, MemberID, ClassID, BookingDateTime, BookingStatus, Attendance) VALUES (
            v_NextBookingID,
            p_MemberID,
            p_ClassID,
            CURRENT_TIMESTAMP, -- Use CURRENT_TIMESTAMP directly (no parentheses for MySQL 8.4)
            'Confirmed',
            FALSE
        );

        -- Update the current bookings count for the class
        UPDATE Classes
        SET CurrentBookings = CurrentBookings + 1
        WHERE ClassID = p_ClassID;

        SELECT 'Class booked successfully!' AS Message, v_NextBookingID AS BookingID;
    END IF;
END$$

-- ==============================================================================
-- Procedure: RecordPayment
-- Description: Records a payment for a member and updates their outstanding balance.
-- Parameters:
--   p_MemberID: ID of the member making the payment.
--   p_Amount: Amount of the payment.
--   p_PaymentMethod: Method of payment (e.g., 'Credit Card', 'Cash').
--   p_PaymentDescription: Description of the payment.
--   p_TransactionReference: Unique reference for the transaction (optional, can be NULL).
-- ==============================================================================
DROP PROCEDURE IF EXISTS RecordPayment$$
CREATE PROCEDURE RecordPayment(
    IN p_MemberID INT,
    IN p_Amount DECIMAL(10,2),
    IN p_PaymentMethod VARCHAR(50),
    IN p_PaymentDescription VARCHAR(255),
    IN p_TransactionReference VARCHAR(100)
)
BEGIN
    DECLARE v_MemberExists INT;

    -- Check if member exists
    SELECT COUNT(*) INTO v_MemberExists FROM Members WHERE MemberID = p_MemberID;
    IF v_MemberExists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: MemberID does not exist.';
    END IF;

    -- Insert the new payment record
    INSERT INTO Payments (
        MemberID,
        Amount,
        PaymentDate,
        PaymentMethod,
        PaymentDescription,
        TransactionReference
    ) VALUES (
        p_MemberID,
        p_Amount,
        CURRENT_DATE, -- Use CURRENT_DATE directly (no parentheses for MySQL 8.4)
        p_PaymentMethod,
        p_PaymentDescription,
        p_TransactionReference
    );

    -- Update the member's outstanding balance
    UPDATE Members
    SET OustandingBalance = OustandingBalance - p_Amount
    WHERE MemberID = p_MemberID;

    SELECT 'Payment recorded and balance updated!' AS Message, LAST_INSERT_ID() AS PaymentID;
END$$

-- ==============================================================================
-- Procedure: GetMemberDetails
-- Description: Retrieves all details for a specific member.
-- Parameters:
--   p_MemberID: ID of the member to retrieve.
-- ==============================================================================
DROP PROCEDURE IF EXISTS GetMemberDetails$$
CREATE PROCEDURE GetMemberDetails(
    IN p_MemberID INT
)
BEGIN
    SELECT
        M.MemberID,
        M.FirstName,
        M.LastName,
        M.Email,
        M.Phone,
        M.Address,
        M.DateOfBirth,
        MP.PlanName,
        MP.Price AS PlanPrice,
        MP.DurationMonths AS PlanDurationMonths,
        M.MembershipStartDate,
        M.MembershipEndDate,
        M.OustandingBalance
    FROM Members M
    JOIN MembershipPlans MP ON M.PlanID = MP.PlanID
    WHERE M.MemberID = p_MemberID;
END$$

-- ==============================================================================
-- Procedure: GetClassesByDate
-- Description: Retrieves class schedule for a specific date.
-- Parameters:
--   p_ClassDate: The date for which to retrieve classes.
-- ==============================================================================
DROP PROCEDURE IF EXISTS GetClassesByDate$$
CREATE PROCEDURE GetClassesByDate(
    IN p_ClassDate DATE
)
BEGIN
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
        C.CurrentBookings
    FROM Classes C
    JOIN Trainers T ON C.TrainerID = T.TrainerID
    WHERE C.ClassDate = p_ClassDate
    ORDER BY C.StartTime;
END$$

-- Reset the delimiter back to semicolon
DELIMITER ;


