[DefaultOutputDestinationSettings = [DestinationDefinition = [Kind = "Reference", QueryName = "DefaultDestination", IsNewTarget = true], UpdateMethod = [Kind = "Replace"], DestinationTypeSettings = [Kind = "Table"]], StagingDefinition = [Kind = "FastCopy"]]

section Section1;

[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "StockCounts_DataDestination", IsNewTarget = false], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "ID", DestinationColumnName = "ID"], [SourceColumnName = "Division", DestinationColumnName = "Division"], [SourceColumnName = "EntryID", DestinationColumnName = "EntryID"], [SourceColumnName = "LineNumber", DestinationColumnName = "LineNumber"], [SourceColumnName = "Description", DestinationColumnName = "Description"], [SourceColumnName = "StockCountNumber", DestinationColumnName = "StockCountNumber"], [SourceColumnName = "Notes", DestinationColumnName = "Notes"], [SourceColumnName = "TransactionDate", DestinationColumnName = "TransactionDate"], [SourceColumnName = "Item", DestinationColumnName = "Item"], [SourceColumnName = "Quantity", DestinationColumnName = "Quantity"], [SourceColumnName = "NewQuantity", DestinationColumnName = "NewQuantity"], [SourceColumnName = "Unit", DestinationColumnName = "Unit"], [SourceColumnName = "CostPrice", DestinationColumnName = "CostPrice"], [SourceColumnName = "Warehouse", DestinationColumnName = "Warehouse"], [SourceColumnName = "GLAccount", DestinationColumnName = "GLAccount"], [SourceColumnName = "Status", DestinationColumnName = "Status"], [SourceColumnName = "Source", DestinationColumnName = "Source"], [SourceColumnName = "CopyEntryID", DestinationColumnName = "CopyEntryID"], [SourceColumnName = "syscreated", DestinationColumnName = "syscreated"], [SourceColumnName = "syscreator", DestinationColumnName = "syscreator"], [SourceColumnName = "sysmodified", DestinationColumnName = "sysmodified"], [SourceColumnName = "sysmodifier", DestinationColumnName = "sysmodifier"], [SourceColumnName = "StorageLocation", DestinationColumnName = "StorageLocation"], [SourceColumnName = "OrderByLocation", DestinationColumnName = "OrderByLocation"], [SourceColumnName = "CountedBy", DestinationColumnName = "CountedBy"], [SourceColumnName = "ReasonCodeID", DestinationColumnName = "ReasonCodeID"]}], DynamicSchema = false, UpdateMethod = [Kind = "Append"], TypeSettings = [Kind = "Table"]]]}]

shared StockCounts = let
    LH = Lakehouse.Contents(null),
    WS = LH{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],
    LHData = WS{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],
    Existing = try LHData{[Id = "StockCounts", ItemKind = "Table"]}[Data] otherwise #table({"sysmodified"}, {}),
    WM = List.Max(Existing[sysmodified]),
    SafeWM = if WM = null then #datetime(2020, 1, 1, 0, 0, 0) else WM,
 
    Source = fnGetExactOnlineTable("StockCounts"),
    Filtered = Table.SelectRows(Source, each true and [sysmodified] > SafeWM),

  #"Changed column type" = Table.TransformColumnTypes(Filtered, {{"OrderByLocation", type number}})
    
in
    #"Changed column type";

[BindToDefaultDestination = true]

shared StockCountSources = let
    StockCountSources_Table = fnGetExactOnlineTable("StockCountSources")
in
    StockCountSources_Table;

[BindToDefaultDestination = true]

shared StockCountStatus = let
    StockCountStatus_Table = fnGetExactOnlineTable("StockCountStatus")
in
    StockCountStatus_Table;

