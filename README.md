# Data Dynamo: SQL Data Engineering & Integrity Audit

This project demonstrates an end-to-end data engineering pipeline for "Mystic Manuscripts," focusing on schema optimization, automated data cleaning, and integrity auditing using PostgreSQL.

## Project Goal
To transform raw, inconsistent CSV data into an analysis-ready dataset. The project addresses common data quality challenges including schema mismatches, boolean inconsistencies, and formatting errors.

## Architecture
The project utilizes a two-layer architecture to ensure data integrity:
1. **Prep Table:** Handles raw data ingestion.
2. **Final Table:** Stores transformed, analysis-ready data.



## Key Technical Skills
* **Schema Design:** Implemented a two-layer architecture (Prep Table -> Final Table) to manage data transitions.
* **Data Cleaning:** Automated the conversion of data types (VARCHAR to BOOL/TIMESTAMP) and cleaned text data (whitespace, casing).
* **Integrity Auditing:** Developed complex SQL queries to identify duplicates, calculation mismatches, and null value gaps.

## Repository Contents
- `/sql/01_schema_setup.sql`: DDL for table creation, initial ingestion, and type casting.
- `/sql/03_exploration.sql`: Analytical queries for data validation, duplicate checks, and integrity auditing.
- `/docs/Data_Dynamo_FROM.pdf`: Project report detailing data preparation and architectural decisions.

## How to use
The SQL scripts are designed to be run in sequence within a PostgreSQL environment. Please refer to the documentation in `/docs/` for the business context and data dictionary.
