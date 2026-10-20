/*
Purpose
-------
Validate the Good Loan / Bad Loan grouping used in Power BI.

Good Loan: Fully Paid or Current.
Bad Loan:  Charged Off.

Unrecognized statuses are reported as Unclassified rather than
silently treated as bad loans.
*/

WITH Classified AS
(
    SELECT
        id,
        loan_amount,
        total_payment,
        CASE
            WHEN loan_status IN ('Fully Paid', 'Current')
                THEN 'Good Loan'
            WHEN loan_status = 'Charged Off'
                THEN 'Bad Loan'
            ELSE 'Unclassified'
        END AS loan_category
    FROM dbo.bank_loan_c_data
),
AllApplications AS
(
    SELECT COUNT(id) AS total_loan_applications
    FROM Classified
)
SELECT
    c.loan_category,
    COUNT(c.id) AS loan_applications,
    SUM(c.loan_amount) AS funded_amount,
    SUM(c.total_payment) AS amount_received,
    CAST(
        100.0 * COUNT(c.id)
        / NULLIF(MAX(a.total_loan_applications), 0)
        AS decimal(9, 2)
    ) AS application_share_pct
FROM Classified AS c
CROSS JOIN AllApplications AS a
GROUP BY c.loan_category
ORDER BY
    CASE c.loan_category
        WHEN 'Good Loan' THEN 1
        WHEN 'Bad Loan' THEN 2
        ELSE 3
    END;
