SELECT * FROM dataprotfolio.coviddeath
where continent is not null
ORDER BY 3,4;
SELECT * FROM covidvaccination
ORDER BY 3,4;

select location,date,total_cases,new_cases,total_deaths,population from coviddeath
order by 1,2;

#---looking at total cases vs total death
#showing likelihood of dying if you contracted with covid in your country
select location,date,total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from coviddeath where location like "%india%"
order by 1,2;

#looking total_cases vs populations 
#show the what percentage of population got covid
select location,date,population,total_cases, (total_cases/population)*100 as effected_percentage
from coviddeath 
where location like "%india%"
order by 1,2 ;

#looking at countries with highest deaths compares to population
select location,population, max(total_cases) as highestInfected , max(total_cases/population)*100 as effectedpercentage
from coviddeath 
#where location like "%india%"
group by 1,2
order by  max(total_cases/population)*100 desc;

#showing countries with highest deaths per population
select location , max(total_deaths) as Total_deathcounts
from coviddeath
where continent is not null
group by location
order by 2 desc;

#LET'S BREAK DOWN THE THINGS BY CONTINENT
select continent , max(total_deaths) as Total_deathcounts
from coviddeath
where continent is NOT NULL
group by continent
order by Total_deathcounts desc;

#GLOBAL NUMBERS
SELECT SUM(total_cases) AS CASES,SUM(TOTAL_DEATHS) AS TOTALDEATHS, (SUM(NEW_CASES)/SUM(TOTAL_DEATHS))*100 DEATHPERCENT
FROM coviddeath
WHERE CONTINENT IS NOT NULL
#GROUP BY DATE
ORDER BY 1,2;

#LOOKING AT POPULATION VS VACCINATIONS

SELECT DEA.continent,DEA.location,DEA.Date,DEA.population,VAC.new_vaccinations,
SUM(convert(VAC.new_vaccinations,decimal)) OVER(PARTITION BY VAC.location ORDER BY  DEA.location,DEA.DATE) AS RollingpeopleVaccinated
FROM coviddeath DEA
JOIN covidvaccination VAC
ON DEA.DATE=VAC.DATE_  AND DEA.location=VAC.location
WHERE DEA.continent IS NOT NULL
ORDER BY 2,3;

#popvsVac --- gives vaccinated percent through cte's Common table expressiong
with popVsvac (continent,location,date,population,new_vaccinations,RollingpeopleVaccinated)
as (SELECT DEA.continent,DEA.location,DEA.Date,DEA.population,VAC.new_vaccinations,
SUM(convert(VAC.new_vaccinations,decimal)) OVER(PARTITION BY VAC.location ORDER BY  DEA.location,DEA.DATE) AS RollingpeopleVaccinated
FROM coviddeath DEA
JOIN covidvaccination VAC
ON DEA.DATE=VAC.DATE_  AND DEA.location=VAC.location
WHERE DEA.continent IS NOT NULL
ORDER BY 2,3)
select *,(RollingpeopleVaccinated/population)*100 as Vaccinatedpercentage from popVSvac;

#Temporary table
drop table if exists tempopulation;
create temporary table tempopulation(
continent nvarchar(255),
location nvarchar(255),
DAte date,
population numeric,
new_vaccination nvarchar(255),
RollingpeopleVaccinated bigint
);

INSERT INTO tempopulation  
SELECT
    DEA.continent,
    DEA.location,
    DEA.Date,
    DEA.population,
    VAC.new_vaccinations,
    SUM(VAC.new_vaccinations) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.DATE) AS RollingpeopleVaccinated
FROM
    coviddeath DEA
JOIN
    covidvaccination VAC ON DEA.DATE = VAC.DATE_ AND DEA.location = VAC.location;

select *,(RollingpeopleVaccinated/population)*100 as Vaccinatedpercentage from tempopulation;

#CREATING A VIEW FOR FURTHER VISUALIZATION
create view PERCENTPEOPLEVACCINATED AS
SELECT DEA.continent,DEA.location,DEA.Date,DEA.population,VAC.new_vaccinations,
SUM(convert(VAC.new_vaccinations,decimal)) OVER(PARTITION BY VAC.location ORDER BY  DEA.location,DEA.DATE) AS RollingpeopleVaccinated
FROM coviddeath DEA
JOIN covidvaccination VAC
ON DEA.DATE=VAC.DATE_  AND DEA.location=VAC.location
WHERE DEA.continent IS NOT NULL
ORDER BY 2,3;

SELECT * FROM PERCENTPEOPLEVACCINATED

    
    

