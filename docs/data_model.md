# Semantic Model & Architecture

This document describes the structure of the Power BI semantic model, its relationships, grouping logic, and design conventions.

---

## 1. Model Overview

The semantic model follows a star-schema pattern centered on a single loan-level fact table connected to a calendar dimension, complemented by a disconnected field-parameter table for dynamic visual switching.

```text
+-----------------------+          1 : * (Single)          +-----------------------------+
|      Date Table       | -------------------------------> |      bank_loan_c_data       |
|-----------------------|   'Date Table'[Date]             |-----------------------------|
| PK  Date              |   = bank_loan_c_data[issue_date] | PK  id                      |
|     Year              |                                  | FK  issue_date              |
|     Month Number      |                                  |     loan_status             |
|     Month (mmm)       |                                  |     Good Loan Vs Bad Loan   |
|     Year-Month        |                                  |     address_state           |
+-----------------------+                                  |     grade / sub_grade       |
                                                           |     purpose / term          |
+-----------------------+                                  |     emp_length / emp_title  |
|   Selected Measure    |   (Disconnected Field Parameter) |     home_ownership          |
|-----------------------|                                  |     loan_amount             |
|     Selected Measure  |                                  |     total_payment           |
|     Measure Fields    |                                  |     int_rate / dti          |
|     Measure Order     |                                  |     installment             |
+-----------------------+                                  +-----------------------------+
