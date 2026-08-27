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

[BindToDefaultDestination = true]

shared PeilDatum = let
    StartDate = #datetime(2020, 1, 1, 0, 0, 0),
    EndDate = DateTime.From(DateTime.Date(DateTime.LocalNow())),
    DayCount = Number.From(Duration.Days(EndDate - StartDate)) + 1,
    Dates = List.DateTimes(StartDate, DayCount, #duration(1,0,0,0)),
    Base = Table.FromList(Dates, Splitter.SplitByNothing(), {"Date"}),
    #"Changed Type" = Table.TransformColumnTypes(Base, {{"Date", type datetime}}),
    WeekdayOf = (d as date) as number => Number.Mod(Date.DayOfWeek(d, Day.Sunday), 7) + 1,
    WeekNrOf = (d as date) as number =>
        let j1 = #date(Date.Year(d), 1, 1) in Number.RoundUp((Date.DayOfYear(d) + WeekdayOf(j1) - 1) / 7),
    #"Added Jaar" = Table.AddColumn(#"Changed Type", "Jaar", each Date.Year(DateTime.Date([Date])), Int64.Type),
    #"Added Maand" = Table.AddColumn(#"Added Jaar", "Maand", each Date.Month(DateTime.Date([Date])), Int64.Type),
    #"Added MaandNaam" = Table.AddColumn(#"Added Maand", "MaandNaam", each Date.MonthName(DateTime.Date([Date]), "en-US"), type text),
    #"Added WeekNr" = Table.AddColumn(#"Added MaandNaam", "WeekNr", each WeekNrOf(DateTime.Date([Date])), Int64.Type),
    #"Added JaarMaand" = Table.AddColumn(#"Added WeekNr", "JaarMaand", each Date.ToText(DateTime.Date([Date]), "yyyy-MM"), type text),
    #"Added JaarWeek" = Table.AddColumn(#"Added JaarMaand", "JaarWeek", each Text.From([Jaar]) & "-W" & Text.PadStart(Text.From([WeekNr]), 2, "0"), type text)
in
    #"Added JaarWeek";

[BindToDefaultDestination = true]
shared MRPInkopen = let
    LH = Lakehouse.Contents(null),
    WS = LH{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],
    LHData = WS{[lakehouseId = "097e8f82-835e-4936-a16d-9f6f886d5ef0"]}[Data],

    SOMP = LHData{[Id = "ShopOrderMaterialPlans", ItemKind = "Table"]}[Data],
    SO = LHData{[Id = "ShopOrders", ItemKind = "Table"]}[Data],
    SP = LHData{[Id = "StockPlanning", ItemKind = "Table"]}[Data],
    ST = LHData{[Id = "StockTransactions", ItemKind = "Table"]}[Data],

    SOMPJoined = Table.NestedJoin(SOMP, {"ShopOrder"}, SO, {"ID"}, "SOMatch", JoinKind.Inner),
    SOMPExpanded = Table.ExpandTableColumn(SOMPJoined, "SOMatch", {"Status"}, {"SO_Status"}),
    SOMPFiltered = Table.SelectRows(SOMPExpanded, each List.Contains({10, 20}, [SO_Status]) and [PlannedDate] <> null),
    Prognose = Table.RenameColumns(
        Table.AddColumn(Table.SelectColumns(SOMPFiltered, {"Item", "PlannedDate", "PlannedQuantity"}), "Type", each "Prognose", type text),
        {{"PlannedDate", "Date"}, {"PlannedQuantity", "Quantity"}}
    ),

    SPFiltered = Table.SelectRows(SP, each [Type] = 130 and [Status] = 12 and [DueDate] <> null),
    Bestelling = Table.RenameColumns(
        Table.AddColumn(Table.SelectColumns(SPFiltered, {"Item", "DueDate", "OrderQuantity"}), "Type", each "Bestelling", type text),
        {{"DueDate", "Date"}, {"OrderQuantity", "Quantity"}}
    ),

    STFiltered = Table.SelectRows(ST, each List.Contains({130, 132}, [Type]) and [Status] = 21 and [TransactionDate] <> null),
    Gerealiseerd = Table.RenameColumns(
        Table.AddColumn(Table.SelectColumns(STFiltered, {"Item", "TransactionDate", "Quantity"}), "TypeCol", each "Gerealiseerd", type text),
        {{"TransactionDate", "Date"}, {"TypeCol", "Type"}}
    ),

    Combined = Table.Combine({Prognose, Bestelling, Gerealiseerd}),
    #"Reordered Columns" = Table.ReorderColumns(Combined, {"Item", "Date", "Quantity", "Type"}),
    #"Typed Columns" = Table.TransformColumnTypes(#"Reordered Columns", {
        {"Item", type text},
        {"Date", type datetime},
        {"Quantity", type number},
        {"Type", type text}
    })
