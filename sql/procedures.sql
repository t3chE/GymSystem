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
