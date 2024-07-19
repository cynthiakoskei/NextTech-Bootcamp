-- Database and Table Setup
DROP DATABASE IF EXISTS llin_analysis;
CREATE DATABASE llin_analysis;
USE `llin_analysis`;

CREATE TABLE llin_distribution (
  ID INT NOT NULL AUTO_INCREMENT,
  Number_distributed INT,
  Location VARCHAR(255),
  Country VARCHAR(255),
  Year DATE,
  By_whom VARCHAR(255),
  Country_code VARCHAR(50),
  PRIMARY KEY (ID)
);


-- Descriptive Statistics
SELECT
sum(Number_distributed) over(PARTITION by Country) as 'total number of LLINs',
avg(Number_distributed)over(PARTITION by By_whom) as 'average number of LLINs',
Country,
Year
FROM llin_distribution 
ORDER BY Year ASC;

-- Trends and Patterns
SELECT DISTINCT
sum(Number_distributed) over(PARTITION by By_whom, Year) as 'total number of LLINs by country and year',
Country,
Year
FROM llin_distribution;

-- Volume Insights
SELECT DISTINCT
		location,
		MAX(Number_distributed)AS highest_no_of_llns, 
		MIN(Number_distributed) AS lowest_no_of_llns  
		FROM llin_distribution 
GROUP BY
		location; 

	
WITH llns AS(	
SELECT  DISTINCT
		by_whom ,
		MAX(Number_distributed)AS highest_no_of_llns,
		MIN(Number_distributed) AS lowest_no_of_llns 
     FROM llin_distribution 
GROUP BY
		by_whom)   
SELECT 
		*,
		(highest_no_of_llns -  lowest_no_of_llns) AS Difference 
FROM
		llns;

    
-- Outlier Investigation
SELECT 
		Number_distributed, 
		 location ,
		 year
FROM
		llin_distribution 
WHERE 
		Number_distributed > 3000000;