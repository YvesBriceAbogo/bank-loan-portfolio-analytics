let
    // ServerName and DatabaseName are Power Query parameters
    // created in Power BI Desktop, not local variables.
    Source = Sql.Database(ServerName, DatabaseName),

    Loans =
        Source{
            [Schema = "dbo", Item = "bank_loan_c_data"]
        }[Data],

    // Preserve the numeric types supplied by SQL Server for
    // amounts, interest rates and DTI.
    TypedColumns =
        Table.TransformColumnTypes(
            Loans,
            {
                {"id", Int64.Type},
                {"issue_date", type date},
                {"loan_status", type text}
            }
        )
in
    TypedColumns
