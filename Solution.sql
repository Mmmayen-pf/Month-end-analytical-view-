--USE PORTFOLIO
--GO
--CREATE VIEW QR AS (
--latest date per fund is the latest date for each security in a fund.the position line 
WITH Latest_Date AS(
SELECT 
	ROW_NUMBER () OVER( Partition BY Fund_code,Security_Code, Accounting_Code ORDER BY Report_Date DESC) rn, 
	Report_Date, 
	Fund_Code, 
	Security_Code,
	Accounting_Code,
	[Bloomberg_Sector_L1],
	[Bloomberg_Sector_L2], 
	Country,
	Rating,
	SUM(Exposure_Base_Currency) AS Exposure_Base_Currency,
	SUM(Market_Value_Base_Currency) AS Market_Value_Base_Currency
FROM [dbo].[Large_MultiDim_Investment_Dataset] 
GROUP BY  
	Report_Date,
	Fund_Code,
	Security_Code, 
	Accounting_Code,[Bloomberg_Sector_L1],
	[Bloomberg_Sector_L2], 
	Country,
	Rating
)
-- bringing out one row from the position in a fund code with an aggregated exposure 
SELECT 
	rn, 
	Report_Date, 
	Fund_Code, 
	Security_Code,
	Accounting_Code,
	[Bloomberg_Sector_L1],
	[Bloomberg_Sector_L2], 
	Country,
	Rating,
	SUM(Exposure_Base_Currency) AS Exposure_Base_Currency,
	SUM(Market_Value_Base_Currency) AS Market_Value_Base_Currency
FROM Latest_Date 
WHERE rn = 1
GROUP BY 
	rn,
	Report_Date,
	Fund_Code,
	Security_Code, 
	Accounting_Code,[Bloomberg_Sector_L1],
	[Bloomberg_Sector_L2], 
	Country,
	Rating



--1.The view should clearly show the total exposure per fund and provide insight into what is driving that exposurE---CREATE VIEW QR AS (
--SELECT 
--	Fund_Name, 
--		SUM(Exposure_Base_Currency) AS Total_Exposure
--  FROM .[dbo].[Large_MultiDim_Investment_Dataset]
--  WHERE Report_Date LIKE '%2024%'
--  GROUP BY Fund_Name
--  ORDER BY Total_Exposure

----2.including how it is split across sectors
--SELECT 
--	Fund_Name, 
--	[Bloomberg_Sector_L1],
--    [Bloomberg_Sector_L2],
--		SUM(Exposure_Base_Currency) AS Total_Exposure
--  FROM .[dbo].[Large_MultiDim_Investment_Dataset]
--  WHERE Report_Date LIKE '%2024%'
--  GROUP BY Fund_Name,
--           [Bloomberg_Sector_L1],
--           [Bloomberg_Sector_L2]
--  ORDER BY Total_Exposure
--  )


--SELECT *
-- FROM .[dbo].[Large_MultiDim_Investment_Dataset]