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
from pyspark.sql.window import Window
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

# ---- bridge_employees: add SeniorityDate ----
# Legacy BRIDGE EMPLOYEES M-code (HR_BIM.bim ~line 15547-15556) takes the
# latest FACT_Employments row per employeeId (sort startDate desc, then
# changedDate desc) and exposes its seniorityDate. dbo.employments already
# carries this column raw -- gold just never surfaced it onto
# hr_dl_bridge_employees when it was enriched with the other legacy-parity
# columns (EmployeeStartDate/EmploymentEndDate/etc) in an earlier session.
# Confirmed via SQL sample that bridge_employees[HRContractStartDate]
# (sourced from employees_enriched.ContractStartDate) does NOT already
# fold SeniorityDate in -- it's the raw latest HR contract start only.
def _bridge_employees_seniority():
    bridge = spark.read.table("hr_dl_bridge_employees")
    employments = spark.read.table("dbo.employments")
    w = Window.partitionBy("EmployeeId").orderBy(F.col("StartDate").desc(), F.col("ChangedDate").desc())
    latest_seniority = (
        employments
        .withColumn("_rn", F.row_number().over(w))
        .filter(F.col("_rn") == 1)
        .select(F.col("EmployeeId").alias("employeeId"), F.col("SeniorityDate"))
    )
    return bridge.join(latest_seniority, "employeeId", "left")

run_step("bridge_employees", _bridge_employees_seniority)

try:
    log_text = json.dumps(results, indent=2, default=str)
    mssparkutils.fs.put("Files/hr_dl_seniority_log.json", log_text, overwrite=True)
except Exception:
    pass

print(json.dumps({k: v.get("status") for k, v in results.items()}, indent=2))


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
