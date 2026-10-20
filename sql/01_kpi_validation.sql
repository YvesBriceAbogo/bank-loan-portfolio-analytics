-- =========================================================================
-- Script: 01_kpi_validation.sql
-- Purpose: Validates headline KPIs (Total, MTD, PMTD)
-- =========================================================================

DECLARE @ReferenceDate DATE = '2021-12-31'; -- Adjust to your data's max date
DECLARE @CurrentMonth INT = MONTH(@ReferenceDate);
DECLARE @PreviousMonth INT = MONTH(DATEADD(MONTH, -1, @ReferenceDate));
DECLARE @CurrentYear INT = YEAR(@ReferenceDate);

-- 1. Total Loan Applications
SELECT COUNT(id) AS Total_Applications 
FROM dbo.bank_loan_c_data;

-- 2. MTD Loan Applications
SELECT COUNT(id) AS MTD_Applications 
FROM dbo.bank_loan_c_data
WHERE MONTH(issue_date) = @CurrentMonth AND YEAR(issue_date) = @CurrentYear;

-- 3. PMTD Loan Applications
SELECT COUNT(id) AS PMTD_Applications 
FROM dbo.bank_loan_c_data
WHERE MONTH(issue_date) = @PreviousMonth AND YEAR(issue_date) = @CurrentYear;

-- 4. Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount 
FROM dbo.bank_loan_c_data;

-- 5. MTD Total Funded Amount
SELECT SUM(loan_amount) AS MTD_Funded_Amount 
FROM dbo.bank_loan_c_data
WHERE MONTH(issue_date) = @CurrentMonth AND YEAR(issue_date) = @CurrentYear;

-- 6. Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Received 
FROM dbo.bank_loan_c_data;

-- 7. Average Interest Rate
SELECT AVG(int_rate) * 100 AS Avg_Int_Rate 
FROM dbo.bank_loan_c_data;

-- 8. Average DTI
SELECT AVG(dti) * 100 AS Avg_DTI 
FROM dbo.bank_loan_c_data;
