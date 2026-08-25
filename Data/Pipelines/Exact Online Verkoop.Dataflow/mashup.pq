[DefaultOutputDestinationSettings = [DestinationDefinition = [Kind = "Reference", QueryName = "DefaultDestination", IsNewTarget = true], UpdateMethod = [Kind = "Replace"], DestinationTypeSettings = [Kind = "Table"]], StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[BindToDefaultDestination = true]
shared SalesForecastDetails = let
    SalesForecastDetails_Table = fnGetExactOnlineTable("SalesForecastDetails"),
    #"Rijen gefilterd" = Table.SelectRows(SalesForecastDetails_Table, each true)
in
    #"Rijen gefilterd";
[BindToDefaultDestination = true]
shared SalesForecastItems = let
    SalesForecastItems_Table = fnGetExactOnlineTable("SalesForecastItems"),
    #"Rijen gefilterd" = Table.SelectRows(SalesForecastItems_Table, each true)
in
    #"Rijen gefilterd";
[BindToDefaultDestination = true]
shared SalesForecasts = let
    SalesForecasts_Table = fnGetExactOnlineTable("SalesForecasts"),
    #"Rijen gefilterd" = Table.SelectRows(SalesForecasts_Table, each true)
in
    #"Rijen gefilterd";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "SalesOrders_DataDestination", IsNewTarget = false], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "ID", DestinationColumnName = "ID"], [SourceColumnName = "Division", DestinationColumnName = "Division"], [SourceColumnName = "Type", DestinationColumnName = "Type"], [SourceColumnName = "SalesOrderNumber", DestinationColumnName = "SalesOrderNumber"], [SourceColumnName = "Description", DestinationColumnName = "Description"], [SourceColumnName = "Notes", DestinationColumnName = "Notes"], [SourceColumnName = "EntryDate", DestinationColumnName = "EntryDate"], [SourceColumnName = "DeliveryDate", DestinationColumnName = "DeliveryDate"], [SourceColumnName = "Currency", DestinationColumnName = "Currency"], [SourceColumnName = "AmountFC", DestinationColumnName = "AmountFC"], [SourceColumnName = "AmountDC", DestinationColumnName = "AmountDC"], [SourceColumnName = "RateFC", DestinationColumnName = "RateFC"], [SourceColumnName = "ExchangeRateType", DestinationColumnName = "ExchangeRateType"], [SourceColumnName = "PaymentCondition", DestinationColumnName = "PaymentCondition"], [SourceColumnName = "EntryID", DestinationColumnName = "EntryID"], [SourceColumnName = "OrderAccount", DestinationColumnName = "OrderAccount"], [SourceColumnName = "OrderAccountContact", DestinationColumnName = "OrderAccountContact"], [SourceColumnName = "InvoiceAccount", DestinationColumnName = "InvoiceAccount"], [SourceColumnName = "InvoiceAccountContact", DestinationColumnName = "InvoiceAccountContact"], [SourceColumnName = "DeliveryAccount", DestinationColumnName = "DeliveryAccount"], [SourceColumnName = "DeliveryAccountContact", DestinationColumnName = "DeliveryAccountContact"], [SourceColumnName = "DeliveryAddress", DestinationColumnName = "DeliveryAddress"], [SourceColumnName = "ShippingMethod", DestinationColumnName = "ShippingMethod"], [SourceColumnName = "Warehouse", DestinationColumnName = "Warehouse"], [SourceColumnName = "syscreated", DestinationColumnName = "syscreated"], [SourceColumnName = "sysmodified", DestinationColumnName = "sysmodified"], [SourceColumnName = "ServicePoint", DestinationColumnName = "ServicePoint"]}], DynamicSchema = false, UpdateMethod = [Kind = "Append"], TypeSettings = [Kind = "Table"]]]}]
shared SalesOrders = let
    LH = Lakehouse.Contents(null),
    WS = LH{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],
    LHData = WS{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],
    Existing = try LHData{[Id = "SalesOrders", ItemKind = "Table"]}[Data] otherwise #table({"sysmodified"}, {}),
    WM = List.Max(Existing[sysmodified]),
    SafeWM = if WM = null then #datetime(2020, 1, 1, 0, 0, 0) else WM,

    Source = fnGetExactOnlineTable("SalesOrderHeaders"),
    #"Rijen gefilterd" = Table.SelectRows(Source, each true and [sysmodified] > SafeWM),
    #"Kolommen verwijderd" = Table.RemoveColumns(#"Rijen gefilterd", {
        "Discount", "DiscountAmountFC", "DiscountAmountDC", "DiscountType", 
        "AmountDiscountFC", "AmountVATDiscountFC", "Document", "YourRef", 
        "QuotationEntryID", "CopyEntryID", "PaymentReference", "SalesChannel", 
        "Incoterm", "IncotermAddress", "SelectionCodeID", "VATCode", "AmountVATFC", 
        "TaxSchedule", "Source", "Status", "InvoiceStatus", "ShippingStatus", 
        "StatusApproval", "Approver", "ApprovalDateTime", "SalesRepresentative", 
        "Project", "DepositChargeAmountDC", "DepositChargeAmountFC", 
        "DepositChargeAmountVATFC", "EnvironmentalTaxChargeAmountDC", 
        "EnvironmentalTaxChargeAmountFC", "EnvironmentalTaxChargeAmountVATFC", 
        "syscreator", "sysmodifier", "TimestampAsBigInt", "timestamp", 
        "UsageTransaction", "ExternalID", "LocationCode", "IsVATRoundingBasedOnTotal"
    }, MissingField.Ignore)