[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "StockEntries_DataDestination", IsNewTarget = false], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "ID", DestinationColumnName = "ID"], [SourceColumnName = "Division", DestinationColumnName = "Division"], [SourceColumnName = "StockEntryNumber", DestinationColumnName = "StockEntryNumber"], [SourceColumnName = "TrackingNumber", DestinationColumnName = "TrackingNumber"], [SourceColumnName = "Type", DestinationColumnName = "Type"], [SourceColumnName = "Warehouse", DestinationColumnName = "Warehouse"], [SourceColumnName = "EntryDate", DestinationColumnName = "EntryDate"], [SourceColumnName = "Account", DestinationColumnName = "Account"], [SourceColumnName = "Contact", DestinationColumnName = "Contact"], [SourceColumnName = "InvoiceAccount", DestinationColumnName = "InvoiceAccount"], [SourceColumnName = "InvoiceContact", DestinationColumnName = "InvoiceContact"], [SourceColumnName = "ShippingAddress", DestinationColumnName = "ShippingAddress"], [SourceColumnName = "ShippingMethod", DestinationColumnName = "ShippingMethod"], [SourceColumnName = "Document", DestinationColumnName = "Document"], [SourceColumnName = "EntryID", DestinationColumnName = "EntryID"], [SourceColumnName = "Notes", DestinationColumnName = "Notes"], [SourceColumnName = "Comment", DestinationColumnName = "Comment"], [SourceColumnName = "Status", DestinationColumnName = "Status"], [SourceColumnName = "Description", DestinationColumnName = "Description"], [SourceColumnName = "YourRef", DestinationColumnName = "YourRef"], [SourceColumnName = "GLEntryID", DestinationColumnName = "GLEntryID"], [SourceColumnName = "GLEntryNumber", DestinationColumnName = "GLEntryNumber"], [SourceColumnName = "HID", DestinationColumnName = "HID"], [SourceColumnName = "syscreated", DestinationColumnName = "syscreated"], [SourceColumnName = "syscreator", DestinationColumnName = "syscreator"], [SourceColumnName = "sysmodified", DestinationColumnName = "sysmodified"], [SourceColumnName = "sysmodifier", DestinationColumnName = "sysmodifier"], [SourceColumnName = "TranssmartID", DestinationColumnName = "TranssmartID"], [SourceColumnName = "RunNumber", DestinationColumnName = "RunNumber"], [SourceColumnName = "TimestampAsBigInt", DestinationColumnName = "TimestampAsBigInt"]}], DynamicSchema = false, UpdateMethod = [Kind = "Append"], TypeSettings = [Kind = "Table"]]]}]

shared StockEntries = let
    LH = Lakehouse.Contents(null),
    WS = LH{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],
    LHData = WS{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],
    Existing = try LHData{[Id = "StockEntries", ItemKind = "Table"]}[Data] otherwise #table({"sysmodified"}, {}),
    WM = List.Max(Existing[sysmodified]),
    SafeWM = if WM = null then #datetime(2020, 1, 1, 0, 0, 0) else WM,
 
    Source = fnGetExactOnlineTable("StockEntries"),
    Filtered = Table.SelectRows(Source, each true and [sysmodified] > SafeWM)
in
    Filtered;

[BindToDefaultDestination = true]

