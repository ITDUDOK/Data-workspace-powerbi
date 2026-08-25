[DefaultOutputDestinationSettings = [DestinationDefinition = [Kind = "Reference", QueryName = "DefaultDestination", IsNewTarget = true], UpdateMethod = [Kind = "Replace"], DestinationTypeSettings = [Kind = "Table"]], StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[BindToDefaultDestination = true]
shared MRPScenarioLinkItems = let
    MRPScenarioLinkItems_Table = fnGetExactOnlineTable("MRPScenarioLinkItems"),
    #"Rijen gefilterd" = Table.SelectRows(MRPScenarioLinkItems_Table, each true)
in
    #"Rijen gefilterd";
[BindToDefaultDestination = true]
shared MRPScenarioLinkSalesForecasts = let
   MRPScenarioLinkSalesForecasts_Table = fnGetExactOnlineTable("MRPScenarioLinkSalesForecasts")
in
    MRPScenarioLinkSalesForecasts_Table;
[BindToDefaultDestination = true]
shared MRPScenarioLinkWarehouses = let
    MRPScenarioLinkWarehouses_Table = fnGetExactOnlineTable("MRPScenarioLinkWarehouses")
in
    MRPScenarioLinkWarehouses_Table;
[BindToDefaultDestination = true]
shared MRPScenarioOrderEntryApprovalStatus = let
    MRPScenarioOrderEntryApprovalStatus_Table = fnGetExactOnlineTable("MRPScenarioOrderEntryApprovalStatus")
in
    MRPScenarioOrderEntryApprovalStatus_Table;
[BindToDefaultDestination = true]
shared MRPScenarioReorderPolicies = let
    MRPScenarioReorderPolicies_Table = fnGetExactOnlineTable("MRPScenarioReorderPolicies")
in
    MRPScenarioReorderPolicies_Table;
[BindToDefaultDestination = true]
shared MRPScenarios = let
    MRPScenarios_Table = fnGetExactOnlineTable("MRPScenarios"),
    #"Kolommen verwijderd" = Table.RemoveColumns(MRPScenarios_Table,{"syscreator"})
in
    #"Kolommen verwijderd";
[BindToDefaultDestination = true]
shared MRPScenarioWarningTypes = let
    MRPScenarioWarningTypes_Table = fnGetExactOnlineTable("MRPScenarioWarningTypes")
in
    MRPScenarioWarningTypes_Table;
[BindToDefaultDestination = true]
shared PrognoseWeekTabel = let
    Today = DateTime.Date(DateTime.LocalNow()),
    Jan1 = #date(Date.Year(Today), 1, 1),
    WeekdayOf = (d as date) as number => Number.Mod(Date.DayOfWeek(d, Day.Sunday), 7) + 1,
    Jan1Weekday = WeekdayOf(Jan1),
    BaseWeekNr = Int64.From(Number.RoundUp((Date.DayOfYear(Today) + Jan1Weekday - 1) / 7)),
    TodayWeekday = WeekdayOf(Today),
    Values = {0..11},
    Base = Table.FromList(Values, Splitter.SplitByNothing(), {"Value"}),
    #"Changed Type" = Table.TransformColumnTypes(Base,{{"Value", Int64.Type}}),
    #"Added WeekNr" = Table.AddColumn(#"Changed Type", "WeekNr", each BaseWeekNr + [Value], Int64.Type),
    #"Added WeekLabel" = Table.AddColumn(#"Added WeekNr", "WeekLabel", each "Week " & Text.From([WeekNr]), type text),
    #"Added StartDatum" = Table.AddColumn(#"Added WeekLabel", "StartDatum", each DateTime.From(Date.AddDays(Today, [Value] * 7 - TodayWeekday + 2)), type datetime),
    #"Added EindDatum" = Table.AddColumn(#"Added StartDatum", "EindDatum", each DateTime.From(Date.AddDays(Today, [Value] * 7 - TodayWeekday + 8)), type datetime),
    #"Added Jaar" = Table.AddColumn(#"Added EindDatum", "Jaar", each Date.Year(Today), Int64.Type)
in
    #"Added Jaar";
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
