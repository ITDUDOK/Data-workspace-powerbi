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

spark.conf.set("spark.sql.parquet.datetimeRebaseModeInRead", "CORRECTED")
spark.conf.set("spark.sql.parquet.datetimeRebaseModeInWrite", "CORRECTED")

results = {}

# NOTE (2026-07-28): write straight into plain dbo.<name>, no more
# management_dl_ prefix / separate management schema (both were dropped).
def run_step(name, fn):
    try:
        df = fn()
        cnt = df.count()
        df.write.format("delta").mode("overwrite").option("overwriteSchema", "true").saveAsTable(f"dbo.{name}")
        results[name] = {"status": "ok", "rows": cnt}
    except Exception as e:
        results[name] = {"status": "error", "error": str(e), "trace": traceback.format_exc()}

# ---- dim_date ----
def _dim_date():
    df = spark.sql("""
        SELECT explode(sequence(to_date('2020-01-01'), to_date('2026-12-31'), interval 1 day)) AS Date
    """)
    df = (df
        .withColumn("DateString", F.date_format("Date", "dd/MM/yyyy"))
        .withColumn("DayISO", F.dayofyear("Date"))
        .withColumn("DayNumberOfTheWeek", ((F.dayofweek("Date") + 5) % 7) + 1)
        .withColumn("Month", F.month("Date"))
        .withColumn("Quarter", F.quarter("Date"))
        .withColumn("WeekISO", F.weekofyear("Date"))
        .withColumn("YearISO", F.year("Date"))
    )
    dutch_days = {1: "maandag", 2: "dinsdag", 3: "woensdag", 4: "donderdag", 5: "vrijdag", 6: "zaterdag", 7: "zondag"}
    dutch_months = {1: "januari", 2: "februari", 3: "maart", 4: "april", 5: "mei", 6: "juni", 7: "juli",
                     8: "augustus", 9: "september", 10: "oktober", 11: "november", 12: "december"}
    day_map = F.create_map([F.lit(x) for pair in dutch_days.items() for x in pair])
    month_map = F.create_map([F.lit(x) for pair in dutch_months.items() for x in pair])
    df = (df
        .withColumn("DayName", day_map[F.col("DayNumberOfTheWeek")])
        .withColumn("MonthName", month_map[F.col("Month")])
        .withColumn("YearWeekSort", F.concat(F.col("YearISO"), F.lpad(F.col("WeekISO"), 2, "0")))
    )
    # ThisWeekISO: current-week label relative to the notebook's run date,
    # replicating the legacy Power Query M column (Management.bim DIM_Date) --
    # a physical column since Direct Lake can't host it as a calculated column.
    now_row = spark.sql("SELECT weekofyear(current_date()) AS w, year(current_date()) AS y").collect()[0]
    current_week_iso, current_year_iso = now_row["w"], now_row["y"]
    week_label = F.concat(F.lit("Week "), F.col("WeekISO").cast("string"))
    df = df.withColumn(
        "ThisWeekISO",
        F.when((F.col("YearISO") == current_year_iso) & (F.col("WeekISO") == current_week_iso),
               F.concat(week_label, F.lit(" - huidige week")))
         .when((F.col("YearISO") == current_year_iso) & (F.col("WeekISO") == current_week_iso - 1),
               F.concat(week_label, F.lit(" - vorige week")))
         .when((F.col("YearISO") == current_year_iso) & (F.col("WeekISO") == current_week_iso + 1),
               F.concat(week_label, F.lit(" - volgende week")))
         .when((F.lit(current_year_iso) > F.col("YearISO")) & F.lit(current_week_iso == 1) & (F.col("WeekISO") >= 52),
               F.concat(week_label, F.lit(" - vorige week")))
         .when((F.lit(current_year_iso) < F.col("YearISO")) & F.lit(current_week_iso >= 52) & (F.col("WeekISO") == 1),
               F.concat(week_label, F.lit(" - volgende week")))
         .otherwise(week_label)
    )
    return df.select("Date", "DateString", "DayISO", "DayName", "DayNumberOfTheWeek", "Month", "MonthName",
                      "Quarter", "WeekISO", "YearISO", "YearWeekSort", "ThisWeekISO")
run_step("dim_date", _dim_date)

# ---- dim_time ----
def _dim_time():
    rows = []
    parts = [("Nacht", [1,2,3,4,5], 0), ("Ochtend", [6,7,8,9,10,11], 1), ("Middag", [12,13,14,15,16,17], 2), ("Avond", [18,19,20,21,22,23], 3)]
    for name, hours_list, idx in parts:
        for h in hours_list:
            rows.append((name, h, f"{h:02d}:00", idx))
    return spark.createDataFrame(rows, ["Dagdelen", "HourNumber", "Hour", "Index_Dagdelen"])
