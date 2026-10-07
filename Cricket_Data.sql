-- Requires MySQL 8.0+.
-- Run CREATE DATABASE / USE, then import Cricket_data1.csv with Workbench's
-- Table Data Import Wizard into cricket_data. Keep dates as TEXT and
-- allow blanks in score fields. Run the remaining statements after import.
CREATE DATABASE IF NOT EXISTS cricket_data;

USE cricket_data;

SELECT *
FROM cricket_data
LIMIT 3;

-- Keep the imported raw dates unchanged; this view parses them safely on each run.
-- Blank scores become NULL rather than zero.
CREATE OR REPLACE VIEW cricket_data AS
SELECT c.*,
       STR_TO_DATE(LEFT(TRIM(start_date), 10), '%d-%m-%Y') AS start_date,
       STR_TO_DATE(LEFT(TRIM(end_date), 10), '%d-%m-%Y') AS end_date,
       CAST(NULLIF(TRIM(first_inning_score), '') AS UNSIGNED) AS first_inning_score,
       CAST(NULLIF(TRIM(second_inning_score), '') AS UNSIGNED) AS second_inning_score
FROM cricket_data AS c;

-- Total Matches played

SELECT COUNT(*) AS total_matches
FROM cricket_data;

-- How many matches were played in each season?

SELECT season, COUNT(*) AS total_matches
FROM cricket_data
GROUP BY season
ORDER BY season;

-- Which team won the most matches?

SELECT winner, COUNT(*) AS matches_won
FROM cricket_data
WHERE winner IN (home_team, away_team)
GROUP BY winner
ORDER BY matches_won DESC
LIMIT 1;

-- Top 5 winning teams

SELECT winner, COUNT(*) AS top_winner
FROM cricket_data
WHERE winner IN (home_team, away_team)
GROUP BY winner
ORDER BY top_winner DESC
LIMIT 5;

-- How many times did the team that won the toss also win the match?

SELECT COUNT(*) AS toss_and_match_win
FROM cricket_data
WHERE toss_won = winner;

-- Analysis of batting vs bowling decision after winning the toss

SELECT decision, COUNT(*) AS total
FROM cricket_data
GROUP BY decision;

-- Highest score in the 1st innings

SELECT MAX(first_inning_score) AS highest_score
FROM cricket_data;

-- Lowest score in the 1st innings

SELECT MIN(first_inning_score) AS lowest_score
FROM cricket_data;

-- Highest second-innings score in a wickets win, excluding D/L or DLS results

SELECT MAX(second_inning_score) AS highest_chase
FROM cricket_data
WHERE winner IN (home_team, away_team)
  AND LOWER(result) REGEXP 'won by [0-9]+ (wkt|wicket)'
  AND LOWER(result) NOT REGEXP 'd/l|dls|duckworth';


-- Who was awarded Player of the Match the most times?

SELECT pom, COUNT(*) AS most_player_of_match
FROM cricket_data
WHERE TRIM(COALESCE(pom, '')) <> ''
GROUP BY pom
ORDER BY most_player_of_match DESC
LIMIT 1;

-- Top 5 player of the match 

SELECT pom, COUNT(*) AS most_player_of_match
FROM cricket_data
WHERE TRIM(COALESCE(pom, '')) <> ''
GROUP BY pom
ORDER BY most_player_of_match DESC
LIMIT 5;

-- Home Team Vs Away Team perfomance 

SELECT home_team, COUNT(*) AS home_matches
FROM cricket_data
GROUP BY home_team;

SELECT away_team, COUNT(*) AS away_matches
FROM cricket_data
GROUP BY away_team;

SELECT 
    Home_Team,
    COUNT(*) AS matches,
    SUM(CASE WHEN Winner = Home_Team THEN 1 ELSE 0 END) AS home_wins
FROM cricket_data
GROUP BY Home_Team;

-- Which venue hosts the most matches?

SELECT venue_name, COUNT(*) AS matches_hosted
FROM cricket_data
GROUP BY venue_name
ORDER BY matches_hosted DESC
LIMIT 1;

-- Chasing wins identified by the recorded wickets margin (ties excluded) 

SELECT COUNT(*) AS chasing_wins
FROM cricket_data
WHERE winner IN (home_team, away_team)
  AND LOWER(result) REGEXP 'won by [0-9]+ (wkt|wicket)';

-- Defending wins identified by the recorded runs margin (ties excluded)

SELECT COUNT(*) AS defending_wins
FROM cricket_data
WHERE winner IN (home_team, away_team)
  AND LOWER(result) REGEXP 'won by [0-9]+ runs?';

-- Winner count for each season

SELECT season, winner, COUNT(*) AS wins
FROM cricket_data
WHERE winner IN (home_team, away_team)
GROUP BY season, winner 
ORDER BY season, wins DESC;

-- Team that won the toss the most times

SELECT toss_won, COUNT(*) AS toss_wons
FROM cricket_data
GROUP BY toss_won
ORDER BY toss_wons DESC
LIMIT 1;

-- Average score per match

SELECT AVG(first_inning_score) AS avg_first,
		AVG(second_inning_score) AS avg_second
        FROM cricket_data;
        
-- Close matches decided by 1-9 runs. Wickets wins are measured differently.

SELECT *
FROM cricket_data
WHERE winner IN (home_team, away_team)
  AND LOWER(result) REGEXP 'won by [1-9] runs?([^0-9]|$)'
ORDER BY start_date, id;

-- Team win percentage: wins / matches played by that team.
-- Includes ties and no-results in matches played; keeps historical team names.

WITH appearances AS (
    SELECT home_team AS team, winner FROM cricket_data
    UNION ALL
    SELECT away_team AS team, winner FROM cricket_data
)
SELECT team, COUNT(*) AS matches_played,
       SUM(CASE WHEN winner = team THEN 1 ELSE 0 END) AS wins,
       ROUND(100.0 * SUM(CASE WHEN winner = team THEN 1 ELSE 0 END)
             / COUNT(*), 2) AS win_percentage
FROM appearances
WHERE TRIM(COALESCE(team, '')) <> ''
GROUP BY team
ORDER BY win_percentage DESC, team;
