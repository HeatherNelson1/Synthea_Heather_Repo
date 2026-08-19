# Synthea_Heather_Repo
Bronze layer: raw Synthea CSV exports loaded directly into Databricks (no transformation)
Learning Databricks with Synthea
# Synthetic Healthcare Data Pipeline (Databricks + Delta Lake)

## Overview
A bronze/silver/gold data pipeline built on Databricks Free Edition, 
using Synthea-generated synthetic patient data to model a real 
healthcare data engineering workflow.

## Architecture
- **Bronze**: Raw Synthea CSV exports (patients, encounters, conditions) 
  loaded as-is
- **Silver**: Cleaned, joined, and validated tables — enforced 
  referential integrity between patients/encounters/conditions
- **Gold**: Aggregated utilization metrics — average encounters per 
  patient by condition

## Key data quality decisions
- Inner joins used at the silver layer to drop orphaned encounters/
  conditions rather than silently keeping bad rows


## Tools
Databricks Free Edition, Delta Lake, PySpark, Spark SQL, Synthea 
synthetic data generator

## Gold Layer: Encounter Risk Stratification

**Table:** `gold_encounter_complexity`

This table aggregates encounter, patient, and condition data into an encounter-grained view designed to mirror a CDI-style complexity assessment — surfacing how much clinical burden is documented per encounter.

**Grain:** One row per encounter (`encounter_id`)

**Key logic:**
- `condition_count` — distinct diagnosis codes associated with the encounter
- `condition_list` — array of condition descriptions, for quick review without a separate join
- `length_of_stay_days` — computed from encounter start/stop
- `complexity_tier` — a simple heuristic bucketing encounters by condition burden:
  - **High**: 5+ distinct conditions
  - **Moderate**: 2–4 distinct conditions
  - **Low**: 0–1 conditions

**Why this matters:** In clinical documentation integrity work, the volume and specificity of coded conditions per encounter is a proxy for how well documentation reflects a patient's actual complexity. This table makes it possible to quickly identify encounters that may be under-documented relative to their apparent burden — a common CDI review target.

**Source tables:** `silver_encounters`, `silver_patients`, `silver_conditions`

**Possible extensions:** tier thresholds could be refined using clinically weighted condition groupings (e.g. chronic vs. acute, or specific comorbidity combinations like diabetes + CKD) rather than a raw distinct count.