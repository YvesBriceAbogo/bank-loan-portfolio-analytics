let
    // Parameters for easy environment switching
    ServerName = "Localhost",
    DatabaseName = "Bank Loan DB",
    SchemaName = "dbo",
    TableName = "bank_loan_c_data",

    // Source connection
    Source = Sql.Database(ServerName, DatabaseName),
    dbo_bank_loan_c_data = Source{[Schema=SchemaName, Item=TableName]}[Data],
    
    // Type transformations (Best Practice: define types explicitly)
    #"Changed Type" = Table.TransformColumnTypes(dbo_bank_loan_c_data, {
        {"id", Int64.Type}, 
        {"issue_date", type date}, 
        {"loan_amount", Currency.Type}, 
        {"total_payment", Currency.Type}, 
        {"int_rate", Percentage.Type}, 
        {"dti", Percentage.Type},
        {"loan_status", type text}
    })
in
    #"Changed Type"
