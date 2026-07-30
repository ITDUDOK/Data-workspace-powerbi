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
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

from pyspark.sql import functions as F
from pyspark.sql.types import StructType, StructField, IntegerType, StringType
import json, traceback

spark.conf.set("spark.sql.parquet.datetimeRebaseModeInRead", "CORRECTED")
spark.conf.set("spark.sql.parquet.datetimeRebaseModeInWrite", "CORRECTED")

results = {}

spark.sql("CREATE SCHEMA IF NOT EXISTS sourcing")

def run_step(name, fn):
    try:
        df = fn()
        cnt = df.count()
        # DROP + recreate rather than in-place overwrite -- observed to
        # avoid stale SQL-analytics-endpoint column metadata (see
        # nb_sync_hr_management_schemas.py for the incident this pattern
        # was adopted from).
        spark.sql(f"DROP TABLE IF EXISTS sourcing.{name}")
        df.write.format("delta").mode("overwrite").saveAsTable(f"sourcing.{name}")
        results[name] = {"status": "ok", "rows": cnt}
    except Exception as e:
        results[name] = {"status": "error", "error": str(e), "trace": traceback.format_exc()}

# ---- map_officeclassification ----
# Copied verbatim from Sourcing.bim's MAP_OfficeClassification DATATABLE() DAX.
_MAP_OFFICE_CLASSIFICATION = [
    (1, "Horeca"), (6, "Horeca"), (10, "Horeca"), (19, "Horeca"), (37, "Horeca"),
    (21, "Events"), (22, "Events"), (23, "Events"), (24, "Horeca"),
    (38, "Events"), (39, "Events"), (43, "Events"), (44, "Events"),
    (47, "Horeca"),
    (12, "Retail"), (13, "Retail"), (40, "Retail"), (41, "Retail"),
    (42, "Retail"), (45, "Retail"), (46, "Retail"),
    (48, "Patisserie"),
]
def _map_officeclassification():
    schema = StructType([
        StructField("OfficeID", IntegerType(), False),
        StructField("Classification", StringType(), False),
    ])
    return spark.createDataFrame(_MAP_OFFICE_CLASSIFICATION, schema=schema)
run_step("map_officeclassification", _map_officeclassification)

# ---- dim_satisfaction ----
# Decoded from Sourcing.bim's DIM_Satisfaction M source (base64+deflate blob).
# Cijfer kept as string ("3,25" style, nl-NL decimal comma) -- same as the
# legacy model, not reparsed to a number here (low risk, only 5 rows, but do
# NOT silently cast to double downstream without confirming decimal-comma
# handling first).
_DIM_SATISFACTION = [
    ("Heel Onprettig", "1"),
    ("Onprettig", "3,25"),
    ("Normaal", "5,50"),
    ("Prettig", "7,75"),
    ("Heel prettig", "10,00"),
]
def _dim_satisfaction():
    schema = StructType([
        StructField("Satisfaction", StringType(), False),
        StructField("Cijfer", StringType(), False),
    ])
    return spark.createDataFrame(_DIM_SATISFACTION, schema=schema)
run_step("dim_satisfaction", _dim_satisfaction)

# ---- dim_businessline ----
# DISTINCT Classification off map_officeclassification + the "Onbekend"
# fallback value used by the (dropped) FACT_Hours_Summary's BusinessLine
# LOOKUPVALUE/COALESCE logic.
def _dim_businessline():
    src = spark.read.table("sourcing.map_officeclassification")
    base = src.select(F.col("Classification").alias("BusinessLine")).distinct()
    extra = spark.createDataFrame([("Onbekend",)], ["BusinessLine"])
    return base.unionByName(extra).distinct()
run_step("dim_businessline", _dim_businessline)

# ---- managers_table ----
# DISTINCT ManagerFullName off hr_dl_bridge_employees (legacy: SUMMARIZE).
def _managers_table():
    src = spark.read.table("hr_dl_bridge_employees")
    return src.select("ManagerFullName").distinct().filter(F.col("ManagerFullName").isNotNull())
run_step("managers_table", _managers_table)

# ---- verzuimcategorieen ----
# DISTINCT EndContractReasonDescription off gold.employments, unioned with
# 'Actief' (legacy DAX: UNION(ROW("Categorie","Actief"), DISTINCT(...))).
# Only resolvable now that FACT_Employments -> gold.employments is confirmed
# (see .csx header point 1) -- was previously an HR-deferred dead end.
def _verzuimcategorieen():
    src = spark.read.table("dbo.employments")
    base = (src.select(F.col("EndContractReasonDescription").alias("Categorie"))
               .distinct()
               .filter(F.col("Categorie").isNotNull()))
    extra = spark.createDataFrame([("Actief",)], ["Categorie"])
    return base.unionByName(extra).distinct()
run_step("verzuimcategorieen", _verzuimcategorieen)

# ---- write results log ----
try:
    log_text = json.dumps(results, indent=2, default=str)
    mssparkutils.fs.put("Files/sourcing_dl_static_run_log.json", log_text, overwrite=True)
except Exception:
    pass

print(json.dumps({k: v.get("status") for k, v in results.items()}, indent=2))


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