run_step("dim_time", _dim_time)

# ---- scenario ----
run_step("scenario", lambda: spark.createDataFrame(
    [(1, "Laatste 4 weken"), (2, "Zelfde week vorig jaar")], ["ScenarioID", "ScenarioName"]
))

# ---- correctiefactor ----
run_step("correctiefactor", lambda: spark.createDataFrame(
    [(v,) for v in range(-10, 11)], ["CorrPercent"]
))

# ---- dim_finreportrows ----
run_step("dim_finreportrows", lambda: spark.createDataFrame([
    ("3010", "Omzet", "Omzet - dranken", 1, 1, -1), ("3020", "Omzet", "Omzet - keuken", 1, 2, -1),
    ("3030", "Omzet", "Omzet - patisserie", 1, 3, -1), ("3040", "Omzet", "Omzet - evenementen", 1, 4, -1),
    ("3050", "Omzet", "Omzet - hotellerie", 1, 5, -1), ("3060", "Omzet", "Omzet - overige", 1, 6, -1),
    ("3070", "Omzet", "Omzet - doorbelastingen", 1, 7, -1),
    ("4010", "Inkoopwaarde", "Inkoopwaarde - dranken", 2, 1, 1), ("4020", "Inkoopwaarde", "Inkoopwaarde - keuken", 2, 2, 1),
    ("4030", "Inkoopwaarde", "Inkoopwaarde - patisserie", 2, 3, 1), ("4040", "Inkoopwaarde", "Inkoopwaarde - evenementen", 2, 4, 1),
    ("4060", "Inkoopwaarde", "Inkoopwaarde - overige", 2, 5, 1),
    ("5010", "Personeelskosten", "Salariskosten - vast", 3, 1, 1), ("5012", "Personeelskosten", "Salariskosten - flex", 3, 2, 1),
    ("5013", "Personeelskosten", "Salariskosten - overige", 3, 3, 1), ("5014", "Personeelskosten", "Sociale lasten", 3, 4, 1),
    ("5020", "Afschrijvingen", "Afschrijvingen immateriele vaste activa", 4, 1, 1), ("5021", "Afschrijvingen", "Afschrijvingen materiele vaste activa", 4, 2, 1),
    ("5030", "Huisvestingskosten", "Huisvestingskosten huur", 5, 1, 1), ("5031", "Huisvestingskosten", "Huisvestingskosten energie", 5, 2, 1),
    ("5032", "Huisvestingskosten", "Huisvestingskosten overige", 5, 3, 1),
    ("5040", "Overige bedrijfskosten", "Exploitatiekosten", 6, 1, 1), ("5050", "Overige bedrijfskosten", "Administratie- en algemene kosten", 6, 2, 1),
    ("5051", "Overige bedrijfskosten", "Communicatiekosten", 6, 3, 1), ("5052", "Overige bedrijfskosten", "IT kosten", 6, 4, 1),
    ("5053", "Overige bedrijfskosten", "Accountants/advieskosten", 6, 5, 1), ("5054", "Overige bedrijfskosten", "Verkoopkosten", 6, 6, 1),
    ("5055", "Overige bedrijfskosten", "Autokosten", 6, 7, 1), ("5056", "Overige bedrijfskosten", "Apparatuurkosten", 6, 8, 1),
    ("5057", "Overige bedrijfskosten", "Verzekeringskosten", 6, 9, 1), ("5058", "Overige bedrijfskosten", "Bankkosten", 6, 10, 1),
    ("5059", "Overige bedrijfskosten", "Management fee & shared services", 6, 11, 1),
    ("6010", "Financiele baten/lasten", "Rente bank", 7, 1, 1), ("6020", "Financiele baten/lasten", "Rente overige", 7, 2, 1),
    ("3500", "Buitengewone baten/lasten", "Overige opbrengsten", 8, 1, -1), ("5060", "Buitengewone baten/lasten", "Overige", 8, 2, 1),
    ("9010", "Buitengewone baten/lasten", "Resultaat deelnemingen", 8, 3, -1),
    ("7010", "Belastingen", "Vennootschapsbelasting", 9, 1, 1),
], ["ClassificatieCode", "Hoofdgroep", "Subrij", "SortHoofd", "SortSub", "Teken"]))

# ---- dim_kengetallen ----
run_step("dim_kengetallen", lambda: spark.createDataFrame([
    ("Personeelskosten %", "1"), ("Bruto marge %", "2"), ("Resultaat %", "3"), ("Status", "4")
], ["Kengetal", "SortOrder"]))

