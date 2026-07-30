[DefaultOutputDestinationSettings = [DestinationDefinition = [Kind = "Reference", QueryName = "DefaultDestination", IsNewTarget = true], UpdateMethod = [Kind = "Replace"], DestinationTypeSettings = [Kind = "Table"]], StagingDefinition = [Kind = "FastCopy"]]
section Section1;
[BindToDefaultDestination = true]
shared Divisions = let
    dbo_pbi_Dim_Divisions = fnGetExactOnlineTable("pbi_Dim_Divisions"),
    #"Renamed Columns" = Table.RenameColumns(dbo_pbi_Dim_Divisions,{{"Description", "CompanyName"}}),
    #"Rijen gefilterd" = Table.SelectRows(#"Renamed Columns", each (true)),
        CompaniesName = Table.AddColumn(#"Rijen gefilterd", "CompaniesName", 
        each Text.From([HID]) & "_" & [CompanyName], type text)
in
    CompaniesName;
[BindToDefaultDestination = true]
shared GLAccounts = let
    GLAccounts = fnGetExactOnlineTable("GLAccounts", each true)
in
    GLAccounts;
[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "GLTransactions_DataDestination", IsNewTarget = false], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "ID", DestinationColumnName = "ID"], [SourceColumnName = "HID", DestinationColumnName = "HID"], [SourceColumnName = "OffsetID", DestinationColumnName = "OffsetID"], [SourceColumnName = "Type", DestinationColumnName = "Type"], [SourceColumnName = "LineType", DestinationColumnName = "LineType"], [SourceColumnName = "Reversal", DestinationColumnName = "Reversal"], [SourceColumnName = "Division", DestinationColumnName = "Division"], [SourceColumnName = "EntryDate", DestinationColumnName = "EntryDate"], [SourceColumnName = "Currency", DestinationColumnName = "Currency"], [SourceColumnName = "AmountFC", DestinationColumnName = "AmountFC"], [SourceColumnName = "RateFC", DestinationColumnName = "RateFC"], [SourceColumnName = "AmountDC", DestinationColumnName = "AmountDC"], [SourceColumnName = "Quantity", DestinationColumnName = "Quantity"], [SourceColumnName = "OpeningBalanceFC", DestinationColumnName = "OpeningBalanceFC"], [SourceColumnName = "ClosingBalanceFC", DestinationColumnName = "ClosingBalanceFC"], [SourceColumnName = "ReportingYear", DestinationColumnName = "ReportingYear"], [SourceColumnName = "ReportingPeriod", DestinationColumnName = "ReportingPeriod"], [SourceColumnName = "DocDate", DestinationColumnName = "DocDate"], [SourceColumnName = "CorrectionEUSalesList", DestinationColumnName = "CorrectionEUSalesList"], [SourceColumnName = "EntryID", DestinationColumnName = "EntryID"], [SourceColumnName = "EntryNumber", DestinationColumnName = "EntryNumber"], [SourceColumnName = "InvoiceNumber", DestinationColumnName = "InvoiceNumber"], [SourceColumnName = "YourRef", DestinationColumnName = "YourRef"], [SourceColumnName = "ProcessNumber", DestinationColumnName = "ProcessNumber"], [SourceColumnName = "Account", DestinationColumnName = "Account"], [SourceColumnName = "Item", DestinationColumnName = "Item"], [SourceColumnName = "Costcenter", DestinationColumnName = "Costcenter"], [SourceColumnName = "Costunit", DestinationColumnName = "Costunit"], [SourceColumnName = "Journal", DestinationColumnName = "Journal"], [SourceColumnName = "Description", DestinationColumnName = "Description"], [SourceColumnName = "Notes", DestinationColumnName = "Notes"], [SourceColumnName = "Document", DestinationColumnName = "Document"], [SourceColumnName = "OrderNumber", DestinationColumnName = "OrderNumber"], [SourceColumnName = "LineNumber", DestinationColumnName = "LineNumber"], [SourceColumnName = "SerialNumber", DestinationColumnName = "SerialNumber"], [SourceColumnName = "Asset", DestinationColumnName = "Asset"], [SourceColumnName = "TransactionID", DestinationColumnName = "TransactionID"], [SourceColumnName = "MatchID", DestinationColumnName = "MatchID"], [SourceColumnName = "DueDate", DestinationColumnName = "DueDate"], [SourceColumnName = "BankAccount", DestinationColumnName = "BankAccount"], [SourceColumnName = "PaymentReference", DestinationColumnName = "PaymentReference"], [SourceColumnName = "AccountBankAccount", DestinationColumnName = "AccountBankAccount"], [SourceColumnName = "BankStatementNumber", DestinationColumnName = "BankStatementNumber"], [SourceColumnName = "PaymentCondition", DestinationColumnName = "PaymentCondition"], [SourceColumnName = "DiscountAmountFC", DestinationColumnName = "DiscountAmountFC"], [SourceColumnName = "DiscountAmountDC", DestinationColumnName = "DiscountAmountDC"], [SourceColumnName = "VATCode", DestinationColumnName = "VATCode"], [SourceColumnName = "VATPercentage", DestinationColumnName = "VATPercentage"], [SourceColumnName = "VATBaseAmountFC", DestinationColumnName = "VATBaseAmountFC"], [SourceColumnName = "VATBaseAmountDC", DestinationColumnName = "VATBaseAmountDC"], [SourceColumnName = "TaxReference", DestinationColumnName = "TaxReference"], [SourceColumnName = "AmountVATFC", DestinationColumnName = "AmountVATFC"], [SourceColumnName = "VATType", DestinationColumnName = "VATType"], [SourceColumnName = "EUSalesListReference", DestinationColumnName = "EUSalesListReference"], [SourceColumnName = "Status", DestinationColumnName = "Status"], [SourceColumnName = "FixedEntryID", DestinationColumnName = "FixedEntryID"], [SourceColumnName = "Source", DestinationColumnName = "Source"], [SourceColumnName = "BatchNumber", DestinationColumnName = "BatchNumber"], [SourceColumnName = "IntraStatCountry", DestinationColumnName = "IntraStatCountry"], [SourceColumnName = "Project", DestinationColumnName = "Project"], [SourceColumnName = "Subscription", DestinationColumnName = "Subscription"], [SourceColumnName = "PaymentInstrument", DestinationColumnName = "PaymentInstrument"], [SourceColumnName = "OfficialInvoiceNumber", DestinationColumnName = "OfficialInvoiceNumber"], [SourceColumnName = "ExchangeRateType", DestinationColumnName = "ExchangeRateType"], [SourceColumnName = "GLAccount", DestinationColumnName = "GLAccount"], [SourceColumnName = "TrackingNumber", DestinationColumnName = "TrackingNumber"], [SourceColumnName = "syscreated", DestinationColumnName = "syscreated"], [SourceColumnName = "syscreator", DestinationColumnName = "syscreator"], [SourceColumnName = "sysmodified", DestinationColumnName = "sysmodified"], [SourceColumnName = "sysmodifier", DestinationColumnName = "sysmodifier"], [SourceColumnName = "ShopOrder", DestinationColumnName = "ShopOrder"], [SourceColumnName = "TimeCostTransaction", DestinationColumnName = "TimeCostTransaction"], [SourceColumnName = "TimeCostReversalType", DestinationColumnName = "TimeCostReversalType"], [SourceColumnName = "Extension", DestinationColumnName = "Extension"], [SourceColumnName = "TimestampAsBigInt", DestinationColumnName = "TimestampAsBigInt"], [SourceColumnName = "ProjectWBS", DestinationColumnName = "ProjectWBS"]}], DynamicSchema = false, UpdateMethod = [Kind = "Append"], TypeSettings = [Kind = "Table"]]]}]
shared GLTransactions = let
    LH = Lakehouse.Contents(null),
    WS = LH{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],
    LHData = WS{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],
    Existing = try LHData{[Id = "GLTransactions", ItemKind = "Table"]}[Data] otherwise #table({"sysmodified"}, {}),
    WM = List.Max(Existing[sysmodified]),
    SafeWM = if WM = null then #datetime(2020, 1, 1, 0, 0, 0) else WM,
 
    DivisionCodes = Table.Column(Administratie, "Code"),

    PerDivisionTables = List.Transform(DivisionCodes, (code) =>

        fnGetExactOnlineTable("GLTransactions", (row) => row[Division] = code and row[sysmodified] > SafeWM)),

    GL_Filtered = Table.Combine(PerDivisionTables)
