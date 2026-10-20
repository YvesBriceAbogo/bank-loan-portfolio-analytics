-- =========================================================================
-- Script: 03_loan_status_summary.sql
-- Purpose: Aggregates metrics by loan status (Overall and MTD)
-- =========================================================================

DECLARE @CurrentMonth INT = 12; -- Adjust as needed

-- 1. Overall Summary by Status
SELECT
    loan_status,
    COUNT(id) AS LoanCount,
    SUM(total_payment) AS Total_Amount_Received,
    SUM(loan_amount) AS Total_Funded_Amount,
    AVG(int_rate) * 100 AS Interest_Rate,
    AVG(dti) * 100 AS DTI
FROM dbo.bank_loan_c_data
GROUP BY loan_status;

-- 2. MTD Summary by Status
SELECT 
    loan_status, 
    SUM(total_payment) AS MTD_Total_Amount_Received, 
    SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM dbo.bank_loan_c_data
WHERE MONTH(issue_date) = @CurrentMonth
GROUP BY loan_status;
