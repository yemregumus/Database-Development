-- ***********************
-- Name: 
-- JP Ostiano: 105292213
-- Yunus Gumus: 150331197
-- Olutoyosi Kuti: 102633211
-- Date: dd mm, yyyy
-- Purpose: Assignment 2 - DBS311NII
-- ***********************
SET SERVEROUTPUT ON;
/*-=Question 1.=-*/
--===============CRUD GAMES===============--
--===============INSERT GAMES===============--
CREATE OR REPLACE PROCEDURE spGamesInsert (
    err OUT games.gameID%type,
    newGameID OUT games.gameID%type,
    div_id games.divID%type,
    game_num games.gameNum%type,
    game_date games.gameDateTime%type,
    home_team games.homeTeam%type,
    home_score games.homeScore%type,
    visit_team games.visitTeam%type,
    visit_Score games.visitScore%type,
    location_id games.locationID%type,
    is_played games.isPlayed%type,
    note games.notes%type
) AS
BEGIN
    err := 0; -- good state
    /*Get the highest game id*/
    SELECT gameID INTO newGameID
    FROM games
    WHERE rownum = 1
    ORDER BY gameID DESC;
    newGameID := newGameID + 1;
    INSERT INTO games g (
            g.gameID, g.divID, g.gameNum, g.gameDateTime, g.homeTeam, g.homeScore, 
            g.visitTeam, g.visitScore, g.locationID, g.isPlayed, g.notes)
    VALUES (newGameID, div_id, game_num, game_date, home_team, home_score,
            visit_team, visit_Score, location_id, is_played, note);
EXCEPTION
    WHEN NO_DATA_FOUND
        THEN
            err := -1;
    WHEN TOO_MANY_ROWS
        THEN
            err := -2;
    WHEN OTHERS
        THEN
            err := -3;
END spGamesInsert;
--===============UPDATE GAMES===============--
CREATE OR REPLACE PROCEDURE spGamesUpdate(
    err OUT games.gameId%type,
    game_id games.gameId%type,
    div_id games.divID%type,
    game_num games.gameNum%type,
    game_date games.gameDateTime%type,
    home_team games.homeTeam%type,
    home_score games.homeScore%type,
    visit_team games.visitTeam%type,
    visit_Score games.visitScore%type,
    location_id games.locationID%type,
    is_played games.isPlayed%type,
    note games.notes%type
)AS
BEGIN
    err := 0; -- good state
    UPDATE games g
    SET 
        g.divID = div_id,
        g.gameNum = game_num,
        g.gameDateTime = game_date,
        g.homeTeam = home_team,
        g.homeScore = home_score,
        g.visitTeam = visit_team,
        g.visitScore = visit_Score,
        g.locationID = location_id,
        g.isPlayed = is_played,
        g.notes = note
    WHERE g.gameId = game_id;
    
    IF SQL%ROWCOUNT = 0 THEN
        err := -1;
    END IF;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3;
END spGamesUpdate;
--===============DELETE GAMES===============--
CREATE OR REPLACE PROCEDURE spGamesDelete(
    err OUT games.gameId%type,
    game_id IN games.gameId%type
) AS
BEGIN
    err := 0; -- good state
    DELETE FROM games g
    WHERE g.gameId = game_id;
    
    IF SQL%ROWCOUNT = 0 THEN
        err := -1;
    END IF;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3;
END spGamesDelete;
--===============SELECT GAMES===============--
CREATE OR REPLACE PROCEDURE spGamesSelect(
    err OUT games.gameId%type,
    game_id IN games.gameId%type,
    game OUT games%ROWTYPE -- returns all fields from given PK
) AS
BEGIN
    err := 0; -- good state
    SELECT * INTO game
    FROM games
    WHERE gameId = game_id;
EXCEPTION
    WHEN NO_DATA_FOUND
        THEN
            err := -1;
    WHEN TOO_MANY_ROWS
        THEN
            err := -2;
    WHEN OTHERS
        THEN
            err := -3;
END spGamesSelect;
--===============CRUD GOALSCORERS===============--
--===============INSERT GOALSCORERS===============--
CREATE OR REPLACE PROCEDURE spGoalScorersInsert (
    err OUT goalscorers.goalID%type,
    newGoalID OUT goalscorers.goalID%type,
    game_id goalscorers.gameId%type,
    player_id goalscorers.playerID%type,
    team_id goalscorers.teamID%type,
    num_goals goalscorers.numGoals%type,
    num_assists goalscorers.numAssists%type
) AS
BEGIN
    err := 0; -- good state
    /*Gets highest/latest goal id*/
    SELECT goalID INTO newGoalID
    FROM goalScorers
    WHERE rownum = 1
    ORDER BY goalID DESC;
    newGoalID := newGoalID + 1;
    INSERT INTO goalscorers gS (
             gS.goalID, gS.gameId, gS.playerID, gS.teamID, gS.numGoals, gS.numAssists)
    VALUES (newGoalID, game_id, player_id, team_id, num_goals, num_assists);
EXCEPTION
    WHEN NO_DATA_FOUND
        THEN
            err := -1;
    WHEN TOO_MANY_ROWS
        THEN
            err := -2;
    WHEN OTHERS
        THEN
            err := -3;
