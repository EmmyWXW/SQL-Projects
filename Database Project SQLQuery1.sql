-- ITCS 1170 2025Winter Week 13 Group Steeler Project 
-- Members in group: Xiaowen Wang

-- Code wrote by Xiaowen

-- Step 1: Switch to master so the target DB isn't in use
USE master;
GO

-- Step 2: Ensure the target database is not being used
-- Terminate connections to the database before dropping it
ALTER DATABASE SQLQuery1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Step 3: Now drop the database
DROP DATABASE SQLQuery1;
GO

-- Step 4: Recreate the database
CREATE DATABASE SQLQuery1;
GO

-- Step 5: Use the new database
USE SQLQuery1;
GO

-- Make sure we don't duplicate the table
IF OBJECT_ID('Appointment', 'U') IS NOT NULL DROP TABLE Appointment;
IF OBJECT_ID('Customer', 'U') IS NOT NULL DROP TABLE Customer;
IF OBJECT_ID('Employee', 'U') IS NOT NULL DROP TABLE Employee;
IF OBJECT_ID('Service', 'U') IS NOT NULL DROP TABLE Service;
IF OBJECT_ID('Style', 'U') IS NOT NULL DROP TABLE Style;

-- Create table employee
create table Employee
(
	[EmployeeID]		int				Primary Key,
	[FirstName]			varchar(15)		Not Null,
	[LastName]			varchar(15)		Not Null,
	[DateOfBirth]		date			Not Null,
	[SSN]				char(9)			Not Null,
	[Address]			char(25)		Not Null,
	[City]				char(20)		Not Null,
	[State]				char(2)			Not Null			Default 'MI',
	[Zipcode]			char(5)			Not Null,
	[PhoneNumber]		char(10)		Not Null			Default 'No Phone',
	[Email]				varchar(25)		Not Null			Default 'No Email',
	[Salary]			int				Not Null,
	[DateHired]			date			Not Null,
	[DateTerminated]	date			Null
)

-- Insert values into table employee
insert into Employee (EmployeeID, FirstName, LastName, DateOfBirth, SSN, Address, City, State, Zipcode, PhoneNumber, Email, Salary, DateHired, DateTerminated)
values
(1, 'John', 'Dogh', '1989-03-14', '000000001', '55555 Hidden', 'Bloomfield', 'MI', '00000', '5555555555', '555@gmail.com', 38, '2024-10-01', Null),
(2, 'Jane', 'Doe', '1989-03-14', '000000002', '55555 Hidden', 'Bloomfield', 'MI', '00000', '5555555555', '555@gmail.com', 38, '2024-10-01', Null),
(3, 'Emily', 'Stone', '1990-06-12', '000000003', '123 Main St', 'Detroit', 'MI', '48201', '5551231234', 'emily.stone@example.com', 42, '2023-05-01', NULL);


--create table Customer
create table Customer
(
	[CustomerID]			int			Not Null			Primary Key,
	[FirstName]			varchar(15)		Not Null,
	[LastName]			varchar(15)		Not Null,
	[Address]			char(25)		Not Null,
	[City]				char(20)		Not Null,
	[State]				char(2)			Not Null			Default 'MI',
	[Zipcode]			char(5)			Not Null,
	[PhoneNumber]		char(10)		Not Null			Default 'No Phone',
	[Email]				varchar(25)		Not Null			Default 'No Email',
	[CustomerSince]		date			Not Null
)

-- insert values into Customer table
insert into Customer(CustomerID, FirstName, LastName, Address, City, State, Zipcode, PhoneNumber, Email, CustomerSince)
values
(1, 'Shelby', 'Hall', '5555 Hayes', 'Shelby', 'MI', '55555', '5555555555', '555@gmail.com', '2024-10-14'),
(2, 'Alex', 'Hall', '5554 Hayes', 'Shelby', 'MI', '55554', '5555555554', '554@gmail.com', '2024-10-14'),
(3, 'Chris', 'Evans', '789 Oak Ave', 'Royal Oak', 'MI', '48067', '5556784321', 'chris.evans@example.com', '2024-12-01');

