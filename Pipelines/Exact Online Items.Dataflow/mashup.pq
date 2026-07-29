[DefaultOutputDestinationSettings = [DestinationDefinition = [Kind = "Reference", QueryName = "DefaultDestination", IsNewTarget = true], UpdateMethod = [Kind = "Replace"], DestinationTypeSettings = [Kind = "Table"]], StagingDefinition = [Kind = "FastCopy"]]

section Section1;

[BindToDefaultDestination = true]

shared ItemClasses = let
    ItemClasses = fnGetExactOnlineTable("ItemClasses", each true),

  #"Removed columns" = Table.RemoveColumns(ItemClasses, {"timestamp"})
in
    #"Removed columns";

[BindToDefaultDestination = true]

shared ItemGroups = let
    ItemGroups_Table = fnGetExactOnlineTable("ItemGroups"),
    #"Rijen gefilterd" = Table.SelectRows(ItemGroups_Table, each (true))
in
    #"Rijen gefilterd";

[BindToDefaultDestination = true]

shared ItemMaterials = let
    ItemMaterials_Table = fnGetExactOnlineTable("ItemMaterials"),
    #"Rijen gefilterd" = Table.SelectRows(ItemMaterials_Table, each true)
in
    #"Rijen gefilterd";

[BindToDefaultDestination = true]

shared ItemPrices = let
    ItemPrices_Table = fnGetExactOnlineTable("ItemPrices"),
    #"Rijen gefilterd" = Table.SelectRows(ItemPrices_Table, each (true))
in
    #"Rijen gefilterd";

[BindToDefaultDestination = true]

shared Items = let
    // Haal de Items-tabel op
    Items_Table = fnGetExactOnlineTable("Items"),

    // Haal de ItemGroups-tabel op
    ItemGroup_Table = fnGetExactOnlineTable("ItemGroups"),

    // Controleer of ItemGroup_Table kolommen heeft
    ItemGroup_Columns = Table.ColumnNames(ItemGroup_Table),
    ItemGroup_Renamed =
        if List.Count(ItemGroup_Columns) > 0 then
            Table.RenameColumns(
                ItemGroup_Table,
                {{ItemGroup_Columns{0}, "ID"}}
            )
        else
            ItemGroup_Table,

    // 1. Kolommen hernoemen in Items
    Renamed_Columns = Table.RenameColumns(Items_Table, {{"ID", "ItemID"}}),

    // 2. Filteren op Division = 2875061
    Filtered_Rows = Table.SelectRows(Renamed_Columns, each true),

    // 3. Kolommen verwijderen
    Removed_Columns = Table.RemoveColumns(
        Filtered_Rows,
        {
            "DescriptionTermID", "ExtraDescription", "ExtraDescriptionTermID", "SearchCode", "SecurityLevel",
            "Class_02", "Class_03", "Class_04", "Class_05", "Class_06", "Class_07", "Class_08", "Class_09", "Class_10",
            "IsSalesItem", "IsStockItem", "IsSerialNumberItem", "IsSubAssemblyItem", "IsFractionAllowedItem",
            "IsAssetItem", "IsTime", "IsNewContract", "IsOnDemandItem", "CostPriceCurrency", "CostPriceNew",
            "Picture", "PictureFileName", "FreeDateField_01", "FreeDateField_02", "FreeDateField_03",
            "FreeDateField_04", "FreeDateField_05", "FreeNumberField_01", "FreeNumberField_02", "FreeNumberField_03",
            "FreeNumberField_04", "FreeNumberField_05", "FreeNumberField_06", "FreeNumberField_07", "FreeNumberField_08",
            "FreeBoolField_01", "FreeBoolField_02", "FreeBoolField_03", "FreeBoolField_04", "FreeBoolField_05",
            "FreeTextField_01", "FreeTextField_02", "FreeTextField_03", "FreeTextField_04", "FreeTextField_05",
            "FreeTextField_06", "FreeTextField_07", "FreeTextField_08", "FreeTextField_09", "FreeTextField_10",
            "StatisticalNumber", "StatisticalUnits", "StatisticalQuantity", "StatisticalValue", "StatisticalNetWeight",
            "Notes", "XmlData", "SalesVATCode", "DepreciationMethod", "ModuleCode", "GLRevaluationBS", "GLCosts",
            "GLStock", "GLAssets", "GLDepreciationPL", "GLDepreciationBS", "Language", "TopicParent", "TopicTime",
            "IsPurchaseItem", "IsSubcontractedItem", "GLRevenue", "timestamp", "IsMakeItem", "IsWebshopItem",
            "CopyRemarks", "IsPackageItem", "BatchQuantity", "UseExplosion", "HasBillOfMaterial", "CalculatorType",
            "CalculatorUnitFactor", "CalculatorUnitFactorType", "Length", "Width", "Depth", "Margin", "WeightFactor",
            "RoundEach", "RoundPlannedQuantityFactor", "CalculatorUnit", "LengthUnit", "WeightPerUnit",
            "PlannedLengthUnit", "PlannedAreaUnit", "PlannedWeightUnit", "PlannedVolumeUnit",
            "IsRegistrationCodeItem", "IsBatchNumberItem", "IsTaxable", "AssembledLeadDays", "GrossWeight",
            "IsServiceItem", "FreeFieldValues", "TimestampAsBigInt", "MaxCompanies", "IsProcurement", "HSCode",
            "IsDiscountItem", "GLRevenueWorkInProgress", "GLCostsWorkInProgress", "DbModified",
            "LinkToVariableMutations", "PayrollEntryType", "PayrollComponent", "QuantityType", "ItemFeatureSets"
        }
    ),

    // 4. Join met ItemGroups
    Merged_Queries = Table.NestedJoin(
        Removed_Columns,
        {"ItemGroup"},
        ItemGroup_Renamed,
        {"ID"},
        "ItemGroup_Joined",
        JoinKind.LeftOuter
    ),

    // 5. Expand ItemGroup.Description
    Expanded_ItemGroup = Table.ExpandTableColumn(
        Merged_Queries,
        "ItemGroup_Joined",
        {"Description"},
        {"ItemGroup.Description"}
    ),

    // 6. Calculated columns: ItemNameCode, Actief
    AddItemNameCode = Table.AddColumn(Expanded_ItemGroup, "ItemNameCode", 
        each [Code] & " - " & [Description], type text),
    AddActief = Table.AddColumn(AddItemNameCode, "Actief", 
        each if [EndDate] = null or [EndDate] >= DateTime.LocalNow() then "Ja" else "Nee", type text),

