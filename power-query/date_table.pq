let
    // Generate a continuous date range based on the fact table
    Source = Sql.Database("Localhost", "Bank Loan DB"),
    FactTable = Source{[Schema="dbo", Item="bank_loan_c_data"]}[Data],
    
    // Get Min and Max dates
    MinDate = List.Min(FactTable[issue_date]),
    MaxDate = List.Max(FactTable[issue_date]),
    
    // Generate continuous list of dates
    DateList = List.Dates(MinDate, Duration.Days(MaxDate - MinDate) + 1, #duration(1, 0, 0, 0)),
    DateTable = Table.FromList(DateList, Splitter.SplitByNothing(), {"Date"}, null, ExtraValues.Error),
    
    // Add columns
    #"Changed Type" = Table.TransformColumnTypes(DateTable, {{"Date", type date}}),
    #"Added Month Name" = Table.AddColumn(#"Changed Type", "Month Name", each Date.MonthName([Date]), type text),
    #"Added Year" = Table.AddColumn(#"Added Month Name", "Year", each Date.Year([Date]), Int64.Type),
    #"Added Month Number" = Table.AddColumn(#"Added Year", "Month Number", each Date.Month([Date]), Int64.Type)
in
    #"Added Month Number"
