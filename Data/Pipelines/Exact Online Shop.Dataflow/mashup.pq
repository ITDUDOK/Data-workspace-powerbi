[DefaultOutputDestinationSettings = [DestinationDefinition = [Kind = "Reference", QueryName = "DefaultDestination", IsNewTarget = true], UpdateMethod = [Kind = "Replace"], DestinationTypeSettings = [Kind = "Table"]], StagingDefinition = [Kind = "FastCopy"]]

section Section1;

[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "ShopOrderRoutingStepPlans_DataDestination", IsNewTarget = false], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "ID", DestinationColumnName = "ID"], [SourceColumnName = "Division", DestinationColumnName = "Division"], [SourceColumnName = "Description", DestinationColumnName = "Description"], [SourceColumnName = "ShopOrder", DestinationColumnName = "ShopOrder"], [SourceColumnName = "LineNumber", DestinationColumnName = "LineNumber"], [SourceColumnName = "Workcenter", DestinationColumnName = "Workcenter"], [SourceColumnName = "Item", DestinationColumnName = "Item"], [SourceColumnName = "OperationDescription", DestinationColumnName = "OperationDescription"], [SourceColumnName = "Status", DestinationColumnName = "Status"], [SourceColumnName = "Account", DestinationColumnName = "Account"], [SourceColumnName = "Setup", DestinationColumnName = "Setup"], [SourceColumnName = "SetupCount", DestinationColumnName = "SetupCount"], [SourceColumnName = "RunMethod", DestinationColumnName = "RunMethod"], [SourceColumnName = "Run", DestinationColumnName = "Run"], [SourceColumnName = "EfficiencyPercentage", DestinationColumnName = "EfficiencyPercentage"], [SourceColumnName = "AttendedPercentage", DestinationColumnName = "AttendedPercentage"], [SourceColumnName = "SetupLaborBurdenRate", DestinationColumnName = "SetupLaborBurdenRate"], [SourceColumnName = "SetupLaborRate", DestinationColumnName = "SetupLaborRate"], [SourceColumnName = "PlannedRunHours", DestinationColumnName = "PlannedRunHours"], [SourceColumnName = "PlannedSetupHours", DestinationColumnName = "PlannedSetupHours"], [SourceColumnName = "PlannedTotalHours", DestinationColumnName = "PlannedTotalHours"], [SourceColumnName = "RunLaborBurdenRate", DestinationColumnName = "RunLaborBurdenRate"], [SourceColumnName = "RunLaborRate", DestinationColumnName = "RunLaborRate"], [SourceColumnName = "MachineBurdenRate", DestinationColumnName = "MachineBurdenRate"], [SourceColumnName = "GeneralBurdenRate", DestinationColumnName = "GeneralBurdenRate"], [SourceColumnName = "Currency", DestinationColumnName = "Currency"], [SourceColumnName = "RateFC", DestinationColumnName = "RateFC"], [SourceColumnName = "PurchaseUnitPriceDC", DestinationColumnName = "PurchaseUnitPriceDC"], [SourceColumnName = "PurchaseUnitPriceFC", DestinationColumnName = "PurchaseUnitPriceFC"], [SourceColumnName = "PurchaseUnit", DestinationColumnName = "PurchaseUnit"], [SourceColumnName = "PurchaseUnitFactor", DestinationColumnName = "PurchaseUnitFactor"], [SourceColumnName = "PlannedCostDC", DestinationColumnName = "PlannedCostDC"], [SourceColumnName = "PlannedCostFC", DestinationColumnName = "PlannedCostFC"], [SourceColumnName = "MinimumChargeDC", DestinationColumnName = "MinimumChargeDC"], [SourceColumnName = "MinimumChargeFC", DestinationColumnName = "MinimumChargeFC"], [SourceColumnName = "SubcontractedLeadDays", DestinationColumnName = "SubcontractedLeadDays"], [SourceColumnName = "Notes", DestinationColumnName = "Notes"], [SourceColumnName = "syscreated", DestinationColumnName = "syscreated"], [SourceColumnName = "syscreator", DestinationColumnName = "syscreator"], [SourceColumnName = "sysmodified", DestinationColumnName = "sysmodified"], [SourceColumnName = "sysmodifier", DestinationColumnName = "sysmodifier"], [SourceColumnName = "Operation", DestinationColumnName = "Operation"], [SourceColumnName = "RelatedShopOrderRoutingStepPlan", DestinationColumnName = "RelatedShopOrderRoutingStepPlan"], [SourceColumnName = "RoutingStepType", DestinationColumnName = "RoutingStepType"], [SourceColumnName = "SetupLabor", DestinationColumnName = "SetupLabor"], [SourceColumnName = "RunLabor", DestinationColumnName = "RunLabor"], [SourceColumnName = "RunLaborBurden", DestinationColumnName = "RunLaborBurden"], [SourceColumnName = "MachineBurden", DestinationColumnName = "MachineBurden"], [SourceColumnName = "GeneralBurden", DestinationColumnName = "GeneralBurden"], [SourceColumnName = "PurchaseUnitQuantity", DestinationColumnName = "PurchaseUnitQuantity"], [SourceColumnName = "SetupLaborBurden", DestinationColumnName = "SetupLaborBurden"], [SourceColumnName = "SetupUnit", DestinationColumnName = "SetupUnit"], [SourceColumnName = "TotalCostDC", DestinationColumnName = "TotalCostDC"], [SourceColumnName = "CostPerItem", DestinationColumnName = "CostPerItem"], [SourceColumnName = "OperationResource", DestinationColumnName = "OperationResource"], [SourceColumnName = "FactorType", DestinationColumnName = "FactorType"], [SourceColumnName = "RemainingEstimatedSetupHours", DestinationColumnName = "RemainingEstimatedSetupHours"], [SourceColumnName = "RemainingEstimatedRunHours", DestinationColumnName = "RemainingEstimatedRunHours"], [SourceColumnName = "RemainingCalculatedRunHours", DestinationColumnName = "RemainingCalculatedRunHours"], [SourceColumnName = "RemainingActualSetupHours", DestinationColumnName = "RemainingActualSetupHours"], [SourceColumnName = "RemainingActualRunHours", DestinationColumnName = "RemainingActualRunHours"], [SourceColumnName = "PlannedStartDate", DestinationColumnName = "PlannedStartDate"], [SourceColumnName = "PlannedEndDate", DestinationColumnName = "PlannedEndDate"], [SourceColumnName = "DueDate", DestinationColumnName = "DueDate"], [SourceColumnName = "ItemRoutingStep", DestinationColumnName = "ItemRoutingStep"], [SourceColumnName = "TimestampAsBigInt", DestinationColumnName = "TimestampAsBigInt"]}], DynamicSchema = false, UpdateMethod = [Kind = "Append"], TypeSettings = [Kind = "Table"]]]}]