END spGoalScorersInsert;
--===============UPDATE GOALSCORERS===============--
CREATE OR REPLACE PROCEDURE spGoalScorersUpdate(
    err OUT goalscorers.goalID%type,
    goal_id goalscorers.goalID%type,
    game_id goalscorers.gameId%type,
    player_id goalscorers.playerID%type,
    team_id goalscorers.teamID%type,
    num_goals goalscorers.numGoals%type,
    num_assists goalscorers.numAssists%type
)AS
BEGIN
    err := 0; -- good state
    UPDATE goalscorers gS
    SET gS.gameId = game_id,
         gS.playerID = player_id,
         gS.teamID = team_id,
         gS.numGoals = num_goals,
         gS.numAssists = num_assists
    WHERE gS.goalID = goal_id;
    
    IF SQL%ROWCOUNT = 0 THEN
        err := -1;
    END IF;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3;
END spGoalScorersUpdate;
--===============DELETE GOALSCORERS===============--
CREATE OR REPLACE PROCEDURE spGoalScorersDelete(
    err OUT goalscorers.goalID%type,
    goal_id IN goalscorers.goalID%type
) AS
BEGIN
    err := 0; -- good state
    DELETE FROM goalscorers gS
    WHERE gS.goalID = goal_id;

    IF SQL%ROWCOUNT = 0 THEN
        err := -1;
    END IF;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3;
END spGoalScorersDelete;
--===============SELECT GOALSCORERS===============--
CREATE OR REPLACE PROCEDURE spGoalScorersSelect(
    err OUT goalscorers.goalID%type,
    goal_id IN goalscorers.goalID%type,
    goalScorer OUT goalScorers%ROWTYPE -- returns all fields from given PK
) AS
BEGIN
    err := 0; -- good state
    SELECT * INTO goalScorer
    FROM goalscorers
    WHERE goalID = goal_id;
EXCEPTION
    WHEN NO_DATA_FOUND
        THEN
            err := -1;
    WHEN TOO_MANY_ROWS
        THEN
            err := -2;
    WHEN OTHERS
        THEN
            err := -3;
END spGoalScorersSelect;
--===============CRUD PLAYERS===============--
--===============INSERT PLAYERS===============--
CREATE OR REPLACE PROCEDURE spPlayersInsert (
    err OUT players.playerid%type,
    newPlayerID OUT players.playerid%type,
    reg_num players.regnumber%type,
    last_name players.lastname%type,
    first_name players.firstname%type,
    is_active players.isactive%type
) AS
BEGIN
    err := 0; -- good state
    /*Gets the highest/latest player id*/
    SELECT playerID INTO newPlayerID
    FROM players
    WHERE rownum = 1
    ORDER BY playerID DESC;
    newPlayerID := newPlayerID + 1;
    INSERT INTO players p (
            p.playerID, p.regNumber, p.lastName, p.firstName, p.isActive)
    VALUES (newPlayerID, reg_num, last_name, first_name, is_active);
EXCEPTION
    WHEN NO_DATA_FOUND
        THEN
            err := -1;
    WHEN TOO_MANY_ROWS
        THEN
            err := -2;
    WHEN OTHERS
        THEN
            err := -3;
END spPlayersInsert;
--===============UPDATE PLAYERS===============--
CREATE OR REPLACE PROCEDURE spPlayersUpdate(
    err OUT players.playerid%type,
    player_id players.playerid%type,
    reg_num players.regnumber%type,
    last_name players.lastname%type,
    first_name players.firstname%type,
    is_active players.isactive%type
)AS
BEGIN
    err := 0; -- good state
    UPDATE Players p
    SET p.regnumber = reg_num,
         p.lastname = last_name,
         p.firstname = first_name,
         p.isactive = is_active
    WHERE p.playerid = player_id;
    
    IF SQL%ROWCOUNT = 0 THEN
        err := -1;
    END IF;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3;
END spPlayersUpdate;
--===============DELETE PLAYERS===============--
CREATE OR REPLACE PROCEDURE spPlayersDelete(
    err OUT players.playerid%type,
    player_id IN players.playerid%type
) AS
BEGIN
    err := 0; -- good state
    DELETE FROM players p
    WHERE p.playerid = player_id;
    
    IF SQL%ROWCOUNT = 0 THEN
        err := -1;
    END IF;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3;
END spPlayersDelete;
--===============SELECT PLAYERS===============--
CREATE OR REPLACE PROCEDURE spPlayersSelect(
    err OUT players.playerid%type,
    player_id IN players.playerid%type,
    player OUT players%ROWTYPE 
) AS
BEGIN
    err := 0; -- good state
    SELECT * INTO player
    FROM players
    WHERE playerid = player_id;
EXCEPTION
    WHEN NO_DATA_FOUND
        THEN
            err := -1;
    WHEN TOO_MANY_ROWS
        THEN
            err := -2;
    WHEN OTHERS
        THEN
            err := -3;
END spPlayersSelect;
--===============CRUD TEAMS===============--
--===============INSERT TEAMS===============--
CREATE OR REPLACE PROCEDURE spTeamsInsert (
    err OUT teams.teamID%TYPE,
    newTeamID OUT teams.teamID%TYPE,
    team_name teams.teamName%TYPE,
    is_active teams.isActive%TYPE,
    jersey_colour teams.jerseyColour%TYPE
) AS
BEGIN
    err := 0;
    SELECT teamID INTO newTeamID
    FROM teams
    WHERE rownum = 1
    ORDER BY teamID DESC;
    newTeamID := newTeamID + 1;
    INSERT INTO teams t (t.teamID, t.teamName, t.isActive, t.jerseyColour)
    VALUES (newTeamID, team_name, is_active, jersey_colour);
