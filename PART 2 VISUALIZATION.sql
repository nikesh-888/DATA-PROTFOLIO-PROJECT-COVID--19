/*

Queries used for Tableau Project

*/



#-- 1. 

Select SUM(new_cases) as total_cases, SUM(convert(new_deaths, decimal)) as total_deaths, SUM(convert(new_deaths,decimal))/SUM(New_Cases)*100 as DeathPercentage
From coviddeath
#--Where location like '%states%' 
where location is not null
##--Group By date
order by 1,2;

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


Select SUM(new_cases) as total_cases, SUM(convert(new_deaths,decimal)) as total_deaths, SUM(convert(new_deaths,decimal))/SUM(New_Cases)*100 as DeathPercentage
From coviddeath
#----Where location like '%states%'
where location = 'World'
#----Group By date
order by 1,2 ;

#2. 

#-- We take these out as they are not included in the above queries and want to stay consistent
#-- European Union is part of Europe

Select continent, SUM(new_deaths) as TotalDeathCount
From coviddeath
Where continent is not null 
and location not in ('World', 'European Union', 'International')
Group by continent
order by TotalDeathCount desc;

select distinct(continent) from coviddeath;


#3 Percent Populated Infected per country
Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From coviddeath
#--Where location like '%india%'
Group by Location, Population
order by PercentPopulationInfected desc;

#4 Percent Populated Infected (grouped by location,population and date)
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From coviddeath
#--Where location like '%india%'
Group by Location, Population, date
order by PercentPopulationInfected desc;