shared StockOverview = let
    // Brontabellen
    StockTransactions = fnGetExactOnlineTable("StockTransactions"),
    Items = fnGetExactOnlineTable("Items"),
    ItemGroups = fnGetExactOnlineTable("ItemGroups"),
    ItemPrices = fnGetExactOnlineTable("ItemPrices"),

    // Unieke Item+Warehouse posities (Status = 21 = geboekt)
    Filtered = Table.SelectRows(StockTransactions, each [Status] = 21),
    
    // Per Item+Warehouse: pak de meest recente sysmodified als watermark
    Grouped = Table.Group(Filtered, {"Item", "Warehouse"}, {
        {"sysmodified_st", each List.Max([sysmodified]), type datetime}
    }),

    // Items join
    ItemsRenamed = Table.SelectColumns(
        Table.RenameColumns(Items, {{"ID", "ItemID"}}),
        {"ItemID", "Code", "Description", "Class_01", "ItemGroup", "sysmodified"}
    ),
    ItemsRenamed2 = Table.RenameColumns(ItemsRenamed, {{"sysmodified", "sysmodified_item"}}),
    MergedItems = Table.NestedJoin(Grouped, {"Item"}, ItemsRenamed2, {"ItemID"}, "i", JoinKind.LeftOuter),
    ExpandedItems = Table.ExpandTableColumn(MergedItems, "i", 
        {"Code", "Description", "Class_01", "ItemGroup", "sysmodified_item"},
        {"ItemCode", "ItemDescription", "ItemClassDescription", "ItemGroupID", "sysmodified_item"}),

    // ItemGroups join
    IG_Columns = Table.ColumnNames(ItemGroups),
    IGRenamed = Table.RenameColumns(
        Table.SelectColumns(ItemGroups, {IG_Columns{0}, "Description"}),
        {{IG_Columns{0}, "IGID"}, {"Description", "ItemGroupDescription"}}
    ),
    MergedIG = Table.NestedJoin(ExpandedItems, {"ItemGroupID"}, IGRenamed, {"IGID"}, "ig", JoinKind.LeftOuter),
    ExpandedIG = Table.ExpandTableColumn(MergedIG, "ig", {"ItemGroupDescription"}, {"ItemGroupDescription"}),

    // ItemPrices → Unit (eerste match)
    IPForUnit = Table.SelectRows(ItemPrices, each [Unit] <> null and [Unit] <> ""),
    IPGrouped = Table.Group(IPForUnit, {"Item"}, {{"Unit", each List.First([Unit]), type text}}),
    MergedUnit = Table.NestedJoin(ExpandedIG, {"Item"}, IPGrouped, {"Item"}, "ip", JoinKind.LeftOuter),
    ExpandedUnit = Table.ExpandTableColumn(MergedUnit, "ip", {"Unit"}, {"Unit"}),

    // ItemNameCode
    AddItemNameCode = Table.AddColumn(ExpandedUnit, "ItemNameCode", 
        each [ItemCode] & " - " & [ItemDescription], type text),

    // sysmodified = MAX van alle bronnen (watermark voor incremental refresh)
    AddSysModified = Table.AddColumn(AddItemNameCode, "sysmodified", each 
        List.Max({[sysmodified_st], [sysmodified_item]}), type datetime),
    
    // Hulpkolommen opruimen
    Result = Table.RemoveColumns(AddSysModified, {"sysmodified_st", "sysmodified_item"})
in
    Result;

[BindToDefaultDestination = true]

shared StockEntryStatus = let
    StockEntryStatus_Table = fnGetExactOnlineTable("StockEntryStatus")
in
    StockEntryStatus_Table;

[BindToDefaultDestination = true]

shared StockEntryTypes = let
    StockEntryTypes_Table = fnGetExactOnlineTable("StockEntryTypes")
in
    StockEntryTypes_Table;

[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "StockPlanning_DataDestination", IsNewTarget = false], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "ID", DestinationColumnName = "ID"], [SourceColumnName = "Division", DestinationColumnName = "Division"], [SourceColumnName = "Item", DestinationColumnName = "Item"], [SourceColumnName = "Warehouse", DestinationColumnName = "Warehouse"], [SourceColumnName = "SalesOrderID", DestinationColumnName = "SalesOrderID"], [SourceColumnName = "PurchaseOrderID", DestinationColumnName = "PurchaseOrderID"], [SourceColumnName = "StockTransaction", DestinationColumnName = "StockTransaction"], [SourceColumnName = "LinkedSalesOrderID", DestinationColumnName = "LinkedSalesOrderID"], [SourceColumnName = "LinkedPurchaseOrderID", DestinationColumnName = "LinkedPurchaseOrderID"], [SourceColumnName = "Job", DestinationColumnName = "Job"], [SourceColumnName = "DueDate", DestinationColumnName = "DueDate"], [SourceColumnName = "OrderQuantity", DestinationColumnName = "OrderQuantity"], [SourceColumnName = "StockQuantity", DestinationColumnName = "StockQuantity"], [SourceColumnName = "Status", DestinationColumnName = "Status"], [SourceColumnName = "Type", DestinationColumnName = "Type"], [SourceColumnName = "syscreated", DestinationColumnName = "syscreated"], [SourceColumnName = "syscreator", DestinationColumnName = "syscreator"], [SourceColumnName = "sysmodifier", DestinationColumnName = "sysmodifier"], [SourceColumnName = "ShopOrder", DestinationColumnName = "ShopOrder"], [SourceColumnName = "ShopOrderMaterialPlan", DestinationColumnName = "ShopOrderMaterialPlan"], [SourceColumnName = "CancelAction", DestinationColumnName = "CancelAction"], [SourceColumnName = "BatchFactor", DestinationColumnName = "BatchFactor"], [SourceColumnName = "AssemblyOrder", DestinationColumnName = "AssemblyOrder"], [SourceColumnName = "WarehouseTransferLine", DestinationColumnName = "WarehouseTransferLine"], [SourceColumnName = "PicklistLine", DestinationColumnName = "PicklistLine"], [SourceColumnName = "QuantityAllocated", DestinationColumnName = "QuantityAllocated"], [SourceColumnName = "QuantityToPicked", DestinationColumnName = "QuantityToPicked"], [SourceColumnName = "ReservedPick", DestinationColumnName = "ReservedPick"], [SourceColumnName = "Items.Code", DestinationColumnName = "Items.Code"], [SourceColumnName = "Items.Description", DestinationColumnName = "Items.Description"], [SourceColumnName = "sysmodified", DestinationColumnName = "sysmodified"]}], DynamicSchema = false, UpdateMethod = [Kind = "Append"], TypeSettings = [Kind = "Table"]]]}]

