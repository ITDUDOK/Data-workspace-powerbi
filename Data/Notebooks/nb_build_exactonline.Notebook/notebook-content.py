# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d",
# META       "default_lakehouse_name": "lh_dudodata_exactonline",
# META       "default_lakehouse_workspace_id": "1f90325e-1060-4c7d-adf4-ccf9fca8b287",
# META       "known_lakehouses": [
# META         {
# META           "id": "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

from pyspark.sql import functions as F
from pyspark.sql.window import Window
import json, traceback

spark.conf.set("spark.sql.parquet.datetimeRebaseModeInRead", "CORRECTED")
spark.conf.set("spark.sql.parquet.datetimeRebaseModeInWrite", "CORRECTED")

results = {}

def run_step(name, fn):
    try:
        df = fn()
        cnt = df.count()
        # No schema prefix at all -- lh_dudodata_exactonline is this notebook's
        # default lakehouse, and "dbo" isn't a resolvable namespace for writes
        # here (SCHEMA_NOT_FOUND) even though bare reads work fine without it.
        df.write.format("delta").mode("overwrite").option("overwriteSchema", "true").saveAsTable(name)
        results[name] = {"status": "ok", "rows": cnt}
    except Exception as e:
        results[name] = {"status": "error", "error": str(e), "trace": traceback.format_exc()}

# ---- source tables (bare names -- default lakehouse context) ----
gl_accounts = spark.read.table("GLAccounts")
gl_schema_structures = spark.read.table("GLAccountSchemaStructures")
gl_transactions = spark.read.table("GLTransactions")

# ---- glaccounts_fin ----
def _glaccounts_fin():
    gla_cols = gl_accounts.select("Division", "ID", "Code", "Description")
    filter_schema = gl_schema_structures.filter(F.col("Schema") == "44df1d98-0304-4125-a0a7-f3b4c71a9d73")
    schema_with_code = (filter_schema.join(gla_cols, filter_schema.GLAccountId == gla_cols.ID, "inner")
        .select(filter_schema["*"], gla_cols["Code"].alias("AccountCode")))
    w = Window.partitionBy("AccountCode").orderBy("SchemaElementCode")
    code_mapping = (schema_with_code.withColumn("rn", F.row_number().over(w))
        .filter(F.col("rn") == 1).select("AccountCode", "SchemaElementCode"))
    joined = (gla_cols.join(code_mapping, gla_cols.Code == code_mapping.AccountCode, "left")
        .select(gla_cols["Division"], gla_cols["ID"], gla_cols["Code"], gla_cols["Description"],
                code_mapping["SchemaElementCode"].alias("ClassificatieCode")))
    w2 = Window.partitionBy("Division", "ID").orderBy(F.lit(1))
    return (joined.withColumn("rn2", F.row_number().over(w2))
        .filter(F.col("rn2") == 1).drop("rn2"))
run_step("glaccounts_fin", _glaccounts_fin)

# ---- gltransacties_fin ----
def _gltransacties_fin():
    return gl_transactions.select(
        "EntryDate",
        F.lower(F.regexp_replace(F.regexp_replace(F.col("GLAccount").cast("string"), "\\{", ""), "\\}", "")).alias("GLAccount"),
        F.col("AmountFC").cast("double").alias("AmountFC"),
        "Division", "ReportingPeriod", "Status"
    )
run_step("gltransacties_fin", _gltransacties_fin)

# ---- finreportrows (static P&L classification lookup) ----
run_step("finreportrows", lambda: spark.createDataFrame([
    ("3010", "Omzet", "Omzet - dranken", 1, 1, -1), ("3020", "Omzet", "Omzet - keuken", 1, 2, -1),
    ("3030", "Omzet", "Omzet - patisserie", 1, 3, -1), ("3040", "Omzet", "Omzet - evenementen", 1, 4, -1),
    ("3050", "Omzet", "Omzet - hotellerie", 1, 5, -1), ("3060", "Omzet", "Omzet - overige", 1, 6, -1),
    ("3070", "Omzet", "Omzet - doorbelastingen", 1, 7, -1),
    ("4010", "Inkoopwaarde", "Inkoopwaarde - dranken", 2, 1, 1), ("4020", "Inkoopwaarde", "Inkoopwaarde - keuken", 2, 2, 1),
    ("4030", "Inkoopwaarde", "Inkoopwaarde - patisserie", 2, 3, 1), ("4040", "Inkoopwaarde", "Inkoopwaarde - evenementen", 2, 4, 1),
    ("4060", "Inkoopwaarde", "Inkoopwaarde - overige", 2, 5, 1),
    ("5010", "Personeelskosten", "Salariskosten - vast", 3, 1, 1), ("5012", "Personeelskosten", "Salariskosten - flex", 3, 2, 1),
    ("5013", "Personeelskosten", "Salariskosten - overige", 3, 3, 1), ("5014", "Personeelskosten", "Sociale lasten", 3, 4, 1),
    ("5020", "Afschrijvingen", "Afschrijvingen immateriele vaste activa", 4, 1, 1), ("5021", "Afschrijvingen", "Afschrijvingen materiele vaste activa", 4, 2, 1),
    ("5030", "Huisvestingskosten", "Huisvestingskosten huur", 5, 1, 1), ("5031", "Huisvestingskosten", "Huisvestingskosten energie", 5, 2, 1),
    ("5032", "Huisvestingskosten", "Huisvestingskosten overige", 5, 3, 1),
    ("5040", "Overige bedrijfskosten", "Exploitatiekosten", 6, 1, 1), ("5050", "Overige bedrijfskosten", "Administratie- en algemene kosten", 6, 2, 1),
    ("5051", "Overige bedrijfskosten", "Communicatiekosten", 6, 3, 1), ("5052", "Overige bedrijfskosten", "IT kosten", 6, 4, 1),
    ("5053", "Overige bedrijfskosten", "Accountants/advieskosten", 6, 5, 1), ("5054", "Overige bedrijfskosten", "Verkoopkosten", 6, 6, 1),
    ("5055", "Overige bedrijfskosten", "Autokosten", 6, 7, 1), ("5056", "Overige bedrijfskosten", "Apparatuurkosten", 6, 8, 1),
    ("5057", "Overige bedrijfskosten", "Verzekeringskosten", 6, 9, 1), ("5058", "Overige bedrijfskosten", "Bankkosten", 6, 10, 1),
    ("5059", "Overige bedrijfskosten", "Management fee & shared services", 6, 11, 1),
    ("6010", "Financiele baten/lasten", "Rente bank", 7, 1, 1), ("6020", "Financiele baten/lasten", "Rente overige", 7, 2, 1),
    ("3500", "Buitengewone baten/lasten", "Overige opbrengsten", 8, 1, -1), ("5060", "Buitengewone baten/lasten", "Overige", 8, 2, 1),
    ("9010", "Buitengewone baten/lasten", "Resultaat deelnemingen", 8, 3, -1),
    ("7010", "Belastingen", "Vennootschapsbelasting", 9, 1, 1),
], ["ClassificatieCode", "Hoofdgroep", "Subrij", "SortHoofd", "SortSub", "Teken"]))

# ---- write results log ----
try:
    log_text = json.dumps(results, indent=2, default=str)
    mssparkutils.fs.put("Files/exactonline_gold_run_log.json", log_text, overwrite=True)
except Exception:
    pass

print(json.dumps(results, indent=2, default=str))


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
