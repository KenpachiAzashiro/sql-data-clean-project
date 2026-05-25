select * from layoffs_staging2;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc;

select year(`date`) , sum(total_laid_off)
from layoffs_staging2
group by year(`date`) 
order by 1 desc;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc;

select substring(`date`,1,7) as months,sum(total_laid_off)
from layoffs_staging2
where substring(`date`,1,7) is not null
group by months
order by months ;


with rolling_total as (
select substring(`date`,1,7) as months,sum(total_laid_off) as tot

from layoffs_staging2
where substring(`date`,1,7) is not null
group by months
order by months 
)
select months,tot,sum(tot) over(order by months) as rollingtotal
from rolling_total
;

select company,year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
order by 3 desc ;

with comp_year (company, Years, Total_laid_off) as (
select company,year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
order by 3 desc 
) ,
company_year_rank as (
select * ,
dense_rank() over (partition by Years order by Total_laid_off desc) as ranking
from comp_year
where years is not null
)
select * from company_year_rank where ranking<=5;

select company,industry,(SUBSTRING(`date`,1,4)) AS YEARS ,sum(total_laid_off) AS TOT_LAID_OFF
from layoffs_staging2
WHERE (SUBSTRING(`date`,1,4)) AND INDUSTRY IS NOT NULL
group by industry,company, YEARS
order by 3,4 desc