EXCEPTION
    WHEN NO_DATA_FOUND
        THEN
            err := -1;
    WHEN TOO_MANY_ROWS
        THEN
            err := -2;
    WHEN OTHERS
        THEN
            err := -3;
END spTeamsInsert;
--===============UPDATE TEAMS===============--
CREATE OR REPLACE PROCEDURE spTeamsUpdate (
    err OUT teams.teamID%Type,
    team_id IN teams.teamID%Type,
    team_name teams.teamname%Type,
    is_active teams.isActive%Type,
    jersey_colour teams.jerseyColour%Type
) AS
BEGIN
    err := 0; -- good state
    UPDATE teams t
    SET t.teamName = team_name,
         t.isActive = is_active,
         t.jerseyColour = jersey_colour
    WHERE t.teamID = team_id;
    
    IF SQL%ROWCOUNT = 0 THEN
        err := -1;
    END IF;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3;
END spTeamsUpdate;
--===============DELETE TEAMS===============--
CREATE OR REPLACE PROCEDURE spTeamsDelete(
    err OUT teams.teamID%type,
    team_id IN teams.teamID%type
) AS
BEGIN
    err := 0; -- good state
    DELETE FROM teams t
    WHERE t.teamID = team_id;

    IF SQL%ROWCOUNT = 0 THEN
        err := -1;
    END IF;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3;
END spTeamsDelete;
--===============SELECT TEAMS===============--
CREATE OR REPLACE PROCEDURE spTeamsSelect(
    err OUT teams.teamID%type,
    team_id IN teams.teamID%type,
    team OUT teams%ROWTYPE
) AS
BEGIN
    err := 0; -- good state
    SELECT * INTO team
    FROM teams
    WHERE teamID = team_id;
EXCEPTION
    WHEN NO_DATA_FOUND
        THEN
            err := -1;
    WHEN TOO_MANY_ROWS
        THEN
            err := -2;
    WHEN OTHERS
        THEN
            err := -3;
END spTeamsSelect;
--===============CRUD ROSTERS===============--
--===============INSERT ROSTERS===============--
CREATE OR REPLACE PROCEDURE spRostersInsert (
    err OUT rosters.rosterID%type,
    newRosterID OUT rosters.rosterID%type,
    player_id rosters.playerID%type,
    team_id rosters.teamID%type,
    is_active rosters.isActive%type,
    jersey_number rosters.jerseyNumber%type
) AS
BEGIN
    err := 0; -- good state
    SELECT rosterID INTO newRosterID
    FROM rosters
    WHERE rownum = 1
    ORDER BY rosterID DESC;
    newRosterID := newRosterID + 1;
    INSERT INTO rosters r (
            r.rosterID, r.playerID, r.teamID, r.isActive, r.jerseyNumber)
    VALUES (newRosterID, player_id, team_id, is_active, jersey_number);
EXCEPTION
    WHEN NO_DATA_FOUND
        THEN
            err := -1;
    WHEN TOO_MANY_ROWS
        THEN
            err := -2;
    WHEN OTHERS
        THEN
            err := -3;
END spRostersInsert;
--===============UPDATE ROSTERS===============--
CREATE OR REPLACE PROCEDURE spRostersUpdate (
    err OUT rosters.rosterID%Type,
    roster_id IN rosters.rosterID%Type,
    player_id rosters.playerID%Type,
    team_id rosters.teamID%Type,
    is_active rosters.isActive%Type,
    jersey_number rosters.jerseyNumber%Type
) AS
BEGIN
    err := 0;
    UPDATE rosters r
    SET r.playerID = player_id,
         r.teamID = team_id,
         r.isActive = is_active,
         r.jerseyNumber = jersey_number
    WHERE r.rosterID = roster_id;

    IF SQL%ROWCOUNT = 0 THEN
        err := -1;
    END IF;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3;
END spRostersUpdate;
--===============DELETE ROSTERS===============--
CREATE OR REPLACE PROCEDURE spRostersDelete(
    err OUT rosters.rosterID%Type,
    roster_id IN rosters.rosterID%type
) AS
BEGIN
    err := 0; -- good state
    DELETE FROM rosters r
    WHERE r.rosterID = roster_id;

    IF SQL%ROWCOUNT = 0 THEN
        err := -1;
    END IF;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3;
END spRostersDelete;
--===============SELECT ROSTERS===============--
CREATE OR REPLACE PROCEDURE spRostersSelect(
    err OUT rosters.rosterID%type,
    roster_id IN rosters.rosterID%type,
    roster OUT rosters%ROWTYPE
) AS
BEGIN
    err := 0; -- good state
    SELECT * INTO roster
    FROM rosters
    WHERE rosterId = roster_id;
EXCEPTION
    WHEN NO_DATA_FOUND
        THEN
            err := -1;
    WHEN TOO_MANY_ROWS
        THEN
            err := -2;
    WHEN OTHERS
        THEN
            err := -3;
