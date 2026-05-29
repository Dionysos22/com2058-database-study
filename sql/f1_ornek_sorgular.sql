-- Formula 1 - ornek sorgular (Project/SAMPLE_QUERIES.sql ozeti)
-- Once: mysql < ../Project/Formula_1.sql

USE formula_1;

-- 1) 2024 sezonu yarislari
SELECT r.round_number, r.grand_prix_name, c.circuit_name, r.race_start_date
FROM races r
JOIN circuits c ON c.circuit_id = r.circuit_id
WHERE r.season_year = 2024
ORDER BY r.race_start_date, r.round_number;

-- 2) 2024 constructors standings
SELECT t.team_name,
       DENSE_RANK() OVER (ORDER BY SUM(rr.points) DESC) AS season_position,
       SUM(rr.points) AS season_points
FROM race_results rr
JOIN team_drivers td ON td.season_year = rr.season_year
  AND td.driver_id = rr.driver_id AND td.role = 'MAIN'
JOIN teams t ON t.team_id = td.team_id
WHERE rr.season_year = 2024
GROUP BY t.team_id, t.team_name
ORDER BY season_position;

-- 3) Pilotun tum yarislari (driver_id = 1)
SELECT r.season_year, r.grand_prix_name, rr.grid_position, rr.finish_position, rr.points
FROM race_results rr
JOIN races r ON r.season_year = rr.season_year AND r.round_number = rr.round_number
WHERE rr.driver_id = 1
ORDER BY r.season_year, r.round_number;

-- 4) Takim kadrosu 2024
SELECT d.first_name, d.last_name, td.role, td.seat_no
FROM team_drivers td
JOIN drivers d ON d.driver_id = td.driver_id
WHERE td.season_year = 2024 AND td.team_id = 1
ORDER BY td.role, td.seat_no;

-- 5) Podyum (2024 round 1)
SELECT rr.finish_position, d.driver_code, t.team_name, rr.points
FROM race_results rr
JOIN drivers d ON d.driver_id = rr.driver_id
JOIN team_drivers td ON td.season_year = rr.season_year
  AND td.driver_id = rr.driver_id AND td.role = 'MAIN'
JOIN teams t ON t.team_id = td.team_id
WHERE rr.season_year = 2024 AND rr.round_number = 1
  AND rr.finish_position BETWEEN 1 AND 3
ORDER BY rr.finish_position;

-- Tam liste: ../../Project/SAMPLE_QUERIES.sql
