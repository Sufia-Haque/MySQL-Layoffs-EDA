-- EXPLORATORY DATA ANANLYSIS
-- IN TOTAL 7 BUSINESS QUESTION ANSWERED WITH INSIGHTS

SELECT *
FROM layoffs_clean_data;

SELECT 
max(total_laid_off) AS Max_layoff, 
min(total_laid_off) AS Min_layoff
FROM layoffs_clean_data;

SELECT
max(percentage_laid_off) AS Max_perentage_layoff,
min(percentage_laid_off) AS Min_percentage_layoff
FROM layoffs_clean_data;

-- Q1. WHAT IS THE MAXIMUM LAYOFFS IN THE SINGLE EVENT, AND WHICH COMPANY HAD A 100% LAYOFF?

SELECT 
max(total_laid_off) AS Max_layoff, 
max(percentage_laid_off) AS Max_perentage_layoff
FROM layoffs_clean_data;

SELECT 
company,
country
industry,
total_laid_off,
funds_raised_millions
FROM layoffs_clean_data
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- INSIGHT: Several well-funded startups shut down entirely  
-- one raised over $2 billion yet laid off 100% of staff, 
-- highlighting that fundraising alone doesn't guarantee survival.

-- Q2. WHICH INDUSTRIES WERE HIT HARDEST BY THE LAYOFFS?

SELECT industry,
SUM(total_laid_off) AS Total_laid_offs,
COUNT(*) AS Number_of_events
FROM layoffs_clean_data
WHERE total_laid_off IS NOT NULL
GROUP BY industry
ORDER BY Total_laid_offs DESC;

-- INSIGHTS: CONSUMER AND RETAIL HAD BEEN HIT THE HARDEST FROM THE LAYOFF
-- FOLLOWED CLOSELY BY TRANSPORTATION--REFLECTING POST-PANDEMIC CHANGES

-- Q3. WHICH COUNTRY EXPERIENCED THE MOST LAYOFFS? AND IS IT CONCENTRATED INTO ONE REGION?

SELECT country,
SUM(total_laid_off) AS Total_laid_off,
ROUND(SUM(total_laid_off) * 100.0 / (SELECT SUM(total_laid_off) FROM layoffs_clean_data), 2) 
AS percentage_of_total
FROM layoffs_clean_data
WHERE total_laid_off IS NOT NULL
GROUP BY country
ORDER BY Total_laid_off DESC
LIMIT 10;

-- INSIGHT: THE UNITED STATES HOLD THE MOST PROPORTION OF THE LAYOFF PERCENTAGE

-- Q4. HOW DID LAYOFFS TREND YEAR OVER YEAR?

SELECT YEAR(date) AS Layoffs_Year,
	SUM(total_laid_off) AS Total_laid_off,
	COUNT(*) AS Number_of_events
FROM layoffs_clean_data
WHERE date IS NOT NULL
GROUP BY Layoffs_Year
ORDER BY Layoffs_Year ASC;

-- INSIGHT: THE LAYOFFS PEAKED IN 2022, BUT 2021 IS THE CALMEST YEAR
-- 2023 HAS FEWER EVENTS BUT STILL THE LAYOFFS IS VERY MASSIVE

-- Q5. WHAT COMPANY STAGE HAD THE MOST LAYOFFS?

SELECT stage,
	SUM(total_laid_off) AS Total_laid_off
FROM layoffs_clean_data
WHERE stage IS NOT NULL
GROUP BY stage
ORDER BY Total_laid_off DESC;

-- INSIGHT: THE POST-IPO STAGE HAS THE MOST LAYOFFS

-- Q6. WHICH COMPANIES RANKED IN THE TOP 3 FOR LAYOFFS FOR EACH YEAR?

WITH Company_year AS 
(
SELECT company,
	YEAR(date) AS Layoff_Year,
	SUM(total_laid_off) AS Total_laid_off
FROM layoffs_clean_data
GROUP BY company, YEAR(date)
),
Ranked AS
(
SELECT Company, Layoff_Year, Total_laid_off,
dense_rank() OVER(PARTITION BY Layoff_Year ORDER BY Total_laid_off DESC) AS Rnk
FROM Company_year
)
SELECT Company, Layoff_Year, Total_laid_off
FROM Ranked
WHERE Rnk <= 3
AND Layoff_Year IS NOT NULL
ORDER BY Layoff_Year ASC, Rnk ASC;

-- INSIGHT: IN 2020 THE TRAVEL AND GIG COMPANIES DOMINATED AS THE PANDEMIC HIT
-- 2020 MARKED THE RISING OF BIG TECH IN 2023 GOOGLE AND MICROSOFT TOOK THE TOP SPOT
-- CONFIRMING THE MOST PROFITABLE TECH WERE NOT IMMUNE

-- Q7. WHICH COMPANIES HAD MULTIPLE ROUND OF LAYOFFS, AND WHAT'S THE TOTAL IMPACT?

SELECT company,
	COUNT(*) AS Round_of_layoffs,
	SUM(total_laid_off) AS Total_laid_off,
	MIN(date) AS First_layoffs,
    MAX(date) AS Last_layoffs
FROM layoffs_clean_data
WHERE total_laid_off IS NOT NULL
GROUP BY company
HAVING COUNT(*) > 1
ORDER BY Total_laid_off DESC
LIMIT 15;

-- INSIGHT: UBER AND SWIGGY HAD THE MOST ROUND OF LAYOFFS, FOLLOWED BY OLA AND SALESFORCE

