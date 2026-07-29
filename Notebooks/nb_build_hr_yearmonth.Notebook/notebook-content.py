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

results = {}

def run_step(name, fn):
    try:
        df = fn()
        cnt = df.count()
        df.write.format("delta").mode("overwrite").option("overwriteSchema", "true").saveAsTable(f"hr_dl_{name}")
        results[name] = {"status": "ok", "rows": cnt}
    except Exception as e:
        results[name] = {"status": "error", "error": str(e), "trace": traceback.format_exc()}

# ---- fact_cumulative: add YearMonth ----
# dbo.cumulative.YearMonth exists as a date (e.g. 2026-07-01) but was never
# selected into hr_dl_fact_cumulative. NOTE: legacy FACT_Cumulative[YearMonth]
# was an Int64 YYYYMM, but hr_dl_dim_date[YearMonth] (the relationship
# target, already deployed from an earlier session) is physically a
# zero-padded "YYYY-MM" string (checked via INFORMATION_SCHEMA + sample
# data) -- match THAT format, not the legacy int encoding, since the
# relationship is what actually needs to resolve.
# YearWeek/WeekNumber/MonthNumber/Year/PeriodType are NOT added -- the new
# dbo.cumulative source only tracks month-level snapshots, there is no
# week-level data to derive them from (genuine gap, not carried across).
#
# IMPORTANT: dbo.cumulative is NOT one row per CardID -- it's one row per
# CardID per YearMonth (up to 79 months of history per employee, 30484
# total rows for 406 cards), and hr_dl_fact_cumulative was already built at
# that same full row grain (just without YearMonth carried across). A join
# back onto the existing hr_dl_fact_cumulative by CardID alone would fan
# out ~79x per employee. Rebuilding fresh from the same source expression
# as the original nb_build_hr_dl.py select (just with YearMonth added) is
# the only safe way to add this column at the correct grain.
cumulative_src = spark.read.table("dbo.cumulative")
offices_src = spark.read.table("dbo.offices")

def _fact_cumulative_yearmonth():
    return (
        cumulative_src.alias("c").join(offices_src.alias("o"), F.col("c.OfficeId") == F.col("o.OfficeId"), "left")
        .select(
            F.col("c.OfficeId").alias("OfficeID"), F.col("o.OfficeName").alias("OfficeName"),
            F.col("c.CardId").alias("CardID"), F.col("c.CummOverHours"), F.col("c.CummHolidayHours"),
            F.col("c.CummCompensationHours"), F.col("c.SourcePeriod").alias("Period"),
            F.date_format("c.YearMonth", "yyyy-MM").alias("YearMonth")
        )
    )

run_step("fact_cumulative", _fact_cumulative_yearmonth)

try:
    log_text = json.dumps(results, indent=2, default=str)
    mssparkutils.fs.put("Files/hr_dl_yearmonth_log.json", log_text, overwrite=True)
except Exception:
    pass

print(json.dumps({k: v.get("status") for k, v in results.items()}, indent=2))


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
