SELECT *
FROM [Portfolio Project]..[Covid Vaccinations]
ORDER BY 3,4

SELECT*
FROM [Portfolio Project]..[Covid Deaths]
ORder by 3,4



SELECT location,date,population,total_cases,total_deaths
FROM [Portfolio Project]..[Covid Deaths]
ORder by 1,2


--Showing the total percentage of population in India that got infected by Covid 

SELECT location,date,population,total_cases,(total_cases/population)*100 as Percentpopulation
FROM [Portfolio Project]..[Covid Deaths]
Where location like 'India'
ORder by 1,2



--Showing  highest Death rate across South Asian Countries


SELECT location,MAX(cast (total_deaths as int))As Maxdeaths , MAX(cast(total_deaths as int)) As HighestDeathrate
FROM [Portfolio Project]..[Covid Deaths]
Where location in ('India', 'Pakistan', 'Sri Lanka', 'Bhutan', 'Nepal')
AND continent is not null
GROUP BY location
ORder by HighestDeathrate DESC


-- DIVING INTO GLOBAL DATA 

--Showing GLobal Death rate occured due to COVid


SELECT Sum(new_cases) as Totalcases, Sum(cast(new_deaths as int))As Totaldeaths , Sum(cast(new_deaths as int))/Sum (new_cases)*100 As Globaldeaths
 FROM [Portfolio Project]..[Covid Deaths]
--Where location like 'India'
Where continent is not null
--GROUP BY date


--Total Vaccinations vs Population For India

SELECT dea.location,dea.date,dea.population,Vacc.new_vaccinations
,SUM(CONVERT(int,Vacc.new_vaccinations)) Over(PARTITION by dea.location Order by  dea.location,dea.date) 
as Vaccinationsrollout
FROM [Portfolio Project]..[Covid Deaths]  Dea
join [Portfolio Project]..[Covid Vaccinations]  Vacc
on Dea.location=Vacc.location
and Dea.date=Vacc.date
WHERE dea.continent is not null
and dea.location like 'india'

--USING CTE

With PopsvsVacc (location,date,population,new_vaccinations,Vaccinationsrollout)
as
(
SELECT dea.location,dea.date,dea.population,Vacc.new_vaccinations
,SUM(CONVERT(int,Vacc.new_vaccinations)) Over(PARTITION by dea.location Order by  dea.location,dea.date) 
as Vaccinationsrollout
FROM [Portfolio Project]..[Covid Deaths]  Dea
join [Portfolio Project]..[Covid Vaccinations]  Vacc
on Dea.location=Vacc.location
and Dea.date=Vacc.date
WHERE dea.continent is not null
and dea.location like 'india'
)
Select*, (Vaccinationsrollout/population)*100  Vaccperpopulation
FROM PopsvsVacc


--Using TempTables
DROP TABLE if EXists #PercentPOPvsVaccIndia 
CREATE table #PercentPOPvsVaccIndia 
(location nvarchar(255),
Date Datetime,
Population numeric,
new_Vaccination numeric,
Vaccinationsrollout numeric)

Insert into #PercentPOPvsVaccIndia
SELECT dea.location,dea.date,dea.population,Vacc.new_vaccinations
,SUM(CONVERT(int,Vacc.new_vaccinations)) Over(PARTITION by dea.location Order by  dea.location,dea.date) 
as Vaccinationsrollout
FROM [Portfolio Project]..[Covid Deaths]  Dea
join [Portfolio Project]..[Covid Vaccinations]  Vacc
on Dea.location=Vacc.location
and Dea.date=Vacc.date
WHERE dea.continent is not null
and dea.location like 'india'

SELECT*,(Vaccinationsrollout/population)*100  Vaccperpopulation
FROM #PercentPOPvsVaccIndia

CREATE VIEW PercentPOPvsVaccIndia as
SELECT dea.location,dea.date,dea.population,Vacc.new_vaccinations
,SUM(CONVERT(int,Vacc.new_vaccinations)) Over(PARTITION by dea.location Order by  dea.location,dea.date) 
as Vaccinationsrollout
FROM [Portfolio Project]..[Covid Deaths]  Dea
join [Portfolio Project]..[Covid Vaccinations]  Vacc
on Dea.location=Vacc.location
and Dea.date=Vacc.date
WHERE dea.continent is not null
and dea.location like 'india'


SELECT *
FROM PercentPOPvsVaccIndia