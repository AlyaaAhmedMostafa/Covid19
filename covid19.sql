Select *
From [Covid19]..CovidVaccinations

Select *
From [Covid19]..[CovidDeaths]

EXEC sp_help CovidVaccinations
EXEC sp_help CovidDeaths

-- changing datatypes from nvarchar to int to make calculations easier
ALTER TABLE Covid19..CovidDeaths
ALTER COLUMN new_cases INT;

ALTER TABLE Covid19..CovidDeaths
ALTER COLUMN total_cases INT;

ALTER TABLE Covid19..CovidDeaths
ALTER COLUMN total_deaths INT

ALTER TABLE Covid19..CovidDeaths
ALTER COLUMN new_deaths INT

ALTER TABLE Covid19..CovidDeaths
ALTER COLUMN new_cases INT

ALTER TABLE Covid19..CovidDeaths
ALTER COLUMN total_cases INT

ALTER TABLE [Covid19]..CovidVaccinations
ALTER COLUMN new_tests INT

ALTER TABLE [Covid19]..CovidVaccinations
ALTER COLUMN total_tests INT

ALTER TABLE [Covid19]..CovidVaccinations
ALTER COLUMN people_vaccinated INT

ALTER TABLE [Covid19]..CovidVaccinations
ALTER COLUMN people_fully_vaccinated INT

ALTER TABLE [Covid19]..CovidVaccinations
ALTER COLUMN new_vaccinations INT


-- Convert the 'date' column to a DATE data type and create a new column 'Full_Date'
SELECT CAST(date AS DATE) AS Full_Date
from [Covid19]..CovidVaccinations

-- Add a new 'Full_Date' column to the 'Covid19..CovidVaccinations' table with a DATE data type
alter table [Covid19]..CovidVaccinations
add Full_Date Date

-- Update the 'Full_Date' column with the converted date values
update [Covid19]..CovidVaccinations
set Full_Date =CAST(date AS DATE)

-- Drop the original 'date' column
alter table [Covid19]..CovidVaccinations drop column  date

-- Convert the 'date' column to a DATE data type and create a new column 'Full_Date'
SELECT CAST(date AS DATE) AS Full_Date
from Covid19..CovidDeaths

-- Add a new 'Full_Date' column to the 'Covid19..CovidDeaths' table with a DATE data type
alter table Covid19..CovidDeaths
add Full_Date Date

-- Update the 'Full_Date' column with the converted date values
update Covid19..CovidDeaths
set Full_Date =CAST(date AS DATE)

-- Drop the original 'date' column
alter table Covid19..CovidDeaths drop column  date


-- Update the 'continent' column to the value of 'location' for rows where 'continent' is null and 'location' matches one of the specified values
UPDATE Covid19..CovidDeaths
SET continent = location
WHERE continent IS NULL
  AND location IN ('North America', 'Asia', 'Africa', 'Oceania', 'South America')

-- Delete rows from 'Covid19..CovidDeaths' where 'location' is a global or regional value
DELETE FROM Covid19..CovidDeaths
WHERE location IN ('World', 'International', 'European Union','Asia','Africa','North America','South America','Oceania','Europe')

-- Update the 'continent' column in 'Covid19..CovidVaccinations' to the 'location' value for rows where 'continent' is null and 'location' is a regional value
UPDATE [Covid19]..CovidVaccinations
SET continent = location
WHERE continent IS NULL
  AND location IN ('North America', 'Asia', 'Africa', 'Oceania', 'South America')

-- Delete rows from 'Covid19..CovidVaccinations' where 'location' is a global or regional value
DELETE FROM [Covid19]..CovidVaccinations
WHERE location IN ('World', 'International', 'European Union','Asia','Africa','North America','South America','Oceania','Europe')

-- Continental Breakdown of COVID-19 Cases and Fatalities
SELECT continent,SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths
FROM Covid19..CovidDeaths
GROUP BY continent
ORDER BY total_cases DESC

--A Continental Analysis of Average Daily COVID-19 Cases and Deaths
SELECT continent,
       AVG(new_cases) AS avg_daily_cases,
       AVG(new_deaths) AS avg_daily_deaths
FROM Covid19..CovidDeaths
GROUP BY continent
ORDER BY avg_daily_cases DESC


--Country Overview of COVID-19 Cases and Fatalities
SELECT Location, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 
    (SUM(CAST(new_deaths AS FLOAT)) / SUM(CAST(new_cases AS FLOAT))) * 100 AS DeathPercentage
FROM Covid19..CovidDeaths   
GROUP BY LOCATION
ORDER BY total_deaths DESC

--Calculating Daily COVID-19 Averages by Country
SELECT location,
       AVG(new_cases ) AS avg_daily_cases,
       AVG(new_deaths) AS avg_daily_deaths
FROM Covid19..CovidDeaths
GROUP BY location
ORDER BY avg_daily_cases DESC

--Tracking the Spread of COVID-19: Day by Day
SELECT Full_Date,
       SUM(new_cases ) AS daily_new_cases,
	   SUM(new_deaths) AS daily_new_deaths
