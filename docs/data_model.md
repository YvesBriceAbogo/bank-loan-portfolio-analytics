# Semantic Model & Architecture

This document describes the structure of the Power BI semantic model, its relationships, grouping logic, and design conventions.

---

## 1. Model Overview

The semantic model follows a star-schema pattern centered on a single loan-level fact table connected to a calendar dimension, complemented by a disconnected field-parameter table for dynamic visual switching.

![Power BI Data Model](images/04_data_model.jpg)

---

## 2. Tables

### 2.1 `bank_loan_c_data` (Fact Table)
- **Grain:** One row per loan application (`id`).
- **Row Count (Report Snapshot):** 38,576 rows.
- **Source:** SQL Server table `dbo.bank_loan_c_data`.
- **Role:** Stores borrower attributes, contract terms, origination dates, and financial measures (`loan_amount`, `total_payment`, `int_rate`, `dti`, `installment`).

### 2.2 `Date Table` (Date Dimension)
- **Grain:** One row per calendar day.
- **Role:** Marked as the model's official Date Table to support DAX time-intelligence functions (`TOTALMTD`, `DATESMTD`, `DATEADD`, `EOMONTH`, `EDATE`).
- **Columns:**
  - `Date` (Date, Primary Key)
  - `Month` (`FORMAT('Date Table'[Date], "mmm")`)
  - `Year`, `Month Number`, `Year-Month` (included in the reference Power Query script so that `Month` can be sorted chronologically by `Month Number`).

### 2.3 `Selected Measure` (Field Parameter Table)
- **Role:** Disconnected parameter table used on the **Overview** and **Details** pages to let users dynamically switch visuals between:
  - `0` — `Total Amount Received`
  - `1` — `Total Funded Amount`
  - `2` — `Total Loan Applications`
- **Note on Naming:** In the initial PBIX build, this table was created with the spelling `Seledcted Measure`. See [`dax/field_parameter.md`](../dax/field_parameter.md) for details.

---

## 3. Relationships

| From Table (Many `*`) | From Column | To Table (One `1`) | To Column | Cardinality | Cross-Filter Direction | Active |
|---|---|---|---|---|---|---|
| `bank_loan_c_data` | `issue_date` | `Date Table` | `Date` | Many-to-One (`*:1`) | Single (`Date Table` filters `bank_loan_c_data`) | Yes |

**Analytical implication:** Because `Date Table[Date]` filters `bank_loan_c_data[issue_date]`, all time-based breakdowns (including `Total Amount Received By Month` and `MTD Amount Received`) group cash collections by the **loan origination month**, not by the historical payment transaction date.

---

## 4. Good Loan vs. Bad Loan Classification

In Power BI Desktop, `Good Loan Vs Bad Loan` is implemented as a native **Power BI Data Group** (`Group type: List`) on `bank_loan_c_data[loan_status]`:

![Good Loan vs Bad Loan Group](images/05_loan_status_group.jpg)

| Group Name | Included `loan_status` Members | Business Interpretation |
|---|---|---|
| **Good Loan** | `Current`, `Fully Paid` | Performing loans (either paid off in full or servicing on schedule). |
| **Bad Loan** | `Charged Off` | Defaulted loans where the lender has written off the remaining balance. |

For environments where a DAX calculated column is preferred over a UI group, the exact equivalent is:

```dax
Good Loan Vs Bad Loan =
SWITCH (
    bank_loan_c_data[loan_status],
    "Fully Paid", "Good Loan",
    "Current", "Good Loan",
    "Charged Off", "Bad Loan",
    "Unclassified"
)
