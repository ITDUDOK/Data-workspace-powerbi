# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {}
# META }

# CELL ********************

print("spark session alive:", spark.version)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

from pyspark.sql import Window
from pyspark.sql import functions as F

# PurchaseOrders has some ancient/placeholder date values (pre-1900) in one
# of its date columns; Spark 3's ambiguity check on Parquet's legacy hybrid
# calendar vs the Proleptic Gregorian calendar refuses to read/rewrite them
# by default. Read/write the raw value as-is, no calendar rebase.
spark.conf.set("spark.sql.parquet.datetimeRebaseModeInRead", "CORRECTED")
spark.conf.set("spark.sql.parquet.datetimeRebaseModeInWrite", "CORRECTED")
spark.conf.set("spark.sql.parquet.int96RebaseModeInRead", "CORRECTED")
spark.conf.set("spark.sql.parquet.int96RebaseModeInWrite", "CORRECTED")

WORKSPACE_ID = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"
LAKEHOUSE_ID = "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"
BASE_PATH = f"abfss://{WORKSPACE_ID}@onelake.dfs.fabric.microsoft.com/{LAKEHOUSE_ID}/Tables"
FILES_PATH = f"abfss://{WORKSPACE_ID}@onelake.dfs.fabric.microsoft.com/{LAKEHOUSE_ID}/Files"

# Tables that use the incremental watermark + Append pattern in
# ExactOnlinePipe_Data. Append means a row that gets touched again in Exact
# lands as a *new* row instead of replacing the old one, so duplicates
# accumulate over time. This dedups each table by keeping, per ID, only the
# row with the most recent sysmodified.
TABLES = [
    "PurchaseOrders",
    "PurchaseTransactions",
    "SalesOrders",
    "SalesOrderLines",
    "SalesTransactions",
    "StockCounts",
    "StockEntries",
    "StockPlanning",
    "StockTransactions",
    "ShopOrderRoutingStepPlans",
    "ShopOrderMaterialPlans",
    "GLTransactions",
]

results = []
for table in TABLES:
    path = f"{BASE_PATH}/{table}"
    try:
        print(f"[{table}] reading from {path}")
        df = spark.read.format("delta").load(path)
        before = df.count()
        print(f"[{table}] before={before}")

        w = Window.partitionBy("ID").orderBy(F.col("sysmodified").desc())
        deduped = (
            df.withColumn("_rn", F.row_number().over(w))
              .filter(F.col("_rn") == 1)
              .drop("_rn")
        )
        after = deduped.count()
        print(f"[{table}] after={after}, removing {before - after} duplicates")

        deduped.write.format("delta").mode("overwrite").option("overwriteSchema", "true").save(path)
        print(f"[{table}] write OK")

        results.append((table, before, after, before - after, "OK"))
    except Exception as e:
        print(f"[{table}] FAILED: {type(e).__name__}: {e}")
        results.append((table, None, None, None, f"FAILED: {e}"))

print("\n=== SUMMARY ===")
for table, before, after, removed, status in results:
    print(f"{table}: {status} ({before} -> {after}, removed {removed})")

# persist results as JSON under Files/ (readable via plain OneLake DFS API)
# since stdout isn't reachable via the REST API and Delta writes under
# Tables/ via .save() don't auto-register in the SQL analytics endpoint.
import json as _json
log_text = _json.dumps([
    {"table": t, "before": before, "after": after, "removed": removed, "status": status}
    for t, before, after, removed, status in results
], indent=2)
mssparkutils.fs.put(f"{FILES_PATH}/dedup_log.json", log_text, overwrite=True)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
