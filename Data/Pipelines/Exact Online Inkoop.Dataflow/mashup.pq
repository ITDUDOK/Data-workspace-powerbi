[DefaultOutputDestinationSettings = [DestinationDefinition = [Kind = "Reference", QueryName = "DefaultDestination", IsNewTarget = true], UpdateMethod = [Kind = "Replace"], DestinationTypeSettings = [Kind = "Table"]], StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "PurchaseOrders_DataDestination", IsNewTarget = false], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "ID", DestinationColumnName = "ID"], [SourceColumnName = "HID", DestinationColumnName = "HID"], [SourceColumnName = "Division", DestinationColumnName = "Division"], [SourceColumnName = "Type", DestinationColumnName = "Type"], [SourceColumnName = "OrderNumber", DestinationColumnName = "OrderNumber"], [SourceColumnName = "LineNumber", DestinationColumnName = "LineNumber"], [SourceColumnName = "Description", DestinationColumnName = "Description"], [SourceColumnName = "Notes", DestinationColumnName = "Notes"], [SourceColumnName = "EntryDate", DestinationColumnName = "EntryDate"], [SourceColumnName = "DueDate", DestinationColumnName = "DueDate"], [SourceColumnName = "ReceiptDate", DestinationColumnName = "ReceiptDate"], [SourceColumnName = "Currency", DestinationColumnName = "Currency"], [SourceColumnName = "AmountFC", DestinationColumnName = "AmountFC"], [SourceColumnName = "AmountDC", DestinationColumnName = "AmountDC"], [SourceColumnName = "RateFC", DestinationColumnName = "RateFC"], [SourceColumnName = "Quantity", DestinationColumnName = "Quantity"], [SourceColumnName = "PriceFC", DestinationColumnName = "PriceFC"], [SourceColumnName = "PriceEntryFC", DestinationColumnName = "PriceEntryFC"], [SourceColumnName = "PaymentCondition", DestinationColumnName = "PaymentCondition"], [SourceColumnName = "Discount", DestinationColumnName = "Discount"], [SourceColumnName = "DiscountAmountFC", DestinationColumnName = "DiscountAmountFC"], [SourceColumnName = "DiscountAmountDC", DestinationColumnName = "DiscountAmountDC"], [SourceColumnName = "EntryID", DestinationColumnName = "EntryID"], [SourceColumnName = "Document", DestinationColumnName = "Document"], [SourceColumnName = "Supplier", DestinationColumnName = "Supplier"], [SourceColumnName = "SupplierContact", DestinationColumnName = "SupplierContact"], [SourceColumnName = "Costcenter", DestinationColumnName = "Costcenter"], [SourceColumnName = "Costunit", DestinationColumnName = "Costunit"], [SourceColumnName = "YourRef", DestinationColumnName = "YourRef"], [SourceColumnName = "Project", DestinationColumnName = "Project"], [SourceColumnName = "CopyEntryID", DestinationColumnName = "CopyEntryID"], [SourceColumnName = "RunNumber", DestinationColumnName = "RunNumber"], [SourceColumnName = "Item", DestinationColumnName = "Item"], [SourceColumnName = "UnitCode", DestinationColumnName = "UnitCode"], [SourceColumnName = "UnitFactor", DestinationColumnName = "UnitFactor"], [SourceColumnName = "Warehouse", DestinationColumnName = "Warehouse"], [SourceColumnName = "VATCode", DestinationColumnName = "VATCode"], [SourceColumnName = "VATPercentage", DestinationColumnName = "VATPercentage"], [SourceColumnName = "VATBaseAmountFC", DestinationColumnName = "VATBaseAmountFC"], [SourceColumnName = "VATBaseAmountDC", DestinationColumnName = "VATBaseAmountDC"], [SourceColumnName = "AmountVATFC", DestinationColumnName = "AmountVATFC"], [SourceColumnName = "VATType", DestinationColumnName = "VATType"], [SourceColumnName = "Source", DestinationColumnName = "Source"], [SourceColumnName = "Status", DestinationColumnName = "Status"], [SourceColumnName = "ReceiptStatus", DestinationColumnName = "ReceiptStatus"], [SourceColumnName = "InvoiceStatus", DestinationColumnName = "InvoiceStatus"], [SourceColumnName = "IntrastatCountry", DestinationColumnName = "IntrastatCountry"], [SourceColumnName = "StatisticalNumber", DestinationColumnName = "StatisticalNumber"], [SourceColumnName = "StatisticalValue", DestinationColumnName = "StatisticalValue"], [SourceColumnName = "StatisticalQuantity", DestinationColumnName = "StatisticalQuantity"], [SourceColumnName = "StatisticalNetWeight", DestinationColumnName = "StatisticalNetWeight"], [SourceColumnName = "IntrastatSystem", DestinationColumnName = "IntrastatSystem"], [SourceColumnName = "IntrastatTransactionA", DestinationColumnName = "IntrastatTransactionA"], [SourceColumnName = "IntrastatTransactionB", DestinationColumnName = "IntrastatTransactionB"], [SourceColumnName = "IntrastatTransportMethod", DestinationColumnName = "IntrastatTransportMethod"], [SourceColumnName = "IntrastatDeliveryTerm", DestinationColumnName = "IntrastatDeliveryTerm"], [SourceColumnName = "IntrastatArea", DestinationColumnName = "IntrastatArea"], [SourceColumnName = "syscreated", DestinationColumnName = "syscreated"], [SourceColumnName = "syscreator", DestinationColumnName = "syscreator"], [SourceColumnName = "sysmodified", DestinationColumnName = "sysmodified"], [SourceColumnName = "sysmodifier", DestinationColumnName = "sysmodifier"], [SourceColumnName = "DeliveryAddress", DestinationColumnName = "DeliveryAddress"], [SourceColumnName = "DeliveryAccount", DestinationColumnName = "DeliveryAccount"], [SourceColumnName = "DeliveryContact", DestinationColumnName = "DeliveryContact"], [SourceColumnName = "SalesOrder", DestinationColumnName = "SalesOrder"], [SourceColumnName = "DeliveryUser", DestinationColumnName = "DeliveryUser"], [SourceColumnName = "StatusApproval", DestinationColumnName = "StatusApproval"], [SourceColumnName = "Approver", DestinationColumnName = "Approver"], [SourceColumnName = "ApprovalDateTime", DestinationColumnName = "ApprovalDateTime"], [SourceColumnName = "PurchasePriceListPeriod", DestinationColumnName = "PurchasePriceListPeriod"], [SourceColumnName = "Extension", DestinationColumnName = "Extension"], [SourceColumnName = "ShippingMethod", DestinationColumnName = "ShippingMethod"], [SourceColumnName = "PurchaseAgent", DestinationColumnName = "PurchaseAgent"], [SourceColumnName = "SelectionCodeID", DestinationColumnName = "SelectionCodeID"], [SourceColumnName = "SendingMethod", DestinationColumnName = "SendingMethod"], [SourceColumnName = "TimestampAsBigInt", DestinationColumnName = "TimestampAsBigInt"], [SourceColumnName = "TrackStatus", DestinationColumnName = "TrackStatus"], [SourceColumnName = "AccountItemCode", DestinationColumnName = "AccountItemCode"], [SourceColumnName = "ProjectWbsID", DestinationColumnName = "ProjectWbsID"], [SourceColumnName = "DiscountType", DestinationColumnName = "DiscountType"], [SourceColumnName = "AmountDiscountFC", DestinationColumnName = "AmountDiscountFC"], [SourceColumnName = "AmountVATDiscountFC", DestinationColumnName = "AmountVATDiscountFC"]}], DynamicSchema = false, UpdateMethod = [Kind = "Append"], TypeSettings = [Kind = "Table"]]]}]
shared PurchaseOrders = let
    LH = Lakehouse.Contents(null),
    WS = LH{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],
    LHData = WS{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],
    Existing = try LHData{[Id = "PurchaseOrders", ItemKind = "Table"]}[Data] otherwise #table({"sysmodified"}, {}),
    WM = List.Max(Existing[sysmodified]),
    SafeWM = if WM = null then #datetime(2020, 1, 1, 0, 0, 0) else WM,
 
    Source = fnGetExactOnlineTable("PurchaseOrders"),
    Filtered = Table.SelectRows(Source, each true and [sysmodified] > SafeWM)
