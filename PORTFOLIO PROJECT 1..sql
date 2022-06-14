select * 
from [Portfolio project].dbo.[CovidDeaths-june22]
ORDER BY 3,4

select * 
from [Portfolio project].dbo.[CovidVaccinations-june22]
ORDER BY 3,4

--selecting some specific data to work with

select location, date, population,total_cases,new_cases,total_deaths
from [Portfolio project].dbo.[CovidDeaths-june22]
ORDER BY 1,2

--Calculating Total Cases vs Total Teaths
-- the below table shows the likelihood of dying when infected in Nigeria
select location, date,new_cases, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from [Portfolio project].dbo.[CovidDeaths-june22]
where location = 'Nigeria'
ORDER BY 1,2


--Looking at the total Cases vs Population
--The table below shows the percentage of the population that got infected
select location, date,total_cases,total_deaths,population, (total_cases/population)*100 as PercentageInfected
from [Portfolio project].dbo.[CovidDeaths-june22]
where location = 'Nigeria'
ORDER BY 1,2



--creating view for Nigeria 
create view NigeriaDeathDetails as 
select date,total_cases,total_deaths,population, (total_cases/population)*100 as PercentageInfected
from [Portfolio project].dbo.[CovidDeaths-june22]
where location = 'Nigeria'


--Looking at the most infected country
select location,population,MAX(total_cases) as HighestInfection, MAX((total_cases/population)*100) as PercentagePopulationInfected
from [Portfolio project].dbo.[CovidDeaths-june22]
Group by location, population
ORDER BY  PercentagePopulationInfected desc 


--SELECTING COUNTRY WITH COUNT OF DEATH
select location,MAX(total_deaths) as CountOfDeath
from [Portfolio project].dbo.[CovidDeaths-june22]
where continent is not null
group by location
order by CountOfDeath Desc


--Breaking down the total deaths by economic factors

select location,MAX(total_deaths) as TotalDeath
from [Portfolio project].dbo.[CovidDeaths-june22]
where continent is  null and location in ('World', 'Upper middle income', 'High income', 'Lower middle income','Low income', 'International')
group by location
order by TotalDeath Desc


--creating view
create view DeathByEconomicFactors as
select location,MAX(total_deaths) as TotalDeath
from [Portfolio project].dbo.[CovidDeaths-june22]
where continent is  null and location in ('World', 'Upper middle income', 'High income', 'Lower middle income','Low income', 'International')
group by location

--Breaking down of total deaths by continent

select location,MAX(total_deaths) as TotalDeath
from [Portfolio project].dbo.[CovidDeaths-june22]
where continent iS null and location in  ('Africa','Asia','Europe', 'South America', 'North America','Oceania')
group by location 
order by TotalDeath Desc



--creating view
create view DeathByCountinent as
select location,population, MAX(total_deaths) as TotalDeath, ((MAX(total_deaths)/population)*100) as DeathPercentage
from [Portfolio project].dbo.[CovidDeaths-june22]
where continent iS null and location in  ('Africa','Asia','Europe', 'South America', 'North America','Oceania')
group by location, population 


--Global Cases, death and DeathRate

select sum(new_cases) as CovidCases, sum(new_deaths) as Death, ((sum(new_deaths)/sum(new_cases))* 100) as PercentageDeath
from [Portfolio project].dbo.[CovidDeaths-june22]
where continent is not null
--group by date
ORDER BY 1,2



--by date

select date,sum(new_cases) as CovidCases, sum(new_deaths) as Death, ((sum(new_deaths)/sum(new_cases))* 100) as PercentageDeath
from [Portfolio project].dbo.[CovidDeaths-june22]
where continent is not null and new_cases is not null
group by date
ORDER BY 1,2

--Vaccination Analysis
select *
from [Portfolio project].dbo.[CovidVaccinations-june22]

--Merging deaths and vaccination table together
select *
from [Portfolio project].dbo.[CovidDeaths-june22] dth
join [Portfolio project].dbo.[CovidVaccinations-june22] vac
on dth.location = vac.location 
and dth.date = vac.date

--Showing the total population and Vaccinations
select dth.continent,dth.location,dth.population,dth.date, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dth.location order by dth.location, dth.date) as TotalVaccinations
from [Portfolio project].dbo.[CovidDeaths-june22] dth
join [Portfolio project].dbo.[CovidVaccinations-june22] vac
on dth.location = vac.location 
and dth.date = vac.date 
where dth.continent is not null
order by  1,2,4




-- CREATING TABLE
CREATE TABLE #PecentPopulationVaccinated
(
continent nvarchar(50),
location nvarchar(50),
population numeric,
date datetime,
New_vaccinations numeric,
TotalVaccination float 
)

---Populating the table
insert into #PecentPopulationVaccinated
select dth.continent,dth.location,dth.population,dth.date, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dth.location order by dth.location, dth.date) as TotalVaccinations
from [Portfolio project].dbo.[CovidDeaths-june22] dth
join [Portfolio project].dbo.[CovidVaccinations-june22] vac
on dth.location = vac.location 
and dth.date = vac.date 
where dth.continent is not null
order by  1,2,4


--Creating view
Create view PecentPopulationVaccinated as
select dth.continent,dth.location,dth.population,dth.date, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dth.location order by dth.location, dth.date) as TotalVaccinations
from [Portfolio project].dbo.[CovidDeaths-june22] dth
join [Portfolio project].dbo.[CovidVaccinations-june22] vac
on dth.location = vac.location 
and dth.date = vac.date 
where dth.continent is not null