in
    GL_Filtered;
[BindToDefaultDestination = true]
shared GLTransactionStatus = let
    GLTransactionStatus_Table = fnGetExactOnlineTable("GLTransactionStatus"),
    #"Waarde vervangen" = Table.ReplaceValue(GLTransactionStatus_Table,"Open","Concept",Replacer.ReplaceText,{"Description"}),
    #"Waarde vervangen1" = Table.ReplaceValue(#"Waarde vervangen","Processed","Definitief",Replacer.ReplaceText,{"Description"})
in
    #"Waarde vervangen1";
[BindToDefaultDestination = true]
shared GLClassifications = let
    GLClassifications = fnGetExactOnlineTable("GLClassifications", each true)
in
    GLClassifications;
[BindToDefaultDestination = true]
shared GLAccountSchemaStructures = let
    GLAccountSchemaStructures = fnGetExactOnlineTable("GLAccountSchemaStructures", each true)
in
    GLAccountSchemaStructures;
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
shared DivisionPeriodStatus = let
    DPS = fnGetExactOnlineTable("DivisionPeriodStatus", each true),
    Cols = Table.SelectColumns(DPS, {"Division", "FinYear", "FinPeriod", "YearPeriodStatus", "Journal"})
in
    Cols;
[BindToDefaultDestination = true]
shared Costcenters = let
    LH = Lakehouse.Contents(null),
    WS = LH{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],
    LHData = WS{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],
    Existing = try LHData{[Id = "Costcenters", ItemKind = "Table"]}[Data] otherwise #table({"sysmodified"}, {}),
    WM = List.Max(Existing[sysmodified]),
    SafeWM = if WM = null then #datetime(2020, 1, 1, 0, 0, 0) else WM,
 
    DivisionCodes = Table.Column(Administratie, "Code"),

    PerDivisionTables = List.Transform(DivisionCodes, (code) =>

        fnGetExactOnlineTable("Costcenters", (row) => row[Division] = code and row[sysmodified] > SafeWM)),

    GL_Filtered = Table.Combine(PerDivisionTables)
in
    GL_Filtered;
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
shared GLTransactions_DataDestination = let

  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),

  Navigation_1 = Pattern{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],

  Navigation_2 = Navigation_1{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],

  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],

  TableNavigation = Navigation_3{[Id = "GLTransactions", ItemKind = "Table"]}[Data]

in

  TableNavigation;