-- create table appointment
create table Appointment
(
	[AppointmentID]			int			Not Null			Primary Key,
	[Date]					date		Not Null,
	[Time]					time		Not Null,
	[EmployeeID]			int			Not Null,
	[CustomerID]			int			Not Null,

	-- Foreign Key Constraints
	FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
	FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
)

-- insert values into table appointment
insert into Appointment(AppointmentID, Date, Time, EmployeeID, CustomerID)
values
(1, '2025-01-02', '14:30:00', 1, 1),
(2, '2025-01-10', '15:30:00', 1, 2),
(3, '2025-02-15', '13:00:00', 3, 3);


-- create Style table
create table Style
(
	[StyleID]			int				Not Null			Primary Key,
	[Name]				char(15)		Not Null,
	[Description]		varchar(30)		Not Null,
	[Colored]			Char(1)			Not Null			default 'N', --'Y' for colored and 'N' for not
	[Washed]			char(1)			Not Null			default 'N', --'Y' for washed and 'N' for not
	[Cost]				Decimal			Not Null,

)

-- Insert values into Style
INSERT INTO Style (StyleID, Name, Description, Colored, Washed, Cost)
VALUES
(1, 'Buzz Cut', 'Simple short style', 'N', 'Y', 15.00),
(2, 'Fade', 'Faded sides, sharp top', 'Y', 'N', 25.00),
(3, 'Twists', 'Twisted protective style', 'Y', 'Y', 40.00),
(4, 'Braids', 'Neat individual braids', 'N', 'Y', 50.00);


--Create table Service
create table Service
(
	[ServiceID]			int				Not Null			Primary Key,
	[StyleID]			int				Not Null,
	
	[AppointmentID]		int				Not Null,

	-- Foreign Key Constraints
	FOREIGN KEY (StyleID) REFERENCES Style(StyleID),
	
	FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID)
)

-- insert values into Service
INSERT INTO Service (ServiceID, StyleID, AppointmentID)
VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 3),
(4, 4, 1);  -- Same appointment, second service



-- Query 1: WHERE clause
-- List all employees who live in Bloomfield
SELECT FirstName, LastName, City
FROM Employee
WHERE City = 'Bloomfield';


-- Query 2: Multi-table JOIN
-- Show appointments with the customer and employee names
SELECT 
    a.AppointmentID,
    a.Date,
    c.FirstName AS CustomerFirstName,
    c.LastName AS CustomerLastName,
    e.FirstName AS EmployeeFirstName,
    e.LastName AS EmployeeLastName
FROM Appointment a
JOIN Customer c ON a.CustomerID = c.CustomerID
JOIN Employee e ON a.EmployeeID = e.EmployeeID;


-- Query 3: JOIN with a SET operator (UNION)
-- Get all distinct first and last names from both Employees and Customers
SELECT FirstName, LastName FROM Employee
UNION
SELECT FirstName, LastName FROM Customer;


-- Query 4: Subquery
-- Find all customers who have had more than one appointment
SELECT FirstName, LastName
FROM Customer
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Appointment
    GROUP BY CustomerID
    HAVING COUNT(*) > 1
);


-- Query 5: OUTER JOIN
-- Show all appointments and any associated services (if any)
SELECT 
    a.AppointmentID,
    a.Date,
    s.ServiceID,
    st.Name AS StyleName
FROM Appointment a
LEFT JOIN Service s ON a.AppointmentID = s.AppointmentID
LEFT JOIN Style st ON s.StyleID = st.StyleID;


-- Query 6: GROUP BY
-- Count how many appointments each employee has had
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    COUNT(a.AppointmentID) AS TotalAppointments
FROM Employee e
JOIN Appointment a ON e.EmployeeID = a.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;


-- Query 7: HAVING clause
-- Same as above, but only show employees with more than one appointment
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    COUNT(a.AppointmentID) AS TotalAppointments
FROM Employee e
JOIN Appointment a ON e.EmployeeID = a.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
HAVING COUNT(a.AppointmentID) > 1;