shared ShopOrderRoutingStepPlans = let
    LH = Lakehouse.Contents(null),
    WS = LH{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],
    LHData = WS{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],
    Existing = try LHData{[Id = "ShopOrderRoutingStepPlans", ItemKind = "Table"]}[Data] otherwise #table({"sysmodified"}, {}),
    WM = List.Max(Existing[sysmodified]),
    SafeWM = if WM = null then #datetime(2020, 1, 1, 0, 0, 0) else WM,
 
    Source = fnGetExactOnlineTable("ShopOrderRoutingStepPlans"),
    Filtered = Table.SelectRows(Source, each true and [sysmodified] > SafeWM)
in
    Filtered;

[BindToDefaultDestination = true]

shared ShopOrderStatus = let
    ShopOrderStatus = fnGetExactOnlineTable("ShopOrderStatus")
in
    #"ShopOrderStatus";

[BindToDefaultDestination = true]

shared ShopOrders = let
    dbo_pbi_Fact_ShopOrders = fnGetExactOnlineTable("pbi_Fact_ShopOrders"),
    #"Rijen gefilterd" = Table.SelectRows(dbo_pbi_Fact_ShopOrders, each (true)),
    
    EntryDateWeekNr = Table.AddColumn(#"Rijen gefilterd", "EntryDateWeekNr", 
        each Text.From(Date.WeekOfYear([EntryDate])), type text),
    PlannedEndDateWeekNr = Table.AddColumn(EntryDateWeekNr, "PlannedEndDateWeekNr", 
        each Text.From(Date.WeekOfYear([PlannedEndDate])), type text)