in
    #"Kolommen verwijderd";
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "SalesOrderLines_DataDestination", IsNewTarget = false], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "ID", DestinationColumnName = "ID"], [SourceColumnName = "Description", DestinationColumnName = "Description"], [SourceColumnName = "Division", DestinationColumnName = "Division"], [SourceColumnName = "Type", DestinationColumnName = "Type"], [SourceColumnName = "LineNumber", DestinationColumnName = "LineNumber"], [SourceColumnName = "Notes", DestinationColumnName = "Notes"], [SourceColumnName = "SalesOrderNumber", DestinationColumnName = "SalesOrderNumber"], [SourceColumnName = "DeliveryDate", DestinationColumnName = "DeliveryDate"], [SourceColumnName = "AmountFC", DestinationColumnName = "AmountFC"], [SourceColumnName = "AmountDC", DestinationColumnName = "AmountDC"], [SourceColumnName = "Quantity", DestinationColumnName = "Quantity"], [SourceColumnName = "PriceFC", DestinationColumnName = "PriceFC"], [SourceColumnName = "PriceEntryFC", DestinationColumnName = "PriceEntryFC"], [SourceColumnName = "Discount", DestinationColumnName = "Discount"], [SourceColumnName = "DiscountAmountFC", DestinationColumnName = "DiscountAmountFC"], [SourceColumnName = "DiscountAmountDC", DestinationColumnName = "DiscountAmountDC"], [SourceColumnName = "DiscountMode", DestinationColumnName = "DiscountMode"], [SourceColumnName = "AmountDiscountFC", DestinationColumnName = "AmountDiscountFC"], [SourceColumnName = "AmountVATDiscountFC", DestinationColumnName = "AmountVATDiscountFC"], [SourceColumnName = "EntryID", DestinationColumnName = "EntryID"], [SourceColumnName = "Item", DestinationColumnName = "Item"], [SourceColumnName = "Unitcode", DestinationColumnName = "Unitcode"], [SourceColumnName = "UnitFactor", DestinationColumnName = "UnitFactor"], [SourceColumnName = "Items.Code", DestinationColumnName = "Items.Code"], [SourceColumnName = "Items.Description", DestinationColumnName = "Items.Description"], [SourceColumnName = "AmountSoldPositive", DestinationColumnName = "AmountSoldPositive"], [SourceColumnName = "ItemNameCode", DestinationColumnName = "ItemNameCode"], [SourceColumnName = "sysmodified", DestinationColumnName = "sysmodified"]}], DynamicSchema = false, UpdateMethod = [Kind = "Append"], TypeSettings = [Kind = "Table"]]]}]
shared SalesOrderLines = let
    LH = Lakehouse.Contents(null),
    WS = LH{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],
    LHData = WS{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],
    Existing = try LHData{[Id = "SalesOrderLines", ItemKind = "Table"]}[Data] otherwise #table({"sysmodified"}, {}),
    WM = List.Max(Existing[sysmodified]),
    SafeWM = if WM = null then #datetime(2020, 1, 1, 0, 0, 0) else WM,
 
    SalesOrderLines = fnGetExactOnlineTable("SalesOrderLines"),
    SOL_Filtered = Table.SelectRows(SalesOrderLines, each true and [sysmodified] > SafeWM),
    Items = fnGetExactOnlineTable("Items"),
    Items_Filtered = Table.SelectRows(Items, each true),
    SOL_Norm = Table.TransformColumns(SOL_Filtered,
        {{"Item", each Text.Lower(Text.Replace(Text.Replace(_, "{", ""), "}", "")), type text}}),
    Items_Norm = Table.TransformColumns(
        Table.SelectColumns(Items_Filtered, {"ID", "Code", "Description", "sysmodified"}),
        {{"ID", each Text.Lower(Text.Replace(Text.Replace(_, "{", ""), "}", "")), type text}}),
    Items_Renamed = Table.RenameColumns(Items_Norm, {{"ID", "ItemID"}, {"sysmodified", "sysmodified_item"}}),
    Joined = Table.NestedJoin(SOL_Norm, {"Item"}, Items_Renamed, {"ItemID"}, "Items", JoinKind.LeftOuter),
    Expanded = Table.ExpandTableColumn(Joined, "Items", {"Code", "Description", "sysmodified_item"}, {"Items.Code", "Items.Description", "sysmodified_item"}),
    Selected = Table.SelectColumns(Expanded, {
        "ID", "Description", "Division", "Type", "LineNumber", "Notes",
        "SalesOrderNumber", "DeliveryDate", "AmountFC", "AmountDC",
        "Quantity", "PriceFC", "PriceEntryFC", "Discount", "DiscountAmountFC",
        "DiscountAmountDC", "DiscountMode", "AmountDiscountFC", "AmountVATDiscountFC",
        "EntryID", "Item", "Unitcode", "UnitFactor", "Items.Code", "Items.Description",
        "sysmodified", "sysmodified_item"
    }),
    AddASP = Table.AddColumn(Selected, "AmountSoldPositive", each Number.Abs([AmountDC]), type number),
    AddINC = Table.AddColumn(AddASP, "ItemNameCode", each [#"Items.Code"] & " - " & [#"Items.Description"], type text),
    AddSM = Table.AddColumn(AddINC, "sysmodified_final", each List.Max({[sysmodified], [sysmodified_item]}), type datetime),
    Cleanup = Table.RemoveColumns(AddSM, {"sysmodified", "sysmodified_item"}),
    Result = Table.RenameColumns(Cleanup, {{"sysmodified_final", "sysmodified"}})
in
    Result;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "SalesTransactions_DataDestination", IsNewTarget = false], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "ID", DestinationColumnName = "ID"], [SourceColumnName = "HID", DestinationColumnName = "HID"], [SourceColumnName = "Division", DestinationColumnName = "Division"], [SourceColumnName = "EntryID", DestinationColumnName = "EntryID"], [SourceColumnName = "InvoiceNumber", DestinationColumnName = "InvoiceNumber"], [SourceColumnName = "OrderNumber", DestinationColumnName = "OrderNumber"], [SourceColumnName = "LineNumber", DestinationColumnName = "LineNumber"], [SourceColumnName = "Type", DestinationColumnName = "Type"], [SourceColumnName = "Status", DestinationColumnName = "Status"], [SourceColumnName = "Currency", DestinationColumnName = "Currency"], [SourceColumnName = "AmountFC", DestinationColumnName = "AmountFC"], [SourceColumnName = "RateFC", DestinationColumnName = "RateFC"], [SourceColumnName = "AmountDC", DestinationColumnName = "AmountDC"], [SourceColumnName = "PriceFC", DestinationColumnName = "PriceFC"], [SourceColumnName = "PriceEntryFC", DestinationColumnName = "PriceEntryFC"], [SourceColumnName = "PriceList", DestinationColumnName = "PriceList"], [SourceColumnName = "EntryDate", DestinationColumnName = "EntryDate"], [SourceColumnName = "ReportingYear", DestinationColumnName = "ReportingYear"], [SourceColumnName = "ReportingPeriod", DestinationColumnName = "ReportingPeriod"], [SourceColumnName = "InvoiceDate", DestinationColumnName = "InvoiceDate"], [SourceColumnName = "Journal", DestinationColumnName = "Journal"], [SourceColumnName = "Account", DestinationColumnName = "Account"], [SourceColumnName = "AccountContact", DestinationColumnName = "AccountContact"], [SourceColumnName = "YourRef", DestinationColumnName = "YourRef"], [SourceColumnName = "Subscription", DestinationColumnName = "Subscription"], [SourceColumnName = "Description", DestinationColumnName = "Description"], [SourceColumnName = "Item", DestinationColumnName = "Item"], [SourceColumnName = "Unitcode", DestinationColumnName = "Unitcode"], [SourceColumnName = "UnitFactor", DestinationColumnName = "UnitFactor"], [SourceColumnName = "Quantity", DestinationColumnName = "Quantity"], [SourceColumnName = "Discount", DestinationColumnName = "Discount"], [SourceColumnName = "OrderAccount", DestinationColumnName = "OrderAccount"], [SourceColumnName = "OrderAccountContact", DestinationColumnName = "OrderAccountContact"], [SourceColumnName = "DueDate", DestinationColumnName = "DueDate"], [SourceColumnName = "PaymentCondition", DestinationColumnName = "PaymentCondition"], [SourceColumnName = "syscreator", DestinationColumnName = "syscreator"], [SourceColumnName = "sysmodified", DestinationColumnName = "sysmodified"], [SourceColumnName = "sysmodifier", DestinationColumnName = "sysmodifier"], [SourceColumnName = "Extension", DestinationColumnName = "Extension"], [SourceColumnName = "Warehouse", DestinationColumnName = "Warehouse"], [SourceColumnName = "SalesOrderLine", DestinationColumnName = "SalesOrderLine"], [SourceColumnName = "AmountSoldPositive", DestinationColumnName = "AmountSoldPositive"]}], DynamicSchema = false, UpdateMethod = [Kind = "Append"], TypeSettings = [Kind = "Table"]]]}]