END spRostersSelect;
--===============CRUD SLLOCATIONS===============--
--===============INSERT SLLOCATIONS===============--
CREATE OR REPLACE PROCEDURE spSlLocationsInsert (
    err OUT sllocations.locationID%type,
    newLocationID OUT sllocations.locationID%type,
    location_name sllocations.locationName%type,
    field_length sllocations.fieldLength%type,
    is_active sllocations.isActive%type
) AS
BEGIN
    err := 0; -- good state
    SELECT locationID INTO newLocationID
    FROM sllocations
    WHERE rownum = 1
    ORDER BY locationID DESC;
    newLocationID := newLocationID + 1;
    INSERT INTO sllocations sL (
            sL.locationID, sL.locationName, sL.fieldLength, sL.isActive)
    VALUES (newLocationID, location_name, field_length, is_active);
EXCEPTION
    WHEN NO_DATA_FOUND
        THEN
            err := -1;
    WHEN TOO_MANY_ROWS
        THEN
            err := -2;
    WHEN OTHERS
        THEN
            err := -3;
END spSlLocationsInsert;
--===============UPDATE SLLOCATIONS===============--
CREATE OR REPLACE PROCEDURE spSlLocationsUpdate (
    err OUT sllocations.locationID%type,
    location_id IN sllocations.locationID%type,
    location_name sllocations.locationName%type,
    field_length sllocations.fieldLength%type,
    is_active sllocations.isActive%type
) AS
BEGIN
    err := 0; -- good state
    UPDATE sllocations sL
    SET sL.locationName = location_name,
         sL.fieldLength = field_length,
         sL.isActive = is_active
    WHERE sL.locationID = location_id;

    IF SQL%ROWCOUNT = 0 THEN
        err := -1;
    END IF;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3;
END spSlLocationsUpdate;
--===============DELETE SLLOCATIONS===============--
CREATE OR REPLACE PROCEDURE spSlLocationsDelete(
    err OUT sllocations.locationID%type,
    location_id IN sllocations.locationID%type
) AS
BEGIN
    err := 0; -- good state
    DELETE FROM sllocations sL
    WHERE sL.locationID = location_id;

    IF SQL%ROWCOUNT = 0 THEN
        err := -1;
    END IF;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3;
END spSlLocationsDelete;
--===============SELECT SLLOCATIONS===============--
CREATE OR REPLACE PROCEDURE spSlLocationsSelect(
    err OUT sllocations.locationID%type,
    location_id IN sllocations.locationID%type,
    sllocation OUT sllocations%ROWTYPE -- returns all fields from given PK
) AS
BEGIN
    err := 0; -- good state
    SELECT * INTO sllocation
    FROM sllocations
    WHERE locationID = location_id;
EXCEPTION
    WHEN NO_DATA_FOUND
        THEN
            err := -1;
    WHEN TOO_MANY_ROWS
        THEN
            err := -2;
    WHEN OTHERS
        THEN
            err := -3;
END spSlLocationsSelect;
----------------------------------------------------------------------------------
/*-=Question 2.=-*/
--===============DISPLAY GAMES===============--
CREATE OR REPLACE PROCEDURE spDisplayGames (
    err OUT NUMBER
) AS
    found BOOLEAN := false;
    game games%ROWTYPE;
    CURSOR gc IS
        SELECT * FROM games;
BEGIN
    err := 0;
    OPEN gc;
        LOOP
            FETCH gc INTO game;
            IF gc%FOUND THEN
                DBMS_OUTPUT.PUT_LINE('GameID:       ' || game.gameID);
                DBMS_OUTPUT.PUT_LINE('DivID:        ' || game.divID);
                DBMS_OUTPUT.PUT_LINE('GameNum:      ' || game.gameNum);
                DBMS_OUTPUT.PUT_LINE('GameDateTime: ' || game.gameDateTime);
                DBMS_OUTPUT.PUT_LINE('HomeTeam:     ' || game.homeTeam);
                DBMS_OUTPUT.PUT_LINE('HomeScore:    ' || game.homeScore);
                DBMS_OUTPUT.PUT_LINE('VisitTeam     ' || game.visitTeam);
                DBMS_OUTPUT.PUT_LINE('VisitScore:   ' || game.visitScore);
                DBMS_OUTPUT.PUT_LINE('LocationID:   ' || game.locationID);
                DBMS_OUTPUT.PUT_LINE('isPlayed:     ' || game.isPlayed);
                DBMS_OUTPUT.PUT_LINE('Notes:        ' || NVL(game.notes, 'No notes'));
                DBMS_OUTPUT.PUT_LINE(''); -- Creates new Line
                found := true;
            ELSE
                IF found = false THEN
                    err := -1; -- No data found
                END IF;
                EXIT;
            END IF;
        END LOOP;
    CLOSE gc;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3; -- Other errors found
END spDisplayGames;
--===============DISPLAY GOALSCORERS===============--
CREATE OR REPLACE PROCEDURE spDisplayGoalScorers (
    err OUT NUMBER
) AS
    found BOOLEAN := false;
    goalScore goalscorers%ROWTYPE;
    CURSOR gsc IS
        SELECT * FROM goalscorers;
