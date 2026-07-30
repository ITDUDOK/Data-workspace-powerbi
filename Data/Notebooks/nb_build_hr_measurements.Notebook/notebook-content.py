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

import json, traceback

results = {}

def run_step(name, fn):
    try:
        df = fn()
        cnt = df.count()
        df.write.format("delta").mode("overwrite").option("overwriteSchema", "true").saveAsTable(f"hr_dl_{name}")
        results[name] = {"status": "ok", "rows": cnt}
    except Exception as e:
        results[name] = {"status": "error", "error": str(e), "trace": traceback.format_exc()}

# ---- measurements (empty host table for standalone measures) ----
# Same pattern as management_dl_measurements (nb_build_management_static_dl.py) --
# HR's rebuild_hr_directlake.csx assumes this table already exists but it never
# got built for HR. Without it, AddMeasure() skips every measure hosted on it.
run_step("measurements", lambda: spark.createDataFrame([(None,)], "Column: string"))

try:
    log_text = json.dumps(results, indent=2, default=str)
    mssparkutils.fs.put("Files/hr_dl_measurements_log.json", log_text, overwrite=True)
except Exception:
    pass

print(json.dumps({k: v.get("status") for k, v in results.items()}, indent=2))


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
