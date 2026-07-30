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

# Diagnostic: is the SQL-analytics-endpoint staleness specific to reusing
# the "hr.bridge_employees" name (residual state from earlier syncs), or a
# general indexing delay? Write to a brand-new never-used table name and
# report columns/rows immediately, so it can be checked from outside this
# notebook without guessing at timing.
import json
df = spark.read.table("dbo.hr_dl_bridge_employees")
spark.sql("DROP TABLE IF EXISTS hr.diag_bridge_test")
df.write.format("delta").mode("overwrite").saveAsTable("hr.diag_bridge_test")
result = {"columns": len(df.columns), "rows": df.count()}
mssparkutils.fs.put("Files/diag_schema_sync_log.json", json.dumps(result), overwrite=True)
print(json.dumps(result))

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