BEGIN
    err := 0;
    OPEN gsc;
        LOOP
            FETCH gsc INTO goalScore;
            IF gsc%FOUND THEN
                DBMS_OUTPUT.PUT_LINE('GoalID:     ' || goalScore.goalID);
                DBMS_OUTPUT.PUT_LINE('GameID:     ' || goalScore.gameID);
                DBMS_OUTPUT.PUT_LINE('PlayerID:   ' || goalScore.playerID);
                DBMS_OUTPUT.PUT_LINE('TeamID:     ' || goalScore.teamID);
                DBMS_OUTPUT.PUT_LINE('NumGoals:   ' || goalScore.numGoals);
                DBMS_OUTPUT.PUT_LINE('NumAssists: ' || goalScore.numAssists);
                DBMS_OUTPUT.PUT_LINE(''); -- Creates new Line
                found := true;
            ELSE
                IF found = false THEN
                    err := -1; -- No data found
                END IF;
                EXIT;
            END IF;
        END LOOP;
    CLOSE gsc;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3; -- Other errors found
END spDisplayGoalScorers;
--===============DISPLAY PLAYERS===============--
CREATE OR REPLACE PROCEDURE spDisplayPlayers (
    err OUT NUMBER
) AS
    found BOOLEAN := false;
    player players%ROWTYPE;
    CURSOR pc IS
        SELECT * FROM players;
BEGIN
    err := 0;
    OPEN pc;
        LOOP
            FETCH pc INTO player;
            IF pc%FOUND THEN
                DBMS_OUTPUT.PUT_LINE('PlayerID:  ' || player.playerID);
                DBMS_OUTPUT.PUT_LINE('RegNum:    ' || player.regNumber);
                DBMS_OUTPUT.PUT_LINE('LastName:  ' || player.lastName);
                DBMS_OUTPUT.PUT_LINE('FirstName: ' || player.firstName);
                DBMS_OUTPUT.PUT_LINE('isActive:  ' || player.isActive);
                DBMS_OUTPUT.PUT_LINE(''); -- Creates new Line
                found := true;
            ELSE
                IF found = false THEN
                    err := -1; -- No data found
                END IF;
                EXIT;
            END IF;
        END LOOP;
    CLOSE pc;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3;
END spDisplayPlayers;
--===============DISPLAY TEAMS===============--
CREATE OR REPLACE PROCEDURE spDisplayTeams (
    err OUT NUMBER
) AS
    found BOOLEAN := false;
    team teams%ROWTYPE;
    CURSOR tc IS
        SELECT * FROM teams;
BEGIN
    err := 0;
    OPEN tc;
        LOOP
            FETCH tc INTO team;
            IF tc%FOUND THEN
                DBMS_OUTPUT.PUT_LINE('TeamID:       ' || team.teamID);
                DBMS_OUTPUT.PUT_LINE('TeamName:     ' || team.teamName);
                DBMS_OUTPUT.PUT_LINE('isActive:     ' || team.isActive);
                DBMS_OUTPUT.PUT_LINE('jerseyColour: ' || team.jerseyColour);
                DBMS_OUTPUT.PUT_LINE(''); -- Creates new Line
                found := true;
            ELSE
                IF found = false THEN
                    err := -1; -- No data found
                END IF;
                EXIT;
            END IF;
        END LOOP;
    CLOSE tc;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3;
END spDisplayTeams;
--===============DISPLAY ROSTERS===============--
CREATE OR REPLACE PROCEDURE spDisplayRosters (
    err OUT NUMBER
) AS
    found BOOLEAN := false;
    roster rosters%ROWTYPE;
    CURSOR rc IS
        SELECT * FROM rosters;
BEGIN
    err := 0;
    OPEN rc;
        LOOP
            FETCH rc INTO roster;
            IF rc%FOUND THEN
                DBMS_OUTPUT.PUT_LINE('RosterID:     ' || roster.rosterID);
                DBMS_OUTPUT.PUT_LINE('PlayerID:     ' || roster.playerID);
                DBMS_OUTPUT.PUT_LINE('TeamID:       ' || roster.teamID);
                DBMS_OUTPUT.PUT_LINE('isActive:     ' || roster.isActive);
                DBMS_OUTPUT.PUT_LINE('jerseyNumber: ' || roster.jerseyNumber);
                DBMS_OUTPUT.PUT_LINE(''); -- Creates new Line
                found := true;
            ELSE
                IF found = false THEN
                    err := -1; -- No data found
                END IF;
                EXIT;
            END IF;
        END LOOP;
    CLOSE rc;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3;
END spDisplayRosters;
--===============DISPLAY SLLOCATIONS===============--
CREATE OR REPLACE PROCEDURE spDisplaySlLocations (
    err OUT NUMBER
) AS
    found BOOLEAN := false;
    sllocation sllocations%ROWTYPE;
    CURSOR sllc IS
        SELECT * FROM sllocations;
BEGIN
    err := 0;
    OPEN sllc;
        LOOP
            FETCH sllc INTO sllocation;
            IF sllc%FOUND THEN
                DBMS_OUTPUT.PUT_LINE('LocationID:   ' || sllocation.locationID);
                DBMS_OUTPUT.PUT_LINE('LocationName: ' || sllocation.locationName);
                DBMS_OUTPUT.PUT_LINE('Field Length: ' || sllocation.fieldLength);
                DBMS_OUTPUT.PUT_LINE('isActive:     ' || sllocation.isActive);
                DBMS_OUTPUT.PUT_LINE(''); -- Creates new Line
                found := true;
            ELSE
                IF found = false THEN
                    err := -1; -- No data found
                END IF;
                EXIT;
            END IF;
        END LOOP;
    CLOSE sllc;
