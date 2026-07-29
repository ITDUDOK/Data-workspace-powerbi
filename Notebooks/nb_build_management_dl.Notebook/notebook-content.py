# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "097e8f82-835e-4936-a16d-9f6f886d5ef0",
# META       "default_lakehouse_name": "lh_dudodata_gold_powerbi",
# META       "default_lakehouse_workspace_id": "1f90325e-1060-4c7d-adf4-ccf9fca8b287",
# META       "known_lakehouses": [
# META         {
# META           "id": "097e8f82-835e-4936-a16d-9f6f886d5ef0"
# META         },
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
spark.conf.set("spark.sql.parquet.int96RebaseModeInRead", "CORRECTED")
spark.conf.set("spark.sql.parquet.int96RebaseModeInWrite", "CORRECTED")

results = {}

# NOTE (2026-07-28): the "management" schema and its dbo.management_dl_*
# staging tables were dropped from the lakehouse. Rebuilding directly into
# plain dbo.<name> tables now, single-table, no prefix/schema layer. Only
# the 4 tables below still have no other source (everything else this
# notebook used to build -- dim_center, dim_product, fact_sales, etc. --
# is now served by the real gold-SQL dbo tables synced via
# pl_dudodata_gold_to_fabric; do NOT resurrect those run_step calls here,
# it would silently regress them to this notebook's older logic).
def run_step(name, fn):
    try:
        df = fn()
        cnt = df.count()
        df.write.format("delta").mode("overwrite").option("overwriteSchema", "true").saveAsTable(f"dbo.{name}")
        results[name] = {"status": "ok", "rows": cnt}
    except Exception as e:
        results[name] = {"status": "error", "error": str(e), "trace": traceback.format_exc()}

events = spark.read.table("dbo.events")

# cross-lakehouse (exactonline) reads via known_lakehouse three-part name
gl_accounts = spark.read.table("lh_dudodata_exactonline.dbo.GLAccounts")
gl_schema_structures = spark.read.table("lh_dudodata_exactonline.dbo.GLAccountSchemaStructures")
gl_transactions = spark.read.table("lh_dudodata_exactonline.dbo.GLTransactions")
division_period_status = spark.read.table("lh_dudodata_exactonline.dbo.DivisionPeriodStatus")

# ---- dim_divisionperiodstatus (cross-lakehouse passthrough) ----
run_step("dim_divisionperiodstatus", lambda: division_period_status.select(
    "Division", "FinYear", "FinPeriod", "YearPeriodStatus", "Journal"
))

# ---- fact_eventstable ----
def _fact_eventstable():
    ev = events.select(
        F.col("EventId").cast("long").alias("event_id"),
        F.col("EventName").alias("event_name"),
        F.col("Status").alias("event_status"),
        F.col("DatetimeStart").alias("event_start"),
        F.col("DatetimeEnd").alias("event_end"),
        F.col("Guests").alias("event_guests"),
        F.col("CompanyId").cast("long").alias("company_id"),
        F.col("PlannerId").cast("long").alias("planner_id"),
        F.col("ClientId").cast("long").alias("client_id"),
        F.col("SpaceId").alias("location_id"),
        F.col("TotalPrice").alias("event_total_price"),
        F.col("TotalPriceExclVat").alias("event_total_price_excl_vat"),
        F.col("Url").alias("event_url"),
        F.col("CreatedAt").alias("created"),
        F.col("UpdatedAt").alias("updated"),
        F.col("BookingId").alias("booking_id"),
        F.col("Reference").alias("reference"),
        F.col("EventTypeId").cast("long").alias("event_type_id"),
        F.col("Locale").alias("locale"),
    )
    mapping_rows = [
        (2676, "1"), (2834, "6"), (2835, "10"), (2811, "19"), (1568, "21"), (2592, "23"),
        (2591, "24"), (2810, "37"), (2590, "38"), (2593, "38"), (2080, "43"), (3154, "44"), (3291, "47"),
    ]
    mapping = spark.createDataFrame(mapping_rows, ["company_id", "OfficeID"]).withColumn("company_id", F.col("company_id").cast("long"))
    return (ev.join(mapping, on="company_id", how="left")
        .withColumn("EventDate", F.to_date("event_start"))
        .withColumn("CancelledTimestamp", F.lit(None).cast("timestamp"))
        .withColumn("ConfirmedTimestamp", F.lit(None).cast("timestamp"))
        .withColumn("cancellation_reason", F.lit(None).cast("string"))
        .withColumn("cancellation_note", F.lit(None).cast("string")))
run_step("fact_eventstable", _fact_eventstable)

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

# ---- write results log ----
try:
    log_text = json.dumps(results, indent=2, default=str)
    mssparkutils.fs.put("Files/management_dl_run_log.json", log_text, overwrite=True)
except Exception:
    pass

print(json.dumps({k: v.get("status") for k, v in results.items()}, indent=2))


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
