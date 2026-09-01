# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {}
# META }

# PARAMETERS CELL ********************

SourceTable = "events"
TargetTable = "events"

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }

# CELL ********************

# Atomically publishes SourceTable into TargetTable in this Lakehouse via
# Delta's own overwrite mode. Production use: ADF copies raw source data
# into stg_<name> (destructive overwrite, but that staging table is never
# referenced by any semantic model), then this notebook publishes
# stg_<name> -> <name>. Delta's overwrite commits a new log version
# pointing at freshly-written parquet files -- it never deletes the
# *previous* version's files, so a Direct Lake model still framed against
# the old version keeps working right up until it re-frames onto the new
# one. That's the whole point: ADF's LakehouseTableSink "Overwrite"
# instead drops and recreates the table folder from scratch (confirmed via
# the _delta_log, 2026-09-01), which is why every sync was briefly
# breaking every model reading that table.
#
# SourceTable == TargetTable is also a valid, useful call on its own: it
# forces a fresh Delta version of an existing table without any new data
# (a "re-publish"), which is exactly how this notebook's core mechanism
# was first validated -- read+write the same table and confirm the
# version number goes up while the old parquet file is still there.
#
# Path note: this Lakehouse is schema-enabled -- tables live under
# Tables/dbo/<name>, not Tables/<name>. Missed that on the first pass and
# every read failed with a generic "System_Cancelled_Session_Statements_Failed"
# (no useful detail via the Jobs API) until isolated with a read-only probe.
WORKSPACE_ID = "1f90325e-1060-4c7d-adf4-ccf9fca8b287"
LAKEHOUSE_ID = "097e8f82-835e-4936-a16d-9f6f886d5ef0"
BASE_PATH = f"abfss://{WORKSPACE_ID}@onelake.dfs.fabric.microsoft.com/{LAKEHOUSE_ID}/Tables/dbo"

source_path = f"{BASE_PATH}/{SourceTable}"
target_path = f"{BASE_PATH}/{TargetTable}"

print(f"reading {SourceTable} from {source_path}")
df = spark.read.format("delta").load(source_path)
row_count = df.count()
print(f"row count = {row_count}")

df.write.format("delta").mode("overwrite").option("overwriteSchema", "true").save(target_path)
print(f"atomic overwrite of {TargetTable} at {target_path} complete ({row_count} rows)")

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
