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

