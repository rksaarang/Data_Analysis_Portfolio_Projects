/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

select *
from [Portfolio project]..covid_death
where continent is not null
order by 3,4



-- Select Data that we are going to be starting with



select location,date,total_cases,new_cases,total_deaths,population
from covid_death
where continent is not null
order by 1,2



-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country



select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percent
from covid_death
where location like '%india%'and  continent is not null
order by 1,2



-- Total Cases vs Population
-- Shows what percentage of population infected with Covid



select location,date,population,total_cases,(total_cases / population)*100 as percentage_population_infected
from covid_death
where continent is not null
order by 1,2 



-- Countries with Highest Infection Rate compared to Population



select location,population,max(total_cases)as highest_infection_rate,max((total_cases / population)*100 )as percentage_population_infected
from covid_death
where continent is not null
group by location,population
order by percentage_population_infected desc



-- Countries with Highest Death Count per Population



select location,max(cast(total_deaths as int))as total_death_count
from covid_death
where continent is not null
group by location
order by total_death_count desc



-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population



select continent,max(cast(total_deaths as int))as total_death_count
from covid_death
where continent is not  null
group by continent
order by total_death_count desc



--showing the continent with the highest death counts per population



select continent,MAX(cast(total_deaths as int))as total_death_count
from covid_death
where continent is not null
group by continent
order by total_death_count desc



--GLOBAL NUMBERS



select sum(new_cases)as total_cases,sum(cast(new_deaths as int))as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as death_percent
from covid_death
where continent is not null
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine



select death.continent,death.location,death.date,death.population,vacc.new_vaccinations,sum(CAST(vacc.new_vaccinations as int)) Over 
(partition by death.location order by death.location,death.date) as rolling_people_vaccinated
from covid_death death
join CovidVaccinations vacc
on death.date=vacc.date
and death.location=vacc.location
where death.continent is not null
order by 2,3



-- Using CTE to perform Calculation on Partition By in previous query



with popvsvac (continent,location,date,population,new_vaccinations,rolling_people_vaccinated)
as
(
 select death.continent,death.location,death.date,death.population,vacc.new_vaccinations,sum(CAST(vacc.new_vaccinations as int)) Over 
 (partition by death.location order by death.location,death.date) as rolling_people_vaccinated
 from covid_death death
 join CovidVaccinations vacc
  on death.date=vacc.date
  and death.location=vacc.location
 where death.continent is not null 
 --order by 2,3
)

select *,(rolling_people_vaccinated/population)*100
from popvsvac



-- Using Temp Table to perform Calculation on Partition By in previous query



drop table if exists #percent_population_vaccinated
create table #percent_population_vaccinated
( continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
rolling_people_vaccinated numeric)

insert into #percent_population_vaccinated
select death.continent,death.location,death.date,death.population,vacc.new_vaccinations,sum(CAST(vacc.new_vaccinations as int)) Over 
 (partition by death.location order by death.location,death.date) as rolling_people_vaccinated
 from covid_death death
 join CovidVaccinations vacc
  on death.date=vacc.date
  and death.location=vacc.location
 where death.continent is not null 
 --order by 2,3

 
select *,(rolling_people_vaccinated/population)*100
from #percent_population_vaccinated



-- Creating View to store data for later visualizations



create view percent_population_vaccinated as
select death.continent,death.location,death.date,death.population,vacc.new_vaccinations,sum(CAST(vacc.new_vaccinations as int)) Over 
 (partition by death.location order by death.location,death.date) as rolling_people_vaccinated
 from covid_death death
 join CovidVaccinations vacc
  on death.date=vacc.date
  and death.location=vacc.location
 where death.continent is not null 
 

