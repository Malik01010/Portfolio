Select *
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Data being used
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

--looking at Total Cases vs Total Deaths, Shows Likelihood of dying if you contract covid based on country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 As DeathPercentage
From PortfolioProject..CovidDeaths
Where Location = 'United States' 
and continent is not null
order by 1,2

-- Total Cases vs Population
-- Shows what % of pop. got Covid

Select Location, date, Population, total_cases, Population, (total_cases/population)*100 As InfectionPercentage
From PortfolioProject..CovidDeaths
Where Location = 'United States'
order by 1,2

-- Highest Infection Rate vs Population
Select Location, Population, MAX(total_cases) As HighestInfectionCount, Population, Max((total_cases/population))*100 As InfectionPercentage
From PortfolioProject..CovidDeaths
Group By Location, Population
order by InfectionPercentage desc

--Countries with Highest Death Count per Population 

Select Location, Population, MAX(cast(total_deaths As int)) As TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group By Location, Population
order by TotalDeathCount desc


-- By Continent

Select continent, MAX(cast(total_deaths As int)) As TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group By continent
order by TotalDeathCount desc


--  Showing continents with highest death count per population

Select continent, MAX(cast(total_deaths As int)) As TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group By continent
order by TotalDeathCount desc


--Global Numbers 

Select Sum(new_cases) As total_cases, Sum(cast(new_deaths as int)) As total_deaths , Sum(cast(New_deaths as int))/Sum(New_Cases)*100 As DeathPerentage
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2


-- Looking at Total Population vs Vaccianations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Cast(vac.new_vaccinations as int)) Over (Partition by dea.Location Order by dea.location, dea.Date) as RollingPplVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Using Temp Table to perform Calculation on Partition By in previous query

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric, 
new_vaccinations numeric, 
RollingPplVaccinated numeric 
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Cast(vac.new_vaccinations as int)) Over (Partition by dea.Location Order by dea.location, dea.Date) as RollingPplVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

Select *, (RollingPplVaccinated/Population) * 100
From #PercentPopulationVaccinated



-- Creating View to store data for later visualizations
Create View PercentPopulationsVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(Cast(vac.new_vaccinations as int)) Over (Partition by dea.Location Order by dea.location, dea.Date) as RollingPplVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
