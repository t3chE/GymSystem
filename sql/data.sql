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

--
-- Data for table `Members`
-- (Ensure PlanID references existing PlanIDs from MembershipPlans)
--
INSERT INTO Members (FirstName, LastName, Email, Phone, Address, DateOfBirth, PlanID, MembershipStartDate, MembershipEndDate, OustandingBalance) VALUES
('John', 'Doe', 'john.doe@email.com', '07700 900201', '123 Main St, Anytown', '1990-05-15', 2, '2023-01-01', '2024-01-01', 0.00),
('Jane', 'Smith', 'jane.smith@email.com', '07700 900202', '456 Oak Ave, Somewhere', '1988-11-20', 1, '2023-03-01', '2024-03-01', 10.00),
('Peter', 'Jones', 'peter.jones@email.com', '07700 900203', '789 Pine Ln, Nowhere', '1995-07-07', 3, '2022-10-15', '2023-10-15', 0.00),
('Sarah', 'Davis', 'sarah.davis@email.com', '07700 900204', '101 Elm Rd, Ourcity', '2000-02-28', 4, '2024-02-01', '2024-05-01', 0.00),
('Michael', 'Taylor', 'michael.t@email.com', '07700 900205', '22 Apple Way, Yourtown', '1985-09-10', 2, '2023-11-01', '2024-11-01', 25.50);

--
-- Data for table `Trainers`
--
INSERT INTO Trainers (FirstName, LastName, Email, Phone, Specialisation) VALUES
('Alice', 'Johnson', 'alice.johnson@gym.com', '07700 900101', 'Strength Training'),
('Bob', 'Williams', 'bob.williams@gym.com', '07700 900102', 'Cardio & Endurance'),
('Charlie', 'Brown', 'charlie.brown@gym.com', '07700 900103', 'Yoga & Flexibility'),
('Diana', 'Miller', 'diana.miller@gym.com', '07700 900104', 'CrossFit');

