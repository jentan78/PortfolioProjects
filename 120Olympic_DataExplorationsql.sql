 USE [PortfolioProj]
 --Show breakdown of no. of female athletes by season and year
 CREATE VIEW [v_NoFemaleParticipants] AS 
	SELECT YEAR, Season, COUNT(DISTINCT ID) as NoofFemales
	FROM [PortfolioProj]..athlete_events$
	WHERE Sex = 'F'
	GROUP BY Year, Season; 


 --Show total no. of athletes (include Male & Female) by year and season
 CREATE VIEW [v_TtlAthletes] AS 
	SELECT YEAR, Season, Count(DISTINCT Sport) AS NoofSports, COUNT(DISTINCT ID) as TotalAthletes  
	FROM [PortfolioProj]..athlete_events$
	GROUP BY Year, Season; 

---------------------------------------------------------------------------------------------------------------
--Comparison of no. of females and males athletes for each Olympics and Season. 
--a) Shows that the percentage (lesser than half of the total no) of Female is much lesser than Male athletes & 
--b) SHows no. of athletes for Winter is lesser as compared to Summer for each year Olympic is held
---------------------------------------------------------------------------------------------------------------
 CREATE VIEW [v_PercentofFemaleAthletes] AS 
   SELECT v1.Year, v1.Season, NoofSports, TotalAthletes, NoofFemales, (TotalAthletes - NoofFemales) AS NoofMales, Round((CAST(NoofFemales AS FLOAT)/TotalAthletes) * 100, 1) AS PercentFemale
   FROM [v_NoFemaleParticipants] v1 JOIN  [v_TtlAthletes] v2 ON v1.Year = v2.Year  and v1.Season = v2.Season;

SELECT * FROM [v_PercentofFemaleAthletes]

 --------------------------------------------------------------------------------------------
 -- NoofAthletes sent vs No of Medals Won
  --------------------------------------------------------------------------------------------
  DROP VIEW [v_NoofAthletesvsMedalsWon]
  CREATE VIEW [v_NoofAthletes] AS 
  SELECT YEAR,ath.NOC, Region, COUNT(DISTINCT ID) AS NoofAthletes
  FROM [PortfolioProj]..[athlete_events$] ath LEFT JOIN [PortfolioProj]..[country_definitions$] ctry ON ath.NOC = ctry.NOC
  GROUP BY Year, ath.NOC, Region 
 
  CREATE VIEW [v_NoofMedalsWon] AS 
  SELECT Year, ath.NOC, Region, COUNT(medal) AS NoofMedals
  FROM [PortfolioProj]..[athlete_events$] ath LEFT JOIN [PortfolioProj]..[country_definitions$] ctry ON ath.NOC = ctry.NOC 
  WHERE ath.Medal != 'NA'
  GROUP BY Year, ath.NOC, Region
 

  CREATE VIEW [v_NoofAthletesvsMedalsWon] AS
  SELECT NOA.Year, NOA.NOC, NOA.Region, NoofAthletes, NoofMedals FROM 
  [PortfolioProj]..[v_NoofAthletes] NOA LEFT JOIN [PortfolioProj]..[v_NoofMedalsWon] NOM ON NOA.NOC = NOM.NOC AND NOA.Year = NOM.Year
  
  SELECT * FROM [PortfolioProj]..[athlete_events$] where NOC = 'AUT'  AND Year = 1908

  ---------------------------------------------------------------------
 --Comparisons of Countries (NOC) with No of Medals over the years
 --Show the countries that improves (increase no. of medal) overall
  ---------------------------------------------------------------------
/*
SELECT Year, ath.NOC, Region, COUNT(medal) as NoofMedals
 FROM [PortfolioProj]..[athlete_events$] ath LEFT JOIN [PortfolioProj]..[country_definitions$] ctry ON ath.NOC = ctry.NOC
 WHERE medal != 'NA'
 GROUP BY Year, ath.NOC, Region
 ORDER BY ath.NOC, Year
 */

 ------------------------------------------------
 -- No of Sports Organized for each Olympic Year
 ------------------------------------------------
 SELECT Year, Season, Count(Distinct Sport) As NoofSports FROM [PortfolioProj].[dbo].[athlete_events$] GROUP BY Year, Season ORDER BY Year


 -----------------------------------------------------------------------
 -- Comparison on No. of Countries competing during Winter and Summer
 -----------------------------------------------------------------------
SELECT 
 Year,
 Season, 
 COUNT(DISTINCT NOC) AS NoOfCountries
FROM [PortfolioProj].[dbo].[athlete_events$] 
GROUP BY Year, Season



---------------------------------------------------------------------------------------
-- Breakdown of Sport to Individual Events showing No of Medals won by Females and Males
---------------------------------------------------------------------------------------

SELECT DISTINCT SPORT, Year, Event, Sex, Count(medal) AS NoofMedals
FROM [PortfolioProj].[dbo].[athlete_events$]
WHERE medal IN ('Gold', 'Silver', 'Bronze') 
GROUP BY Sport, Year, Event, Sex
ORDER BY Sport, NoofMedals Desc


 --Country Level
 ------------------
 -- Total No. of athletes group by participating countries and year

SELECT Year, ath.NOC, Region, Season, COUNT(DISTINCT ID)  AS NoOfAthletes 
  FROM [PortfolioProj].[dbo].[athlete_events$] ath LEFT JOIN [PortfolioProj]..[country_definitions$] ctry ON ath.NOC = ctry.NOC
  GROUP BY ath.NOC,Region, Year, Season
  ORDER BY NoOfAthletes DESC

 -- Compute the total no. of medals each athlete has sorted in Descending Order
 SELECT NOC, Sex, Name, COUNT(medal) as NoofMedals
 FROM [PortfolioProj]..[athlete_events$]
 WHERE medal != 'NA'
 GROUP BY Name, NOC, Sex
 ORDER BY NoofMedals DESC
 
 ---------------------------------------------------------------------------------------------------
 --Breakdown of the no. of medal each country has gotten in Gold, Silver and Bronze as well as Year
 ---------------------------------------------------------------------------------------------------
 SELECT  Year, ath.NOC, region, Medal, Count(medal) as NoofMedals
 FROM [PortfolioProj]..[athlete_events$] ath LEFT JOIN [PortfolioProj]..[country_definitions$] ctry ON ath.NOC = ctry.NOC
 WHERE medal != 'NA'
 GROUP BY  Year, ath.NOC, region, Medal
 ORDER BY Year, NOC DESC,Medal Desc
 
 


 --Show the No of Events held for each Olympics per season 
 SELECT Year, Season, COUNT(DISTINCT Event) AS NoofEvents FROM [PortfolioProj]..[athlete_events$] GROUP BY Year, Season Order BY NoofEvents Desc

 --Show the No. of Countries held for each Olympics per season
 SELECT Year, Season, Event, Count(Distinct NOC) AS NoofCountries, Count(DISTINCT ID) AS NoofAthletes FROM [PortfolioProj]..[athlete_events$]
 GROUP BY Year,Season, Event ORDER BY NoofCountries DESC

 SELECT DISTINCT ID FROM [PortfolioProj]..[athlete_events$]