EXCEPTION
    WHEN OTHERS
        THEN
            err := -3;
END spDisplaySlLocations;
----------------------------------------------------------------------------------
/*-=Question 3.=-*/
--===============STORES PLAYERS ON TEAMS===============--
CREATE OR REPLACE VIEW vwPlayerRosters AS
  SELECT 
    p.playerid,
    p.regnumber,
    p.lastname,
    p.firstname,
    r.teamid,
    t.teamname,
    r.rosterid,
    r.jerseynumber,
    t.jerseycolour
  FROM players p
  INNER JOIN rosters r ON p.playerid = r.playerid
  INNER JOIN teams t ON r.teamid = t.teamid
  ORDER BY p.playerid;

----------------------------------------------------------------------------------
/*-=Question 4.=-*/
--===============DISPLAY TEAM ROSTERS BY ID===============--
CREATE OR REPLACE PROCEDURE spTeamRosterByID(
  idteam teams.teamid%TYPE,
  err OUT NUMBER
) AS
  rosters vwPlayerRosters%ROWTYPE;
  found BOOLEAN := false;
  CURSOR trid IS
          SELECT * FROM vwPlayerRosters
          WHERE idteam = teamid;
BEGIN
  err:= 0;
    OPEN trid;
        LOOP
            FETCH trid INTO rosters;
            --EXIT WHEN trid%NOTFOUND;
            IF trid%FOUND THEN
              DBMS_OUTPUT.PUT_LINE('Roster ID:  ' || rosters.rosterid);
              DBMS_OUTPUT.PUT_LINE('Team Name:  ' || rosters.teamname);
              DBMS_OUTPUT.PUT_LINE('Team ID:  ' || rosters.teamid);
              DBMS_OUTPUT.PUT_LINE('First Name: ' || rosters.firstname);
              DBMS_OUTPUT.PUT_LINE('Last Name:  ' || rosters.lastname);
              DBMS_OUTPUT.PUT_LINE('Player ID:  ' || rosters.playerid);
              DBMS_OUTPUT.PUT_LINE('');
              found := true;
            ELSE
              IF found = false THEN
                err := -1; -- NO DATA FOUND
              END IF;
              EXIT;
            END IF;
        END LOOP;
    CLOSE trid;
EXCEPTION
  WHEN TOO_MANY_ROWS
    THEN 
        err := -2;
  WHEN OTHERS
        THEN
            err := -3; -- Other errors
END spTeamRosterByID;
---------------EXECUTE-------------------------------------------
DECLARE
  err NUMBER;
BEGIN
  /*spTeamRosterByID('check', err);
  IF err = -1 THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: NO DATA FOUND');
  ELSIF err = -3 THEN
    DBMS_OUTPUT.PUT_LINE('ERROR: ERROR OCCURED IN EXECUTION');
  END IF;
DBMS_OUTPUT.PUT_LINE('------------------------------'); */

  spTeamRosterByID(212, err);
    IF err = -1 THEN
      DBMS_OUTPUT.PUT_LINE('ERROR: NO DATA FOUND');
       ELSIF err = -2 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: TOO MANY ROWS');
    ELSIF err = -3 THEN
      DBMS_OUTPUT.PUT_LINE('ERROR: ERROR OCCURED IN EXECUTION');
    END IF;
DBMS_OUTPUT.PUT_LINE('------------------------------');

  spTeamRosterByID(1738, err);
      IF err = -1 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: NO DATA FOUND');
      ELSIF err = -2 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: TOO MANY ROWS');
      ELSIF err = -3 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ERROR OCCURED IN EXECUTION');
      END IF;
DBMS_OUTPUT.PUT_LINE('------------------------------');
END;
----------------------------------------------------------------------------------
/*-=Question 5.=- */
--===============DISPLAY TEAM ROSTERS BY NAME===============--
CREATE OR REPLACE PROCEDURE spTeamRosterByName(
  nameteam teams.teamname%TYPE,
  err OUT NUMBER
  )AS
      rosters vwPlayerRosters%ROWTYPE;
      found BOOLEAN := false;
      CURSOR trname IS
              SELECT * FROM vwPlayerRosters
              WHERE INSTR(UPPER(teamname),UPPER(nameteam)) > 0;
BEGIN
    err := 0;
    OPEN trname;
        LOOP
            FETCH trname INTO rosters;
            IF trname%FOUND THEN
              DBMS_OUTPUT.PUT_LINE('Roster ID:  ' || rosters.rosterid);
              DBMS_OUTPUT.PUT_LINE('Team Name:  ' || rosters.teamname);
              DBMS_OUTPUT.PUT_LINE('Team ID:  ' || rosters.teamid);
              DBMS_OUTPUT.PUT_LINE('First Name: ' || rosters.firstname);
              DBMS_OUTPUT.PUT_LINE('Last Name:  ' || rosters.lastname);
              DBMS_OUTPUT.PUT_LINE('Player ID:  ' || rosters.playerid);
              DBMS_OUTPUT.PUT_LINE('');
              found := true;
            ELSE
              IF found = false THEN
                err := -1; --NO DATA FOUND 
              END IF;
              EXIT;
            END IF;
        END LOOP;
    CLOSE trname;
