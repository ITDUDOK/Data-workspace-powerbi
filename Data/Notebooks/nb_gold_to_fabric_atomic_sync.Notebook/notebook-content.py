# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {}
# META }

# PARAMETERS CELL ********************

SourceTable = ""
TargetTable = ""
TablePairsJson = "[]"

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# Atomically publishes gold tables into this Lakehouse via Delta's own
# overwrite mode instead of ADF's LakehouseTableSink Overwrite (which
# drops and recreates the table folder from scratch -- confirmed via the
# _delta_log, 2026-09-01). Delta's overwrite commits a new log version
# pointing at freshly-written parquet files without deleting the
# *previous* version's files, so a Direct Lake model still framed against
# the old version keeps working right up until it re-frames onto the new
# one.
#
# Two calling modes:
# - TablePairsJson (batch mode, preferred): a JSON array of
#   {"SourceTable": "...", "TargetTable": "..."} objects, all published in
#   ONE Spark session. Built 2026-09-03 after finding that per-table
#   calls (one notebook job per table) spent most of their wall time on
#   Spark/Livy session startup, not the actual read+write -- 16 separate
#   ~30-90s jobs cost ~30 min total even with zero capacity contention,
#   because every one of them re-pays that startup cost. Batching into a
#   single session amortizes it once across all tables.
# - SourceTable/TargetTable (single-pair mode): kept for pl_atomic_publish_table
#   and any ad-hoc one-off call. Used when TablePairsJson is empty/"[]".
#
# Results are written to Files/atomic_sync_results/latest.json (overwritten
# each run -- safe because pl_dudodata_gold_to_fabric has concurrency:1, so
# only one publish batch is ever in flight) so the calling ADF pipeline can
# log per-table success/failure into meta.pipeline_log without needing a
# separate Spark session per table just to find out what happened.
import json

WORKSPACE_ID = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"
LAKEHOUSE_ID = "097e8f82-835e-4936-a16d-9f6f886d5ef0"
BASE_PATH = f"abfss://{WORKSPACE_ID}@onelake.dfs.fabric.microsoft.com/{LAKEHOUSE_ID}/Tables/dbo"
FILES_PATH = f"abfss://{WORKSPACE_ID}@onelake.dfs.fabric.microsoft.com/{LAKEHOUSE_ID}/Files"

pairs = json.loads(TablePairsJson) if TablePairsJson and TablePairsJson != "[]" else []
if not pairs:
    pairs = [{"SourceTable": SourceTable, "TargetTable": TargetTable}]

results = []
for pair in pairs:
    src = pair["SourceTable"]
    tgt = pair["TargetTable"]
    source_path = f"{BASE_PATH}/{src}"
    target_path = f"{BASE_PATH}/{tgt}"
    try:
        print(f"[{tgt}] reading {src} from {source_path}")
        df = spark.read.format("delta").load(source_path)
        row_count = df.count()
        df.write.format("delta").mode("overwrite").option("overwriteSchema", "true").save(target_path)
        print(f"[{tgt}] atomic overwrite complete ({row_count} rows)")
        results.append({"TableName": tgt, "Status": "Success", "RowsProcessed": row_count, "Error": None})
    except Exception as e:
        print(f"[{tgt}] FAILED: {type(e).__name__}: {e}")
        results.append({"TableName": tgt, "Status": "Failed", "RowsProcessed": None, "Error": f"{type(e).__name__}: {e}"})

print("\n=== SUMMARY ===")
for r in results:
    print(r)

mssparkutils.fs.put(f"{FILES_PATH}/atomic_sync_results/latest.json", json.dumps(results, indent=2), overwrite=True)

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
