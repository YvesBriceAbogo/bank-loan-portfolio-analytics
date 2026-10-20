# Bank Loan Portfolio Analysis | Power BI & SQL Server

A three-page Power BI report for exploring loan applications, funding, amounts received, interest rates, debt-to-income ratios, and loan-status performance. The project combines SQL Server validation, Power Query data preparation, DAX measures, and deployment to Power BI Service through a standard on-premises data gateway.

**Author:** [Brice Abogo](https://www.linkedin.com/in/brice-abogo/)

## Report pages

| Page | Purpose |
|------|---------|
| Summary | Portfolio KPIs, good-versus-bad loan indicators, and a loan-status breakdown |
| Overview | Breakdowns by issue month, state, loan term, employment length, purpose, and home ownership |
| Details | Loan-level exploration within the report |

The report has been published to Power BI Service using an on-premises data gateway. No public report URL is provided here.

## Reported portfolio snapshot

The unfiltered report supplied for this project displays:

| Metric | Reported value |
|--------|---------------:|
| Loan applications | 38,576 |
| Total funded amount | $435,757,075 |
| Total amount received | $473,070,933 |
| Average interest rate | 12.05% |
| Average debt-to-income ratio | 13.33% |
| Good loan applications | 33,243 (approximately 86.2%) |
| Bad loan applications | 5,333 (approximately 13.8%) |

These are **reported dashboard values**, not a claim that the SQL scripts were executed by a visitor to this repository. Results will change with the source data, date context, and report filters.

## Metric definitions

- **Loan applications:** count of non-blank loan IDs.
- **Funded amount:** sum of `loan_amount`.
- **Amount received:** sum of `total_payment`.
- **Average interest rate and DTI:** arithmetic averages of the underlying fractional values, displayed as percentages.
- **Good loan:** `loan_status` is `Fully Paid` or `Current`.
- **Bad loan:** `loan_status` is `Charged Off`.
- **MTD:** from the first day of the reference month through the reference date.
- **PMTD:** from the first day of the preceding month through its corresponding day, capped at that month's final day.
- **MoM:** `(MTD - PMTD) / PMTD`; undefined when the PMTD denominator is zero.

The good/bad classification is based on **loan status**, not on whether an individual loan's amount received exceeds its funded amount. For the displayed portfolio, good loans happen to have a higher *aggregate* amount received than aggregate funding; this observation is not the classification rule.

Amounts received are analyzed against **loan issue dates** in this model. Consequently, an “amount received by month” chart is **not** a payment-transaction-date cash-flow statement. The difference between amounts received and funded should not be described as accounting profit.

## Data flow

1. A CSV dataset is loaded into SQL Server as `dbo.bank_loan_c_data`.
2. Power Query loads the loan table and builds a date dimension.
3. The semantic model relates `Date Table[Date]` to `bank_loan_c_data[issue_date]`.
4. A Power BI group classifies the three observed loan statuses.
5. DAX measures calculate the report indicators.
6. SQL queries independently reconcile the dashboard totals and breakdowns.
7. The report is published to Power BI Service using an on-premises data gateway.

## Repository contents

| Path | Description |
|------|-------------|
| [`sql/`](sql/) | SQL Server KPI and status-validation queries |
| [`power-query/`](power-query/) | Improved Power Query (M) reference implementations |
| [`dax/`](dax/) | DAX measure definitions and field-parameter documentation |
| [`docs/`](docs/) | Project documentation |
| [`data/`](data/) | Data-source notes; no raw dataset is distributed |

**Implementation status:** The SQL, Power Query, and DAX files document improved reference implementations. Committing these files does not change the existing Power BI Desktop file or the version published in Power BI Service. They must be integrated into the model and reconciled against the SQL results before they can be described as deployed code.

## Reproduction prerequisites

- Power BI Desktop.
- SQL Server and access to a properly licensed copy of the source dataset.
- Permission to connect to and refresh the SQL Server database.

Import the CSV into `dbo.bank_loan_c_data`, review SQL data types, and verify the expected row count for this report snapshot. In Power BI Desktop, the reference Power Query code requires text parameters named `ServerName` and `DatabaseName`. The date query must be loaded as a continuous date table and marked as the model's date table. Check the active relationship on `issue_date` before evaluating the time-intelligence measures.

Run the scripts in [`sql/`](sql/) with the project database selected in SQL Server Management Studio. Compare **unfiltered, like-for-like** SQL results with the corresponding Power BI visuals; then repeat selected checks under report filters.

## Data provenance and redistribution

The author describes the online CSV as fictitious, but its original source and redistribution license have not yet been identified. The dataset is **not included** in this repository. Until its rights are verified, the CSV, any PBIX containing imported records, and exports showing loan-level data should not be publicly distributed.

The repository's MIT license covers the original code and documentation contributed here; it does **not** grant rights to any third-party dataset.

## Contact

[Brice Abogo on LinkedIn](https://www.linkedin.com/in/brice-abogo/)