EXCEPTION
    WHEN TOO_MANY_ROWS
        THEN 
            err := -2;
    WHEN OTHERS
        THEN
            err := -3;
END spTeamRosterByName;
----------------------- EXECUTE -------------------------------------
DECLARE
  err NUMBER;
BEGIN
  spTeamRosterByName('check', err);
    IF err = -1 THEN
      DBMS_OUTPUT.PUT_LINE('ERROR: NO DATA FOUND');
    ELSIF err = -2 THEN
      DBMS_OUTPUT.PUT_LINE('ERROR: TOO MANY ROWS');
    ELSIF err = -3 THEN
      DBMS_OUTPUT.PUT_LINE('ERROR: ERROR OCCURED IN EXECUTION');
    END IF;
DBMS_OUTPUT.PUT_LINE('------------------------------');

  spTeamRosterByName('uni', err);
    IF err = -1 THEN
      DBMS_OUTPUT.PUT_LINE('ERROR: NO DATA FOUND');
    ELSIF err = -2 THEN
      DBMS_OUTPUT.PUT_LINE('ERROR: TOO MANY ROWS');
    ELSIF err = -3 THEN
      DBMS_OUTPUT.PUT_LINE('ERROR: ERROR OCCURED IN EXECUTION');
    END IF;
DBMS_OUTPUT.PUT_LINE('------------------------------');

  spTeamRosterByName(212, err);
      IF err = -1 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: NO DATA FOUND');
      ELSIF err = -2 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: TOO MANY ROWS');
      ELSIF err = -3 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: ERROR OCCURED IN EXECUTION');
      END IF;
DBMS_OUTPUT.PUT_LINE('------------------------------');
END;
----------------------------------------------------------------------------------
/*-=Question 6.=- view that returns the number of players currently registered on each team*/
--===============vwTeamsNumPlayers===============--

CREATE OR REPLACE VIEW vwTeamsNumPlayers AS 
  SELECT 
      COUNT(playerid) AS PlayerCount,
      t.teamid
FROM rosters r
LEFT OUTER JOIN teams t ON t.teamid = r.teamid
GROUP BY t.teamid
ORDER BY t.teamid;


SELECT * FROM vwTeamsNumPlayers;

----------------------------------------------------------------------------------
/*-=Question 7.=- a user defined function, that given the team PK, will return the number of players currently registered*/
--===============fncNumPlayersByTeamID===============--

CREATE OR REPLACE FUNCTION fncNumPlayersByTeamID(
    team_id IN INT
) RETURN INT IS
    numPlayers NUMBER;
BEGIN
        SELECT PlayerCount
        INTO numPlayers
        FROM vwTeamsNumPlayers
        WHERE team_id LIKE teamid;
        
        RETURN numPlayers;
EXCEPTION
        WHEN NO_DATA_FOUND
            THEN
                numPlayers := -1;
                RETURN numPlayers;
        WHEN TOO_MANY_ROWS
            THEN
                numPlayers := -2;
                RETURN numPlayers;
        WHEN OTHERS
            THEN
                numPlayers := -3;
                RETURN numPlayers;
END fncNumPlayersByTeamID;

----Execution------

DECLARE
    result INT;
BEGIN
    result := fncNumPlayersByTeamID(2);
    IF result = -1 THEN
      DBMS_OUTPUT.PUT_LINE('ERROR: NO DATA FOUND');
    ELSIF result = -2 THEN
      DBMS_OUTPUT.PUT_LINE('ERROR: TOO MANY ROWS');
    ELSIF result = -3 THEN
      DBMS_OUTPUT.PUT_LINE('ERROR: ERROR OCCURED IN EXECUTION');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Player count is: ' || result);
    END IF;
    DBMS_OUTPUT.PUT_LINE('------------------------------');
END;

----------------------------------------------------------------------------------
/*-=Question 8.=- a view that shows all games, but includes the written names for teams and locations, in addition to the PK/FK values*/
--===============vwSchedule===============--

CREATE OR REPLACE VIEW vwSchedule AS
SELECT
        gameid,
        gamenum,
        gamedatetime,
        ht.teamid AS homeTeamID,
        ht.teamname AS homeTeam,
        homescore AS homeScore,
        SUBSTR(visitscore,1,2) AS visitScore,
        vt.teamname AS visitTeam,
        SUBSTR(vt.teamid,1,3) AS visitTeamID,
        l.locationname AS locationName,
        isplayed,
        notes
FROM games g
JOIN teams ht ON ht.teamid = g.hometeam
JOIN teams vt ON vt.teamid = g.visitteam
JOIN sllocations l ON l.locationid = g.locationid;

--Execute
SELECT * FROM vwSchedule;

----------------------------------------------------------------------------------
/*-=Question 9.=-*/
--===============spSchedUpcomingGames===============--
CREATE OR REPLACE PROCEDURE spSchedUpcomingGames (
    days IN INTEGER,
    err OUT NUMBER
) AS
    found BOOLEAN := false;
    CURSOR gup IS
        SELECT * FROM games
        WHERE gameDateTime BETWEEN TRUNC(sysdate + days)
        AND TRUNC(sysdate);
