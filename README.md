# Month-end Analytical View

## Project Overview
This project demonstrates how to build a month-end analytical view to understand how risk is distributed across investment funds using the latest available reporting data.

## Dataset
The dataset `Large_MultiDim_Investment_Dataset.csv` contains multi-dimensional investment data including:
- Fund information  
- Sector and region breakdowns  
- Exposure and market values  

## Objective
To provide a clear, auditable view of:
- Total exposure per fund  
- Key drivers of risk  
- Comparison between exposure and market value  

## SQL Solution
The full SQL logic is available in `Solution.sql`.  
It uses:
- CTEs  
- Aggregations  
- Window functions  
- Data quality checks  

## Key Skills Demonstrated
- Advanced SQL (CTEs, window functions)
- Financial data analysis
- Data modelling
- GitHub documentation

## SQL Solution

The full SQL logic is available in `Solution.sql`.

```sql
CREATE VIEW QR AS 
WITH Latest_Date AS (
    SELECT 
        ROW_NUMBER() OVER (
            PARTITION BY Fund_Code, Security_Code, Accounting_Code 
            ORDER BY Report_Date DESC
        ) AS rn, 
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
        Accounting_Code,
        [Bloomberg_Sector_L1],
        [Bloomberg_Sector_L2], 
        Country,
        Rating
)

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
    Accounting_Code,
    [Bloomberg_Sector_L1],
    [Bloomberg_Sector_L2], 
    Country,
    Rating;
