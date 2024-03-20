-- View 1: Get an overview of all matches with team names and stadium locations.
DROP VIEW IF EXISTS MatchOverview;
CREATE VIEW MatchOverview AS
SELECT GameID, g.Team1Name, g.Team2Name, s.Host AS StadiumLocation, Round, Date, Score
FROM Game g
JOIN Stadium s ON g.StadiumName = s.StadiumName;

-- View 2: Get an overview of players with the most matches played.
DROP VIEW IF EXISTS TopPlayers;
CREATE VIEW TopPlayers AS
SELECT p.PlayerName, p.TeamName, COUNT(g.GameID) as MatchesPlayed
FROM Player p
JOIN Game g ON p.TeamName = g.Team1Name OR p.TeamName = g.Team2Name
GROUP BY p.PlayerName, p.TeamName
ORDER BY MatchesPlayed DESC;

