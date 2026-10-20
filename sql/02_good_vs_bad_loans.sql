-- =========================================================================
-- Script: 02_good_vs_bad_loans.sql
-- Purpose: Validates Good vs. Bad Loan metrics based on loan_status
-- =========================================================================

-- 1. Good Loan Percentage
SELECT
    (COUNT(CASE WHEN loan_status IN ('Fully Paid', 'Current') THEN id END) * 100.0) / 
    COUNT(id) AS Good_Loan_Percentage
FROM dbo.bank_loan_c_data;

-- 2. Good Loan Applications
SELECT COUNT(id) AS Good_Loan_Applications 
FROM dbo.bank_loan_c_data
WHERE loan_status IN ('Fully Paid', 'Current');

-- 3. Good Loan Funded Amount
SELECT SUM(loan_amount) AS Good_Loan_Funded_Amount 
FROM dbo.bank_loan_c_data
WHERE loan_status IN ('Fully Paid', 'Current');

-- 4. Bad Loan Percentage
SELECT
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / 
    COUNT(id) AS Bad_Loan_Percentage
FROM dbo.bank_loan_c_data;

-- 5. Bad Loan Applications
SELECT COUNT(id) AS Bad_Loan_Applications 
FROM dbo.bank_loan_c_data
WHERE loan_status = 'Charged Off';

-- 6. Bad Loan Funded Amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_Amount 
FROM dbo.bank_loan_c_data
WHERE loan_status = 'Charged Off';
