-- ******************************
-- DBS311 NII Week 5 
-- Oct 6, 2022
-- Sportleagues Demonstration
-- Advanced SQL Real World Application
-- Clint MacDonald
-- ******************************

-- with the perspective of the home team
SELECT 
    TheTeamID,
    (SELECT teamName FROM teams WHERE teamID = tempTable.TheTeamID) AS TeamName,
    SUM(GamesPlayed) AS GP,
    SUM(Wins) AS W,
    SUM(Losses) AS L,
    SUM(Ties) AS T,
    SUM(GoalsFor) AS GF,
    SUM(GoalsAgainst) AS GA,
    SUM(GoalsFor) - Sum(GoalsAgainst) AS GD,
    SUM(Wins) * 3 + Sum(Ties) AS Pts
FROM(
    SELECT
        hometeam AS TheTeamID,
        COUNT(gameID) AS GamesPlayed,
        SUM(homescore) AS GoalsFor,
        SUM(visitscore) AS GoalsAgainst,
        SUM(
            CASE
                WHEN homescore > visitscore THEN 1
                ELSE 0
                END
        ) AS Wins,
        SUM(
            CASE
                WHEN homescore < visitscore THEN 1
                ELSE 0
                END
        ) AS Losses,
        SUM(
            CASE
                WHEN homescore = visitscore THEN 1
                ELSE 0
                END
        ) AS Ties
    FROM games
    WHERE isPlayed = 1
    GROUP BY hometeam
    
    UNION ALL
        -- with perspective of the visitteam
    SELECT
        visitteam AS TheTeamID,
        COUNT(gameID) AS GamesPlayed,
        SUM(visitscore) AS GoalsFor,
        SUM(homescore) AS GoalsAgainst,
        SUM(
            CASE
                WHEN homescore < visitscore THEN 1
                ELSE 0
                END
        ) AS Wins,
        SUM(
            CASE
                WHEN homescore > visitscore THEN 1
                ELSE 0
                END
        ) AS Losses,
        SUM(
            CASE
                WHEN homescore = visitscore THEN 1
                ELSE 0
                END
        ) AS Ties
    FROM games
    WHERE isPlayed = 1
    GROUP BY visitteam
    ) tempTable
GROUP BY TheTeamID
ORDER BY Pts DESC;