SELECT * FROM donationdb.data;
SET SQL_SAFE_UPDATES = 0;
UPDATE data
SET Donation_Amount = NULL
WHERE Donation_Amount < 0;

DELETE FROM data
WHERE Donor_ID IN (
    SELECT Donor_ID
    FROM (
        SELECT Donor_ID, COUNT(*) AS cnt
        FROM data
        GROUP BY Donor_ID, Donation_Date
        HAVING cnt > 1
    ) AS duplicates
);

-- Aggregate Total Donations by Province:
SELECT Province, 
       COUNT(Donor_ID) AS Total_Donors, 
       SUM(Donation_Amount) AS Total_Donations
FROM data
GROUP BY Province
ORDER BY Total_Donations DESC;

-- Find the Most Popular Causes:
SELECT Cause_Supported, 
       COUNT(Donor_ID) AS Donor_Count, 
       SUM(Donation_Amount) AS Total_Donations
FROM data
GROUP BY Cause_Supported
ORDER BY Total_Donations DESC;

-- Monthly Donation Trends:
SELECT YEAR(Donation_Date) AS Year, 
       MONTH(Donation_Date) AS Month, 
       SUM(Donation_Amount) AS Total_Donations
FROM data
GROUP BY YEAR(Donation_Date), MONTH(Donation_Date)
ORDER BY Year, Month;

-- Donor Segmentation by Age Group:
SELECT 
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS Age_Group,
    COUNT(Donor_ID) AS Donor_Count,
    SUM(Donation_Amount) AS Total_Donations
FROM data
GROUP BY Age_Group
ORDER BY Total_Donations DESC;

-- Recurring vs. One-Time Donations:
SELECT Donation_Type, 
       COUNT(Donor_ID) AS Donor_Count, 
       SUM(Donation_Amount) AS Total_Donations
FROM data
GROUP BY Donation_Type
ORDER BY Total_Donations DESC;

-- Identify Seasonal Donation Trends:
SELECT Donation_Season, 
       SUM(Donation_Amount) AS Total_Donations
FROM data
GROUP BY Donation_Season
ORDER BY Total_Donations DESC;

-- Engagement Analysis:
SELECT Engagement_Score, 
       COUNT(Donor_ID) AS Donor_Count, 
       AVG(Donation_Amount) AS Avg_Donation
FROM data
GROUP BY Engagement_Score
ORDER BY Engagement_Score DESC;

-- Analyze Donation Channels:
SELECT Donation_Channel, 
       COUNT(Donor_ID) AS Donor_Count, 
       SUM(Donation_Amount) AS Total_Donations
FROM data
GROUP BY Donation_Channel
ORDER BY Total_Donations DESC;


-- Export Transformed Data for Power BI:
SELECT * FROM data;



