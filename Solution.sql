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



