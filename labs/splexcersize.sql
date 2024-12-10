--best goal scorer in team 212
SELECT
        firstname | | ' ' | | lastname AS PlayerName,
        MAX(numgoals) AS Goals,
        teamid AS TeamID
FROM goalscorers g
JOIN players p ON p.playerid = g.playerid
WHERE teamid = 212
GROUP BY firstname,lastname,teamid
ORDER BY Goals DESC;

--DISPLAY matches ended with tie score, where was it played, in between which teams it was played
SELECT 
        gameid,
        to_char(gamedatetime, 'DD-MM-YYYY') AS DateOfMatch,
        l.locationname AS Stadium,
        ht.teamname AS HomeTeam,
        homescore AS HomeTeamScore,
        SUBSTR(visitscore, 1,2) AS VisitingTeamScore,
        vt.teamname AS VisitingTeam
FROM games g
INNER JOIN teams ht ON ht.teamid = g.hometeam
INNER JOIN teams vt ON vt.teamid = g.visitteam
INNER JOIN sllocations l ON l.locationid = g.locationid
WHERE (homescore LIKE visitscore AND isplayed = 1)
ORDER BY gameid;

--DISPLAY matches ended with a score where total goal count is more than 5 and atleast one player scored 2 goals

SELECT 
        g.gameid,
        homescore + visitscore AS TotalGoals,
        numgoals || ' ' | | 'Goals scored by: ' | | firstname | | ' ' | | lastname AS GoalScorer
FROM games g
JOIN goalscorers gs ON gs.gameid = g.gameid
JOIN players p ON gs.playerid = p.playerid
WHERE (homescore + visitscore > 5) AND (numgoals > 2);

--display the matches that visiting team wins and dates of the matches and which stadium theyve been played . format the date like May 2nd of 2022
--

SELECT
        TO_CHAR(gamedatetime, 'FMMonth ddth "of" YYYY') AS DateOfMatch,
        locationname AS Stadium,
        vt.teamname AS VisitingTeam
FROM games g
INNER JOIN sllocations l ON l.locationid = g.locationid
INNER JOIN teams vt ON vt.teamid = g.visitteam
WHERE visitscore > homescore;




