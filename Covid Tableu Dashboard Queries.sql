--Queries for Tableu Project

--1
--For total cases, deaths with death percentage
Select SUM(new_cases) as total_cases, Sum(convert(bigint, new_deaths)) as total_deaths, Sum(convert(bigint, new_deaths))/Sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

--2
--For DeathCount by each Continent
Select Location, Sum(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null
and location not in ('world', 'European union','International')
Group by Location
order by TotalDeathCount desc

--3
--For Highest Infection Count with Population to infection percentage
Select Location, Population, Max(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where continent is not null
Group by Location, Population
order by PercentpopulationInfected Desc

--4
Select Location, Population, Date, Max(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population, Date
order by PercentpopulationInfected Desc

--5
select dea.continent, dea.location, dea.date, dea.population , vac.new_vaccinations
, Max(vac.total_vaccinations) as RollingPeopleVaccinated
From portfolioproject..CovidDeaths dea
join portfolioproject..CovidVaccinations vac
      on dea.location = vac.location 
	  and dea.date = vac.date
where dea.continent is not null
group by dea.continent, dea.date, dea.location, dea.population, vac.new_vaccinations
order by  1,2,3

--6
--countries with Highest vaccinations
select dea.location, Max(vac.total_vaccinations)/dea.population*100 as totalVaccinationsPercentage
From portfolioproject..CovidDeaths dea
join portfolioproject..CovidVaccinations vac
      on dea.location = vac.location 
	  and dea.date = vac.date
group by dea.location, dea.population
order by  TotalVaccinationsPercentage asc

