# Fabric notebook source

# METADATA ********************

# META {
# META   "kernel_info": {
# META     "name": "synapse_pyspark"
# META   },
# META   "dependencies": {
# META     "lakehouse": {
# META       "default_lakehouse": "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d",
# META       "default_lakehouse_name": "lh_dudodata_exactonline",
# META       "default_lakehouse_workspace_id": "1f90325e-1060-4c7d-adf4-ccf9fca8b287",
# META       "known_lakehouses": [
# META         {
# META           "id": "380445e2-5d18-4ef6-b3f0-2b4aab5bea0d"
# META         }
# META       ]
# META     }
# META   }
# META }

# CELL ********************

# nb_purge_deleted_gl -- verwijdert uit lakehouse.GLTransactions de OPEN boekingsregels (Status 20) die in Exact
# niet meer bestaan. De GL-dataflow werkt Append-only op sysmodified; verwijderde boekingen blijven daardoor staan.
# Input: GLTransactions_Window (dataflow "Exact Online GL Window": alle huidige IDs van de laatste 150 dagen).
# Draaivolgorde in ExactOnlinePipe_Data: GL-dataflow -> nb_dedup -> "Exact Online GL Window" -> DIT -> nb_build_exactonline.
from pyspark.sql import functions as F
from delta.tables import DeltaTable
import json, datetime

DRY_RUN = False             # eerst True draaien, Files/purge_deleted_gl_log.json beoordelen, dan False
LOOKBACK_DAYS = 150        # gelijk aan de dataflow
BUFFER_DAYS = 2            # randmarge i.v.m. tijdzone/venstergrens
MIN_COVERAGE = 0.8         # per administratie: window moet >= 80% bevatten van wat de lakehouse in dat venster heeft
MAX_DELETE_SHARE = 0.05    # nooit meer dan 5% van de venster-rijen in 1 run verwijderen

import traceback
try:
    spark.conf.set("spark.sql.parquet.datetimeRebaseModeInRead", "CORRECTED")
    spark.conf.set("spark.sql.parquet.datetimeRebaseModeInWrite", "CORRECTED")

    win = spark.read.table("GLTransactions_Window")
    gl = spark.read.table("GLTransactions")
    start = F.date_sub(F.current_date(), LOOKBACK_DAYS - BUFFER_DAYS)

    win_n = win.count()
    if win_n == 0:
        raise Exception("GLTransactions_Window is leeg - geen verwijdering uitgevoerd")

    win_div = win.groupBy("Division").agg(F.count("*").alias("win_n"))
    lh_div = gl.where(F.col("EntryDate") >= start).groupBy("Division").agg(F.count("*").alias("lh_n"))
    cov = win_div.join(lh_div, "Division", "left").fillna(0, ["lh_n"])
    cov = cov.withColumn("ok", F.col("win_n") >= MIN_COVERAGE * F.col("lh_n"))
    ok_divs = [r["Division"] for r in cov.where("ok").collect()]
    skipped = [r["Division"] for r in cov.where("not ok").collect()]

    # Alleen status 20 (open): verwerkte boekingen (50) kunnen in Exact niet verwijderd worden.
    cand = (gl.where((F.col("EntryDate") >= start) & (F.col("Status") == 20) & F.col("Division").isin(ok_divs))
              .join(win.select("ID").distinct(), "ID", "left_anti"))
    to_del = cand.select("ID").distinct().cache()
    n_del = to_del.count()
    detail = [r.asDict() for r in cand.groupBy("Division", "ReportingPeriod")
              .agg(F.count("*").alias("rows"), F.round(F.sum("AmountFC"), 2).alias("sum_amount")).collect()]

    if n_del > MAX_DELETE_SHARE * win_n:
        raise Exception(f"Veiligheidsstop: {n_del} te verwijderen rijen > {MAX_DELETE_SHARE:.0%} van {win_n}")

    if not DRY_RUN and n_del > 0:
        DeltaTable.forName(spark, "GLTransactions").alias("t").merge(
            to_del.alias("s"), "t.ID = s.ID").whenMatchedDelete().execute()

    log = {"run_utc": datetime.datetime.utcnow().isoformat(), "dry_run": DRY_RUN, "window_rows": win_n,
           "ids_to_delete": n_del, "skipped_divisions": skipped, "detail": detail}
    mssparkutils.fs.put("Files/purge_deleted_gl_log.json", json.dumps(log, indent=2, default=str), overwrite=True)
    print(json.dumps(log, indent=2, default=str))

except Exception as _e:
    mssparkutils.fs.put("Files/purge_deleted_gl_error.json", json.dumps({"error": str(_e), "trace": traceback.format_exc()}, indent=2), overwrite=True)
    raise


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
