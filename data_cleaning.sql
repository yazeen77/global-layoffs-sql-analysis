SELECT *
FROM layoffs
;
-- REMOVE DUPLICATES
-- STANDARDIZE THE DATA
-- NULL VALUES
 -- REMOVE any columns
 
 CREATE TABLE layoffs_staging
 LIKE layoffs;
 
INSERT layoffs_staging
SELECT *
FROM layoffs
;
SELECT *
FROM layoffs_staging
;

SELECT *, 
row_number() OVER(
PARTITION BY company,total_laid_off,percentage_laid_off,`date`) AS row_num
FROM layoffs_staging
;

WITH duplicate_cte AS
(
SELECT *, 
row_number() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num>1;

SELECT *
FROM layoffs_staging
WHERE company='Casper';


WITH duplicate_cte AS
(
SELECT *, 
row_number() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num>1;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2
WHERE row_num>1;

INSERT INTO layoffs_staging2
SELECT *, 
row_number() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num>1;

SELECT *
FROM layoffs_staging2;



SELECT *
FROM layoffs_staging2
;


SELECT distinct country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1
;


UPDATE layoffs_staging2
SET country='United States'
WHERE country LIKE 'United States%'
;



SELECT `date`
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`,'%m/%d/%Y')
;



ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;

SELECT distinct INDUSTRY
FROM layoffs_staging2
ORDER BY 1
;

SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR industry=''
;

SELECT *
FROM layoffs_staging2
;

UPDATE layoffs_staging2
SET industry =NULL
WHERE industry =''
;



SELECT t1.industry,t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry= '')
AND t2.industry IS NOT NULL
;
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry= '')
AND t2.industry IS NOT NULL
;

SELECT *, row_number() OVER()
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;

DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;


SELECT * 
FROM layoffs_staging2
;

ALTER TABLE layoffs_staging2
DROP column row_num
;

