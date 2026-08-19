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


--encounters
CREATE OR REPLACE TABLE workspace.default.silver_encounters AS
SELECT
  e.Id AS encounter_id,
  e.PATIENT AS patient_id,
  e.START AS encounter_start,
  e.STOP AS encounter_stop,
  e.ENCOUNTERCLASS AS encounter_class,
  e.DESCRIPTION AS encounter_description
FROM workspace.default.bronze_encounters e
INNER JOIN workspace.default.silver_patients p
  ON e.PATIENT = p.patient_id
WHERE e.Id IS NOT NULL
  AND e.START IS NOT NULL;

SELECT * FROM workspace.default.silver_encounters; -- LIMIT 5

  /*conditions*/
CREATE OR REPLACE TABLE workspace.default.silver_conditions AS
SELECT
  c.PATIENT AS patient_id,
  c.ENCOUNTER AS encounter_id,
  c.START AS condition_start,
  c.STOP AS condition_stop,
  c.DESCRIPTION AS condition_description,
  c.CODE AS condition_code
FROM workspace.default.bronze_conditions c
INNER JOIN workspace.default.silver_encounters e
  ON c.ENCOUNTER = e.encounter_id
WHERE c.PATIENT IS NOT NULL;

SELECT * FROM workspace.default.silver_conditions LIMIT 5;


/*gold encounter*/
/*one row per encounter, complexity score*/

CREATE OR REPLACE TABLE workspace.default.gold_encounter_complexity AS
SELECT
    e.encounter_id,
    e.patient_id,
    p.birth_date,
    e.encounter_class,
    e.encounter_description,
    e.encounter_start,
    e.encounter_stop,
    DATEDIFF(e.encounter_stop, e.encounter_start) AS length_of_stay_days,
    COUNT(DISTINCT c.condition_code) AS condition_count,
    /*conidtion count and complexity tier for risk stratification*/
    COLLECT_SET(c.condition_description) AS condition_list,
    CASE
        WHEN COUNT(DISTINCT c.condition_code) >= 5 THEN 'High'
        WHEN COUNT(DISTINCT c.condition_code) >= 2 THEN 'Moderate'
        ELSE 'Low'
    END AS complexity_tier
FROM workspace.default.silver_encounters e
LEFT JOIN workspace.default.silver_patients p
    ON e.patient_id = p.patient_id
LEFT JOIN workspace.default.silver_conditions c
    ON e.encounter_id = c.encounter_id
GROUP BY
    e.encounter_id, e.patient_id, p.birth_date,
    e.encounter_class, e.encounter_description,
    e.encounter_start, e.encounter_stop;

  SELECT * FROM workspace.default.gold_encounter_complexity;
  
 /*trival edit--testing git*/

