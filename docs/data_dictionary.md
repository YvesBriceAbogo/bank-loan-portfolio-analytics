# Data Dictionary — Bank Loan Portfolio

This document defines the fields stored in `dbo.bank_loan_c_data` and used across the SQL validation scripts, Power Query transformations, DAX measures, and Power BI visuals.

---

## 1. Summary Table

| SQL Column Name | Business Label | Data Type | Category | Description |
|---|---|---|---|---|
| `id` | Loan ID | Integer | Identifier | Unique primary key assigned to each loan application. |
| `address_state` | Address State | Text | Borrower | Two-letter US state code indicating the borrower's residence. |
| `application_type` | Application Type | Text | Application | Indicates whether the application is individual or joint. |
| `emp_length` | Employee Length | Text | Borrower | Length of continuous employment reported by the borrower. |
| `emp_title` | Employee Title | Text | Borrower | Borrower's occupation or employer title. |
| `grade` | Grade | Text | Credit Risk | High-level credit risk grade (`A` to `G`). |
| `sub_grade` | Sub Grade | Text | Credit Risk | Granular risk classification within a grade (e.g., `A1` to `G5`). |
| `home_ownership` | Home Ownership | Text | Borrower | Housing status (`MORTGAGE`, `RENT`, `OWN`, `OTHER`, `NONE`). |
| `issue_date` | Issue Date | Date | Timeline | Date on which the loan was funded/originated. |
| `last_credit_pull_date` | Last Credit Pull Date | Date | Timeline | Date of the most recent credit bureau inquiry. |
| `last_payment_date` | Last Payment Date | Date | Timeline | Date of the most recent repayment received. |
| `next_payment_date` | Next Payment Date | Date | Timeline | Scheduled date for the next installment payment. |
| `loan_status` | Loan Status | Text | Performance | Current state of the loan (`Fully Paid`, `Current`, `Charged Off`). |
| `purpose` | Purpose | Text | Application | Stated reason for borrowing (e.g., `Debt consolidation`, `credit card`). |
| `term` | Term | Text | Contract | Repayment duration (`36 months` or `60 months`). |
| `verification_status` | Verification Status | Text | Underwriting | Indicates whether borrower income was verified (`Verified`, `Source Verified`, `Not Verified`). |
| `annual_income` | Annual Income | Decimal / Currency | Financial | Self-reported or verified total annual income of the borrower. |
| `dti` | DTI (Debt-to-Income) | Decimal / Percentage | Credit Risk | Ratio of monthly debt obligations to monthly income. |
| `installment` | Installment | Decimal / Currency | Contract | Fixed monthly payment amount (principal plus interest). |
| `int_rate` | Interest Rate | Decimal / Percentage | Contract | Annual nominal interest rate charged on the loan. |
| `loan_amount` | Loan Amount | Integer / Currency | Financial | Total principal funded to the borrower. |
| `total_payment` | Total Amount Received | Integer / Currency | Performance | Cumulative principal and interest collected to date. |

---

## 2. Detailed Business Definitions & Banking Use Cases

### Loan ID (`id`)
- **Purpose:** Unique identifier assigned to each loan application or loan account. It serves as the primary key for tracking and managing individual loans.
- **Use for Banks:** Efficiently manage and track loans throughout their lifecycle, organize loan records, monitor repayments, and resolve customer or audit inquiries.

### Address State (`address_state`)
- **Purpose:** Indicates the borrower's geographic location. Helps assess regional macroeconomic risk factors, state regulatory compliance, and geographic default patterns.
- **Use for Banks:** Identify regional trends in loan demand, calibrate marketing strategies, and diversify credit risk across states.

### Application Type (`application_type`)
- **Purpose:** Specifies whether the loan application is submitted by a single borrower (`INDIVIDUAL`) or with a co-borrower (`JOINT`).
- **Use for Banks:** Evaluate combined repayment capacity and underwriting rules applicable to single versus joint obligors.

### Employee Length (`emp_length`)
- **Purpose:** Provides insight into the borrower's employment stability (`< 1 year`, `1 year`, ..., `10+ years`). Longer tenure generally signals stronger income continuity.
- **Use for Banks:** Assess repayment capacity and income durability during credit underwriting.

### Employee Title (`emp_title`)
- **Purpose:** Specifies the borrower's occupation or job title, giving context on the source and nature of the borrower's income.
- **Use for Banks:** Cross-check income plausibility, segment borrower profiles, and tailor credit products by occupational category.

