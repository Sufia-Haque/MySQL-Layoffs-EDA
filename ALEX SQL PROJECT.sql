SELECT *
FROM Layoffs;
-- DATA CLEANING
-- 1. REMOVE DUPLICATES
-- 2. STANDARDIZED THE DATA
-- 3. NULL OR BLANK VALUES
-- 4. REMOVE ANY UNNESSARY COLUMN

CREATE TABLE Layoffs_Clean_data
LIKE Layoffs;

DROP TABLE Layoffs_Cleandata;

-- CREATED A NEW TABLE TO WORK ON AS IT HELPS US KEEP THE ORIGINAL DATA INTACT

SELECT *
FROM layoffs_clean_data;

INSERT Layoffs_clean_data
SELECT *
FROM Layoffs;

-- DELETING DUPLICATES

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off, 
percentage_laid_off, `date`,stage, funds_raised_millions) AS Row_num
FROM layoffs_clean_data;


WITH Duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,location, industry, total_laid_off, percentage_laid_off,
 `date`,stage, funds_raised_millions) AS Row_num
FROM layoffs_clean_data
)
SELECT *
FROM Duplicate_cte
WHERE Row_num > 1;


SELECT *
FROM layoffs_clean_data
WHERE company = 'Casper';
-- Fix safe update mode
SET SQL_SAFE_UPDATES = 0;

-- Drop if already exists
DROP TABLE IF EXISTS layoffs_clean_data2;


-- Step 1: Create a staging table with row numbers
CREATE TABLE layoffs_clean_data2 AS
SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY company, location, industry, total_laid_off, 
                 percentage_laid_off, `date`, stage, funds_raised_millions
    ORDER BY (SELECT NULL)
) AS Row_num
FROM layoffs_clean_data;

-- Step 2: Delete duplicates (keep Row_num = 1)
DELETE FROM layoffs_clean_data2
WHERE Row_num > 1;

-- Step 3: Verify it worked
SELECT * FROM layoffs_clean_data2
WHERE company = 'Casper';

-- Drop the original messy table
DROP TABLE layoffs_clean_data;

-- Rename the clean table to the original name
RENAME TABLE layoffs_clean_data2 TO layoffs_clean_data;

SELECT *
FROM layoffs_clean_data
WHERE Row_num > 1;

-- STANDARIZING THE DATA

SELECT *
FROM layoffs_clean_data;

SELECT company,(TRIM(company))
FROM layoffs_clean_data;

UPDATE layoffs_clean_data
SET company = TRIM(company);

SELECT distinct industry
FROM layoffs_clean_data;

SELECT *
FROM layoffs_clean_data
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_clean_data
SET industry =  'Crypto'
WHERE industry LIKE 'Crypto%' ;


SELECT *
FROM layoffs_clean_data;

-- REUPDATED ALL THE INDUSTRY BACK TO CORRECT ORDER

UPDATE layoffs_clean_data lcd
JOIN layoffs l 
  ON lcd.company = l.company 
  AND lcd.date = l.date
SET lcd.industry = l.industry;

SELECT DISTINCT industry 
FROM layoffs_clean_data 
ORDER BY industry;

SELECT DISTINCT country
FROM layoffs_clean_data
ORDER BY country;

SELECT *
FROM layoffs_clean_data
WHERE country LIKE 'United States%';

UPDATE layoffs_clean_data
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT *
FROM layoffs_clean_data;

UPDATE layoffs_clean_data
SET date = STR_TO_DATE(date, '%m/%d/%Y');

ALTER TABLE layoffs_clean_data
MODIFY COLUMN date DATE;

SELECT *
FROM layoffs_clean_data
WHERE industry IS NULL;

UPDATE layoffs_clean_data
SET industry = NULL
WHERE industry = '';

SELECT 
  SUM(industry = '') AS blank_industry,
  SUM(stage = '') AS blank_stage,
  SUM(country = '') AS blank_country
FROM layoffs_clean_data;

SELECT *
FROM layoffs_clean_data
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_clean_data
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_clean_data
WHERE company = 'Airbnb';

UPDATE layoffs_clean_data t1
JOIN layoffs_clean_data t2
	ON t1.company = t2.company
	AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

ALTER TABLE layoffs_clean_data
DROP COLUMN Row_num;

SELECT *
FROM layoffs_clean_data;

-- NOW WE HAVE CLEAN DATA -- 