in
    PlannedEndDateWeekNr;

[BindToDefaultDestination = true]

shared ShopOrdersDeliveryPerformance = let
    dbo_pbi_Fact_ShopOrdersDeliveryPerformance = fnGetExactOnlineTable("pbi_Fact_ShopOrdersDeliveryPerformance")
in
    dbo_pbi_Fact_ShopOrdersDeliveryPerformance;

[DataDestinations = {[Definition = [Kind = "Reference", QueryName = "ShopOrderMaterialPlans_DataDestination", IsNewTarget = false], Settings = [Kind = "Manual", AllowCreation = true, ColumnSettings = [Mappings = {[SourceColumnName = "ID", DestinationColumnName = "ID"], [SourceColumnName = "Division", DestinationColumnName = "Division"], [SourceColumnName = "ShopOrder", DestinationColumnName = "ShopOrder"], [SourceColumnName = "Item", DestinationColumnName = "Item"], [SourceColumnName = "LineNumber", DestinationColumnName = "LineNumber"], [SourceColumnName = "Status", DestinationColumnName = "Status"], [SourceColumnName = "PlannedQuantity", DestinationColumnName = "PlannedQuantity"], [SourceColumnName = "PlannedQuantityFactor", DestinationColumnName = "PlannedQuantityFactor"], [SourceColumnName = "CalculatorDiscreteFactor", DestinationColumnName = "CalculatorDiscreteFactor"], [SourceColumnName = "CalculatorType", DestinationColumnName = "CalculatorType"], [SourceColumnName = "DetailDrawing", DestinationColumnName = "DetailDrawing"], [SourceColumnName = "Notes", DestinationColumnName = "Notes"], [SourceColumnName = "syscreated", DestinationColumnName = "syscreated"], [SourceColumnName = "syscreator", DestinationColumnName = "syscreator"], [SourceColumnName = "sysmodified", DestinationColumnName = "sysmodified"], [SourceColumnName = "sysmodifier", DestinationColumnName = "sysmodifier"], [SourceColumnName = "PlannedDate", DestinationColumnName = "PlannedDate"], [SourceColumnName = "PlannedPriceFC", DestinationColumnName = "PlannedPriceFC"], [SourceColumnName = "RateFC", DestinationColumnName = "RateFC"], [SourceColumnName = "Currency", DestinationColumnName = "Currency"], [SourceColumnName = "PlannedAmountFC", DestinationColumnName = "PlannedAmountFC"], [SourceColumnName = "PlannedAmountDC", DestinationColumnName = "PlannedAmountDC"], [SourceColumnName = "Costcenter", DestinationColumnName = "Costcenter"], [SourceColumnName = "Costunit", DestinationColumnName = "Costunit"], [SourceColumnName = "BurdenRate", DestinationColumnName = "BurdenRate"], [SourceColumnName = "BurdenAmount", DestinationColumnName = "BurdenAmount"], [SourceColumnName = "CalculatorUnitFactor", DestinationColumnName = "CalculatorUnitFactor"], [SourceColumnName = "CalculatorUnitFactorType", DestinationColumnName = "CalculatorUnitFactorType"], [SourceColumnName = "Length", DestinationColumnName = "Length"], [SourceColumnName = "Width", DestinationColumnName = "Width"], [SourceColumnName = "Depth", DestinationColumnName = "Depth"], [SourceColumnName = "Margin", DestinationColumnName = "Margin"], [SourceColumnName = "WeightFactor", DestinationColumnName = "WeightFactor"], [SourceColumnName = "PieceLength", DestinationColumnName = "PieceLength"], [SourceColumnName = "PieceWidth", DestinationColumnName = "PieceWidth"], [SourceColumnName = "PieceWeight", DestinationColumnName = "PieceWeight"], [SourceColumnName = "PieceInsideMargin", DestinationColumnName = "PieceInsideMargin"], [SourceColumnName = "PieceInsideMargin2", DestinationColumnName = "PieceInsideMargin2"], [SourceColumnName = "PiecesAcross", DestinationColumnName = "PiecesAcross"], [SourceColumnName = "PiecesPerMultiplier", DestinationColumnName = "PiecesPerMultiplier"], [SourceColumnName = "PlannedLength", DestinationColumnName = "PlannedLength"], [SourceColumnName = "PlannedArea", DestinationColumnName = "PlannedArea"], [SourceColumnName = "PlannedWeight", DestinationColumnName = "PlannedWeight"], [SourceColumnName = "PlannedVolume", DestinationColumnName = "PlannedVolume"], [SourceColumnName = "PlannedEach", DestinationColumnName = "PlannedEach"], [SourceColumnName = "CalculatorUnit", DestinationColumnName = "CalculatorUnit"], [SourceColumnName = "LengthUnit", DestinationColumnName = "LengthUnit"], [SourceColumnName = "WeightPerUnit", DestinationColumnName = "WeightPerUnit"], [SourceColumnName = "WeightUnit", DestinationColumnName = "WeightUnit"], [SourceColumnName = "PlannedLengthUnit", DestinationColumnName = "PlannedLengthUnit"], [SourceColumnName = "PlannedAreaUnit", DestinationColumnName = "PlannedAreaUnit"], [SourceColumnName = "PlannedWeightUnit", DestinationColumnName = "PlannedWeightUnit"], [SourceColumnName = "PlannedVolumeUnit", DestinationColumnName = "PlannedVolumeUnit"], [SourceColumnName = "Description", DestinationColumnName = "Description"], [SourceColumnName = "Type", DestinationColumnName = "Type"], [SourceColumnName = "ItemMaterial", DestinationColumnName = "ItemMaterial"], [SourceColumnName = "WastePercentage", DestinationColumnName = "WastePercentage"], [SourceColumnName = "TimestampAsBigInt", DestinationColumnName = "TimestampAsBigInt"], [SourceColumnName = "RoutingStepID", DestinationColumnName = "RoutingStepID"]}], DynamicSchema = false, UpdateMethod = [Kind = "Append"], TypeSettings = [Kind = "Table"]]]}]

