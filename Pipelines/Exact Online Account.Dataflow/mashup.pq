[DefaultOutputDestinationSettings = [DestinationDefinition = [Kind = "Reference", QueryName = "DefaultDestination", IsNewTarget = true], UpdateMethod = [Kind = "Replace"], DestinationTypeSettings = [Kind = "Table"]], StagingDefinition = [Kind = "FastCopy"]]

section Section1;

[BindToDefaultDestination = true]

shared AccountClassificationNames = let
    AccountClassificationNames_Table = fnGetExactOnlineTable("AccountClassificationNames"),
    #"Rijen gefilterd" = Table.SelectRows(AccountClassificationNames_Table, each (true))
in
    #"Rijen gefilterd";

[BindToDefaultDestination = true]

shared AccountClassifications = let
    AccountClassifications_Table = fnGetExactOnlineTable("AccountClassifications"),
    #"Rijen gefilterd" = Table.SelectRows(AccountClassifications_Table, each (true))
in
    #"Rijen gefilterd";

[BindToDefaultDestination = true]

shared Accounts = let
    Div = 2875061,

    // === Accounts: filter + kolomselectie DIRECT op de bron ===
    // SelectRows + SelectColumns folden naar de Exact Online-query, zodat de
    // brede Accounts-tabel niet volledig over de API wordt opgehaald (oorzaak 120s-timeout).
    Accounts_Source = fnGetExactOnlineTable("Accounts"),
    Accounts_Clean = Table.SelectColumns(
        Table.SelectRows(Accounts_Source, each true),
        {"ID", "Name", "Code", "Division", "IsSupplier"}
    ),

    // === AccountClassifications: alleen ID + Description nodig ===
    AC_Source = fnGetExactOnlineTable("AccountClassifications"),
    AC = Table.SelectColumns(
        Table.SelectRows(AC_Source, each true),
        {"ID", "Description"}
    ),

    // === AccountAccountClassifications: filter + audit-kolommen weg vóór unpivot ===
    AAC_Source = fnGetExactOnlineTable("AccountAccountClassifications"),
    AAC_Filtered = Table.SelectRows(AAC_Source, each true),
    AAC_Trim = Table.RemoveColumns(
        AAC_Filtered,
        {"ID", "Division", "syscreated", "syscreator", "sysmodified", "sysmodifier", "timestamp"},
        MissingField.Ignore
    ),
    AAC_Unpivoted = Table.UnpivotOtherColumns(AAC_Trim, {"Account"}, "Kenmerk", "Waarde"),

    // === Normaliseer join-sleutels naar lower-text ===
    AAC_Text = Table.TransformColumns(AAC_Unpivoted, {
        {"Waarde", each Text.Lower(Text.From(_)), type text},
        {"Account", each Text.Lower(Text.From(_)), type text}
    }),
    AC_Text = Table.TransformColumns(AC, {
        {"ID", each Text.Lower(Text.From(_)), type text}
    }),

    // === Join AAC ↔ AC voor Description, daarna pivot per Account ===
    AAC_Merged = Table.NestedJoin(AAC_Text, {"Waarde"}, AC_Text, {"ID"}, "AC", JoinKind.LeftOuter),
    AAC_Expanded = Table.ExpandTableColumn(AAC_Merged, "AC", {"Description"}, {"ClassificationDescription"}),
    AAC_Selected = Table.SelectColumns(AAC_Expanded, {"Account", "Kenmerk", "ClassificationDescription"}),
    AAC_Pivoted = Table.Pivot(AAC_Selected, List.Distinct(AAC_Selected[Kenmerk]), "Kenmerk", "ClassificationDescription"),

    // === Merge classificaties op Accounts ===
    Accounts_NormID = Table.TransformColumns(Accounts_Clean, {
        {"ID", each Text.Lower(Text.From(_)), type text}
    }),
    Merged = Table.NestedJoin(Accounts_NormID, {"ID"}, AAC_Pivoted, {"Account"}, "Classifications", JoinKind.LeftOuter),
    Accounts_RestoreID = Table.TransformColumns(Merged, {
        {"ID", each "{" & Text.Upper(_) & "}", type text}
    }),
    ClassificationColumns = List.RemoveItems(Table.ColumnNames(AAC_Pivoted), {"Account"}),
    Expanded = Table.ExpandTableColumn(Accounts_RestoreID, "Classifications", ClassificationColumns),
    #"Namen van kolommen gewijzigd" = Table.RenameColumns(Expanded, {{"Name", "AccountName"}})
in
    #"Namen van kolommen gewijzigd";

[BindToDefaultDestination = true]

shared AccountAccountClassifications_Table = let
    AccountAccountClassifications_Table = fnGetExactOnlineTable("AccountAccountClassifications"),
    #"Rijen gefilterd" = Table.SelectRows(AccountAccountClassifications_Table, each (true)),
    #"GUIDs geformatteerd" = Table.TransformColumns(#"Rijen gefilterd", {
        {"ID", each "{" & Text.Upper(Text.From(_)) & "}", type text},
        {"Account", each "{" & Text.Upper(Text.From(_)) & "}", type text},
        {"syscreator", each "{" & Text.Upper(Text.From(_)) & "}", type text},
        {"sysmodifier", each "{" & Text.Upper(Text.From(_)) & "}", type text}
    }),
    #"Draaitabel voor kolommen opgeheven" = Table.UnpivotOtherColumns(#"GUIDs geformatteerd", {"ID", "Division", "Account", "syscreated", "syscreator", "sysmodified", "sysmodifier", "timestamp"}, "Kenmerk", "Waarde"),
    #"Waarde GUIDs geformatteerd" = Table.TransformColumns(#"Draaitabel voor kolommen opgeheven", {
        {"Waarde", each if Text.Length(Text.From(_)) = 36 then "{" & Text.Upper(Text.From(_)) & "}" else Text.From(_), type text}
    }),
    #"Volgorde van kolommen gewijzigd" = Table.ReorderColumns(#"Waarde GUIDs geformatteerd",{"ID", "Division", "Account", "Kenmerk", "Waarde", "syscreated", "syscreator", "sysmodified", "sysmodifier", "timestamp"})
in
    #"Volgorde van kolommen gewijzigd";

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

