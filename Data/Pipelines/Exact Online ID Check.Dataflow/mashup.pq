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

shared fnIds = (TableName as text) =>
let
    DivisionCodes = Table.Column(Administratie, "Code"),
    PerDivision = List.Transform(DivisionCodes, (code) =>
        Table.SelectColumns(fnGetExactOnlineTable(TableName, (row) => row[Division] = code), {"ID", "Division"})),
    Combined = Table.Combine(PerDivision),
    Typed = Table.TransformColumnTypes(Combined, {{"ID", type text}, {"Division", Int64.Type}})
in
    Typed;

shared fnProbe = (TableName as text) =>
let
    DivisionCodes = Table.Column(Administratie, "Code"),
    PerDivision = List.Transform(DivisionCodes, (code) =>
        Table.SelectColumns(fnGetExactOnlineTable(TableName, (row) => row[Division] = code), {"ID", "Division", "sysmodified", "syscreated"}, MissingField.UseNull)),
    Combined = Table.Combine(PerDivision),
    Typed = Table.TransformColumnTypes(Combined, {{"ID", type text}, {"Division", Int64.Type}, {"sysmodified", type datetime}, {"syscreated", type datetime}})
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

[BindToDefaultDestination = true]
shared SalesOrders_Ids = fnIds("SalesOrderHeaders");

[BindToDefaultDestination = true]
shared SalesOrderLines_Ids = fnIds("SalesOrderLines");

[BindToDefaultDestination = true]
shared SalesTransactions_Ids = fnIds("SalesTransactions");

[BindToDefaultDestination = true]
shared PurchaseOrders_Ids = fnIds("PurchaseOrders");

[BindToDefaultDestination = true]
shared PurchaseTransactions_Ids = fnIds("PurchaseTransactions");

[BindToDefaultDestination = true]
shared StockPlanning_Ids = fnIds("StockPlanning");

[BindToDefaultDestination = true]
shared StockCounts_Ids = fnIds("StockCounts");

[BindToDefaultDestination = true]
shared StockEntries_Ids = fnIds("StockEntries");

[BindToDefaultDestination = true]
shared StockTransactions_Ids = fnIds("StockTransactions");

[BindToDefaultDestination = true]
shared ShopOrderMaterialPlans_Ids = fnIds("ShopOrderMaterialPlans");

[BindToDefaultDestination = true]
shared ShopOrderRoutingStepPlans_Ids = fnIds("ShopOrderRoutingStepPlans");

[BindToDefaultDestination = true]
shared StockTransactions_Probe = fnProbe("StockTransactions");

[BindToDefaultDestination = true]
shared PurchaseTransactions_Probe = fnProbe("PurchaseTransactions");

[BindToDefaultDestination = true]
shared PurchaseTransactions_Unf = Table.SelectColumns(fnGetExactOnlineTable("PurchaseTransactions"), {"ID", "Division"}, MissingField.UseNull);

[BindToDefaultDestination = true]
shared StockTransactions_Unf = Table.SelectColumns(fnGetExactOnlineTable("StockTransactions"), {"ID", "Division"}, MissingField.UseNull);
