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
import json, traceback

spark.conf.set("spark.sql.parquet.datetimeRebaseModeInRead", "CORRECTED")
spark.conf.set("spark.sql.parquet.datetimeRebaseModeInWrite", "CORRECTED")

results = {}

spark.sql("CREATE SCHEMA IF NOT EXISTS retail")

def run_step(name, fn):
    try:
        df = fn()
        cnt = df.count()
        # DROP + recreate rather than in-place overwrite -- an in-place
        # overwrite of an existing schema-qualified table was observed to
        # leave the SQL analytics endpoint's column metadata stale (Spark
        # itself read back the correct new schema, but sys.columns via the
        # SQL endpoint kept showing the old column list even after 3+ min).
        spark.sql(f"DROP TABLE IF EXISTS retail.{name}")
        df.write.format("delta").mode("overwrite").saveAsTable(f"retail.{name}")
        results[name] = {"status": "ok", "rows": cnt}
    except Exception as e:
        results[name] = {"status": "error", "error": str(e), "trace": traceback.format_exc()}

# ---- fact_predictedcakesales ----
# Straight select/rename off gold.predicted_cake_sales. Column-for-column
# match against legacy FACT_PredictedCakeSales -- no transformation logic.
def _fact_predictedcakesales():
    src = spark.read.table("dbo.predicted_cake_sales")
    return src.select(
        F.col("PredictionDate"),
        F.col("PredictedSales").cast("double"),
        F.col("CakeType"),
        F.col("Location"),
        F.col("BatchId"),
        F.col("CreatedDate"),
        F.col("ModelType"),
        F.col("SizeCategory"),
    )
run_step("fact_predictedcakesales", _fact_predictedcakesales)

# ---- dim_cakes ----
# DISTINCT CakeType off predicted_cake_sales -- the only physical source
# available (see header note: this is a KNOWN PARTIAL replacement, historic
# cake types are not represented here).
def _dim_cakes():
    src = spark.read.table("dbo.predicted_cake_sales")
    return src.select("CakeType").distinct().filter(F.col("CakeType").isNotNull())
run_step("dim_cakes", _dim_cakes)

# ---- write results log ----
try:
    log_text = json.dumps(results, indent=2, default=str)
    mssparkutils.fs.put("Files/retail_dl_static_run_log.json", log_text, overwrite=True)
except Exception:
    pass

print(json.dumps({k: v.get("status") for k, v in results.items()}, indent=2))


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
