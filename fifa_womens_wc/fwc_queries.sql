-- 1. Which players are aged 25 and play as a Forward (FW)?
SELECT PlayerName, Age, TeamName 
FROM Player 
WHERE Age = 25 AND Position = 'FW';


-- 2. How many players are there for each team?
SELECT TeamName, COUNT(PlayerName) as NumberOfPlayers 
FROM Player 
GROUP BY TeamName;


-- 3. Who are the youngest and oldest players in the tournament?
(SELECT PlayerName, Age, TeamName 
FROM Player 
ORDER BY Age ASC LIMIT 1)
UNION
(SELECT PlayerName, Age, TeamName 
FROM Player 
ORDER BY Age DESC LIMIT 1);


-- 4. Which stadium hosted the most games?
SELECT StadiumName, COUNT(GameID) as NumberOfMatches 
FROM Game 
GROUP BY StadiumName 
ORDER BY NumberOfMatches DESC LIMIT 1;


-- 5. Which teams played at "Accor Stadium, Sydney"?
SELECT DISTINCT Team1Name as Team 
FROM Game 
WHERE StadiumName = 'Accor Stadium, Sydney' 
UNION 
SELECT DISTINCT Team2Name as Team 
FROM Game 
WHERE StadiumName = 'Accor Stadium, Sydney';


-- 6. Which team has accumulated the highest total score across all matches in the tournament?
SELECT Team, SUM(TotalGoals) as OverallGoals
FROM (
    SELECT Team1Name as Team, CAST(SUBSTRING_INDEX(Score, '-', 1) AS UNSIGNED) as TotalGoals
    FROM Game

    UNION ALL

    SELECT Team2Name as Team, CAST(SUBSTRING_INDEX(Score, '-', -1) AS UNSIGNED) as TotalGoals
    FROM Game
) as CombinedScores
GROUP BY Team
ORDER BY OverallGoals DESC
LIMIT 1;


-- 7. How many games did each team win?
SELECT Team, COUNT(*) as TotalWins
FROM (
    SELECT Team1Name as Team
    FROM Game
    WHERE CAST(SUBSTRING_INDEX(Score, '-', 1) AS UNSIGNED) > CAST(SUBSTRING_INDEX(Score, '-', -1) AS UNSIGNED)
    UNION ALL
    SELECT Team2Name
    FROM Game
    WHERE CAST(SUBSTRING_INDEX(Score, '-', 1) AS UNSIGNED) < CAST(SUBSTRING_INDEX(Score, '-', -1) AS UNSIGNED)
) as Wins
GROUP BY Team;

-- 8. Which games ended in a draw?
SELECT GameID, Team1Name, Team2Name, Score 
FROM Game 
WHERE SUBSTRING_INDEX(Score, '-', 1) = SUBSTRING_INDEX(Score, '-', -1);

-- 9. List the top 5 players based on age from the team "Spain".
SELECT PlayerName, Age 
FROM Player 
WHERE TeamName = 'Spain' 
ORDER BY Age 
LIMIT 5;

-- 10. Which team captains have played in the "Final" round?
SELECT t.TeamName, t.CaptainName 
FROM Team t 
JOIN Game g ON t.TeamName = g.Team1Name OR t.TeamName = g.Team2Name 
WHERE g.Round = 'Final';