in
    Filtered;
[BindToDefaultDestination = true]
shared PurchaseOrderTypes = let
    PurchaseOrderTypes_Table = fnGetExactOnlineTable("PurchaseOrderTypes")
in
    PurchaseOrderTypes_Table;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "PurchaseTransactions_DataDestination", IsNewTarget = false], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "ID", DestinationColumnName = "ID"], [SourceColumnName = "HID", DestinationColumnName = "HID"], [SourceColumnName = "Division", DestinationColumnName = "Division"], [SourceColumnName = "EntryID", DestinationColumnName = "EntryID"], [SourceColumnName = "EntryNumber", DestinationColumnName = "EntryNumber"], [SourceColumnName = "LineNumber", DestinationColumnName = "LineNumber"], [SourceColumnName = "Currency", DestinationColumnName = "Currency"], [SourceColumnName = "ExchangeRateType", DestinationColumnName = "ExchangeRateType"], [SourceColumnName = "AmountFC", DestinationColumnName = "AmountFC"], [SourceColumnName = "RateFC", DestinationColumnName = "RateFC"], [SourceColumnName = "PriceFC", DestinationColumnName = "PriceFC"], [SourceColumnName = "PriceEntryFC", DestinationColumnName = "PriceEntryFC"], [SourceColumnName = "InvoiceDate", DestinationColumnName = "InvoiceDate"], [SourceColumnName = "ReportingYear", DestinationColumnName = "ReportingYear"], [SourceColumnName = "ReportingPeriod", DestinationColumnName = "ReportingPeriod"], [SourceColumnName = "DueDate", DestinationColumnName = "DueDate"], [SourceColumnName = "Journal", DestinationColumnName = "Journal"], [SourceColumnName = "Account", DestinationColumnName = "Account"], [SourceColumnName = "AccountContact", DestinationColumnName = "AccountContact"], [SourceColumnName = "Costcenter", DestinationColumnName = "Costcenter"], [SourceColumnName = "Costunit", DestinationColumnName = "Costunit"], [SourceColumnName = "YourRef", DestinationColumnName = "YourRef"], [SourceColumnName = "PaymentReference", DestinationColumnName = "PaymentReference"], [SourceColumnName = "Description", DestinationColumnName = "Description"], [SourceColumnName = "Item", DestinationColumnName = "Item"], [SourceColumnName = "Unit", DestinationColumnName = "Unit"], [SourceColumnName = "UnitFactor", DestinationColumnName = "UnitFactor"], [SourceColumnName = "Quantity", DestinationColumnName = "Quantity"], [SourceColumnName = "Discount", DestinationColumnName = "Discount"], [SourceColumnName = "Warehouse", DestinationColumnName = "Warehouse"], [SourceColumnName = "GLAccount", DestinationColumnName = "GLAccount"], [SourceColumnName = "syscreated", DestinationColumnName = "syscreated"], [SourceColumnName = "syscreator", DestinationColumnName = "syscreator"], [SourceColumnName = "sysmodified", DestinationColumnName = "sysmodified"], [SourceColumnName = "sysmodifier", DestinationColumnName = "sysmodifier"], [SourceColumnName = "PurchaseOrderLine", DestinationColumnName = "PurchaseOrderLine"]}], DynamicSchema = false, UpdateMethod = [Kind = "Append"], TypeSettings = [Kind = "Table"]]]}]