FROM Covid19..CovidDeaths
GROUP BY Full_Date
ORDER BY Full_Date


-- The Cumulative Toll of COVID-19: Cases and Deaths
SELECT 
    Full_Date,
    SUM(new_cases) OVER (ORDER BY Full_Date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_cases,
    SUM(new_deaths) OVER (ORDER BY Full_Date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_deaths
FROM Covid19..CovidDeaths
ORDER BY Full_Date


--Identifying the 10 Days with the Most COVID-19 Deaths and Cases
SELECT Top 10 Full_Date,
       MAX(new_cases) AS peak_cases,
       MAX(new_deaths) AS peak_deaths
FROM Covid19..CovidDeaths
GROUP BY Full_Date
ORDER BY peak_cases DESC

--Assessing the Proportion of COVID-19 Cases in Each Nation
SELECT location,population,
    (SUM(CAST(new_cases AS FLOAT)) / NULLIF(CAST(population AS FLOAT), 0)) * 100 AS percent_population_affected
FROM  Covid19..CovidDeaths
GROUP BY location,population
ORDER BY percent_population_affected DESC


--Identifying Peak COVID-19 Cases and Deaths by Country
WITH MaxCasesAndDeaths AS (
    SELECT location,new_cases, new_deaths,Full_Date,
           ROW_NUMBER() OVER (PARTITION BY location ORDER BY new_cases  DESC) AS Case_Rank,
           ROW_NUMBER() OVER (PARTITION BY location ORDER BY new_deaths DESC) AS Death_Rank
    FROM Covid19..CovidDeaths deaths
)
SELECT location,
       MAX(new_cases) AS Max_cases,
       MAX(new_deaths) AS Max_deaths,
       MAX(CASE WHEN Case_Rank = 1 THEN Full_Date END) AS Date_of_Max_cases,
       MAX(CASE WHEN Death_Rank = 1 THEN Full_Date END) AS Date_of_Max_deaths
FROM MaxCasesAndDeaths
GROUP BY location
ORDER BY Max_cases DESC

--Lockdown Measures and COVID-19: Analyzing Cases, Deaths, and Testing
SELECT 
    SUM(CASE WHEN Full_Date BETWEEN '2020-02-09' AND '2020-03-09' THEN (new_cases ) ELSE 0 END) AS cases_before_lockdown,
    SUM(CASE WHEN Full_Date BETWEEN '2020-03-22' AND '2020-04-22' THEN (new_cases ) ELSE 0 END) AS cases_during_lockdown,
    SUM(CASE WHEN Full_Date BETWEEN '2020-05-15' AND '2020-06-15' THEN (new_cases ) ELSE 0 END) AS cases_after_lockdown
FROM Covid19..CovidDeaths


SELECT 
    SUM(CASE WHEN Full_Date BETWEEN '2020-02-09' AND '2020-03-09' THEN CAST(new_deaths AS INT) ELSE 0 END) AS deaths_before_lockdown,
    SUM(CASE WHEN Full_Date BETWEEN '2020-03-22' AND '2020-04-22' THEN CAST(new_deaths AS INT) ELSE 0 END) AS deaths_during_lockdown,
    SUM(CASE WHEN Full_Date BETWEEN '2020-05-15' AND '2020-06-15' THEN CAST(new_deaths AS INT) ELSE 0 END) AS deaths_after_lockdown
FROM Covid19..CovidDeaths


SELECT 
    SUM(CASE WHEN Full_Date BETWEEN '2020-02-09' AND '2020-03-09' THEN CAST(new_tests AS INT) ELSE 0 END) AS tests_before_lockdown,
    SUM(CASE WHEN Full_Date BETWEEN '2020-03-22' AND '2020-04-22' THEN CAST(new_tests AS INT) ELSE 0 END) AS tests_during_lockdown,
    SUM(CASE WHEN Full_Date BETWEEN '2020-05-15' AND '2020-06-15' THEN CAST(new_tests AS INT) ELSE 0 END) AS test_after_lockdown
FROM [Covid19]..CovidVaccinations
WHERE continent is not null
 

--Measuring Lockdown Impact in Italy: Cases, Deaths, and Testing
-- ITALY AS A CASE STUDY: The impact of the first lockdown
SELECT
    SUM(CASE WHEN Full_Date BETWEEN '2020-02-09' AND '2020-03-09' THEN (new_cases ) ELSE 0 END) AS cases_before_lockdown,
    SUM(CASE WHEN Full_Date BETWEEN '2020-03-22' AND '2020-04-22' THEN (new_cases ) ELSE 0 END) AS cases_during_lockdown,
    SUM(CASE WHEN Full_Date BETWEEN '2020-05-15' AND '2020-06-15' THEN (new_cases ) ELSE 0 END) AS cases_after_lockdown
FROM Covid19..CovidDeaths
WHERE location = 'Italy'


SELECT
    SUM(CASE WHEN Full_Date BETWEEN '2020-02-09' AND '2020-03-09' THEN (new_deaths ) ELSE 0 END) AS deaths_before_lockdown,
    SUM(CASE WHEN Full_Date BETWEEN '2020-03-22' AND '2020-04-22' THEN (new_deaths ) ELSE 0 END) AS deaths_during_lockdown,
    SUM(CASE WHEN Full_Date BETWEEN '2020-05-15' AND '2020-06-15' THEN (new_deaths ) ELSE 0 END) AS deaths_after_lockdown
FROM Covid19..CovidDeaths
WHERE location = 'Italy'


SELECT
    SUM(CASE WHEN Full_Date BETWEEN '2020-02-09' AND '2020-03-09' THEN (new_tests) ELSE 0 END) AS tests_before_lockdown,
    SUM(CASE WHEN Full_Date BETWEEN '2020-03-22' AND '2020-04-22' THEN (new_tests) ELSE 0 END) AS tests_during_lockdown,
    SUM(CASE WHEN Full_Date BETWEEN '2020-05-15' AND '2020-06-15' THEN (new_tests) ELSE 0 END) AS test_after_lockdown
FROM [Covid19]..CovidVaccinations
WHERE location = 'Italy'


-- ITALY AS A CASE STUDY: The impact of the second lockdown
SELECT
    SUM(CASE WHEN Full_Date BETWEEN '2020-08-01' AND '2020-10-01' THEN (new_cases) ELSE 0 END) AS cases_before_lockdown,
    SUM(CASE WHEN Full_Date BETWEEN '2020-10-15' AND '2020-12-15' THEN (new_cases) ELSE 0 END) AS cases_during_lockdown,
    SUM(CASE WHEN Full_Date BETWEEN '2021-01-15' AND '2021-03-15' THEN (new_cases) ELSE 0 END) AS cases_after_lockdown
FROM Covid19..CovidDeaths
WHERE location = 'Italy'

SELECT
        SUM(CASE WHEN Full_Date BETWEEN '2020-08-01' AND '2020-10-01' THEN (new_deaths) ELSE 0 END) AS cases_before_lockdown,
        SUM(CASE WHEN Full_Date BETWEEN '2020-10-15' AND '2020-12-15' THEN (new_deaths) ELSE 0 END) AS cases_during_lockdown,
        SUM(CASE WHEN Full_Date BETWEEN '2021-01-15' AND '2021-03-15' THEN (new_deaths) ELSE 0 END) AS cases_after_lockdown
FROM Covid19..CovidDeaths
WHERE location = 'Italy'


SELECT
    SUM(CASE WHEN Full_Date BETWEEN '2020-08-01' AND '2020-10-01' THEN (new_tests) ELSE 0 END) AS tests_before_lockdown,
    SUM(CASE WHEN Full_Date BETWEEN '2020-10-15' AND '2020-12-15' THEN (new_tests ) ELSE 0 END) AS tests_during_lockdown,
    SUM(CASE WHEN Full_Date BETWEEN '2021-01-15' AND '2021-03-15' THEN (new_tests ) ELSE 0 END) AS test_after_lockdown
FROM [Covid19]..CovidVaccinations
WHERE location = 'Italy'

--ITALY AS A CASE STUDY: Monitoring the Growing Toll of COVID-19 in Italy
SELECT Full_Date,
       SUM(new_cases ) AS daily_new_cases,
	   SUM(new_deaths ) AS daily_new_deaths
FROM Covid19..CovidDeaths
WHERE location = 'Italy' 
GROUP BY Full_Date
ORDER BY Full_Date

--ITALY AS A CASE STUDY:Following the Trajectory of COVID-19 in Italy
SELECT Full_Date,
       SUM(new_cases ) OVER (ORDER BY Full_Date) AS cumulative_cases,
       SUM(new_deaths) OVER (ORDER BY Full_Date) AS cumulative_deaths
FROM Covid19..CovidDeaths
WHERE location = 'Italy'  
ORDER BY Full_Date

-- Calculating Total Vaccination and Vaccination Rate in each country
SELECT vaccinations.location,deaths.population,Sum(cast(vaccinations.new_vaccinations as float)) as totalvaccinations,
    SUM(Cast(vaccinations.new_vaccinations as float)) / Cast(deaths.population as float) AS vaccination_rate
FROM Covid19..CovidDeaths deaths JOIN Covid19..CovidVaccinations vaccinations ON deaths.iso_code = vaccinations.iso_code
GROUP BY vaccinations.location, deaths.population
order by vaccination_rate DESC

--Following the Progress of Vaccination Programs
SELECT Full_Date,SUM(CAST(new_vaccinations AS bigint)) OVER (ORDER BY Full_Date) AS cumulative_Vaccinations
FROM Covid19..CovidVaccinations
ORDER BY Full_Date

--Tracking Vaccination Coverage in a daily basis
SELECT Full_Date, SUM(new_vaccinations) AS daily_Vaccinations
FROM [Covid19]..CovidVaccinations
GROUP BY Full_Date
ORDER BY Full_Date

--Continental Vaccination Coverage
SELECT continent,SUM(Cast( new_vaccinations as bigint)) AS total_vaccinations
FROM [Covid19]..CovidVaccinations
GROUP BY continent
ORDER BY total_vaccinations DESC


