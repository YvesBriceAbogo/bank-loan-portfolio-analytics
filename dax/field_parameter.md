# Selected Measure Field Parameter

The Overview and Details pages use a Power BI field parameter to switch between three measures.

| Order | Display label | Measure |
|------:|---------------|---------|
| 0 | Total Amount Received | `[Total Amount Received]` |
| 1 | Total Funded Amount | `[Total Funded Amount]` |
| 2 | Total Loan Applications | `[Total Loan Applications]` |

For reference, Power BI generates a table expression equivalent to:

```dax
Selected Measure = {
    (
        "Total Amount Received",
        NAMEOF ( 'bank_loan_c_data'[Total Amount Received] ),
        0
    ),
    (
        "Total Funded Amount",
        NAMEOF ( 'bank_loan_c_data'[Total Funded Amount] ),
        1
    ),
    (
        "Total Loan Applications",
        NAMEOF ( 'bank_loan_c_data'[Total Loan Applications] ),
        2
    )
}
```

Create or modify the parameter through **Power BI Desktop → Modeling → New parameter → Fields**. Do not paste the expression into **New measure**: a field parameter is a table with additional metadata managed by Power BI.

The existing report already contains this parameter. When integrating the reference DAX, confirm its actual table and column names before updating the dynamic title. The title measure reads the numeric order column rather than the display column.
