use CovidPortfolio
go
select *
from CovidPortfolio.dbo.coviddeaths
order by 3,4

select *
from CovidPortfolio.dbo.CovidVaccinations
order by 3,4

--Select data that we are going to be used

select location,date,population,total_cases,total_deaths,new_cases
from CovidPortfolio.dbo.coviddeaths
order by 1,2

--Total cases vs total deaths

select location,date,total_cases,total_deaths,
CAST(((cast(total_deaths as int)*1.00/cast(total_cases as int))*100) AS DECIMAL(18,2)) as DeathPercentage
from CovidPortfolio.dbo.coviddeaths
where location like '%states%'
order by 1,2

--Looking at Total cases Vs Population
--Shows percentage of population got covid

select location,date,population,total_cases,
(total_cases/population)*100 as covid_percentage
from CovidPortfolio.dbo.coviddeaths
where location like '%states%'
order by 1,2

--Looking at countries with highest infected rate to population

select location,population,max(total_cases) as highest_cases,
max((total_cases/population)*100)as highest_infected_cases
from CovidPortfolio.dbo.coviddeaths
where location like 'India%'
group by location,population
order by highest_infected_cases desc

--Let's break things down by COntinent

select continent, Max(cast(total_deaths as int))as highest_deaths
from CovidPortfolio.dbo.coviddeaths
where continent is not null
group by continent
order by continent desc

--Global Numbers

select sum(new_cases) as totalcases,sum(new_deaths) as totaldeaths,sum(new_deaths)/Sum(new_cases)*100 as deathpercentage
from CovidPortfolio.dbo.coviddeaths
where continent is not null and new_cases != 0
--group by date,continent
order by 1,2

--Looking at total population vs total vaccination
select  distinct  isnumeric(new_vaccinations) from [CovidPortfolio].[dbo].[CovidVaccinations]
select  distinct new_vaccinations from [CovidPortfolio].[dbo].[CovidVaccinations] where isnumeric(new_vaccinations)=1

select d.continent,d.location,d.date,d.population,v.new_vaccinations ,
sum(cast(v.new_vaccinations as bigint)) over (partition by d.location order by d.location,d.date) as rollingvaccinated
from [CovidPortfolio].[dbo].[coviddeaths] as d 
join  [CovidPortfolio].[dbo].[CovidVaccinations] as v
ON d.location = v.location and d.date = v.date
where d.continent is not null
--AND d.location = 'Albama'
order by 2,3

;with vacvspop (continent,location,date,population,new_vaccinations,rollingvaccinated)
as
(
select d.continent,d.location,d.date,d.population,v.new_vaccinations ,
sum(cast(v.new_vaccinations as bigint)) over (partition by d.location order by d.location,d.date) as rollingvaccinated
from [CovidPortfolio].[dbo].[coviddeaths] as d 
join  [CovidPortfolio].[dbo].[CovidVaccinations] as v
ON d.location = v.location and d.date = v.date
where d.continent is not null
)

SELECT *,(rollingvaccinated/population)*100 FROM vacvspop

--TEMP TABLE
drop table if exists  #percentpopulationvaccinated
Create table #percentpopulationvaccinated
( 
  continent nvarchar(255),
  location nvarchar(255),
  date datetime,
  Population numeric,
  new_vaccinations numeric,
   rollingvaccinated numeric
   )

   insert into #percentpopulationvaccinated
   
   select d.continent,d.location,d.date,d.population,v.new_vaccinations ,
sum(cast(v.new_vaccinations as bigint)) over (partition by d.location order by d.location,d.date) as rollingvaccinated
from [CovidPortfolio].[dbo].[coviddeaths] as d 
join  [CovidPortfolio].[dbo].[CovidVaccinations] as v
ON d.location = v.location and d.date = v.date
where d.continent is not null
SELECT *,(rollingvaccinated/population)*100 FROM #percentpopulationvaccinated 