# ---- map_division_office ----
run_step("map_division_office", lambda: spark.createDataFrame([
    (2875046, "1", "Dudok Rotterdam B.V."), (2875054, "6", "Dudok Den Haag B.V."),
    (2875055, "10", "Dudok Arnhem B.V."), (2875056, "23", "Dudok aan de Maas B.V."),
    (2875059, "19", "Dudok aan het IJ B.V."), (2875061, "48", "Dudok Patisserie B.V."),
    (2875062, "13", "Dudok Patisserie Rotterdam CS B.V."), (2875063, "12", "Dudok Patisserie Utrecht CS B.V."),
    (2875067, "41", "Dudok Patisserie Meent B.V."), (3554323, "42", "Dudok Patisserie Berkel en Rodenrijs B.V."),
    (10005135, "46", "Dudok Patisserie Den Haag CS B.V."), (10005136, "45", "Dudok Patisserie Leiden CS B.V."),
    (2854203, "37", "Trattoria Sophia B.V."), (2875070, "22", "Dudok CTR B.V."),
    (2875071, "24", "Dudok RDM B.V."), (2889364, "44", "Dudok Van Nelle Fabriek Events B.V."),
    (2875072, "21", "Dudok in het Park B.V."), (3042384, "39", "Dudok Kralingen B.V."),
    (3580698, "43", "Dudok Schiecentrale Events B.V."), (10004630, "47", "Dudok HAKA Events B.V."),
    (2916692, "38", "Dudok Events Holding B.V."), (2875075, "15", "Dudok Horeca Shared Services B.V."),
    (2875064, "11", "Dudok Staffing B.V."), (2875065, "40", "Dudok Retail Holding B.V."),
], ["Division", "OfficeID", "Administratie"]))

# ---- measurements (empty host table for standalone measures) ----
run_step("measurements", lambda: spark.createDataFrame([(None,)], "Column: string"))

# ---- fact_hourlylabour (row-expansion of fact_hours) ----
# 2026-07-28: re-pointed at the real gold-synced dbo.fact_hours / dbo.staff
# (Id casing, not the old management_dl_ ID casing) now that those replace
# the old management_dl_fact_hours/dim_staff staging tables.
def _fact_hourlylabour():
    fact_hours = spark.read.table("dbo.fact_hours")
    staff = spark.read.table("dbo.staff")

    base = (fact_hours
        .filter(F.col("HourEnterNumber").isNotNull() & F.col("HourExitNumber").isNotNull() & (F.col("HourHours") > 0))
        .withColumn("EndHourAdj", F.when(F.col("HourExitNumber") > F.col("HourEnterNumber"), F.col("HourExitNumber")).otherwise(F.col("HourExitNumber") + 24))
    )
    exploded = base.withColumn("Value", F.explode(F.sequence(F.col("HourEnterNumber"), F.col("EndHourAdj") - F.lit(1))))

    staff_rates = staff.select(
        F.col("CardId").cast("long").alias("s_CardId"),
        F.col("OfficeId").cast("string").alias("s_OfficeId"),
        "CardSalaryRate"
    )
    joined = exploded.join(
        staff_rates,
        (exploded.CardId == staff_rates.s_CardId) & (exploded.HourOfficeId == staff_rates.s_OfficeId),
        "left"
    )

    result = (joined
        .withColumn("WorkingHour", F.col("Value") % 24)
        .withColumn("ValidRate", F.when(F.col("CardSalaryRate").isNull() | (F.col("CardSalaryRate") <= 0), F.lit(0.0)).otherwise(F.col("CardSalaryRate")))
        .withColumn("TotalShiftCost", F.col("HourHours") * F.col("ValidRate"))
        .withColumn("WorkingHoursDuration", F.col("EndHourAdj") - F.col("HourEnterNumber"))
        .withColumn("ProportionalCost", F.when(F.col("WorkingHoursDuration") > 0, F.col("TotalShiftCost") / F.col("WorkingHoursDuration")).otherwise(F.lit(0.0)))
        .select(
            F.col("CardId").alias("CardID"), F.col("HourDate"), F.col("HourOfficeId").alias("HourOfficeID"),
            F.col("Value").alias("Value"), F.col("WorkingHour"), F.col("ProportionalCost")
        )
    )
    return result
run_step("fact_hourlylabour", _fact_hourlylabour)

# ---- write results log ----
try:
    log_text = json.dumps(results, indent=2, default=str)
    mssparkutils.fs.put("Files/management_dl_static_run_log.json", log_text, overwrite=True)
except Exception:
    pass

print(json.dumps({k: v.get("status") for k, v in results.items()}, indent=2))


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
