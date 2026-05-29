-- F1 ornek sorgulari icin minimal demo veri (sql/f1_ornek_sorgular.sql)
USE formula_1;

INSERT INTO seasons (season_year) VALUES (2024);

INSERT INTO teams (team_name, full_name) VALUES ('FERRARI', 'Scuderia Ferrari');
INSERT INTO teams (team_name, full_name) VALUES ('MCLAREN', 'McLaren F1 Team');

INSERT INTO drivers (car_no, driver_code, first_name, last_name, nation)
VALUES (16, 'LEC', 'Charles', 'Leclerc', 'Monaco'),
       (81, 'PIA', 'Oscar', 'Piastri', 'Australia');

INSERT INTO team_drivers (season_year, team_id, driver_id, role, seat_no)
VALUES (2024, 1, 1, 'MAIN', 1),
       (2024, 2, 2, 'MAIN', 1);

INSERT INTO circuits (circuit_name, country, city, laps)
VALUES ('Monza', 'Italy', 'Monza', 53);

INSERT INTO races (season_year, round_number, circuit_id, grand_prix_name, race_start_date, race_end_date)
VALUES (2024, 1, 1, 'Italian Grand Prix', '2024-09-01', '2024-09-01');

INSERT INTO race_results (season_year, round_number, driver_id, grid_position, finish_position, points)
VALUES (2024, 1, 1, 2, 1, 25),
       (2024, 1, 2, 1, 2, 18);

INSERT INTO team_standings (season_year, team_id, season_position, season_points)
VALUES (2024, 1, 1, 25),
       (2024, 2, 2, 18);
