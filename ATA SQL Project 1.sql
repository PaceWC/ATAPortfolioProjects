--SELECT *
--FROM COVIDPortfolioProject..CovidDeaths
--order by 3, 4

--SELECT *
--FROM COVIDPortfolioProject..CovidVaccinations
--order by 3, 4


--Select Data that we are going to be using
--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM COVIDPortfolioProject..CovidDeaths
--ORDER BY 1, 2


--Looking at Total Cases vs Total Deaths
--Shows the likelihood of dying if you contract COVID in your country
--SELECT location, date, total_cases, total_deaths, (CAST(total_deaths AS FLOAT)/CAST(total_cases AS FLOAT))*100 AS DeathPercentage
--FROM COVIDPortfolioProject..CovidDeaths
--WHERE location like '%states%'
--ORDER BY DeathPercentage DESC

--Looking at Total Cases vs Population
--Shows what percentage of the population has caught COVID by country
--SELECT location, date, total_cases, population, (CAST(total_cases AS FLOAT)/CAST(population AS FLOAT))*100 AS PercentPopulationInfected
--FROM COVIDPortfolioProject..CovidDeaths
--WHERE location like '%states%'
--ORDER BY 1, 2

--Looking at contries with higest infection rate compared to population
--SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX(CAST(total_cases AS FLOAT)/CAST(population AS FLOAT))*100 AS PercentPopulationInfected
--FROM COVIDPortfolioProject..CovidDeaths
----WHERE location like '%states%'
--GROUP BY location, population
--ORDER BY PercentPopulationInfected DESC

--Showing countries with the highest death count per population
--SELECT location, MAX(CAST(total_deaths AS FLOAT)) AS TotalDeathCount
--FROM COVIDPortfolioProject..CovidDeaths
--WHERE continent IS NULL
--GROUP BY location
--ORDER BY TotalDeathCount DESC

--Breaking down by continent
--SELECT continent, MAX(CAST(total_deaths AS FLOAT)) AS TotalDeathCount
--FROM COVIDPortfolioProject..CovidDeaths
--WHERE continent IS NOT NULL
--GROUP BY continent
--ORDER BY TotalDeathCount DESC

--Global Numbers

--SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercentage
--FROM COVIDPortfolioProject..CovidDeaths
--WHERE continent is not null
--ORDER BY 1, 2

-- Looking at Total Population vs Vaccinations
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--,SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/dea.population)*100
--FROM COVIDPortfolioProject.. CovidDeaths dea
--JOIN COVIDPortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3


-- USE CTE
--WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
--AS
--(
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--,SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
----, (RollingPeopleVaccinated/dea.population)*100
--FROM COVIDPortfolioProject.. CovidDeaths dea
--JOIN COVIDPortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent is not null
----ORDER BY 2,3
--)
--SELECT *, (RollingPeopleVaccinated/Population)*100
--FROM PopvsVac

--Temp Table version
--DROP TABLE IF EXISTS #PercentPopulationVaccinated
--CREATE TABLE #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--location nvarchar(255),
--date datetime,
--population numeric,
--new_vaccinations numeric,
--RollingPeopleVaccinated numeric
--)

--INSERT INTO #PercentPopulationVaccinated
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--,SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
----, (RollingPeopleVaccinated/dea.population)*100
--FROM COVIDPortfolioProject.. CovidDeaths dea
--JOIN COVIDPortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent is not null
----ORDER BY 2,3
--SELECT *, (RollingPeopleVaccinated/Population)*100
--FROM #PercentPopulationVaccinated

--Creating View to store date for later visualizations
--CREATE VIEW PercentPopulationVaccinated AS
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--,SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
----, (RollingPeopleVaccinated/dea.population)*100
--FROM COVIDPortfolioProject.. CovidDeaths dea
--JOIN COVIDPortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent is not null
----ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated