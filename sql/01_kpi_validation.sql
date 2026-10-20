/*
Purpose
-------
Reconcile the report's total, month-to-date (MTD), previous
month-to-date (PMTD), and month-over-month (MoM) KPIs.

The reference date is the latest issue_date in the source table.
PMTD covers the previous month from its first day through the
corresponding reference day, capped at the previous month's end.

Amounts retain their source currency units. Interest and DTI
columns ending in _pct are on a 0–100 scale; MoM columns ending
in _ratio are on a 0–1 scale.
*/

DECLARE @AsOfDate date =
(
    SELECT CAST(MAX(issue_date) AS date)
    FROM dbo.bank_loan_c_data
);

IF @AsOfDate IS NULL
    THROW 50001, 'No non-null issue_date is available.', 1;

DECLARE @MTDStart date =
    DATEFROMPARTS(YEAR(@AsOfDate), MONTH(@AsOfDate), 1);

DECLARE @MTDEndExclusive date =
    DATEADD(day, 1, @AsOfDate);

DECLARE @PMTDStart date =
    DATEADD(month, -1, @MTDStart);

DECLARE @PMTDEndExclusive date =
    DATEADD(day, 1, DATEADD(month, -1, @AsOfDate));

WITH Metrics AS
(
    SELECT
        COUNT(id) AS total_loan_applications,
        SUM(loan_amount) AS total_funded_amount,
        SUM(total_payment) AS total_amount_received,
        100.0 * AVG(CAST(int_rate AS decimal(19, 8)))
            AS average_interest_rate_pct,
        100.0 * AVG(CAST(dti AS decimal(19, 8)))
            AS average_dti_pct,

        COUNT(CASE
            WHEN issue_date >= @MTDStart
             AND issue_date < @MTDEndExclusive
            THEN id
        END) AS mtd_loan_applications,

        SUM(CASE
            WHEN issue_date >= @MTDStart
             AND issue_date < @MTDEndExclusive
            THEN loan_amount
        END) AS mtd_funded_amount,

        SUM(CASE
            WHEN issue_date >= @MTDStart
             AND issue_date < @MTDEndExclusive
            THEN total_payment
        END) AS mtd_amount_received,

        100.0 * AVG(CASE
            WHEN issue_date >= @MTDStart
             AND issue_date < @MTDEndExclusive
            THEN CAST(int_rate AS decimal(19, 8))
        END) AS mtd_average_interest_rate_pct,

        100.0 * AVG(CASE
            WHEN issue_date >= @MTDStart
             AND issue_date < @MTDEndExclusive
            THEN CAST(dti AS decimal(19, 8))
        END) AS mtd_average_dti_pct,

        COUNT(CASE
            WHEN issue_date >= @PMTDStart
             AND issue_date < @PMTDEndExclusive
            THEN id
        END) AS pmtd_loan_applications,

        SUM(CASE
            WHEN issue_date >= @PMTDStart
             AND issue_date < @PMTDEndExclusive
            THEN loan_amount
        END) AS pmtd_funded_amount,

        SUM(CASE
            WHEN issue_date >= @PMTDStart
             AND issue_date < @PMTDEndExclusive
            THEN total_payment
        END) AS pmtd_amount_received,

        100.0 * AVG(CASE
            WHEN issue_date >= @PMTDStart
             AND issue_date < @PMTDEndExclusive
            THEN CAST(int_rate AS decimal(19, 8))
        END) AS pmtd_average_interest_rate_pct,

        100.0 * AVG(CASE
            WHEN issue_date >= @PMTDStart
             AND issue_date < @PMTDEndExclusive
            THEN CAST(dti AS decimal(19, 8))
        END) AS pmtd_average_dti_pct
    FROM dbo.bank_loan_c_data
)
SELECT
    m.*,

    1.0 * (m.mtd_loan_applications - m.pmtd_loan_applications)
        / NULLIF(m.pmtd_loan_applications, 0)
        AS mom_loan_applications_ratio,

    1.0 * (m.mtd_funded_amount - m.pmtd_funded_amount)
        / NULLIF(m.pmtd_funded_amount, 0)
        AS mom_funded_amount_ratio,

    1.0 * (m.mtd_amount_received - m.pmtd_amount_received)
        / NULLIF(m.pmtd_amount_received, 0)
        AS mom_amount_received_ratio,

    1.0 * (
        m.mtd_average_interest_rate_pct
        - m.pmtd_average_interest_rate_pct
    ) / NULLIF(m.pmtd_average_interest_rate_pct, 0)
        AS mom_interest_rate_ratio,

    1.0 * (m.mtd_average_dti_pct - m.pmtd_average_dti_pct)
        / NULLIF(m.pmtd_average_dti_pct, 0)
        AS mom_dti_ratio
FROM Metrics AS m;
