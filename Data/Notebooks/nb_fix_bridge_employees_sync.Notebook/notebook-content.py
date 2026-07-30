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

# Step 2: hr.bridge_employees_fixed confirmed synced correctly (35 cols,
# 1507 rows, verified via SQL analytics endpoint). Now swap it into the
# real name: drop the stuck hr.bridge_employees, rename the fixed one in.
import json
spark.sql("DROP TABLE IF EXISTS hr.bridge_employees")
spark.sql("ALTER TABLE hr.bridge_employees_fixed RENAME TO hr.bridge_employees")
result = {"renamed": True}
mssparkutils.fs.put("Files/fix_bridge_employees_log.json", json.dumps(result), overwrite=True)
print(json.dumps(result))

# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