shared StockPlanning = let
    LH = Lakehouse.Contents(null),
    WS = LH{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],
    LHData = WS{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],
    Existing = try LHData{[Id = "StockPlanning", ItemKind = "Table"]}[Data] otherwise #table({"sysmodified"}, {}),
    WM = List.Max(Existing[sysmodified]),
    SafeWM = if WM = null then #datetime(2020, 1, 1, 0, 0, 0) else WM,
 
    StockPlanning = fnGetExactOnlineTable("StockPlanning"),
    SP_Filtered = Table.SelectRows(StockPlanning, each true and [sysmodified] > SafeWM),
 
    Items = fnGetExactOnlineTable("Items"),
    Items_Filtered = Table.SelectRows(Items, each true),
    Items_Norm = Table.TransformColumns(
        Table.SelectColumns(Items_Filtered, {"ID", "Code", "Description", "sysmodified"}),
        {{"ID", each Text.Lower(Text.Replace(Text.Replace(_, "{", ""), "}", "")), type text}}
    ),
    Items_Renamed = Table.RenameColumns(Items_Norm, {{"ID", "ItemID"}, {"sysmodified", "sysmodified_item"}}),
    SP_Norm = Table.TransformColumns(SP_Filtered,
        {{"Item", each Text.Lower(Text.Replace(Text.Replace(_, "{", ""), "}", "")), type text}}
    ),
    Joined = Table.NestedJoin(SP_Norm, {"Item"}, Items_Renamed, {"ItemID"}, "Items", JoinKind.LeftOuter),
    Expanded = Table.ExpandTableColumn(Joined, "Items", {"Code", "Description", "sysmodified_item"}, {"Items.Code", "Items.Description", "sysmodified_item"}),
    AddSysModified = Table.AddColumn(Expanded, "sysmodified_final", each List.Max({[sysmodified], [sysmodified_item]}), type datetime),
    Cleanup = Table.RemoveColumns(AddSysModified, {"sysmodified", "sysmodified_item"}),
    Result = Table.RenameColumns(Cleanup, {{"sysmodified_final", "sysmodified"}})
in
    Result;

[BindToDefaultDestination = true]

shared StockPlanningStatus = let
    StockPlanningStatus_Table = fnGetExactOnlineTable("StockPlanningStatus")
in
    StockPlanningStatus_Table;

[BindToDefaultDestination = true]

shared StockPlanningTypes = let
    StockPlanningStatus_Table = fnGetExactOnlineTable("StockPlanningStatus")
in
    StockPlanningStatus_Table;

[BindToDefaultDestination = true]

shared StockPositions = let
    StockPositions_Table = fnGetExactOnlineTable("StockPositions"),
    #"Rijen gefilterd" = Table.SelectRows(StockPositions_Table, each (true))