shared ShopOrderMaterialPlans = let
    LH = Lakehouse.Contents(null),
    WS = LH{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],
    LHData = WS{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],
    Existing = try LHData{[Id = "ShopOrderMaterialPlans", ItemKind = "Table"]}[Data] otherwise #table({"sysmodified"}, {}),
    WM = List.Max(Existing[sysmodified]),
    SafeWM = if WM = null then #datetime(2020, 1, 1, 0, 0, 0) else WM,
 
    Source = fnGetExactOnlineTable("ShopOrderMaterialPlans"),
    Filtered = Table.SelectRows(Source, each true and [sysmodified] > SafeWM)
in
    Filtered;

[BindToDefaultDestination = true]

shared PlannedOrderCalculationDateMethods = let
    PlannedOrderCalculationDateMethods_Table = fnGetExactOnlineTable("PlannedOrderCalculationDateMethods")
in
    PlannedOrderCalculationDateMethods_Table;

[BindToDefaultDestination = true]

shared PlannedOrderTypes = let
    PlannedOrderTypes_Table = fnGetExactOnlineTable("PlannedOrderTypes")
in
    PlannedOrderTypes_Table;

[BindToDefaultDestination = true]

shared ReplenishmentTypes = let
    ReplenishmentTypes_Table = fnGetExactOnlineTable("ReplenishmentTypes")
in
    ReplenishmentTypes_Table;

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

shared ShopOrderMaterialPlans_DataDestination = let

  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),

  Navigation_1 = Pattern{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],

  Navigation_2 = Navigation_1{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],

  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],

  TableNavigation = Navigation_3{[Id = "ShopOrderMaterialPlans", ItemKind = "Table"]}[Data]

in

  TableNavigation;

shared ShopOrderRoutingStepPlans_DataDestination = let

  Pattern = Lakehouse.Contents([CreateNavigationProperties = false, EnableFolding = false, HierarchicalNavigation = true]),

  Navigation_1 = Pattern{[workspaceId = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"]}[Data],

  Navigation_2 = Navigation_1{[lakehouseId = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"]}[Data],

  Navigation_3 = Navigation_2{[Id = "dbo", ItemKind = "Schema"]}[Data],

  TableNavigation = Navigation_3{[Id = "ShopOrderRoutingStepPlans", ItemKind = "Table"]}[Data]

in

  TableNavigation;