shared SalesTransactions = let
    LH = Lakehouse.Contents(null),
    WS = LH{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],
    LHData = WS{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],
    Existing = try LHData{[Id = "SalesTransactions", ItemKind = "Table"]}[Data] otherwise #table({"sysmodified"}, {}),
    WM = List.Max(Existing[sysmodified]),
    SafeWM = if WM = null then #datetime(2020, 1, 1, 0, 0, 0) else WM,
 
    Source = fnGetExactOnlineTable("SalesTransactions"),
    Filtered = Table.SelectRows(Source, each true and [sysmodified] > SafeWM),
    AmountSoldPositive = Table.AddColumn(Filtered, "AmountSoldPositive", each [AmountDC] * -1, type number)
in
    AmountSoldPositive;
[BindToDefaultDestination = true]
shared SalesTransactionStatus = let
    SalesTransactionStatus_Table = fnGetExactOnlineTable("SalesTransactionStatus")
in
    #"SalesTransactionStatus_Table";
[BindToDefaultDestination = true]
shared SalesTransactionTypes = let
    SalesTransactionTypes_Table = fnGetExactOnlineTable("SalesTransactionTypes")
in
    SalesTransactionTypes_Table;
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
shared SalesTransactions_DataDestination = let

  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),

  Navigation_1 = Pattern{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],

  Navigation_2 = Navigation_1{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],

  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],

  TableNavigation = Navigation_3{[Id = "SalesTransactions", ItemKind = "Table"]}[Data]

