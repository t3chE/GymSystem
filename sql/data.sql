-- Use the GymDB database
USE GymDB;

-- Disable foreign key checks temporarily to allow insertions in any order if needed,
-- though the order below is designed to respect constraints.
SET FOREIGN_KEY_CHECKS = 0;

--
-- Data for table `MembershipPlans`
--
INSERT INTO MembershipPlans (PlanName, Price, DurationMonths, Benefits) VALUES
('Basic Monthly', 29.99, 1, 'Access to gym equipment during off-peak hours.'),
('Standard Monthly', 49.99, 1, 'Full access to gym equipment, 2 free classes per month.'),
('Premium Annual', 399.99, 12, 'Full access, unlimited classes, 1 personal training session per month.'),
('Student Discount', 24.99, 3, 'Access to gym equipment, valid student ID required.');