// 7. Leverancier via ItemPrices + Accounts
    IP_Raw = fnGetExactOnlineTable("ItemPrices"),
    IP_Filtered = Table.SelectRows(IP_Raw, each [Account] <> null and [Account] <> ""),
    IP_TextKey = Table.TransformColumns(IP_Filtered, {{"Account", Text.From, type text}}),
    
    Acc_Raw = fnGetExactOnlineTable("Accounts"),
    Acc_TextKey = Table.TransformColumns(Acc_Raw, {{"ID", Text.From, type text}}),
    
    IP_Joined = Table.NestedJoin(IP_TextKey, {"Account"}, Acc_TextKey, {"ID"}, "acc", JoinKind.LeftOuter),
    IP_Expanded = Table.ExpandTableColumn(IP_Joined, "acc", {"AccountName"}, {"Leverancier"}),
    IP_Grouped = Table.Group(IP_Expanded, {"Item"}, {{"Leverancier", each List.Max([Leverancier]), type text}}),

    // 8. Merge terug — ook Item key naar text
    AddItemIDText = Table.TransformColumns(AddActief, {{"ItemID", Text.From, type text}}),
    IP_ItemText = Table.TransformColumns(IP_Grouped, {{"Item", Text.From, type text}}),
    MergeLeverancier = Table.NestedJoin(AddItemIDText, {"ItemID"}, IP_ItemText, {"Item"}, "lev", JoinKind.LeftOuter),
    ExpandLeverancier = Table.ExpandTableColumn(MergeLeverancier, "lev", {"Leverancier"}, {"Leverancier"})
in
    ExpandLeverancier;

[BindToDefaultDestination = true]

shared ItemWarehouses = let
    ItemWarehouses = fnGetExactOnlineTable("ItemWarehouses", each true)
in
    ItemWarehouses;

[BindToDefaultDestination = true]

shared MaterialRequirements = let
    MaterialRequirements = fnGetExactOnlineTable("MaterialRequirements", each true)
in
    MaterialRequirements;

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

