-- Stored Procedure 1: Get the total number of players in a given team.
DELIMITER //
DROP PROCEDURE IF EXISTS TotalPlayersInTeam;
CREATE PROCEDURE TotalPlayersInTeam(IN team_name VARCHAR(20), OUT total_players INT)
BEGIN
    SELECT COUNT(PlayerID) INTO total_players FROM Player WHERE TeamName = team_name;
END //
DELIMITER ;

-- Stored Procedure 2: Add multiple new Gamees and automatically update the number of Gamees played for each team
DELIMITER //
DROP PROCEDURE IF EXISTS AddMultipleGames;
CREATE PROCEDURE AddMultipleGames(IN team1 VARCHAR(20), IN team2 VARCHAR(20), IN stadium_name VARCHAR(30), IN match_round VARCHAR(20), IN start_date DATE, IN end_date DATE)
BEGIN
    DECLARE curr_date DATE; 
    SET curr_date = start_date;
    
    WHILE curr_date <= end_date DO
        INSERT INTO Game(Team1Name, Team2Name, StadiumName, Round, Date, Score) 
        VALUES (team1, team2, stadium_name, match_round, curr_date, '0-0');
  
        SET curr_date = DATE_ADD(curr_date, INTERVAL 1 DAY); 
    END WHILE;
END //
DELIMITER ;