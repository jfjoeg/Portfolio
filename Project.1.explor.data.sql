## World Life Expectancy Project (Exploratory Data Analysis)

SELECT *
FROM worldlifexpectancy;


## Look at Life expectancy. Identified some missing values amd removing.

SELECT country, MIN(lifeexpectancy), MAX(lifeexpectancy), ROUND(MAX(lifeexpectancy) - MIN(lifeexpectancy),1) AS expectancy_change
FROM worldlifexpectancy
Group By Country
HAVING MIN(lifeexpectancy) and MAX(lifeexpectancy) <> 0
ORDER BY expectancy_change DESC
;


## Look at avg life expectancy based upon year


SELECT Year, Round(AVG(lifeexpectancy),2)
FROM worldlifexpectancy
WHERE lifeexpectancy <> 0
GROUP BY Year
ORDER BY Year DESC
;


SELECT *
FROM worldlifexpectany;

### Wanted to look at life expectyancy and if it correlates to GDP. missing data in GDP for some countries. Clearly a correlation between GDP and life expectancy.

SELECT Country, ROUND(AVG(lifeexpectancy),1)as avg_lifeexp, Round(AVG(GDP),1) as avg_gdp
FROM worldlifexpectancy
GROUP BY Country
HAVING avg_lifeexp AND avg_gdp <> 0
ORDER BY avg_gdp DESC
;

## Grouping Life Expectancy using a case stmnt. Seperating HIGH GDP/Life EXP vs LOWGDP/LOW life EXP

SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) HIGH_GDP_COUNT,
AVG(CASE WHEN GDP >= 1500 THEN lifeexpectancy ELSE null END) High_GDP_LIFE_EXP,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) LOW_GDP_COUNT,
AVG(CASE WHEN GDP <= 1500 THEN lifeexpectancy ELSE null END) LOW_GDP_LIFE_EXP
FROM worldlifexpectancy;


## Average life exp vs Delopement Status

SELECT status, ROUND(AVG(lifeexpectancy),2)
FROM worldlifexpectancy
GROUP BY status;

SELECT status, count(Distinct Country), ROUND(AVG(lifeexpectancy),2)
FROM worldlifexpectancy
GROUP BY status;

## LOOKING at BMI vs Life Expectancy

SELECT Country, ROUND(AVG(lifeexpectancy),2) as life_exp, 
ROUND(AVG(BMI),2) as avg_bmi
FROM worldlifexpectancy
GROUP BY Country
HAVING life_exp > 0
AND avg_bmi > 0
Order BY avg_bmi asc
;


## Adult Mortality. USING Rolling Total.

SELECT Country, year, lifeexpectancy, AdultMortality,
SUM(adultmortality) OVER(Partition By Country ORDER BY Year) as rolling_total
FROM worldlifexpectancy
WHERE Country LIke '%United%'