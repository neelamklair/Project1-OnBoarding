
-- a. Display a list of all property names and their property id’s for Owner Id: 1426. 

SELECT ownerP.OwnerId AS "Owner ID", prop.Id AS "Property ID", prop.Name AS "Property Name" 
FROM Property prop 
JOIN OwnerProperty ownerP ON ownerP.PropertyId = prop.Id 
WHERE OwnerId = 1426

--b. Display the current home value for each property in question a). 

SELECT propValue.Value AS "Property Value", ownerP.OwnerId AS "Owner ID", prop.Id AS "Property ID", prop.Name AS "Property Name" 
FROM Property prop JOIN OwnerProperty ownerP ON ownerP.PropertyId = prop.Id 
JOIN PropertyHomeValue propValue ON propValue.PropertyId = ownerP.PropertyId 
WHERE OwnerId = 1426

--c. For each property in question a), return the following:   
	--i. Using rental payment amount, rental payment frequency, tenant start date and tenant end date to write a query that returns the sum of all payments from start date to end date. 

SELECT 
	CASE 
		WHEN tp.PaymentFrequencyId = 1 
			THEN CAST((tp.PaymentAmount*DATEDIFF(Week, StartDate,EndDate)) AS DECIMAL(8,2)) 
		WHEN tp.PaymentFrequencyId = 2 
			THEN CAST(((tp.PaymentAmount/2)*DATEDIFF(Week, StartDate,EndDate)) AS DECIMAL(8,2)) 
		ELSE 	CAST(((tp.PaymentAmount/4)*DATEDIFF(Week, StartDate,EndDate)) AS DECIMAL(8,2)) END AS "SUM OF ALL PAYMENTS" 
FROM Property prop 
JOIN OwnerProperty ownerP ON ownerP.PropertyId = prop.Id 
JOIN TenantProperty tp ON tp.PropertyId = prop.Id 
WHERE OwnerId = 1426


-- ii. Display the yield. 

SELECT prop.Name AS "Property Name", propValue.Value AS "Property Value", tp.PaymentAmount as Rent, pe.Amount as Expense, CONCAT(CAST((tp.PaymentAmount-pe.Amount)/propValue.Value*100 as numeric(7,2)), '%') as YIELD 
FROM Property prop 
JOIN OwnerProperty ownerP ON ownerP.PropertyId = prop.Id 
JOIN PropertyExpense pe ON prop.Id = pe.PropertyId 
JOIN TenantProperty tp ON prop.Id = tp.PropertyId JOIN PropertyHomeValue propValue 	ON propValue.PropertyId = ownerP.PropertyId 
WHERE OwnerId = 1426

-- d. Display all the jobs available

SELECT prop.Id AS "Property ID", prop.Name, tjr.JobDescription, tjr.OwnerId, tjr.JobStatusId 
FROM TenantJobRequest tjr 
JOIN Property prop ON tjr.PropertyId = prop.Id where tjr.OwnerId = 1426 and	tjr.JobStatusId = 1

-- e. Display all property names, current tenants first and last names and rental payments per week/ fortnight/month for the properties in question a). 

SELECT p.Name, per.FirstName, per.LastName, tp.PaymentAmount 
FROM TenantProperty tp JOIN Person per ON per.Id = tp.TenantId 
JOIN Property p ON p.Id = PropertyId 
	WHERE PropertyId IN
	( 
		SELECT p.Id 
		FROM Property p 
		JOIN OwnerProperty own ON p.Id = own.PropertyId 
		JOIN PropertyHomeValue phv ON phv.PropertyId = own.PropertyId 
		WHERE own.OwnerId = 1426 
	)


-- 2. Use Report Builder or Visual Studio (SSRS) to develop the following report:

SELECT p.Id, op.OwnerId, per.FirstName, per.MiddleName, per.LastName, p.Bedroom, p.Bathroom, p.TargetRent, ad.Number, ad.Street, ad.Suburb, ad.Region, ad.City, ad.PostCode, pe.Description as Expense, pe.Amount AS Expense, pe.Date 
FROM Property p 
INNER JOIN OwnerProperty op ON p.Id = op.PropertyId 
INNER JOIN Address ad ON ad.AddressId = p.AddressId
INNER JOIN Person per ON per.Id = op.OwnerId 
INNER JOIN PropertyExpense pe ON pe.PropertyId = p.Id 
WHERE op.OwnerId = 1426


