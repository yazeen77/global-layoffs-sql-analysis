-- =============================================================
-- GLOBAL LAYOFFS — EXPLORATORY DATA ANALYSIS
-- =============================================================
-- Structured version of my orginal query worksheet
-- =============================================================



-- 01. PREVIEW THE CLEANED DATASET
-- -------------------------------------------------------------
-- Exploratory Data Analysis

select *
FROM layoffs_staging2;


-- 02. MAXIMUM LAYOFFS AND LAYOFF PERCENTAGE
-- -------------------------------------------------------------
select MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;


-- 03. COMPANIES WITH 100% WORKFORCE LAID OFF
-- -------------------------------------------------------------
select *
FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC;


-- 04. TOTAL LAYOFFS BY COMPANY
-- -------------------------------------------------------------
select company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
;


-- 05. DATASET DATE RANGE
-- -------------------------------------------------------------
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2
;


-- 06. TOTAL LAYOFFS BY INDUSTRY
-- -------------------------------------------------------------
select industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC
;


-- 07. PREVIEW THE CLEANED DATASET
-- -------------------------------------------------------------
select *
FROM layoffs_staging2;


-- 08. TOTAL LAYOFFS BY COUNTRY
-- -------------------------------------------------------------
select country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
;


-- 09. TOTAL LAYOFFS BY YEAR
-- -------------------------------------------------------------
select YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC
;


-- 10. TOTAL LAYOFFS BY COMPANY STAGE
-- -------------------------------------------------------------
select stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC
;


-- 11. AVERAGE LAYOFF PERCENTAGE BY COMPANY
-- -------------------------------------------------------------
select company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
;


-- 12. PREVIEW THE CLEANED DATASET
-- -------------------------------------------------------------
select *
FROM layoffs_staging2;


-- 13. MONTHLY LAYOFFS
-- -------------------------------------------------------------
SELECT substring(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
group by `MONTH`
ORDER BY 1
;


-- 14. MONTHLY LAYOFFS WITH ROLLING TOTAL
-- -------------------------------------------------------------
WITH Rolling_total AS
(
SELECT substring(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
group by `MONTH`
ORDER BY 1
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total
;


-- 15. TOTAL LAYOFFS BY COMPANY
-- -------------------------------------------------------------
select company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
;


-- 16. COMPANY LAYOFFS BY YEAR
-- -------------------------------------------------------------
select company,YEAR(`date`),  SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 desc;


-- 17. TOP 5 COMPANIES BY LAYOFFS FOR EACH YEAR
-- -------------------------------------------------------------
WITH company_year(company, years, total_laid) AS
(
select company,YEAR(`date`),  SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
), 
company_year_rank AS
(
SELECT *, dense_rank() OVER (PARTITION BY years ORDER BY total_laid DESC) AS Ranking
FROM company_year
WHERE years IS NOT NULL
)
SELECT *
FROM company_year_rank
WHERE Ranking <=5
;


-- 18. INDUSTRY LAYOFFS BY YEAR
-- -------------------------------------------------------------
select industry,YEAR(`date`),  SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry,YEAR(`date`)
;


-- 19. TOP 5 INDUSTRIES BY LAYOFFS FOR EACH YEAR
-- -------------------------------------------------------------
WITH industry_year(industry, years, total_laid) AS
(
select industry,YEAR(`date`),  SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry,YEAR(`date`)
), 
industry_year_rank AS
(
SELECT *, dense_rank() OVER (PARTITION BY years ORDER BY total_laid DESC) AS Ranking
FROM industry_year
WHERE years IS NOT NULL
)
SELECT *
FROM industry_year_rank
WHERE Ranking <=5
;


-- 20. TOTAL LAYOFFS BY COUNTRY
-- -------------------------------------------------------------
select country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
;


-- 21. TOP 5 COUNTRIES BY LAYOFFS FOR EACH YEAR
-- -------------------------------------------------------------
WITH country_year(country, years, total_laid) AS
(
select country,YEAR(`date`),  SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country,YEAR(`date`)
), 
country_year_rank AS
(
SELECT *, dense_rank() OVER (PARTITION BY years ORDER BY total_laid DESC) AS Ranking
FROM country_year
WHERE years IS NOT NULL
)
SELECT *
FROM country_year_rank
WHERE Ranking <=5
;