### Grade (`grade`)
- **Purpose:** Risk classification (`A` through `G`) assigned to the loan based on creditworthiness. Higher grades (`A`) signify lower expected default risk.
- **Use for Banks:** Drive risk-based pricing, set capital reserves, and communicate portfolio quality to investors and credit committees.

### Sub Grade (`sub_grade`)
- **Purpose:** Refines the risk assessment within each letter grade (`1` to `5`), providing finer differentiation across borrower credit profiles.
- **Use for Banks:** Fine-tune interest rates and lending terms to match granular probability-of-default tiers.

### Home Ownership (`home_ownership`)
- **Purpose:** Indicates the borrower's housing status (`MORTGAGE`, `RENT`, `OWN`, etc.), offering insight into asset backing and financial stability.
- **Use for Banks:** Assess borrower stability and wealth indicators when estimating loss given default (LGD) and default probability.

### Issue Date (`issue_date`)
- **Purpose:** Marks the loan's origination date. Serves as the primary chronological anchor in the semantic model.
- **Use for Banks:** Track origination cohorts (vintages), calculate Month-to-Date (MTD) and Month-over-Month (MoM) origination volume, and monitor portfolio aging.

### Last Credit Pull Date (`last_credit_pull_date`)
- **Purpose:** Records when the borrower's credit report was most recently accessed.
- **Use for Banks:** Monitor ongoing creditworthiness, detect credit deterioration early, and support account-management reviews.

### Last Payment Date (`last_payment_date`)
- **Purpose:** Marks the most recent loan payment received from the borrower.
- **Use for Banks:** Track payment recency, identify early delinquency, and validate repayment activity.

### Loan Status (`loan_status`)
- **Purpose:** Indicates the current performance state of the loan (`Fully Paid`, `Current`, or `Charged Off`).
- **Use for Banks:** Monitor portfolio health, classify performing (**Good Loan**: `Fully Paid`, `Current`) versus non-performing (**Bad Loan**: `Charged Off`) exposures, and determine provisioning requirements.

### Next Payment Date (`next_payment_date`)
- **Purpose:** Estimates the scheduled date of the next loan installment.
- **Use for Banks:** Support short-term cash-flow forecasting and servicing schedules for active (`Current`) loans.

### Purpose (`purpose`)
- **Purpose:** Specifies the stated reason for the loan (e.g., `Debt consolidation`, `credit card`, `home improvement`, `small business`, `car`, `major purchase`).
- **Use for Banks:** Segment loan demand, analyze default rates by borrowing purpose, and align product terms with customer needs.

### Term (`term`)
- **Purpose:** Defines the contractual duration of the loan in months (`36 months` or `60 months`).
- **Use for Banks:** Structure amortization schedules, manage duration risk, and compare performance between medium- and long-term loans.

### Verification Status (`verification_status`)
- **Purpose:** Indicates whether the borrower's stated income and financial information have been verified by the lender.
- **Use for Banks:** Gauge data reliability, mitigate misrepresentation risk, and compare credit performance across verification tiers.

### Annual Income (`annual_income`)
- **Purpose:** Reflects the borrower's total yearly earnings.
- **Use for Banks:** Determine maximum loan eligibility, compute debt-to-income ratios, and evaluate overall repayment capacity.

### DTI — Debt-to-Income Ratio (`dti`)
- **Purpose:** Measures the borrower's existing monthly debt burden relative to monthly gross income.
- **Use for Banks:** Enforce underwriting debt-service ceilings and prevent borrower over-indebtedness.

### Installment (`installment`)
- **Purpose:** Fixed monthly payment amount required to amortize the loan (principal and interest) over its contractual term.
- **Use for Banks:** Structure repayment schedules and evaluate monthly payment affordability against borrower cash flow.

### Interest Rate (`int_rate`)
- **Purpose:** Annual nominal cost of borrowing expressed as a percentage of principal.
- **Use for Banks:** Price credit risk appropriately, preserve net interest margin, and compensate for expected credit losses.

### Loan Amount (`loan_amount`)
- **Purpose:** Total principal sum funded to the borrower at origination.
- **Use for Banks:** Measure gross credit exposure, track total funded volume across cohorts, and manage concentration limits.

### Total Amount Received (`total_payment`)
- **Purpose:** Cumulative cash collected from the borrower (principal repayments plus interest received).
- **Use for Banks:** Evaluate cash recovery, compare total collections against funded principal, and quantify recovery shortfalls on charged-off loans.