shared PurchaseTransactions = let
    LH = Lakehouse.Contents(null),
    WS = LH{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],
    LHData = WS{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],
    Existing = try LHData{[Id = "PurchaseTransactions", ItemKind = "Table"]}[Data] otherwise #table({"sysmodified"}, {}),

    // Bepaal de laatste sysmodified datum
    WM = List.Max(Existing[sysmodified]),
    SafeWM = if WM = null then #datetime(2020, 1, 1, 0, 0, 0) else WM,

    // Filter de PurchaseTransactions tabel
    // Vervang "Div" door de daadwerkelijke divisie-waarde of parameter
    Source = fnGetExactOnlineTable("PurchaseTransactions"),
    PT_Filtered = Table.SelectRows(
        Source,
        each true
            and [InvoiceDate] >= #datetime(2024, 1, 1, 0, 0, 0)
            and [sysmodified] > SafeWM
    )
in
    PT_Filtered;
[BindToDefaultDestination = true]
shared InkoopTransacties = let
    Div = 2875061,

    // === PurchaseTransactions: filter + kolomselectie + sysmodified ===
    PT = fnGetExactOnlineTable("PurchaseTransactions"),
    PT_Filtered = Table.SelectRows(PT, each [Division] = Div and [InvoiceDate] >= #datetime(2024, 1, 1, 0, 0, 0)),
    PT_Cols = Table.SelectColumns(PT_Filtered, {
        "InvoiceDate", "AmountFC", "Quantity", "Item", "Account", "Journal", "sysmodified"
    }),

    PT_Norm = Table.TransformColumns(PT_Cols, {
        {"Item", each Text.Lower(Text.Replace(Text.Replace(_, "{", ""), "}", "")), type text},
        {"Account", each Text.Lower(Text.Replace(Text.Replace(_, "{", ""), "}", "")), type text}
    }),
    PT_Clean = Table.SelectRows(PT_Norm, each [Item] <> null and [Item] <> ""),

    ItemsTable = fnGetExactOnlineTable("Items"),
    Items_Filtered = Table.SelectRows(ItemsTable, each [Division] = Div),
    Items_WithNameCode = Table.AddColumn(Items_Filtered, "ItemNameCode", each [Code] & " - " & [Description], type text),
    Items_Cols = Table.SelectColumns(Items_WithNameCode, {"ID", "Code", "Description", "Class_01", "ItemGroup", "ItemNameCode", "CostPriceStandard"}),
    Items_Norm = Table.TransformColumns(Items_Cols, {
        {"ID", each Text.Lower(Text.Replace(Text.Replace(_, "{", ""), "}", "")), type text}
    }),

    ItemGroups = fnGetExactOnlineTable("ItemGroups"),
    IG_Cols = Table.SelectColumns(ItemGroups, {"ID", "Description"}),
    IG_Norm = Table.TransformColumns(IG_Cols, {
        {"ID", each Text.Lower(Text.Replace(Text.Replace(_, "{", ""), "}", "")), type text}
    }),

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
    Acc_Norm = Table.TransformColumns(Acc_Cols, {
        {"ID", each Text.Lower(Text.Replace(Text.Replace(_, "{", ""), "}", "")), type text}
    }),

    WithItems = Table.NestedJoin(PT_Clean, {"Item"}, Items_Norm, {"ID"}, "ItemJoin", JoinKind.LeftOuter),
    ExpandItems = Table.ExpandTableColumn(WithItems, "ItemJoin",
        {"Code", "Description", "Class_01", "ItemGroup", "ItemNameCode", "CostPriceStandard"},
        {"ItemCode", "ItemDescription", "Producttype", "ItemGroupID", "ItemNameCode", "CostPriceStandard"}),

    WithIG = Table.NestedJoin(ExpandItems, {"ItemGroupID"}, IG_Norm, {"ID"}, "IGJoin", JoinKind.LeftOuter),
    ExpandIG = Table.ExpandTableColumn(WithIG, "IGJoin", {"Description"}, {"ItemGroup"}),

    WithAcc = Table.NestedJoin(ExpandIG, {"Account"}, Acc_Norm, {"ID"}, "AccJoin", JoinKind.LeftOuter),
    ExpandAcc = Table.ExpandTableColumn(WithAcc, "AccJoin", {"AccountName", "Classification_01"}, {"AccountName", "Classification_01"}),

    Result = Table.SelectColumns(ExpandAcc, {
        "InvoiceDate", "AmountFC", "Quantity", "Item", "Account",
        "AccountName", "Classification_01",
        "ItemCode", "ItemDescription", "ItemNameCode",
        "Producttype", "ItemGroup", "CostPriceStandard",
        "sysmodified"
    })
in
    Result;
[BindToDefaultDestination = true]
shared ArtikelKostprijsSplit = let
    Div = 2875061,

    // === 1. Haal Items op (1x) ===
    Items = fnGetExactOnlineTable("Items"),
    Items_Filtered = Table.SelectRows(Items, each [Division] = Div),
    Items_Norm = Table.TransformColumns(
        Items_Filtered,
        {{"ID", each Text.Lower(Text.Replace(Text.Replace(_, "{", ""), "}", "")), type text}}
    ),
    Items_AllCols = Table.SelectColumns(
        Items_Norm,
        {"ID", "Code", "Description", "CostPriceStandard", "Unit", "StartDate", "EndDate", "Class_01"}
    ),

    // === 2. Haal ItemMaterials op (met sysmodified) ===
    IM = fnGetExactOnlineTable("ItemMaterials"),
    IM_Filtered = Table.SelectRows(IM, each [Division] = Div),
    IM_Cols = Table.SelectColumns(IM_Filtered, {"AssembledItem", "PartItem", "Quantity", "QuantityBatch", "sysmodified"}),

    IM_Norm = Table.TransformColumns(
        IM_Cols,
        {
            {"PartItem", each Text.Lower(Text.Replace(Text.Replace(_, "{", ""), "}", "")), type text},
            {"AssembledItem", each Text.Lower(Text.Replace(Text.Replace(_, "{", ""), "}", "")), type text}
        }
    ),

    // === 3. Join met Items voor Ingredient info ===
    JoinIngredient = Table.NestedJoin(IM_Norm, {"PartItem"}, Items_AllCols, {"ID"}, "Ingredient", JoinKind.LeftOuter),
    ExpandIngredient = Table.ExpandTableColumn(
        JoinIngredient, "Ingredient",
        {"Code", "Description", "CostPriceStandard", "Unit", "Class_01"},
        {"IngredientCode", "IngredientOmschrijving", "IngredientKostprijs", "IngredientEenheid", "Producttype"}
    ),

    // === 4. Join met Items voor Eindproduct info ===
    JoinEindproduct = Table.NestedJoin(ExpandIngredient, {"AssembledItem"}, Items_AllCols, {"ID"}, "Eindproduct", JoinKind.LeftOuter),
    ExpandEindproduct = Table.ExpandTableColumn(
        JoinEindproduct, "Eindproduct",
        {"Code", "Description", "CostPriceStandard", "StartDate", "EndDate"},
        {"EindproductCode", "EindproductOmschrijving", "EindproductKostprijs", "EindproductStartDate", "EindproductEndDate"}
    ),

    // === 5. Hernoem kolommen ===
    Renamed = Table.RenameColumns(ExpandEindproduct, {
        {"AssembledItem", "EindproductID"},
        {"PartItem", "Item"},
        {"QuantityBatch", "GeplandAantal"}
    }),

    // === 6. Berekeningen ===
    MetRatio = Table.AddColumn(Renamed, "HoeveelheidPer1",
        each if [GeplandAantal] = null or [GeplandAantal] = 0 then null else [Quantity] / [GeplandAantal], type number),
    MetIngredientKostenPer1 = Table.AddColumn(MetRatio, "IngredientKostenPer1",
        each if [HoeveelheidPer1] = null or [IngredientKostprijs] = null then null else [IngredientKostprijs] * [HoeveelheidPer1], type number),
    MetTotaleKosten = Table.AddColumn(MetIngredientKostenPer1, "TotaleIngredientKosten",
        each if [IngredientKostprijs] = null or [Quantity] = null then null else [IngredientKostprijs] * [Quantity], type number),

    // === 7. Null Producttype opvangen ===
    CleanType = Table.ReplaceValue(MetTotaleKosten, null, "Overig", Replacer.ReplaceValue, {"Producttype"}),

    // === 8. Berekende kostprijs per eindproduct ===
    Gegroepeerd = Table.Group(CleanType, {"EindproductID"}, {
        {"BerekendeKostprijs", each List.Sum([IngredientKostenPer1]), type number}
    }),
    MetBerekend = Table.NestedJoin(CleanType, {"EindproductID"}, Gegroepeerd, {"EindproductID"}, "Berekend", JoinKind.LeftOuter),
    ExpandBerekend = Table.ExpandTableColumn(MetBerekend, "Berekend", {"BerekendeKostprijs"}, {"BerekendeKostprijsEindproduct"}),

    MetVerschil = Table.AddColumn(ExpandBerekend, "KostprijsVerschil",
        each if [EindproductKostprijs] = null or [BerekendeKostprijsEindproduct] = null then null
             else [EindproductKostprijs] - [BerekendeKostprijsEindproduct], type number),

    // === 9. Normaliseer EindproductID ===
    Norm = Table.TransformColumns(MetVerschil, {
        {"EindproductID", each Text.Lower(Text.Replace(Text.Replace(_, "{", ""), "}", "")), type text}
    }),

    // === 10. sysmodified per EindproductID (vóór pivot) ===
    SysmodGrouped = Table.Group(Norm, {"EindproductID"}, {
        {"sysmodified", each List.Max([sysmodified]), type datetime}
    }),

    // === 11. Filter en groepeer voor pivot ===
    Filtered = Table.SelectRows(Norm, each [IngredientKostenPer1] <> null and [EindproductID] <> null),
    Grouped = Table.Group(Filtered, {"EindproductID", "Producttype"}, {
        {"KostprijsPerType", each List.Average([IngredientKostenPer1]), type number}
    }),
    Pivoted = Table.Pivot(Grouped, List.Distinct(Grouped[Producttype]), "Producttype", "KostprijsPerType", List.Sum),

    // === 12. Zorg voor Grondstof en Verpakking kolommen ===
    MetGrondstof = if Table.HasColumns(Pivoted, "Grondstof") then Pivoted
                   else Table.AddColumn(Pivoted, "Grondstof", each 0, type number),
    MetVerpakking = if Table.HasColumns(MetGrondstof, "Verpakking") then MetGrondstof
                    else Table.AddColumn(MetGrondstof, "Verpakking", each 0, type number),

    CleanGrondstof = Table.ReplaceValue(MetVerpakking, null, 0, Replacer.ReplaceValue, {"Grondstof"}),
    CleanVerpakking = Table.ReplaceValue(CleanGrondstof, null, 0, Replacer.ReplaceValue, {"Verpakking"}),

    // === 13. Join sysmodified terug (ging verloren bij pivot) ===
    MetSysmod = Table.NestedJoin(CleanVerpakking, {"EindproductID"}, SysmodGrouped, {"EindproductID"}, "sm", JoinKind.LeftOuter),
    ExpandSysmod = Table.ExpandTableColumn(MetSysmod, "sm", {"sysmodified"}, {"sysmodified"}),

    Result = Table.SelectColumns(ExpandSysmod, {"EindproductID", "Grondstof", "Verpakking", "sysmodified"})
in
    Result;
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
shared PurchaseOrders_DataDestination = let

  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),

  Navigation_1 = Pattern{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],

  Navigation_2 = Navigation_1{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],

  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],

  TableNavigation = Navigation_3{[Id = "PurchaseOrders", ItemKind = "Table"]}[Data]

in

  TableNavigation;
shared PurchaseTransactions_DataDestination = let

  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),

  Navigation_1 = Pattern{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],

  Navigation_2 = Navigation_1{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],

  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],

  TableNavigation = Navigation_3{[Id = "PurchaseTransactions", ItemKind = "Table"]}[Data]

in

  TableNavigation;
