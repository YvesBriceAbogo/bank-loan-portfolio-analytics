let
    // Reuse the existing fact query instead of opening a second,
    // independently configured SQL Server connection.
    Fact = bank_loan_c_data,

    IssueDates = List.RemoveNulls(Fact[issue_date]),

    FirstDate =
        if List.IsEmpty(IssueDates) then
            error "No non-null issue_date values are available."
        else
            Date.From(List.Min(IssueDates)),

    LastDate = Date.From(List.Max(IssueDates)),

    DayCount = Duration.Days(LastDate - FirstDate) + 1,

    ContinuousDates =
        List.Dates(
            FirstDate,
            DayCount,
            #duration(1, 0, 0, 0)
        ),

    Calendar =
        Table.FromColumns(
            {ContinuousDates},
            {"Date"}
        ),

    TypedCalendar =
        Table.TransformColumnTypes(
            Calendar,
            {{"Date", type date}}
        ),

    WithYear =
        Table.AddColumn(
            TypedCalendar,
            "Year",
            each Date.Year([Date]),
            Int64.Type
        ),

    WithMonthNumber =
        Table.AddColumn(
            WithYear,
            "Month Number",
            each Date.Month([Date]),
            Int64.Type
        ),

    WithYearMonth =
        Table.AddColumn(
            WithMonthNumber,
            "Year-Month",
            each Date.ToText([Date], "yyyy-MM", "en-US"),
            type text
        )
in
    WithYearMonth
