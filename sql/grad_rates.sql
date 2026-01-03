-- Graduation Rates vs SAT (seed data)
-- Compatible with SQLite (also works in PostgreSQL with small tweaks)
DROP TABLE IF EXISTS colleges;
CREATE TABLE colleges (
  college_id     INTEGER PRIMARY KEY AUTOINCREMENT,
  college_name   TEXT NOT NULL,
  state          TEXT,
  sector         TEXT NOT NULL CHECK (sector IN ('Public','Private')),
  graduation_rate REAL NOT NULL,       -- percent
  sat_total      INTEGER NOT NULL,     -- Math + Verbal
  sat_imputed    INTEGER NOT NULL DEFAULT 0 CHECK (sat_imputed IN (0,1))
);
BEGIN TRANSACTION;
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Angelo State University', 'TX', 'Public', 34.0, 950, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('California State Univ. at Long Beach', 'CA', 'Public', 48.0, 838, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('College of William and Mary', 'VA', 'Public', 93.0, 1240, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('CUNY-Brooklyn College', 'NY', 'Public', 43.0, 916, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('East Carolina University', 'NC', 'Public', 58.0, 921, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Illinois State University', 'IL', 'Public', 54.0, 961, 1);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Metropolitan State College', 'CO', 'Public', 25.0, 855, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Montana State University', 'MT', 'Public', 37.0, 960, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('North Adams State College', 'MA', 'Public', 57.0, 897, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Oakland University', 'MI', 'Public', 53.0, 996, 1);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Ramapo College of New Jersey', 'NJ', 'Public', 47.0, 970, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('United States Military Academy', 'NY', 'Public', 95.0, 1211, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('University of Missouri at Rolla', 'MO', 'Public', 49.0, 1202, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('University of North Florida', 'FL', 'Public', 47.0, 1017, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('University of Southwestern Louisiana', 'LA', 'Public', 30.0, 855, 1);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('University of Wisconsin at Milwaukee', 'WI', 'Public', 38.0, 961, 1);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Weber State University', 'UT', 'Public', 38.0, 925, 1);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('West Virginia University', 'WV', 'Public', 57.0, 946, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Western New Mexico University', 'NM', 'Public', 47.0, 785, 1);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Wichita State University', 'KS', 'Public', 32.0, 926, 1);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Adrian College', 'MI', 'Private', 54.0, 961, 1);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Bennett College', 'NC', 'Private', 44.0, 780, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Boston University', 'MA', 'Private', 72.0, 1150, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('California Institute of Technology', 'CA', 'Private', 83.0, 1410, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Centre College', 'KY', 'Private', 74.0, 1109, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Coker College', 'SC', 'Private', 75.0, 900, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Cornell College', 'IA', 'Private', 64.0, 1070, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('David Lipscomb University', 'TN', 'Private', 73.0, 980, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Emory & Henry College', 'VA', 'Private', 82.0, 930, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Grove City College', 'PA', 'Private', 100.0, 1144, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Hillsdale College', 'MI', 'Private', 79.0, 1070, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Immaculata College', 'PA', 'Private', 69.0, 850, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('John Brown University', 'AR', 'Private', 75.0, 993, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('LeTourneau University', 'TX', 'Private', 56.0, 1043, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Loyola University', 'LA', 'Private', 53.0, 1050, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Mary Baldwin College', 'VA', 'Private', 90.0, 929, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Molloy College', 'NY', 'Private', 80.0, 903, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Mount St. Mary''s College', 'CA', 'Private', 72.0, 972, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Phillips University', 'OK', 'Private', 39.0, 888, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Rose-Hulman Institute of Technology', 'IN', 'Private', 97.0, 1210, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Seton Hall University', 'NJ', 'Private', 64.0, 939, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Spring Hill College', 'AL', 'Private', 70.0, 1005, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Swarthmore College', 'PA', 'Private', 95.0, 1302, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Thiel College', 'PA', 'Private', 60.0, 862, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('Union College', 'NY', 'Private', 88.0, 1171, 1);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('University of Dallas', 'TX', 'Private', 63.0, 1143, 0);
INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) VALUES ('University of Notre Dame', 'IN', 'Private', 97.0, 1220, 0);
COMMIT;

-- Example sanity checks
-- SELECT sector, COUNT(*) AS n FROM colleges GROUP BY sector;
-- SELECT sector, AVG(graduation_rate) AS avg_grad, AVG(sat_total) AS avg_sat FROM colleges GROUP BY sector;
-- SELECT * FROM colleges WHERE sat_imputed = 1;