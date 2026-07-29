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

