import mysql.connector

host = "localhost"
user = "me"
password = "myUserPassword"
database = "FIFAWorldCup_20618166"

# Establishing the connection
conn = mysql.connector.connect(
    host=host,
    user=user,
    password=password,
    database=database
)

# Creating a cursor object
cursor = conn.cursor()

# Function to execute and print results
def execute_and_print(query, description):
    cursor.execute(query)
    results = cursor.fetchall()
    print(description)
    for result in results:
        print(result)
    print("\n")

# Query 1
execute_and_print("SELECT PlayerName, Age, TeamName FROM Player WHERE Age = 25 AND Position = 'FW';", "Players aged 25 and play as a Forward (FW):")

# Query 2
execute_and_print("SELECT TeamName, COUNT(PlayerName) as NumberOfPlayers FROM Player GROUP BY TeamName;", "Number of players for each team:")

# Query 3
execute_and_print("(SELECT PlayerName, Age, TeamName FROM Player ORDER BY Age ASC LIMIT 1) UNION (SELECT PlayerName, Age, TeamName FROM Player ORDER BY Age DESC LIMIT 1);", "Youngest and oldest players in the tournament:")

# Query 4
execute_and_print("SELECT StadiumName, COUNT(GameID) as NumberOfMatches FROM Game GROUP BY StadiumName ORDER BY NumberOfMatches DESC LIMIT 1;", "Stadium that hosted the most games:")

# Query 5
execute_and_print("SELECT DISTINCT Team1Name as Team FROM Game WHERE StadiumName = 'Accor Stadium, Sydney' UNION SELECT DISTINCT Team2Name as Team FROM Game WHERE StadiumName = 'Accor Stadium, Sydney';", "Teams that played at 'Accor Stadium, Sydney':")

# Query 6
execute_and_print("""
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
""", "Team with the highest total score across all matches:")

# Query 7
execute_and_print("""
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
""", "Number of games each team won:")

# Query 8
execute_and_print("SELECT GameID, Team1Name, Team2Name, Score FROM Game WHERE SUBSTRING_INDEX(Score, '-', 1) = SUBSTRING_INDEX(Score, '-', -1);", "Games that ended in a draw:")

# Query 9
execute_and_print("SELECT PlayerName, Age FROM Player WHERE TeamName = 'Spain' ORDER BY Age LIMIT 5;", "Top 5 players based on age from the team 'Spain':")

# Query 10
execute_and_print("""
SELECT t.TeamName, t.CaptainName 
FROM Team t 
JOIN Game g ON t.TeamName = g.Team1Name OR t.TeamName = g.Team2Name 
WHERE g.Round = 'Final';
""", "Team captains who played in the 'Final' round:")

# Call the AddMultipleGames stored procedure
team1 = "Australia"
team2 = "Japan"
stadium_name = "Accor Stadium, Sydney"
match_round = "Extra"
start_date = "2023-07-01"
end_date = "2023-07-10"

cursor.callproc("AddMultipleGames", [team1, team2, stadium_name, match_round, start_date, end_date])

print(f"Games added between {team1} and {team2} from {start_date} to {end_date}.\n")

# Executing View
execute_and_print("SELECT * FROM MatchOverview LIMIT 5;", "Overview of first 5 matches:")

# Demonstrating Trigger
# This will activate the PlayerAgeCheck trigger
try:
    cursor.execute("UPDATE Player SET Age = 15 WHERE PlayerName = 'SomePlayer';")
    conn.commit()
except mysql.connector.Error as err:
    print(f"Error: {err.msg}\n")

# CRUD Operations

# Inserting a new player
cursor.execute("INSERT INTO Player (PlayerName, Age, TeamName, Position) VALUES ('Bridget Chia', 21, 'Australia', 'MF');")
print("New player inserted successfully!")

# Updating the player's age
cursor.execute("UPDATE Player SET Age = 22 WHERE PlayerName = 'Bridget Chia';")
print("Player's age updated successfully!")

# Deleting the player
cursor.execute("DELETE FROM Player WHERE PlayerName = 'Bridget Chia';")
print("Player deleted successfully!")

# Committing changes
conn.commit()

# Closing the cursor and connection
cursor.close()
conn.close()