BEGIN
    err := 0;
    OPEN gup;
        LOOP
            FETCH gup INTO game;
            IF gup%FOUND THEN
                DBMS_OUTPUT.PUT_LINE('GameID:       ' || game.gameID);
                DBMS_OUTPUT.PUT_LINE('DivID:        ' || game.divID);
                DBMS_OUTPUT.PUT_LINE('GameNum:      ' || game.gameNum);
                DBMS_OUTPUT.PUT_LINE('GameDateTime: ' || game.gameDateTime);
                DBMS_OUTPUT.PUT_LINE('HomeTeam:     ' || game.homeTeam);
                DBMS_OUTPUT.PUT_LINE('HomeScore:    ' || game.homeScore);
                DBMS_OUTPUT.PUT_LINE('VisitTeam     ' || game.visitTeam);
                DBMS_OUTPUT.PUT_LINE('VisitScore:   ' || game.visitScore);
                DBMS_OUTPUT.PUT_LINE('LocationID:   ' || game.locationID);
                DBMS_OUTPUT.PUT_LINE('isPlayed:     ' || game.isPlayed);
                DBMS_OUTPUT.PUT_LINE('Notes:        ' || NVL(game.notes, 'No notes'));
                DBMS_OUTPUT.PUT_LINE('');
                found := true;
            ELSE
                IF found = false THEN
                    err := -1; --NO DATA FOUND 
                END IF;
                EXIT;
            END IF;
        END LOOP;
    CLOSE gup;
EXCEPTION
    WHEN TOO_MANY_ROWS
        THEN 
            err := -2;
    WHEN OTHERS
        THEN
            err := -3;
END spSchedUpcomingGames;

----------------------------------------------------------------------------------
/*-=Question 10.=-*/
--===============spSchedPastGames===============--

CREATE OR REPLACE PROCEDURE spSchedPastGames (
    days IN INTEGER,
    err OUT NUMBER
) AS
    found BOOLEAN := false;
    CURSOR spg IS
        SELECT * FROM games
        WHERE gameDateTime BETWEEN TRUNC(sysdate - days)
        AND TRUNC(sysdate);
BEGIN
    err := 0;
    OPEN spg;
        LOOP
            FETCH spg INTO game;
            IF spg%FOUND THEN
                DBMS_OUTPUT.PUT_LINE('GameID:       ' || game.gameID);
                DBMS_OUTPUT.PUT_LINE('DivID:        ' || game.divID);
                DBMS_OUTPUT.PUT_LINE('GameNum:      ' || game.gameNum);
                DBMS_OUTPUT.PUT_LINE('GameDateTime: ' || game.gameDateTime);
                DBMS_OUTPUT.PUT_LINE('HomeTeam:     ' || game.homeTeam);
                DBMS_OUTPUT.PUT_LINE('HomeScore:    ' || game.homeScore);
                DBMS_OUTPUT.PUT_LINE('VisitTeam     ' || game.visitTeam);
                DBMS_OUTPUT.PUT_LINE('VisitScore:   ' || game.visitScore);
                DBMS_OUTPUT.PUT_LINE('LocationID:   ' || game.locationID);
                DBMS_OUTPUT.PUT_LINE('isPlayed:     ' || game.isPlayed);
                DBMS_OUTPUT.PUT_LINE('Notes:        ' || NVL(game.notes, 'No notes'));
                DBMS_OUTPUT.PUT_LINE('');
                found := true;
            ELSE
                IF found = false THEN
                err := -1; --NO DATA FOUND 
              END IF;
              EXIT;
            END IF;
        END LOOP;
    CLOSE spg;
EXCEPTION
    WHEN TOO_MANY_ROWS
        THEN 
            err := -2;
    WHEN OTHERS
        THEN
            err := -3;
END spSchedPastGames;

----------------------------------------------------------------------------------
/*-=Question 11.=- a user defined function returns number of matches by the 
given team id from vwSchedule */
--===============fncNumMatchesByTeamId===============--

CREATE OR REPLACE FUNCTION fncNumMatchesByTeamId(
    team_id IN INT
) RETURN INT IS
    numMatches NUMBER;         
BEGIN
    SELECT COUNT(gameid) INTO numMatches
    FROM vwSchedule
    WHERE team_id LIKE homeTeamID OR team_id LIKE visitTeamID;
        IF numMatches = 0 
            THEN numMatches := -1;
        END IF;
    
    RETURN numMatches;
EXCEPTION
        WHEN NO_DATA_FOUND
            THEN
                numMatches := -1;
                RETURN numMatches;
        WHEN TOO_MANY_ROWS
            THEN
                numMatches := -2;
                RETURN numMatches;
        WHEN OTHERS
            THEN
                numMatches := -3;
                RETURN numMatches;
END fncNumMatchesByTeamId;


DECLARE
    result INT;
BEGIN
    result := fncNumMatchesByTeamID(222);
    IF result = -1 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: NO DATA FOUND');
    ELSIF result = -2 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: TOO MANY ROWS');
    ELSIF result = -3 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: An Unexpected Error Occured');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Number of games by team id: ' || result);
    END IF;
END;