in
    #"Rijen gefilterd";

[BindToDefaultDestination = true]

shared StockReplenishmentAdvices = let
    StockReplenishmentAdvices_Table = fnGetExactOnlineTable("StockReplenishmentAdvices"),
    #"Rijen gefilterd" = Table.SelectRows(StockReplenishmentAdvices_Table, each true)
in
    #"Rijen gefilterd";

[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "StockTransactions_DataDestination", IsNewTarget = false], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "Item", DestinationColumnName = "Item"], [SourceColumnName = "Warehouse", DestinationColumnName = "Warehouse"], [SourceColumnName = "Quantity", DestinationColumnName = "Quantity"], [SourceColumnName = "Type", DestinationColumnName = "Type"], [SourceColumnName = "TransactionDate", DestinationColumnName = "TransactionDate"], [SourceColumnName = "Status", DestinationColumnName = "Status"], [SourceColumnName = "Source", DestinationColumnName = "Source"], [SourceColumnName = "CostPrice", DestinationColumnName = "CostPrice"], [SourceColumnName = "sysmodified", DestinationColumnName = "sysmodified"]}], DynamicSchema = false, UpdateMethod = [Kind = "Append"], TypeSettings = [Kind = "Table"]]]}]

shared StockTransactions = let
    LH = Lakehouse.Contents(null),
    WS = LH{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],
    LHData = WS{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],
    Existing = try LHData{[Id = "StockTransactions", ItemKind = "Table"]}[Data] otherwise #table({"sysmodified"}, {}),
    WM = List.Max(Existing[sysmodified]),
    SafeWM = if WM = null then #datetime(2020, 1, 1, 0, 0, 0) else WM,
 
    Source = fnGetExactOnlineTable("StockTransactions"),
    Filtered = Table.SelectRows(Source, each true and [sysmodified] > SafeWM)
in
    Filtered;

[BindToDefaultDestination = true]

shared StockTransactionSources = let
    StockTransactionSources_Table = fnGetExactOnlineTable("StockTransactionSources")
in
    StockTransactionSources_Table;

[BindToDefaultDestination = true]

shared StockTransactionStatus = let
    StockTransactionStatus_Table = fnGetExactOnlineTable("StockTransactionStatus")
in
    StockTransactionStatus_Table;

[BindToDefaultDestination = true]

shared StockTransactionTypes = let
    StockTransactionTypes_Table = fnGetExactOnlineTable("StockTransactionTypes"),
    #"Kolommen verwijderd" = Table.RemoveColumns(StockTransactionTypes_Table,{"StockTransactionTypeFeatureSets"})
in
    #"Kolommen verwijderd";

[BindToDefaultDestination = true]

shared Warehouses = let
    dbo_pbi_Dim_Warehouses = fnGetExactOnlineTable("pbi_Dim_Warehouses"),
    #"Rijen gefilterd" = Table.SelectRows(dbo_pbi_Dim_Warehouses, each (true))
in
    #"Rijen gefilterd";

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

shared StockTransactions_DataDestination = let

  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),

  Navigation_1 = Pattern{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],

  Navigation_2 = Navigation_1{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],

  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],

  TableNavigation = Navigation_3{[Id = "StockTransactions", ItemKind = "Table"]}[Data]

in

  TableNavigation;

shared StockPlanning_DataDestination = let

  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),

  Navigation_1 = Pattern{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],

  Navigation_2 = Navigation_1{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],

  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],

  TableNavigation = Navigation_3{[Id = "StockPlanning", ItemKind = "Table"]}[Data]

in

  TableNavigation;

shared StockEntries_DataDestination = let

  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),

  Navigation_1 = Pattern{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],

  Navigation_2 = Navigation_1{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],

  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],

  TableNavigation = Navigation_3{[Id = "StockEntries", ItemKind = "Table"]}[Data]

in

  TableNavigation;

shared StockCounts_DataDestination = let

  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),

  Navigation_1 = Pattern{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],

  Navigation_2 = Navigation_1{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],

  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],

  TableNavigation = Navigation_3{[Id = "StockCounts", ItemKind = "Table"]}[Data]

in

  TableNavigation;

