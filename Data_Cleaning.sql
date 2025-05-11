SELECT * 
FROM layoffs;

# duplicate table (for avoid any error in real dataset)
CREATE TABLE layoffs_staging
LIKE layoffs;
SELECT * 
FROM layoffs_staging;
INSERT layoffs_staging
SELECT*
FROM layoffs;

-- Delete duplicate
SELECT *, # identifying the duplicate row by number >1 that means duplicate
ROW_NUMBER() OVER(
PARTITION BY company, industry, location, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS #checking the duplicate
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, location, total_laid_off, percentage_laid_off, `date`,
country, stage, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE ROW_NUM > 1;

SELECT* # checking duplicates
FROM layoffs_staging
WHERE company='Casper';

WITH duplicate_cte AS #delete the duplicate
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, location, total_laid_off, percentage_laid_off, `date`,
country, stage, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE ROW_NUM > 1;

CREATE TABLE `layoffs_staging2` ( #edit statement, create another table to avoid wrong delete data
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, industry, location, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

SET SQL_SAFE_UPDATES = 0; # shutdown SAFE MODE (error 1175)

SELECT * 
FROM layoffs_staging2
WHERE row_num>1;

DELETE # delete data
FROM layoffs_staging2
WHERE row_num > 1;

SELECT * 
FROM layoffs_staging2;

-- Standardizing data
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2 #update and fix the space
SET company = trim(company);

SELECT DISTINCT industry #checking
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_staging2 #delete the same industry type
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
FROM layoffs_staging2
ORDEr BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) # delete point (.)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2 #update data
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%'; 

SELECT `date`, #change text date column into time series
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2 #change column type into date, but do it only in staging data not the real one
MODIFY COLUMN `date` DATE;

-- Update NULL
SELECT*
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2 # Making blank column into null
SET industry = NULL
WHERE industry = ''
;

SELECT DISTINCT industry
FROM layoffs_staging2
WHERE industry IS NULL 
OR industry = '';

SELECT* #checking null based on company name
FROM layoffs_staging2
WHERE company = 'Airbnb';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1 #Update in industry column the same level with other by using join
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT* #checking null based on company name
FROM layoffs_staging2
WHERE company  LIKE 'Bally%';

SELECT* 
FROM layoffs_staging2;
#cannot retrive the null in total_laid_off, percentage_laid_off, and funds_raised_millions column becasue there are not enough data

-- Delete Column/drop
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;