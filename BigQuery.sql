-- Highest run scorers in each season

WITH SeasonTopScorer AS (
  SELECT
    p.player_name,
    m.season_year,
    SUM(b.runs_scored) AS total_runs,
    RANK() OVER(PARTITION BY m.season_year ORDER BY SUM(b.runs_scored) DESC) as rank
  FROM 
    `sp24-i535-shahhh-cricanalysis.cric_dataset.ball_by_ball` b
  JOIN 
    `sp24-i535-shahhh-cricanalysis.cric_dataset.match` m ON b.match_id = m.match_id   
  JOIN 
    `sp24-i535-shahhh-cricanalysis.cric_dataset.player_match` pm ON m.match_id = pm.match_id AND b.striker = pm.player_id     
  JOIN 
    `sp24-i535-shahhh-cricanalysis.cric_dataset.player` p ON p.player_id = pm.player_id
  GROUP BY 
    p.player_name, m.season_year
)
SELECT
  player_name,
  season_year,
  total_runs
FROM 
  SeasonTopScorer
WHERE
  rank = 1
ORDER BY
  total_runs DESC


-- Best Economy (least average runs per over)

WITH BowlerStatistics AS (
  SELECT
    p.player_name,
    SUM(b.runs_scored) AS total_runs_given,
    COUNT(b.ball_id) AS total_balls_bowled,
    COUNT(DISTINCT CONCAT(CAST(b.match_id AS STRING), '-', CAST(b.over_id AS STRING))) AS total_overs_bowled,
    SUM(IF(b.bowler_wicket, 1, 0)) AS total_wickets
  FROM 
    `sp24-i535-shahhh-cricanalysis.cric_dataset.ball_by_ball` b
  JOIN 
    `sp24-i535-shahhh-cricanalysis.cric_dataset.player_match` pm ON b.match_id = pm.match_id AND b.bowler = pm.player_id
  JOIN 
    `sp24-i535-shahhh-cricanalysis.cric_dataset.player` p ON pm.player_id = p.player_id
  GROUP BY p.player_name
  HAVING total_overs_bowled >= 50
)
SELECT
  player_name,
  (total_runs_given / total_overs_bowled) AS avg_runs_per_over,
  total_wickets
FROM 
  BowlerStatistics
ORDER BY avg_runs_per_over ASC
LIMIT 30

-- Relation between toss and outcome of the match (Analyzing whether winning the toss does actually have an impact on the outcome of the match or not)

SELECT 
  m.match_id, 
  m.toss_winner, 
  m.toss_name, 
  m.match_winner,
  CASE 
    WHEN m.toss_winner = m.match_winner THEN 'Won' 
    ELSE 'Lost' 
  END AS match_outcome
FROM 
  `sp24-i535-shahhh-cricanalysis.cric_dataset.match` m
WHERE 
  m.toss_name IS NOT NULL
ORDER BY 
  m.match_id

SELECT 
  m.toss_winner AS team_name,
  COUNT(*) AS wins_after_winning_toss
FROM 
  `sp24-i535-shahhh-cricanalysis.cric_dataset.match` m
WHERE 
  m.toss_name IS NOT NULL AND 
  m.toss_winner = m.match_winner
GROUP BY 
  m.toss_winner
ORDER BY 
  wins_after_winning_toss DESC

SELECT 
  team1, 
  COUNT(*) AS matches_played, 
  SUM(CASE WHEN toss_winner = match_winner THEN 1 ELSE 0 END) AS wins_after_toss
FROM 
  `sp24-i535-shahhh-cricanalysis.cric_dataset.match`
WHERE 
  toss_winner = team1
GROUP BY 
  team1
ORDER BY 
  wins_after_toss DESC

-- Analyzing dismissal types

SELECT 
  out_type, 
  COUNT(*) AS frequency
FROM 
  `sp24-i535-shahhh-cricanalysis.cric_dataset.ball_by_ball`
WHERE 
  out_type IS NOT NULL
GROUP BY 
  out_type
ORDER BY 
  frequency DESC

-- Analyzing average (both innings) scores for each venue

SELECT 
  venue_name, 
  AVG(total_runs) AS average_score, 
  MAX(total_runs) AS highest_score
FROM (
  SELECT 
    b.match_id, 
    m.venue_name, 
    SUM(b.runs_scored) AS total_runs
  FROM 
    `sp24-i535-shahhh-cricanalysis.cric_dataset.ball_by_ball` b
  JOIN 
    `sp24-i535-shahhh-cricanalysis.cric_dataset.match` m ON b.match_id = m.match_id
  GROUP BY 
    b.match_id, m.venue_name
)
GROUP BY 
  venue_name
ORDER BY 
  average_score DESC
