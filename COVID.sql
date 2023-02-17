select *
from portfolioproject..coviddeaths
order by 3,4

select location,total_Cases,total_deaths
from portfolioproject..coviddeaths

--percent of deaths and total cases

select location,date,total_Cases,total_deaths,cast((total_deaths/total_cases)*100 as decimal (5,2)) as percentage_deaths
from portfolioproject..coviddeaths
where location like '%states%'
order by percentage_deaths desc

--looking for highest infected country by their population

select location,population,max(total_Cases) as infected_people,population,max(cast((total_cases/population)*100 as decimal (5,2))) as percentage_infected
from portfolioproject..coviddeaths
--where location like '%states%'
group by location,population 
order by percentage_infected desc

--highest deaths per population for countries

select location,population,max(cast(total_deaths as int)) as people_died,max(cast((total_deaths/population)*100 as decimal (5,2))) as percentage_deaths
from portfolioproject..coviddeaths
group by location,population 
order by percentage_deaths desc

-- total people died in each continent
select continent,sum(cast(total_deaths as int)) as people_died
from portfolioproject..coviddeaths
where continent is not null
group by continent
order by people_died desc

-- global numbers and total deaths percentage
select date,sum(cast(new_deaths as int))as total_deaths,sum(cast (new_cases as int)) as people_infected,sum(cast(new_deaths as decimal))/sum(cast (new_cases as decimal))*100 as percentage_deaths
from portfolioproject..coviddeaths
where continent is not null
group by date
order by date

--total population and vaccinated popultaion by location
select cov.date,cov.location,cov.total_deaths, cov.population, vac.new_vaccinations, sum (convert (decimal,vac.new_vaccinations)) over (partition by cov.location order by cov.location,cov.date) as vaccinated_people
from portfolioproject..coviddeaths cov
join portfolioproject..vaccination$ vac
	on cov.location = vac.location
	and cov.date = vac.date
where cov.continent is not null	
order by 2

--temp table usecase
with temptab (date,location,total_deaths,population,new_vaccinations,vaccinated_people)
as
(
select cov.date,cov.location,cov.total_deaths, cov.population, vac.new_vaccinations, sum (convert (decimal,vac.new_vaccinations)) over (partition by cov.location order by cov.location,cov.date) as vaccinated_people
from portfolioproject..coviddeaths cov
join portfolioproject..vaccination$ vac
	on cov.location = vac.location
	and cov.date = vac.date
where cov.continent is not null	
)
select * ,(vaccinated_people/population )*100 as percentage_of_vaccinated_people
from temptab

--create view table to later do visulization

create view temptable as
select cov.date,cov.location,cov.total_deaths, cov.population, vac.new_vaccinations, sum (convert (decimal,vac.new_vaccinations)) over (partition by cov.location order by cov.location,cov.date) as vaccinated_people
from portfolioproject..coviddeaths cov
join portfolioproject..vaccination$ vac
	on cov.location = vac.location
	and cov.date = vac.date
where cov.continent is not null