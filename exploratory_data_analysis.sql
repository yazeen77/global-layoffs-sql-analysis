-- Exploratory Data Analysis

select *
FROM layoffs_staging2;

select MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;


select *
FROM layoffs_staging2
WHERE percentage_laid_off=1
ORDER BY funds_raised_millions DESC;

select company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
;


SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2
;


select industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC
;

select *
FROM layoffs_staging2;

select country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
;

select YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC
;


select stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC
;


select company, AVG(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
;

select *
FROM layoffs_staging2;

SELECT substring(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE substring(`date`,1,7) IS NOT NULL
group by `MONTH`
ORDER BY 1
;

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

select company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
;

select company,YEAR(`date`),  SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company,YEAR(`date`)
ORDER BY 3 desc;



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


select industry,YEAR(`date`),  SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry,YEAR(`date`)
;



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




select country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
;






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