in
    #"Typed Columns";

[BindToDefaultDestination = true]
shared MRPPlanning = let
    LH = Lakehouse.Contents(null),
    WS = LH{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],
    LHData = WS{[lakehouseId = "097e8f82-835e-4936-a16d-9f6f886d5ef0"]}[Data],

    StockPlanningT = LHData{[Id = "StockPlanning", ItemKind = "Table"]}[Data],
    ShopOrdersT = LHData{[Id = "ShopOrders", ItemKind = "Table"]}[Data],
    MaterialRequirementsT = LHData{[Id = "MaterialRequirements", ItemKind = "Table"]}[Data],
    StockReplenishmentAdvicesT = LHData{[Id = "StockReplenishmentAdvices", ItemKind = "Table"]}[Data],
    ItemsT = LHData{[Id = "Items", ItemKind = "Table"]}[Data],
    ItemGroupsT = LHData{[Id = "ItemGroups", ItemKind = "Table"]}[Data],
    ItemPricesT = LHData{[Id = "ItemPrices", ItemKind = "Table"]}[Data],

    OrderTypeSP = (t as nullable number) as text =>
        if t = 120 then "Verkooporder" else if t = 130 then "Inkooporder"
        else if t = 134 then "Magazijntransfer" else if t = 140 then "Productieorder"
        else if t = 150 then "Materiaalbehoefte" else "Overig",
    OrderTypeMR = (t as nullable number) as text =>
        if t = 1 then "Inkoopadvies" else if t = 2 then "Produceren"
        else if t = 3 then "Assembleren" else if t = 4 then "Transfer"
        else if t = 7 then "Materiaalbehoefte" else if t = 100 then "Verkoopprognose"
        else if t = 102 then "Veiligheidsvoorraad" else "Overig MRP",
    OrderTypeSRA = (t as nullable number) as text =>
        if t = 1 then "MRP: Inkopen" else if t = 2 then "MRP: Assembleren"
        else if t = 3 then "MRP: Produceren" else if t = 4 then "MRP: Transfer"
        else if t = 5 then "MRP: Geen aanvulling" else "MRP Advies",

    Cols = {"BronTabel","OrderType","OrderID","OrderDatum","OntvangstDatum","BehoefteDatum","ArtikelID","MagazijnID","LeverancierID","Hoeveelheid","Geproduceerd","StatusCode","WaarschuwingType","AanvulType","SalesOrderLink","PurchaseOrderLink","ShopOrderLink","MRPScenarioLink","DivisionCode"},

    Shape1 = Table.AddColumn(StockPlanningT, "Shaped", each [
        BronTabel = "StockPlanning", OrderType = OrderTypeSP([Type]), OrderID = [ID],
        OrderDatum = [DueDate], OntvangstDatum = null, BehoefteDatum = null,
        ArtikelID = [Item], MagazijnID = [Warehouse], LeverancierID = null,
        Hoeveelheid = [OrderQuantity], Geproduceerd = null, StatusCode = [Status],
        WaarschuwingType = null, AanvulType = null, SalesOrderLink = [SalesOrderID],
        PurchaseOrderLink = [PurchaseOrderID], ShopOrderLink = [ShopOrder],
        MRPScenarioLink = null, DivisionCode = [Division]
    ]),
    AllOrders1 = Table.ExpandRecordColumn(Table.SelectColumns(Shape1, {"Shaped"}), "Shaped", Cols),

    Shape2 = Table.AddColumn(ShopOrdersT, "Shaped", each [
        BronTabel = "ShopOrders", OrderType = "Productieorder", OrderID = [ID],
        OrderDatum = [PlannedDate], OntvangstDatum = [PlannedEndDate], BehoefteDatum = [PlannedDate],
        ArtikelID = [Item], MagazijnID = [Warehouse], LeverancierID = null,
        Hoeveelheid = [PlannedQuantity], Geproduceerd = [QuantityProduced], StatusCode = [Status],
        WaarschuwingType = null, AanvulType = 3, SalesOrderLink = null,
        PurchaseOrderLink = null, ShopOrderLink = [ID],
        MRPScenarioLink = null, DivisionCode = [Division]
    ]),
    AllOrders2 = Table.ExpandRecordColumn(Table.SelectColumns(Shape2, {"Shaped"}), "Shaped", Cols),

    Shape3 = Table.AddColumn(MaterialRequirementsT, "Shaped", each [
        BronTabel = "MaterialRequirements", OrderType = OrderTypeMR([Type]), OrderID = [ID],
        OrderDatum = [RequiredDate], OntvangstDatum = null, BehoefteDatum = [RequiredDate],
        ArtikelID = [Item], MagazijnID = [Warehouse], LeverancierID = null,
        Hoeveelheid = [Quantity], Geproduceerd = null, StatusCode = null,
        WaarschuwingType = null, AanvulType = [Type], SalesOrderLink = null,
        PurchaseOrderLink = null, ShopOrderLink = null,
        MRPScenarioLink = [MRPScenario], DivisionCode = [Division]
    ]),
    AllOrders3 = Table.ExpandRecordColumn(Table.SelectColumns(Shape3, {"Shaped"}), "Shaped", Cols),

    Shape4 = Table.AddColumn(StockReplenishmentAdvicesT, "Shaped", each [
        BronTabel = "StockReplenishmentAdvice", OrderType = OrderTypeSRA([ReplenishmentType]), OrderID = [ID],
        OrderDatum = [OrderDate], OntvangstDatum = [ReceiptDate], BehoefteDatum = [RequirementDate],
        ArtikelID = [Item], MagazijnID = [Warehouse], LeverancierID = [Supplier],
        Hoeveelheid = [Quantity], Geproduceerd = null, StatusCode = null,
        WaarschuwingType = [WarningType], AanvulType = [ReplenishmentType], SalesOrderLink = null,
        PurchaseOrderLink = null, ShopOrderLink = null,
        MRPScenarioLink = [MRPScenario], DivisionCode = [Division]
    ]),
    AllOrders4 = Table.ExpandRecordColumn(Table.SelectColumns(Shape4, {"Shaped"}), "Shaped", Cols),

    AllOrders = Table.Combine({AllOrders1, AllOrders2, AllOrders3, AllOrders4}),

    AllOrdersTyped = Table.TransformColumnTypes(AllOrders, {
        {"BronTabel", type text}, {"OrderType", type text}, {"OrderID", type text},
        {"OrderDatum", type datetime}, {"OntvangstDatum", type datetime}, {"BehoefteDatum", type datetime},
        {"ArtikelID", type text}, {"MagazijnID", type text}, {"LeverancierID", type text},
        {"Hoeveelheid", type number}, {"Geproduceerd", type number},
        {"StatusCode", Int64.Type}, {"WaarschuwingType", Int64.Type}, {"AanvulType", Int64.Type},
        {"SalesOrderLink", type text}, {"PurchaseOrderLink", type text}, {"ShopOrderLink", type text},
        {"MRPScenarioLink", type text}, {"DivisionCode", Int64.Type}
    }),

    J1 = Table.NestedJoin(AllOrdersTyped, {"ArtikelID"}, ItemsT, {"ItemID"}, "ItemsMatch", JoinKind.LeftOuter),
    J1Exp = Table.ExpandTableColumn(J1, "ItemsMatch", {"Code","Description","ItemGroup","Class_01"}, {"Artikelcode","Artikelnaam","ArtikelgroepID","Producttype"}),

    J2 = Table.NestedJoin(J1Exp, {"ArtikelgroepID"}, ItemGroupsT, {"ID"}, "IGMatch", JoinKind.LeftOuter),
    J2Exp = Table.ExpandTableColumn(J2, "IGMatch", {"Description"}, {"Artikelgroep"}),

    J3 = Table.AddColumn(J2Exp, "ArtikelcodeNaam", each if [Artikelcode] <> null then [Artikelcode] & " - " & [Artikelnaam] else null, type text),

    ItemPricesSorted = Table.Sort(ItemPricesT, {{"syscreated", Order.Descending}}),
    ItemPricesLatest = Table.Group(ItemPricesSorted, {"Item"}, {{"Latest", each Table.FirstN(_,1){0}, type record}}),
    ItemPricesExp = Table.ExpandRecordColumn(ItemPricesLatest, "Latest", {"Unit","Price"}, {"Eenheid","Prijs"}),
    ItemPricesTyped = Table.TransformColumnTypes(ItemPricesExp, {{"Eenheid", type text}, {"Prijs", type number}}),

    J4 = Table.NestedJoin(J3, {"ArtikelID"}, ItemPricesTyped, {"Item"}, "IPMatch", JoinKind.LeftOuter),
    J4Exp = Table.ExpandTableColumn(J4, "IPMatch", {"Eenheid","Prijs"}, {"Eenheid","Prijs"}),

    J5 = Table.AddColumn(J4Exp, "Waarde", each [Hoeveelheid] * (if [Prijs] = null then 0 else [Prijs]), type number),

    J6 = Table.NestedJoin(J5, {"ShopOrderLink"}, ShopOrdersT, {"ID"}, "SO2Match", JoinKind.LeftOuter),
    J6Exp = Table.ExpandTableColumn(J6, "SO2Match", {"ShopOrderNumber"}, {"ShopOrderNumber"}),

    J7 = Table.AddColumn(J6Exp, "ShopOrderURL", each
        if [ShopOrderLink] <> null then
            "https://start.exactonline.nl/docs/MfgShopOrderCard.aspx?ID=" &
            Text.Replace(Text.Replace(Text.From([ShopOrderLink]), "{", "%7b"), "}", "%7d") &
            "&_Division_=" & Text.From([DivisionCode])
        else null, type text),

    WeekdayOf = (d as date) as number => Number.Mod(Date.DayOfWeek(d, Day.Sunday), 7) + 1,
    WeekNrOf = (d as nullable date) as nullable number =>
        if d = null then null else
        let j1 = #date(Date.Year(d), 1, 1) in Number.RoundUp((Date.DayOfYear(d) + WeekdayOf(j1) - 1) / 7),

    J8 = Table.AddColumn(J7, "Jaar", each if [OrderDatum] = null then null else Date.Year(DateTime.Date([OrderDatum])), Int64.Type),
    J9 = Table.AddColumn(J8, "Maand", each if [OrderDatum] = null then null else Date.Month(DateTime.Date([OrderDatum])), Int64.Type),
    J10 = Table.AddColumn(J9, "MaandNaam", each if [OrderDatum] = null then null else Date.MonthName(DateTime.Date([OrderDatum]), "en-US"), type text),
    J11 = Table.AddColumn(J10, "Weeknummer", each WeekNrOf(if [OrderDatum] = null then null else DateTime.Date([OrderDatum])), Int64.Type),
    J12 = Table.AddColumn(J11, "JaarMaand", each if [OrderDatum] = null then null else Date.ToText(DateTime.Date([OrderDatum]), "yyyy-MM"), type text),
    J13 = Table.AddColumn(J12, "JaarWeek", each if [OrderDatum] = null then null else Text.From(Date.Year(DateTime.Date([OrderDatum]))) & "-W" & Text.PadStart(Text.From([Weeknummer]), 2, "0"), type text),
    J14 = Table.AddColumn(J13, "Kwartaal", each if [Maand] = null then null else "Q" & Text.From(Number.RoundUp([Maand] / 3)), type text),
    J15 = Table.AddColumn(J14, "Status", each
        if [StatusCode] = 21 then "Compleet"
        else if [StatusCode] = 30 then "Open"
        else if [StatusCode] = 40 then "Afgerond"
        else if [StatusCode] = 10 then "In process"
        else null, type text),
    J16 = Table.AddColumn(J15, "VraagAanbod", each if [Hoeveelheid] <> null and [Hoeveelheid] < 0 then "Vraag" else "Aanbod", type text),
    J17 = Table.AddColumn(J16, "HoeveelheidAbs", each if [Hoeveelheid] = null then null else Number.Abs([Hoeveelheid]), type number)
in
    J17;

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

