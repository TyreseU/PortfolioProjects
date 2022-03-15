select *
from PortfolioProject..['Covid Deaths$']
Where continent is not null
order by 3,4

--select *
--from PortfolioProject..Covidvaccinations$
--order by 3,4

select location, date, total_cases, new_cases, total_cases, population
from PortfolioProject..['Covid Deaths$']
order by 1,2

--Looking at Total cases vs Total Deaths
-- Shows the likelihood of dying if you catch covid in your country
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..['Covid Deaths$']
Where location like '%states%'
and continent is not null
order by 1,2

--Looking at Total cases vs Population
--percentage that contracted covid

select location, date, Population, total_cases, (total_cases/population)*100 as ContractedPercentage
from PortfolioProject..['Covid Deaths$']
--Where location like '%states%'
order by 1,2


--Countries with highest infection rate compared to population

select location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_deaths/total_cases))*100 as ContractedPercentage
from PortfolioProject..['Covid Deaths$']
--Where location like '%states%'
Group by Location, Population
order by ContractedPercentage desc


-- Showing the Countries with Highest Death Count for Population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..['Covid Deaths$']
--Where location like '%states%'
Where continent is not null
Group by Location
order by TotalDeathCount desc



--Seperating By Continent
-- Showing cotinents with Highest Death Count

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..['Covid Deaths$']
--Where location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc



-- Global Breakdown

select SUM(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
from PortfolioProject..['Covid Deaths$']
--Where location like '%states%'
Where continent is not null
--group by date
order by 1,2


--Total Population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date) as RollingVaccinationCount
--, (RollingVaccinationCount/population)*100
from PortfolioProject..['Covid Deaths$'] dea
join PortfolioProject..Covidvaccinations$ vac
   on dea.location = vac.location
   and dea.date = vac.date
Where dea.continent is not null
order by 2,3

--CTE
with PopvsVac(Continent, location, date, population, new_vaccinations, RollingVaccinationCount)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date) as RollingVaccinationCount
--, (RollingVaccinationCount/population)*100
from PortfolioProject..['Covid Deaths$'] dea
join PortfolioProject..Covidvaccinations$ vac
   on dea.location = vac.location
   and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select * , (RollingVaccinationCount/population)*100
from PopvsVac


--Storing Data For Later Visualizations

Create View PopvsVac as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date) as RollingVaccinationCount
--, (RollingVaccinationCount/population)*100
from PortfolioProject..['Covid Deaths$'] dea
join PortfolioProject..Covidvaccinations$ vac
   on dea.location = vac.location
   and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

select *
from PopvsVac