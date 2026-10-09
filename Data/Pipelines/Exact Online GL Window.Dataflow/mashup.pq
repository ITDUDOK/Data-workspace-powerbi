[DefaultOutputDestinationSettings = [DestinationDefinition = [Kind = "Reference", QueryName = "DefaultDestination", IsNewTarget = true], UpdateMethod = [Kind = "Replace"], DestinationTypeSettings = [Kind = "Table"]], StagingDefinition = [Kind = "FastCopy"]]
section Section1;

[BindToDefaultDestination = true]
shared Administratie = let
    Div = fnGetExactOnlineTable("Divisions"),

    Step1_Status = Table.SelectRows(Div, each [Status] = 0),
    Step2_Dudok = Table.SelectRows(Step1_Status, each Text.StartsWith([Description], "Dudok")),
    Step3_NoTest = Table.SelectRows(Step2_Dudok, each not Text.Contains([Description], "TEST")),
    Step4_NoHolding = Table.SelectRows(Step3_NoTest, each not Text.Contains([Description], "Holding")),
    #"Rijen gefilterd" = Table.SelectRows(Step4_NoHolding, each ([Deleted] = null))
in
    #"Rijen gefilterd";

[BindToDefaultDestination = true]
shared GLTransactions_Window = let
    Cutoff = DateTime.From(Date.AddDays(Date.From(DateTime.LocalNow()), -150)),
    DivisionCodes = Table.Column(Administratie, "Code"),
    PerDivisionTables = List.Transform(DivisionCodes, (code) =>
        Table.SelectColumns(
            fnGetExactOnlineTable("GLTransactions", (row) => row[Division] = code and row[EntryDate] >= Cutoff),
            {"ID", "Division", "EntryDate", "Status"})),
    Combined = Table.Combine(PerDivisionTables),
    Typed = Table.TransformColumnTypes(Combined, {{"ID", type text}, {"Division", Int64.Type}, {"EntryDate", type datetime}, {"Status", Int64.Type}})
in
    Typed;

shared fnGetExactOnlineTable = (TableName as text, optional FilterCondition as function) =>
let
    Source = ExactOnlinePremium.Contents(),
    dbo_Schema = Source{[Name="dbo", Kind="Schema"]}[Data],
    TableData = try dbo_Schema{[Name=TableName, Kind="View"]}[Data] otherwise dbo_Schema{[Name=TableName, Kind="Table"]}[Data],
    // Pas filter toe als meegegeven
    FilteredData = if FilterCondition <> null then Table.SelectRows(TableData, FilterCondition) else TableData
in
    FilteredData;

shared DefaultDestination = Lakehouse.Contents([EnableFolding = false]){[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data]{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data];
