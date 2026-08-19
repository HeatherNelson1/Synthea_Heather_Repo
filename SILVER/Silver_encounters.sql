%sql
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