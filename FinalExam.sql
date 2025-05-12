USE Shelter;
go

SELECT 
    p.FirstName,
    p.LastName,
    COUNT(*) AS FundraiserEventCount
FROM 
    PEOPLE p
JOIN 
    FOSTER_EVENT fe ON p.PeopleID = fe.Foster
JOIN 
    EVENT e ON fe.EventID = e.EventID
WHERE 
    e.EventName LIKE '%fundraiser%' -- filters for fundraiser events
    AND p.PeopleType = 'F'          -- ensures the person is a foster
GROUP BY 
    p.FirstName, p.LastName
HAVING 
    COUNT(*) >= 1                   -- only shows those who attended at least one fundraiser
ORDER BY 
    p.LastName;


USE Shelter;
GO

-- Dogs with a condition and procedure
USE Shelter;
GO

-- Select dogs with both a condition and a procedure using UNION ALL
SELECT DISTINCT d.Name
FROM DOG d
JOIN DOG_CONDITION dc ON d.DogID = dc.DogID

UNION

SELECT DISTINCT d.Name
FROM DOG d
JOIN DOG_PROCEDURE dp ON d.DogID = dp.DogID

ORDER BY Name;
GO

--Procedure Cost
USE Shelter;
GO

SELECT 
    d.Name,
    dp.procedure_cost
FROM 
    DOG d
JOIN 
    DOG_PROCEDURE dp ON d.DogID = dp.DogID
WHERE 
    dp.procedure_cost >= (
        SELECT AVG(procedure_cost)
        FROM DOG_PROCEDURE
    )
ORDER BY 
    d.Name;

-- Create table Breed
	USE Shelter;
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BREED')
BEGIN
    CREATE TABLE BREED (
        BreedID INTEGER NOT NULL PRIMARY KEY,
        BreedName CHAR(20) NOT NULL DEFAULT 'None'
    );
END
GO

--Insert data to new table
USE Shelter;
GO

IF NOT EXISTS (SELECT 1 FROM BREED WHERE BreedID = 1000)
BEGIN
    INSERT INTO BREED (BreedID, BreedName)
    VALUES (1000, 'Beagle');
END

IF NOT EXISTS (SELECT 1 FROM BREED WHERE BreedID = 1001)
BEGIN
    INSERT INTO BREED (BreedID, BreedName)
    VALUES (1001, 'Golden Labrador');
END

IF NOT EXISTS (SELECT 1 FROM BREED WHERE BreedID = 1002)
BEGIN
    INSERT INTO BREED (BreedID, BreedName)
    VALUES (1002, 'Husky');
END

IF NOT EXISTS (SELECT 1 FROM BREED WHERE BreedID = 1003)
BEGIN
    INSERT INTO BREED (BreedID, BreedName)
    VALUES (1003, 'Boxer');
END
GO

-- Question 22 Create a view
USE Shelter;
GO

IF OBJECT_ID('dbo.DogProcedureSummary', 'V') IS NOT NULL
    DROP VIEW dbo.DogProcedureSummary;
GO

CREATE VIEW DogProcedureSummary AS
SELECT 
    d.Name AS Name,
    SUM(dp.procedure_cost) AS [Total Cost],
    COUNT(dp.DogProcedureID) AS [Total Num]
FROM 
    DOG d
JOIN 
    DOG_PROCEDURE dp ON d.DogID = dp.DogID
WHERE 
    dp.procedure_cost IS NOT NULL
GROUP BY 
    d.Name;
GO
SELECT * FROM DogProcedureSummary;
GO

-- query the view with dogd have has 5 or more procedure done.
USE Shelter;
GO

SELECT * 
FROM DogProcedureSummary
WHERE [Total Num] >= 5;
GO