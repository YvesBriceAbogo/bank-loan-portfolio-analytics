/*
Purpose
-------
Validate the loan-status table in the Summary page.

MTD is anchored to the latest issue_date in the source data.
Amounts received are grouped by issue_date; this is not a
payment-transaction-date cash-flow analysis.
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

SELECT
    loan_status,
    COUNT(id) AS loan_applications,
    SUM(loan_amount) AS total_funded_amount,
    SUM(total_payment) AS total_amount_received,

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

    100.0 * AVG(CAST(int_rate AS decimal(19, 8)))
        AS average_interest_rate_pct,

    100.0 * AVG(CAST(dti AS decimal(19, 8)))
        AS average_dti_pct
FROM dbo.bank_loan_c_data
GROUP BY loan_status
ORDER BY loan_status;
