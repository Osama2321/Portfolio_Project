Select *
From Porfolio_Project..CovidDeaths$
Where continent is not null
Order by 1,2

Select location,date,total_cases,new_cases,total_deaths,population
From Porfolio_Project..CovidDeaths$
Where continent is not null
Order by 1,2

--Select *
--From Porfolio_Project..CovidVaccinations$
--Order by 3,4

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From Porfolio_Project..CovidDeaths$
Where location like '%states%'
Order by 1,2

Select location,date,population,total_cases,(total_cases/population)*100 as Total_Percentage
From Porfolio_Project..CovidDeaths$
Where location like '%states%'
Order by 1,2 

Select location,population,max(total_cases) as Highest_cases,(max(total_cases)/population) *100 as Total_Percentage
From Porfolio_Project..CovidDeaths$
--Where location like '%states%'
Group by location,population
Order by Total_Percentage desc

Select location,max(cast (total_deaths as int)) as Total_Death
From Porfolio_Project..CovidDeaths$
--Where location like '%states%'
Where continent is not null
Group by location
Order by Total_Death desc
 

Select continent,max(cast (total_deaths as int)) as Total_Death
From Porfolio_Project..CovidDeaths$
--Where location like '%states%'
Where continent is not null
Group by continent
Order by Total_Death desc
 
Select location,max(cast (total_deaths as int)) as Total_Death
From Porfolio_Project..CovidDeaths$
--Where location like '%states%'
Where continent is null
Group by location
Order by Total_Death desc

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Porfolio_Project..CovidDeaths$
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

Select cod.continent, cod.location,cod.population,cod.date,cov.new_vaccinations, SUM(CONVERT(int,cov.new_vaccinations)) OVER (Partition by cod.Location Order by cod.location, cod.Date) as RollingPeopleVaccinated
From Porfolio_Project..CovidDeaths$ cod
Join Porfolio_Project..CovidVaccinations$ cov
	on cod.date=cov.date
	and cod.location=cov.location
where cod.continent is not null 
Order by 2,3

With PopsVac(Continent, Location,Date,Population,New_Vaccications, RollingPeopleVaccinated)
as
(
Select cod.continent, cod.location,cod.date,cod.population,cov.new_vaccinations, SUM(CONVERT(int,cov.new_vaccinations)) OVER (Partition by cod.Location Order by cod.location, cod.Date) as RollingPeopleVaccinated
From Porfolio_Project..CovidDeaths$ cod
Join Porfolio_Project..CovidVaccinations$ cov
	on cod.date=cov.date
	and cod.location=cov.location
where cod.continent is not null 
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopsVac

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select cod.continent, cod.location,cod.date,cod.population,cov.new_vaccinations, SUM(CONVERT(int,cov.new_vaccinations)) OVER (Partition by cod.Location Order by cod.location, cod.Date) as RollingPeopleVaccinated
From Porfolio_Project..CovidDeaths$ cod
Join Porfolio_Project..CovidVaccinations$ cov
	on cod.date=cov.date
	and cod.location=cov.location
where cod.continent is not null 
--Order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated

Create View PercentPopulationVaccinated as
Select cod.continent, cod.location,cod.date,cod.population,cov.new_vaccinations, SUM(CONVERT(int,cov.new_vaccinations)) OVER (Partition by cod.Location Order by cod.location, cod.Date) as RollingPeopleVaccinated
From Porfolio_Project..CovidDeaths$ cod
Join Porfolio_Project..CovidVaccinations$ cov
	on cod.date=cov.date
	and cod.location=cov.location
where cod.continent is not null 
--Order by 2,3 
Select *
From PercentPopulationVaccinated