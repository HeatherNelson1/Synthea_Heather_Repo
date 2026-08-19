 %sql
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
