# Synthea_Heather_Repo
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
- [any other judgment calls you made]

## Tools
Databricks Free Edition, Delta Lake, PySpark, Spark SQL, Synthea 
synthetic data generator

## Sample output
[screenshot of your visualization here]