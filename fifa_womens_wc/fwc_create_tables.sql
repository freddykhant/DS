/* MySQL file for creating tables for Final Assignment */

-- Create table for Team
DROP TABLE IF EXISTS Team;
CREATE TABLE Team (
    TeamName VARCHAR(30) PRIMARY KEY,
    ManagerName VARCHAR(30) NOT NULL,
    CaptainName VARCHAR(30) NOT NULL
);

-- Create table for Player
DROP TABLE IF EXISTS Player;
CREATE TABLE Player (
    PlayerID INT PRIMARY KEY AUTO_INCREMENT,
    TeamName VARCHAR(30),
    PlayerName VARCHAR(30) NOT NULL,
    Position VARCHAR(30) NOT NULL,
    Age INT CHECK (Age >= 16 AND Age <= 40),
    FOREIGN KEY (TeamName) REFERENCES Team(TeamName)
);

-- Create table for Stadium
DROP TABLE IF EXISTS Stadium;
CREATE TABLE Stadium (
    StadiumName VARCHAR(30) PRIMARY KEY,
    Host VARCHAR(30) NOT NULL
);

-- Create table for Game
DROP TABLE IF EXISTS Game;
CREATE TABLE Game (
    GameID INT PRIMARY KEY AUTO_INCREMENT,
    Team1Name VARCHAR(30),
    Team2Name VARCHAR(30),
    StadiumName VARCHAR(30),
    Round VARCHAR(30) NOT NULL,
    Date DATE NOT NULL,
    Score VARCHAR(5) NOT NULL,
    CHECK (Team1Name <> Team2Name),
    FOREIGN KEY (Team1Name) REFERENCES Team(TeamName) ON DELETE CASCADE,
    FOREIGN KEY (Team2Name) REFERENCES Team(TeamName) ON DELETE CASCADE,
    FOREIGN KEY (StadiumName) REFERENCES Stadium(StadiumName) ON DELETE NO ACTION
);

