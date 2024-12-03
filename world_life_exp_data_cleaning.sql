 ## WORLD LIFE EXPECTANCY Project (Data CLeaning)



SELECT * 
FROM worldlifexpectancy;

## Look for duplicate entries

SELECT Country, Year, CONCAT(country, year), COUNT(CONCAT(country, year))
FROM worldlifexpectancy
GROUP BY Country, Year, CONCAT(country, year)
HAVING COUNT(CONCAT(country, year)) > 1
;
## 3 Duplicates found and identify theyre unique row IDs ##

SELECT *
FROM (SELECT ROW_ID, 
	  CONCAT(country, year),
	  ROW_NUMBER () OVER (PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) 	as row_num
	  FROM worldlifexpectancy) AS ROW_table
WHERE row_num > 1
;

### Now we will delete duplicates
SET SQL_SAFE_UPDATES = 0;

DELETE FROM worldlifexpectancy
WHERE 
row_id IN (SELECT row_id
		   FROM (SELECT ROW_ID, 
	       CONCAT(country, year),
	       ROW_NUMBER () OVER (PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country,           year)) as row_num
FROM worldlifexpectancy) AS ROW_table
WHERE row_num > 1)
;

## Re-run querie to verify change and should be nothing in output
SELECT *
FROM (SELECT ROW_ID, 
	  CONCAT(country, year),
	  ROW_NUMBER () OVER (PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country, year)) 	as row_num
	  FROM worldlifexpectancy) AS ROW_table
WHERE row_num > 1
;
## Review data for missing values
SELECT * 
FROM worldlifexpectancy;

## Missing Values in status and life expectancy. Review status for blanks

SELECT *
FROM worldlifexpectancy
WHERE status = ''
;

## Multiples found. Should be able to replicate data from previous entries. either DEVELOPED or DEVELOPING

SELECT DISTINCT(Country)
FROM worldlifexpectancy
WHERE status = 'Developing'
;


UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.country = t2.country
Set t1.status = 'Developing'
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'Developing'
;

UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.country = t2.country
Set t1.status = 'Developed'
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'Developed'
;

## Verify Changes

SELECT *
FROM worldlifexpectancy
WHERE status = ''
;

## Review for NULLS

SELECT *
FROM worldlifexpectancy
WHERE status IS NULL
;

### Fix Life Expectancy. Two Missing Values. Use everage of previous and following year

SELECT *
FROM worldlifexpectancy
WHERE lifeexpectancy = ''
;

SELECT *
FROM worldlifexpectancy
WHERE Country = 'afghanistan'
;

SELECT t1.Country, t1.Year, t1.lifeexpectancy,
t2.Country, t2.Year, t2.lifeexpectancy,
t3.Country, t3.Year, t3.lifeexpectancy,
ROUND((t3.lifeexpectancy + t2.lifeexpectancy)/2,1)
FROM worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country =t2.country
    AND t1.year = t2.year -1
JOIN worldlifexpectancy t3
	ON t1.Country =t3.country
    AND t1.year = t3.year +1
WHERE t1.lifeexpectancy = ''
;
UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country =t2.country
    AND t1.year = t2.year -1
JOIN worldlifexpectancy t3
	ON t1.Country =t3.country
    AND t1.year = t3.year +1
SET t1.lifeexpectancy = ROUND((t3.lifeexpectancy + t2.lifeexpectancy)/2,1)
WHERE t1.lifeexpectancy = ''
;
## Verify changes
SELECT *
FROM worldlifexpectancy
WHERE lifeexpectancy = ''

