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

spark.conf.set("spark.sql.parquet.datetimeRebaseModeInRead", "CORRECTED")
spark.conf.set("spark.sql.parquet.datetimeRebaseModeInWrite", "CORRECTED")
spark.conf.set("spark.sql.parquet.int96RebaseModeInRead", "CORRECTED")
spark.conf.set("spark.sql.parquet.int96RebaseModeInWrite", "CORRECTED")

results = {}

spark.sql("CREATE SCHEMA IF NOT EXISTS hr")
spark.sql("CREATE SCHEMA IF NOT EXISTS management")

def sync_prefix(prefix, schema):
    tables = [t.name for t in spark.catalog.listTables("dbo") if t.name.startswith(prefix)]
    for full_name in tables:
        target = full_name[len(prefix):]
        try:
            df = spark.read.table(f"dbo.{full_name}")
            cnt = df.count()
            df.write.format("delta").mode("overwrite").option("overwriteSchema", "true").saveAsTable(f"{schema}.{target}")
            results[f"{schema}.{target}"] = {"status": "ok", "rows": cnt, "source": f"dbo.{full_name}"}
        except Exception as e:
            results[f"{schema}.{target}"] = {"status": "error", "error": str(e), "trace": traceback.format_exc()}

def sync_one_dropfirst(full_name, schema, prefix):
    target = full_name[len(prefix):]
    try:
        spark.sql(f"REFRESH TABLE dbo.{full_name}")
        df = spark.read.table(f"dbo.{full_name}")
        src_cols = len(df.columns)
        cnt = df.count()
        spark.sql(f"DROP TABLE IF EXISTS {schema}.{target}")
        df.write.format("delta").mode("overwrite").saveAsTable(f"{schema}.{target}")
        written_cols = len(spark.read.table(f"{schema}.{target}").columns)
        results[f"{schema}.{target}"] = {
            "status": "ok", "rows": cnt, "source": f"dbo.{full_name}",
            "source_columns": src_cols, "written_columns": written_cols
        }
    except Exception as e:
        results[f"{schema}.{target}"] = {"status": "error", "error": str(e), "trace": traceback.format_exc()}

sync_one_dropfirst("hr_dl_bridge_employees", "hr", "hr_dl_")
sync_one_dropfirst("hr_dl_dim_date", "hr", "hr_dl_")
sync_one_dropfirst("management_dl_dim_productgroup", "management", "management_dl_")

try:
    log_text = json.dumps(results, indent=2, default=str)
    mssparkutils.fs.put("Files/sync_hr_management_schemas_log.json", log_text, overwrite=True)
except Exception:
    pass

print(json.dumps({k: v.get("status") for k, v in results.items()}, indent=2))

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
