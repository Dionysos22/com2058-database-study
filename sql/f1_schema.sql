-- =========================
-- Formula 1 (Web-Friendly) Schema v2 (MySQL 8+)
-- =========================

CREATE DATABASE IF NOT EXISTS formula_1
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_0900_ai_ci;

USE formula_1;

-- Re-run friendly
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS race_results;
DROP TABLE IF EXISTS races;
DROP TABLE IF EXISTS circuits;
DROP TABLE IF EXISTS team_standings;
DROP TABLE IF EXISTS team_drivers;
DROP TABLE IF EXISTS drivers;
DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS seasons;
SET FOREIGN_KEY_CHECKS = 1;

-- -------------------------
-- Seasons
-- -------------------------
CREATE TABLE seasons (
  season_year INT NOT NULL,
  PRIMARY KEY (season_year),
  CHECK (season_year >= 1950)
);

-- -------------------------
-- Teams
-- -------------------------
CREATE TABLE teams (
  team_id INT NOT NULL AUTO_INCREMENT,
  team_name VARCHAR(50) NOT NULL,
  full_name VARCHAR(120) NULL,
  founding_year INT NULL,
  base_country VARCHAR(60) NULL,
  base_city VARCHAR(60) NULL,
  team_chief VARCHAR(80) NULL,
  engine_supplier VARCHAR(80) NULL,

  PRIMARY KEY (team_id),
  UNIQUE KEY uq_teams_team_name (team_name),
  CHECK (founding_year IS NULL OR founding_year >= 1800)
);

-- -------------------------
-- Drivers
-- -------------------------
CREATE TABLE drivers (
  driver_id INT NOT NULL AUTO_INCREMENT,
  car_no INT NULL,
  driver_code CHAR(3) NOT NULL,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  nation VARCHAR(60) NULL,
  birth_date DATE NULL,

  num_poles INT NOT NULL DEFAULT 0,
  num_podiums INT NOT NULL DEFAULT 0,
  num_championships INT NOT NULL DEFAULT 0,

  PRIMARY KEY (driver_id),
  UNIQUE KEY uq_drivers_car_no (car_no),
  UNIQUE KEY uq_drivers_code (driver_code),
  CHECK (num_poles >= 0 AND num_podiums >= 0 AND num_championships >= 0)
);

-- -------------------------
-- Driver <-> Team (per season)
-- -------------------------
CREATE TABLE team_drivers (
  season_year INT NOT NULL,
  team_id INT NOT NULL,
  driver_id INT NOT NULL,
  role ENUM('MAIN','RESERVE') NOT NULL,
  seat_no TINYINT NULL,

  PRIMARY KEY (season_year, team_id, driver_id),

  CONSTRAINT fk_td_season FOREIGN KEY (season_year) REFERENCES seasons(season_year)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_td_team FOREIGN KEY (team_id) REFERENCES teams(team_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_td_driver FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,

  CHECK (seat_no IS NULL OR seat_no IN (1,2)),
  CHECK (
    (role = 'MAIN' AND seat_no IS NOT NULL) OR
    (role = 'RESERVE' AND seat_no IS NULL)
  )
);

CREATE INDEX ix_td_team_season ON team_drivers (team_id, season_year);
CREATE INDEX ix_td_driver_season ON team_drivers (driver_id, season_year);

-- -------------------------
-- Team standings (optional cache)
-- -------------------------
CREATE TABLE team_standings (
  season_year INT NOT NULL,
  team_id INT NOT NULL,
  season_position INT NULL,
  season_points INT NOT NULL DEFAULT 0,

  PRIMARY KEY (season_year, team_id),
  CONSTRAINT fk_ts_season FOREIGN KEY (season_year) REFERENCES seasons(season_year)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_ts_team FOREIGN KEY (team_id) REFERENCES teams(team_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,

  CHECK (season_points >= 0)
);

-- -------------------------
-- Circuits
-- -------------------------
CREATE TABLE circuits (
  circuit_id INT NOT NULL AUTO_INCREMENT,
  circuit_name VARCHAR(120) NOT NULL,
  country VARCHAR(60) NULL,
  city VARCHAR(60) NULL,
  laps INT NULL,
  length_m INT NULL,
  first_gp_year INT NULL,
  fastest_lap_time TIME(3) NULL,

  PRIMARY KEY (circuit_id),
  UNIQUE KEY uq_circuits_name (circuit_name),
  CHECK (laps IS NULL OR laps > 0),
  CHECK (length_m IS NULL OR length_m > 0),
  CHECK (first_gp_year IS NULL OR first_gp_year >= 1900)
);

-- -------------------------
-- Races (schedule)
-- -------------------------
CREATE TABLE races (
  season_year INT NOT NULL,
  round_number INT NOT NULL,
  circuit_id INT NOT NULL,
  grand_prix_name VARCHAR(160) NOT NULL,
  race_start_date DATE NOT NULL,
  race_end_date DATE NOT NULL,

  PRIMARY KEY (season_year, round_number),

  CONSTRAINT fk_r_season FOREIGN KEY (season_year) REFERENCES seasons(season_year)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_r_circuit FOREIGN KEY (circuit_id) REFERENCES circuits(circuit_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,

  UNIQUE KEY uq_race_name_per_season (season_year, grand_prix_name),
  CHECK (round_number > 0),
  CHECK (race_start_date <= race_end_date)
);

CREATE INDEX ix_races_circuit ON races (circuit_id);

-- -------------------------
-- Race results
-- -------------------------
CREATE TABLE race_results (
  season_year INT NOT NULL,
  round_number INT NOT NULL,
  driver_id INT NOT NULL,

  grid_position INT NULL,
  finish_position INT NULL,
  points INT NOT NULL DEFAULT 0,

  PRIMARY KEY (season_year, round_number, driver_id),

  CONSTRAINT fk_rr_race FOREIGN KEY (season_year, round_number) REFERENCES races(season_year, round_number)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_rr_driver FOREIGN KEY (driver_id) REFERENCES drivers(driver_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,

  CHECK (grid_position IS NULL OR grid_position > 0),
  CHECK (finish_position IS NULL OR finish_position > 0),
  CHECK (points >= 0)
);

CREATE INDEX ix_rr_driver ON race_results (driver_id);
CREATE INDEX ix_rr_finish ON race_results (season_year, round_number, finish_position);

