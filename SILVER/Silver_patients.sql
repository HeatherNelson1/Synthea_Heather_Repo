%sql
--PATIENTS
CREATE OR REPLACE TABLE workspace.default.silver_patients AS
SELECT
  Id AS patient_id,
  BIRTHDATE AS birth_date,
  DEATHDATE AS death_date,
  GENDER AS gender,
  RACE AS race,
  ETHNICITY AS ethnicity,
  CITY AS city,
  STATE AS state
FROM workspace.default.bronze_patients
WHERE Id IS NOT NULL;

select * from workspace.default.bronze_patients;
select * from workspace.default.silver_patients;