in

  TableNavigation;
shared SalesOrderLines_DataDestination = let

  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),

  Navigation_1 = Pattern{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],

  Navigation_2 = Navigation_1{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],

  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],

  TableNavigation = Navigation_3{[Id = "SalesOrderLines", ItemKind = "Table"]}[Data]

in

  TableNavigation;
shared OmzetTransacties_DataDestination = let

  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),

  Navigation_1 = Pattern{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],

  Navigation_2 = Navigation_1{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],

  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],

  TableNavigation = Navigation_3{[Id = "OmzetTransacties", ItemKind = "Table"]}[Data]

in

  TableNavigation;
shared SalesOrders_DataDestination = let

  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true, EnableVorder = true, OutputMetadataRefresh = true]),

  Navigation_1 = Pattern{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],

  Navigation_2 = Navigation_1{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],

  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],

  TableNavigation = Navigation_3{[Id = "SalesOrders", ItemKind = "Table"]}[Data]

in

  TableNavigation;
[BindToDefaultDestination = true]
shared OmzetTransacties = let
    Div = 2875061,

    // Watermark uit Lakehouse
    LH = Lakehouse.Contents(null),
    WS = LH{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],
    LHData = WS{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],
    Existing = try LHData{[Id = "OmzetTransacties", ItemKind = "Table"]}[Data] otherwise #table({"sysmodified"}, {}),
    WM = List.Max(Existing[sysmodified]),
    SafeWM = if WM = null then #datetime(2020, 1, 1, 0, 0, 0) else WM,

    // === GLTransactions: filter + watermark ===
    GL = fnGetExactOnlineTable("GLTransactions"),
    GL_Filtered = Table.SelectColumns(
        Table.SelectRows(GL, each [Division] = Div 
            and [EntryDate] >= #datetime(2024, 1, 1, 0, 0, 0)
            and [sysmodified] > SafeWM),
        {"EntryDate", "AmountFC", "Quantity", "Item", "Account", "Journal", "GLAccount", "sysmodified"}
    ),

    GLA = fnGetExactOnlineTable("GLAccounts"),
    GLA_IDs = Table.SelectColumns(
        Table.SelectRows(GLA, each [Division] = Div and [Type] = 110),
        {"ID"}
    ),

    Items = fnGetExactOnlineTable("Items"),
    Items_WithNameCode = Table.AddColumn(Items, "ItemNameCode", each [Code] & " - " & [Description], type text),
    Items_Cols = Table.SelectColumns(Items_WithNameCode, {"ID", "Code", "Description", "ItemGroup", "Class_01", "ItemNameCode"}),

    ItemGroups = fnGetExactOnlineTable("ItemGroups"),
    IG_Cols = Table.SelectColumns(ItemGroups, {"ID", "Description"}),

    Accounts_Source = fnGetExactOnlineTable("Accounts"),
    Accounts_Clean = Table.SelectColumns(
        Table.SelectRows(Accounts_Source, each [Division] = Div),
        {"ID", "Name", "Code", "Division", "IsSupplier"}
    ),

    AC_Source = fnGetExactOnlineTable("AccountClassifications"),
    AC = Table.SelectColumns(
        Table.SelectRows(AC_Source, each [Division] = Div),
        {"ID", "Description"}
    ),

    AAC_Source = fnGetExactOnlineTable("AccountAccountClassifications"),
    AAC_Filtered = Table.SelectRows(AAC_Source, each [Division] = Div),
    AAC_Trim = Table.RemoveColumns(
        AAC_Filtered,
        {"ID", "Division", "syscreated", "syscreator", "sysmodified", "sysmodifier", "timestamp"},
        MissingField.Ignore
    ),
    AAC_Unpivoted = Table.UnpivotOtherColumns(AAC_Trim, {"Account"}, "Kenmerk", "Waarde"),

    AAC_Text = Table.TransformColumns(AAC_Unpivoted, {
        {"Waarde", each Text.Lower(Text.From(_)), type text},
        {"Account", each Text.Lower(Text.From(_)), type text}
    }),
    AC_Text = Table.TransformColumns(AC, {
        {"ID", each Text.Lower(Text.From(_)), type text}
    }),

    AAC_Merged = Table.NestedJoin(AAC_Text, {"Waarde"}, AC_Text, {"ID"}, "AC", JoinKind.LeftOuter),
    AAC_Expanded = Table.ExpandTableColumn(AAC_Merged, "AC", {"Description"}, {"ClassificationDescription"}),
    AAC_Selected = Table.SelectColumns(AAC_Expanded, {"Account", "Kenmerk", "ClassificationDescription"}),
    AAC_Pivoted = Table.Pivot(AAC_Selected, List.Distinct(AAC_Selected[Kenmerk]), "Kenmerk", "ClassificationDescription"),

    Accounts_NormID = Table.TransformColumns(Accounts_Clean, {
        {"ID", each Text.Lower(Text.From(_)), type text}
    }),
    Merged = Table.NestedJoin(Accounts_NormID, {"ID"}, AAC_Pivoted, {"Account"}, "Classifications", JoinKind.LeftOuter),
    Accounts_RestoreID = Table.TransformColumns(Merged, {
        {"ID", each "{" & Text.Upper(_) & "}", type text}
    }),
    ClassificationColumns = List.RemoveItems(Table.ColumnNames(AAC_Pivoted), {"Account"}),
    ExpandedAccounts = Table.ExpandTableColumn(Accounts_RestoreID, "Classifications", ClassificationColumns),
    Accounts_Final = Table.RenameColumns(ExpandedAccounts, {{"Name", "AccountName"}}),
    Acc_Cols = Table.SelectColumns(Accounts_Final, {"ID", "AccountName", "Classification_01"}),

    GL_Type110 = Table.NestedJoin(GL_Filtered, {"GLAccount"}, GLA_IDs, {"ID"}, "GLA", JoinKind.Inner),
    GL_Clean = Table.RemoveColumns(GL_Type110, {"GLA"}),
    GL_ItemFilter = Table.SelectRows(GL_Clean, each [Item] <> null and [Item] <> ""),

    GL_NormItem = Table.TransformColumns(GL_ItemFilter, {
        {"Item", each Text.Lower(Text.Replace(Text.Replace(_, "{", ""), "}", "")), type text}
    }),

    WithItems = Table.NestedJoin(GL_NormItem, {"Item"}, Items_Cols, {"ID"}, "ItemJoin", JoinKind.LeftOuter),
    ExpandItems = Table.ExpandTableColumn(WithItems, "ItemJoin",
        {"Code", "Description", "ItemGroup", "Class_01", "ItemNameCode"},
        {"ItemCode", "ItemDescription", "ItemGroupID", "ItemClass_01", "ItemNameCode"}
    ),

    WithIG = Table.NestedJoin(ExpandItems, {"ItemGroupID"}, IG_Cols, {"ID"}, "IGJoin", JoinKind.LeftOuter),
    ExpandIG = Table.ExpandTableColumn(WithIG, "IGJoin", {"Description"}, {"ItemGroup"}),

    ExpandIG_NormAccount = Table.TransformColumns(ExpandIG, {
        {"Account", each Text.Lower(Text.Replace(Text.Replace(_, "{", ""), "}", "")), type text}
    }),
    Acc_Norm = Table.TransformColumns(Acc_Cols, {
        {"ID", each Text.Lower(Text.Replace(Text.Replace(_, "{", ""), "}", "")), type text}
    }),

    WithAcc = Table.NestedJoin(ExpandIG_NormAccount, {"Account"}, Acc_Norm, {"ID"}, "AccJoin", JoinKind.LeftOuter),
    ExpandAcc = Table.ExpandTableColumn(WithAcc, "AccJoin", {"AccountName", "Classification_01"}, {"AccountName", "Classification_01"}),

    Result = Table.SelectColumns(ExpandAcc, {
        "EntryDate", "AmountFC", "Quantity", "Item", "Account", "Journal",
        "AccountName", "Classification_01",
        "ItemCode", "ItemDescription", "ItemNameCode", "ItemClass_01", "ItemGroup",
        "sysmodified"
    })
in
    Result;
