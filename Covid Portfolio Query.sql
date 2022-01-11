SELECT *

--SELECT *
--FROM Portfolioproject..CovidVaccinations
--order by 3,4

Select Location, Date, Total_cases, New_cases, total_Deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

--% of dying if you get covid
Select Location, Date, Total_cases, total_Deaths, (total_deaths/total_cases)*100 as Deathpercentage
from PortfolioProject..CovidDeaths
WHERE location like '%germany%'
order by 1,2

--population vs total cases
Select Location, Date, population, Total_cases, total_Deaths, (total_cases/population)*100 as populationpercentage
FROM PortfolioProject..CovidDeaths
WHERE location='germany'
order by 1,2

--country with the highest covid rate against population
Select Location, population, MAX(Total_cases) as HighestInfectionCount, MAX(total_deaths) as TotalDeaths, MAX(total_cases/population)*100 as Infectedpopulationpercentage
FROM PortfolioProject..CovidDeaths
Where continent is not null
Group by Location, Population
order by Infectedpopulationpercentage desc


Select Location, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is null
Group by Location
Order by Totaldeathcount asc


--DELETE from PortfolioProject..CovidDeaths
--WHERE Location = 'High Income' 'Low income', 'Upper middle Income', 'lower middle income', 

--DELETE from PortfolioProject..CovidDeaths
--WHERE Location =  'lower middle income'

--DELETE from PortfolioProject..CovidDeaths
--WHERE Location = 'Upper middle Income'

--DELETE from PortfolioProject..CovidDeaths
--WHERE Location = 'Low income'


--showing the continent with the highest death count
Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by continent
Order by Totaldeathcount asc

--Global numbers
Select Date, SUM(new_cases) as TotalCases, SUM(cast(New_Deaths as int)) as totalDeaths, SUM(Cast(New_deaths as int))/SUM(New_cases)*100 as TotalDeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
--and new_cases is not null
Group by date
order by 1,2 
--Total Cases
Select SUM(new_cases) as TotalCases, SUM(cast(New_Deaths as int)) as totalDeaths, SUM(Cast(New_deaths as int))/SUM(New_cases)*100 as TotalDeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
order by 1,2 

--Total population vs vaccinations increase
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(Bigint, vac.New_vaccinations)) OVER (partition by dea.location Order by dea.Location, dea.date) as RollingPeopleVaccinated
From portfolioproject..CovidDeaths dea
join portfolioproject..CovidVaccinations vac
    on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
order by  2,3

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(BIGint, vac.new_vaccinations)) OVER (Partition by dea.location)
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    on dea.location = vac.Location
	and dea.date = vac.date
WHERE dea.continent is not null
	order by 2,3


--Use CTE
with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(BIGint, vac.new_vaccinations)) OVER (partition by dea.location Order by dea.Location, dea.date) as RollingPeopleVaccinated
From portfolioproject..CovidDeaths dea
join portfolioproject..CovidVaccinations vac
on dea.location = vac.location 
and dea.date=vac.date
where dea.continent is not null
--order by  2,3
)

select * , (RollingPeopleVaccinated/population)*100 as VaccinationPercentage
FROM PopvsVac

--TEMP TABLE
DROP table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert into  #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(BIGint, vac.new_vaccinations)) OVER (partition by dea.location Order by dea.Location, dea.date) as RollingPeopleVaccinated
From portfolioproject..CovidDeaths dea
join portfolioproject..CovidVaccinations vac
      on dea.location = vac.location 
	  and dea.date = vac.date
where dea.continent is not null
--order by  2,3

select * , (RollingPeopleVaccinated/population)*100
FROM  #PercentPopulationVaccinated


--Creating View to store data for later visualization
Create view NPercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(convert(BIGint, vac.new_vaccinations)) OVER (partition by dea.location Order by dea.Location, dea.date) as RollingPeopleVaccinated
From portfolioproject..CovidDeaths dea
join portfolioproject..CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
where dea.continent is not null
--order by  2,3



select *
FROM PercentPopulationVaccinated