-- Trigger 1: Ensure that a team does not play more than one match on the same date.
DELIMITER //
DROP TRIGGER IF EXISTS MatchDateCheck;
CREATE TRIGGER MatchDateCheck BEFORE INSERT ON Game
FOR EACH ROW 
BEGIN
    IF EXISTS (SELECT 1 FROM Game WHERE (Team1Name = NEW.Team1Name OR Team2Name = NEW.Team1Name OR Team1Name = NEW.Team2Name OR Team2Name = NEW.Team2Name) AND Date = NEW.Date) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A team cannot play more than one match on the same date.';
    END IF;
END //
DELIMITER ;


-- Trigger 2: Ensure that a player's age remains within the acceptable range when updated.
DELIMITER //
DROP TRIGGER IF EXISTS PlayerAgeCheck;
CREATE TRIGGER PlayerAgeCheck BEFORE UPDATE ON Player
FOR EACH ROW 
BEGIN
    IF NEW.Age < 16 OR NEW.Age > 40 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Player age must be between 16 and 40.';
    END IF;
END //
DELIMITER ;
