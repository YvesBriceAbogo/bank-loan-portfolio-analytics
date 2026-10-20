# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-05-18

### Added
- **SQL Server Validation Suite (`sql/`):**
  - `01_kpi_validation.sql`: Dynamic date-anchored reconciliation of Total, MTD, PMTD, and MoM KPIs.
  - `02_good_vs_bad_loans.sql`: Verification of Good Loan (`Fully Paid`, `Current`) and Bad Loan (`Charged Off`) counts, percentages, funded amounts, and amounts received.
  - `03_loan_status_summary.sql`: Portfolio and MTD breakdown by `loan_status`.
- **Power Query ETL Scripts (`power-query/`):**
  - `bank_loan_c_data.pq`: Parameterized SQL Server extraction (`ServerName`, `DatabaseName`).
  - `date_table.pq`: Continuous calendar dimension generated dynamically from `issue_date`.
- **DAX Measures & Field Parameter (`dax/`):**
  - Complete measure definitions (`measures.dax`) using `DIVIDE()`, `TOTALMTD()`, and date-safe PMTD calculations.
  - Documentation of the `Selected Measure` field parameter (`field_parameter.md`).
- **Project Documentation (`docs/`):**
  - Complete field-level Data Dictionary (`data_dictionary.md`) with banking use cases.
  - Semantic Model architecture and grouping documentation (`data_model.md`).
  - Power BI Service publication and Standard On-Premises Data Gateway guide (`deployment_gateway.md`).
  - Dashboard screenshots (`docs/images/`) for the **Summary**, **Overview**, and **Details** pages.
