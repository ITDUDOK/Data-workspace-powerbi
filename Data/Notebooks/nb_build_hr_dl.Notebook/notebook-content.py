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
spark.conf.set("spark.sql.parquet.int96RebaseModeInRead", "CORRECTED")
spark.conf.set("spark.sql.parquet.int96RebaseModeInWrite", "CORRECTED")

results = {}

def run_step(name, fn):
    try:
        df = fn()
        cnt = df.count()
        df.write.format("delta").mode("overwrite").option("overwriteSchema", "true").saveAsTable(f"hr_dl_{name}")
        results[name] = {"status": "ok", "rows": cnt}
    except Exception as e:
        results[name] = {"status": "error", "error": str(e), "trace": traceback.format_exc()}

departments = spark.read.table("dbo.departments")
freedays = spark.read.table("dbo.freedays")
functions_t = spark.read.table("dbo.functions")
hr_contracts = spark.read.table("dbo.hr_contracts")
hours = spark.read.table("dbo.hours")
offices = spark.read.table("dbo.offices")
prognosis = spark.read.table("dbo.prognosis")
teams = spark.read.table("dbo.teams")
types_t = spark.read.table("dbo.types")
planning = spark.read.table("dbo.planning")
sickness = spark.read.table("dbo.sickness")
satisfaction = spark.read.table("dbo.satisfaction")
mutations = spark.read.table("dbo.mutations")
companies = spark.read.table("dbo.companies")
debtors = spark.read.table("dbo.debtors")
employee_managers = spark.read.table("dbo.employee_managers")
contracts = spark.read.table("dbo.contracts")
centers = spark.read.table("dbo.centers")
center_classification = spark.read.table("dbo.center_classification")
staff = spark.read.table("dbo.staff")
cumulative = spark.read.table("dbo.cumulative")
employee_schedule_current = spark.read.table("dbo.employee_schedule_current")
debtor_managers = spark.read.table("dbo.debtor_managers")
hr_functions = spark.read.table("dbo.hr_functions")
debtor_functions = spark.read.table("dbo.debtor_functions")
employees_enriched = spark.read.table("dbo.employees_enriched")
dates = spark.read.table("dbo.dates")
employments = spark.read.table("dbo.employments")

# ---- dim_departments ----
run_step("dim_departments", lambda: departments.select(
    F.col("OfficeId").alias("OfficeID"), F.col("DepartmentId").alias("DepartmentID"), "DepartmentName"
))

# ---- fact_freedays ----
run_step("fact_freedays", lambda: freedays.select(
    F.col("OfficeId").alias("OfficeID"), "OfficeName", F.col("CardId").alias("CardID"),
    F.col("FreedayId").alias("FreedayID"), "FreedayStart", "FreedayEnd", "FreedayDays", "FreedayType",
    "FreedayHours", "FreedayRemarks"
))

# ---- dim_functions ----
run_step("dim_functions", lambda: functions_t.select(
    F.col("FunctionId").alias("FunctionID"), "FunctionName", F.col("DepartmentId").alias("DepartmentID"),
    "FunctionAccountant", "FunctionState"
))

# ---- fact_hrcontracts ----
# IsLatestContract: legacy DAX picks the row with MAX(createdAt) per employeeId -- a stable
# per-employee flag, materialized here via window function. IsActiveContract/IsActiveLatestContract/
# IsActiveForPeriod are TODAY()/SELECTEDVALUE-relative in the legacy model (not stable physical
# values, same class as Management's dropped "Is Yesterday" column) -- not materialized; port the
# dependent measures with the equivalent filter inlined as DAX instead (see rebuild_hr_directlake.csx).
def _fact_hrcontracts():
    df = hr_contracts.select(
        F.col("ContractId").alias("contractId"), F.col("CompanyId").alias("companyId"),
        F.col("EmployeeId").alias("employeeId"), F.col("StartDate").alias("startDate"),
        F.col("TrialPeriod").alias("trialPeriod"), F.col("EndDate").alias("endDate"),
        F.col("Indefinite").alias("indefinite"), F.col("WrittenContract").alias("writtenContract"),
        F.col("HoursPerWeek").alias("hoursPerWeek"), F.col("CreatedAt").alias("createdAt")
    ).distinct()
    w = Window.partitionBy("employeeId").orderBy(F.col("createdAt").desc())
    return df.withColumn("IsLatestContract", F.when(F.row_number().over(w) == 1, F.lit(True)).otherwise(F.lit(False)))
run_step("fact_hrcontracts", _fact_hrcontracts)

# ---- fact_hours ----
run_step("fact_hours", lambda: hours.select(
    F.col("OfficeId").alias("OfficeID"), "OfficeName", F.col("CardId").alias("CardID"), "CardName",
    F.col("HourId").alias("HourID"), F.col("HourOfficeId").alias("HourOfficeID"),
    F.col("HourDepartmentId").alias("HourDepartmentID"), "HourDate", "HourHours", "HourEnter", "HourExit",
    "HourState", F.col("HourTeamId").alias("HourTeamID"), "HourType", F.col("ProjectId").alias("ProjectID"),
    "HourTypeName", "HourBreak",
    F.hour("HourEnter").alias("HourEnterNumber"), F.hour("HourExit").alias("HourExitNumber")
))

# ---- dim_offices ----
run_step("dim_offices", lambda: offices.select(
    F.col("OfficeId").alias("OfficeID"), "OfficeName", F.col("OfficeIdAccountant").alias("OfficeIDAccountant")
))

# ---- fact_prognosis ----
run_step("fact_prognosis", lambda: prognosis.select(
    F.col("OfficeId").alias("OfficeID"), F.col("TypeId").alias("TypeID"), "PrognosisDate",
    "PrognosisGuests", "PrognosisSpending", "PrognosisTurnover"
))

# ---- dim_teams ----
run_step("dim_teams", lambda: teams.select(
    F.col("TeamId").alias("TeamID"), F.col("OfficeId").alias("OfficeID"),
    F.col("DepartmentId").alias("DepartmentID"), "TeamName"
))

# ---- fact_types ----
run_step("fact_types", lambda: types_t.select(
    F.col("TypeId").alias("TypeID"), F.col("OfficeId").alias("OfficeID"),
    F.col("TypeParentId").alias("TypeParentID"), "TypeName"
))

# ---- fact_planning ----
def _parse_time(colname):
    c = F.col(colname)
    has_colon = F.instr(c, ":") > 0
    hours_mod = (F.substring(c, 1, 2).cast("int") % 24)
    rest = F.expr(f"substring({colname}, length({colname}) - 5, 6)")
    rebuilt = F.concat(
        F.lpad(hours_mod.cast("string"), 2, "0"), F.lit(":"),
        F.substring(rest, 1, 2), F.lit(":"), F.substring(rest, 3, 2)
    )
    return (F.when(c.isNull() | (c == ""), None)
             .when(has_colon, c)
             .otherwise(rebuilt))

def _fact_planning():
    return (planning
        .withColumn("PlanningStart_parsed", _parse_time("PlanningStart"))
        .withColumn("PlanningEnd_parsed", _parse_time("PlanningEnd"))
        .select(
            F.col("OfficeId").alias("OfficeID"), "OfficeName", F.col("CardId").alias("CardID"),
            F.col("DepartmentId").alias("PlanningDepartmentID"), F.col("TeamId").alias("PlanningTeamID"),
            "PlanningDate",
            F.to_timestamp(F.substring_index(F.col("PlanningStart_parsed"), ".", 1), "HH:mm:ss").cast("timestamp").alias("PlanningStart"),
            F.to_timestamp(F.substring_index(F.col("PlanningEnd_parsed"), ".", 1), "HH:mm:ss").cast("timestamp").alias("PlanningEnd"),
            "PlanningHours", "PlanningCosts",
            F.col("PlanningWorkplaceId").alias("PlanningWorkplaceID"), "PlanningWorkplaceName", "PlanningWorkplaceType",
            F.col("PlanningProjectId").alias("PlanningProjectID"), "PlanningBreak", "PlanningLabels", "PlanningRemarks",
            F.col("PlanningTypeId").alias("PlanningTypeID"),
        ))
run_step("fact_planning", _fact_planning)

# ---- fact_sickness ----
run_step("fact_sickness", lambda: sickness.select(
    F.col("OfficeId").alias("OfficeID"), "OfficeName", F.col("CardId").alias("CardID"),
    F.col("SicknessId").alias("SicknessID"), "SicknessStart", "SicknessEnd", "SicknessType",
    "SicknessWaitdayHours", F.col("SicknessWaitdayDay").alias("SicknessWaitdayDays"), "SicknessHours", "SicknessDays",
    F.col("MeldingId").alias("MeldingID"), F.col("CardName").alias("DIM_Staff_CardName")
))

# ---- fact_satisfaction (row-level, pivot deferred) ----
run_step("fact_satisfaction", lambda: satisfaction.select(
    "SatisfactionId", F.col("SurveyDate").alias("Date"), "StaffName", "Office", "Department", "Satisfaction", "Remarks"
))

# ---- fact_mutations ----
run_step("fact_mutations", lambda: mutations.select(
    F.col("CardId").alias("StaffID"), "WageCode", F.col("MutationDate").cast("timestamp").alias("Date"), "Value", "Remarks"
))

# ---- dim_company ----
run_step("dim_company", lambda: companies.select(
    F.col("CompanyId").alias("companyId"), F.col("CompanyNumber").alias("number"),
    F.col("CompanyName").alias("name"), F.col("DebtorId").alias("debtorId")
))

# ---- dim_debtors ----
def _dim_debtors():
    w = Window.partitionBy("DebtorId").orderBy(F.lit(1))
    return (debtors.withColumn("rn", F.row_number().over(w))
        .filter(F.col("rn") == 1)
        .select(
            F.col("DebtorId").alias("debtorId"), F.col("DebtorNumber").alias("number"),
            F.col("DebtorName").alias("name"), F.col("AddressId").alias("addressId"),
            F.col("Street").alias("street"), F.col("HouseNumber").alias("houseNumber"),
            F.col("HouseNumberAddition").alias("houseNumberAddition"), F.col("PostalCode").alias("postalCode"),
            F.col("City").alias("city"), F.col("StateProvince").alias("stateProvince"),
            F.col("CountryISOCode").alias("countryISOCode"),
            F.lit(None).cast("string").alias("type"),
            F.lit(None).cast("boolean").alias("isDefault"),
            F.lit(None).cast("string").alias("period"),
            F.col("AddressCreatedAt").alias("createdAt"),
        ))
run_step("dim_debtors", _dim_debtors)

# ---- fact_employeesmanagers ----
run_step("fact_employeesmanagers", lambda: employee_managers.select(
    F.col("EmployeeId").alias("employeeId"), F.col("ManagerId").alias("managerId"),
    F.col("ManagerFirstName").alias("firstName"), F.col("ManagerLastName").alias("lastName"),
    F.col("ManagerEmail").alias("email"), F.col("CreatedAt").cast("timestamp").alias("createdAt")
))

# ---- fact_contracts ----
def _fact_contracts():
    w = Window.partitionBy("ContractId").orderBy(F.lit(1))
    return (contracts.withColumn("rn", F.row_number().over(w))
        .filter(F.col("rn") == 1)
        .select(
            F.col("ContractId").alias("ID"), F.col("ParentId").alias("ParentID"), F.col("CardId").alias("CardID"),
            "Profile", "Cao", "ContractNumber", "ContractWeekHours", "ContractWeekDays", "ContractDayHoursAvg",
            "ContractPeriodHours", "ContractFirstPeriodHours", "ContractLastPeriodHours",
            "ContractStartDate", "ContractEndDate", "ContractProbationEnd", "ContractDisplayEndDate",
            "ContractType", "ContractHolidayBuild", "ContractRemarks", "ContractModified", "ContractModifiedBy"
        ))
run_step("fact_contracts", _fact_contracts)

# ---- dim_center (HR variant, no Office15/HAKA patch) ----
def _dim_center():
    replacements = [
        ("HaKa Gebouw Pop-up", "Dudok Pop-Up locatie"),
        ("Dudok Schiecentrale", "Dudok Schiecentrale Events"),
        ("Café Rotterdam", "Dudok aan de Maas"),
        ("Patisserie CS Rotterdam", "Dudok Patisserie Rotterdam CS"),
        ("van Nelle Fabriek", "Dudok Van Nelle Fabriek Events"),
    ]
    renamed_name = F.col("CenterName")
    for old, new in replacements:
        escaped = old.replace(".", "\\.")
        renamed_name = F.regexp_replace(renamed_name, escaped, new)

    base = (centers.filter(F.col("Level") != 1)
        .select(
            F.col("CenterKey").alias("Key"), renamed_name.alias("Name"),
            F.col("CenterNr").cast("string").alias("CenterNr"), "Level", "SiteNr", "SubCenter", "RevenueCenter"
        ))
    lvl2 = base.filter(F.col("Level") == 2).select(F.col("SiteNr").alias("SiteNr2"), F.col("Name").alias("Level2Name"))
    return (base.join(lvl2, base.SiteNr == lvl2.SiteNr2, "left")
        .withColumn("FinalName",
            F.when(F.col("Level") == 3, F.concat(F.coalesce(F.col("Level2Name"), F.lit("")), F.lit(" - "), F.col("Name")))
             .otherwise(F.col("Name")))
        .select("Key", F.col("FinalName").alias("Name"), "CenterNr", "Level", "SiteNr", "SubCenter", "RevenueCenter"))
run_step("dim_center", _dim_center)

# ---- dim_classification ----
run_step("dim_classification", lambda: center_classification.select(
    F.lit(None).cast("string").alias("SourceFileName"),
    "CenterNr", F.col("CenterKey").alias("Key"), "LeftNr", "Level", "Name", "Classification"
))

# ---- dim_staff (HR variant, minimal columns) ----
def _dim_staff():
    w = Window.partitionBy("CardId").orderBy(F.lit(1))
    return (staff.withColumn("rn", F.row_number().over(w))
        .filter(F.col("rn") == 1)
        .select(
            F.col("CardId").alias("CardID"), "CardStart", "CardEnd", "CardContractHours",
            "CardHourlySalary", "CardSalaryRate", "CardFunction"
        ))
run_step("dim_staff", _dim_staff)

# ---- fact_cumulative ----
# YearMonth: dbo.cumulative.YearMonth is a date (e.g. 2026-07-01); formatted as zero-padded
# "YYYY-MM" to match hr_dl_dim_date[YearMonth]'s physical string format (the relationship target),
# not the legacy Int64 YYYYMM encoding. Merged in here (was previously nb_build_hr_yearmonth.py,
# a second notebook writing this same table) so a future re-run of this notebook can't silently
# drop the column again -- see check_notebook_table_overlap.py.
run_step("fact_cumulative", lambda: (
    cumulative.alias("c").join(offices.alias("o"), F.col("c.OfficeId") == F.col("o.OfficeId"), "left")
    .select(
        F.col("c.OfficeId").alias("OfficeID"), F.col("o.OfficeName").alias("OfficeName"),
        F.col("c.CardId").alias("CardID"), F.col("c.CummOverHours"), F.col("c.CummHolidayHours"),
        F.col("c.CummCompensationHours"), F.col("c.SourcePeriod").alias("Period"),
        F.date_format("c.YearMonth", "yyyy-MM").alias("YearMonth")
    )
))

# ---- fact_employeesschedule ----
run_step("fact_employeesschedule", lambda: employee_schedule_current.select(
    F.col("EmployeeId").alias("employeeId"), F.col("CompanyId").alias("companyId"),
    F.col("ScheduleId").alias("scheduleId"), F.col("ScheduleStartDate").alias("startDate"),
    F.col("ParttimePercentage").alias("parttimePercentage"),
    F.col("Week1Monday").alias("week1_monday"), F.col("Week1Tuesday").alias("week1_tuesday"),
    F.col("Week1Wednesday").alias("week1_wednesday"), F.col("Week1Thursday").alias("week1_thursday"),
    F.col("Week1Friday").alias("week1_friday"), F.col("Week1Saturday").alias("week1_saturday"),
    F.col("Week1Sunday").alias("week1_sunday"),
    F.col("Week2Monday").alias("week2_monday"), F.col("Week2Tuesday").alias("week2_tuesday"),
    F.col("Week2Wednesday").alias("week2_wednesday"), F.col("Week2Thursday").alias("week2_thursday"),
    F.col("Week2Friday").alias("week2_friday"), F.col("Week2Saturday").alias("week2_saturday"),
    F.col("Week2Sunday").alias("week2_sunday"),
    F.col("ModifiedAt").alias("createdAt")
))

# ---- fact_managers ----
run_step("fact_managers", lambda: debtor_managers.select(
    F.col("ManagerId").alias("managerId"), F.col("ManagerNumber").alias("number"),
    F.col("FirstName").alias("firstName"), F.col("LastName").alias("lastName"), F.col("Gender").alias("gender"),
    F.col("DepartmentId").alias("departmentId"), F.col("DepartmentCode").alias("department_code"),
    F.col("DepartmentDescription").alias("department_description"), F.col("FunctionId").alias("functionId"),
    F.col("FunctionCode").alias("function_code"), F.col("FunctionDescription").alias("function_description"),
    F.col("PhoneNumber").alias("phoneNumber"), F.col("Cellphone").alias("cellphone"), F.col("Email").alias("email")
))

# ---- fact_employeesfunctions ----
run_step("fact_employeesfunctions", lambda: hr_functions.select(
    F.col("EmployeeId").alias("employeeId"), F.col("FunctionId").alias("functionId"),
    F.col("FunctionCode").alias("code"), F.col("FunctionDescription").alias("description"),
    F.col("CompanyId").alias("companyId"),
    F.lit(None).cast("string").alias("companyName"),
    F.col("ModifiedAt").alias("createdAt")
))

# ---- dim_hrfunctions ----
run_step("dim_hrfunctions", lambda: (
    debtor_functions.alias("df").join(debtors.alias("d"), F.col("df.DebtorId") == F.col("d.DebtorId"), "left")
    .select(
        F.col("df.DebtorId").alias("debtorId"), F.col("d.DebtorName").alias("debtorName"),
        F.col("df.FunctionId").alias("functionId"), F.col("df.FunctionCode").alias("code"),
        F.col("df.FunctionDescription").alias("description"), F.col("df.ModifiedAt").alias("createdAt")
    )
))

# ---- dim_date (gold already has a ready-made date dimension -- straight copy) ----
# YearWeek: matches fact_cumulative[Period]'s physical format exactly (Year + "-" + unpadded ISO
# week, e.g. "2025-4") -- confirmed via SQL sample against dbo.cumulative.SourcePeriod, NOT the
# same as this table's existing YearWeekISO column (zero-padded "2025-W04"). Needed so
# fact_cumulative[YearWeek] -> dim_date[YearWeek] (an inactive relationship activated via
# USERELATIONSHIP in the OverHoursSom/HolidayHoursSom/CompensationHoursSom measures' pre-2026
# week-mode branch) is real, matching data -- not a placeholder.
run_step("dim_date", lambda: dates.select(
    "Date", "DateKey", "Year", "Quarter", "QuarterName", "Month", "MonthName", "MonthNameShort",
    "YearMonth", "WeekISO", "YearISO", "YearWeekISO", "DayOfMonth", "DayOfYear", "DayOfWeekISO",
    "DayName", "DayNameShort", "IsWeekend", "DateString"
).withColumn("YearWeek", F.concat(F.col("YearISO").cast("string"), F.lit("-"), F.col("WeekISO").cast("string"))))

# ---- bridge_employees ----
# EmployeeStartDate/EmployeeEndDate/IsActief/VerzuimredenColumn/EndDateEmployment/FinalEndDate/
# FinalEndDateFormatted were previously dropped from this select even though employees_enriched
# already has them as physical columns (same DAX logic as legacy BRIDGE EMPLOYEES calculated
# columns, already resolved upstream) -- carrying them across now unblocks the date-dependent
# HR measures (In Dienst, Uit Dienst, FTE EMPLOYEES, Ziekteverzuim %, Actieve Medewerkers in Periode).
# BirthdayDayMonth/BirthdaySortKey are trivial derivations, added here too.
# NOT carried across (no physical source, don't invent):
#   - DuplicateCounter: was a per-CardID row-count dedup diagnostic on the legacy raw source;
#     employees_enriched is already deduped upstream by the fuzzy-match process, so this is
#     structurally moot now (would always read 1).
#   - IsEchteMedewerker: legacy DAX depends on FACT_Staff[OverwriteOfficeID], a column that does
#     not exist anywhere in gold (checked staff/employees_enriched schemas) -- genuine data gap,
#     not something to fabricate.
#
# SeniorityDate: legacy BRIDGE EMPLOYEES M-code (HR_BIM.bim ~line 15547-15556) takes the latest
# dbo.employments row per employeeId (sort StartDate desc, then ChangedDate desc) and exposes its
# SeniorityDate. Merged in here (was previously nb_build_hr_seniority.py, a second notebook
# writing this same table) so a future re-run of this notebook can't silently drop the column
# again -- see check_notebook_table_overlap.py.
def _bridge_employees():
    w = Window.partitionBy("EmployeeId").orderBy(F.col("StartDate").desc(), F.col("ChangedDate").desc())
    latest_seniority = (
        employments
        .withColumn("_rn", F.row_number().over(w))
        .filter(F.col("_rn") == 1)
        .select(F.col("EmployeeId").alias("employeeId"), F.col("SeniorityDate"))
    )
    return (
        employees_enriched.alias("e")
        .join(companies.select(F.col("CompanyId").alias("companyId"), F.col("CompanyNumber").alias("number"), F.col("CompanyName").alias("name")).alias("c"),
              F.col("e.CompanyId") == F.col("c.companyId"), "left")
        .join(staff.alias("s"), F.col("e.CardId") == F.col("s.CardId"), "left")
        .select(
            F.col("e.EmployeeId").alias("employeeId"), F.col("e.EmployeeNumber").alias("employeeNumber"),
            F.col("e.EmployeeType").alias("employeeType"), F.col("e.CompanyName").alias("companyName"),
            F.col("e.FullName"), F.col("c.number").alias("Number"), F.col("c.name").alias("Name"),
            F.col("e.OfficeId").alias("OfficeID"), F.col("e.NmbrsFunctionCode").alias("EmployeeFunctionCode"),
            F.col("e.NmbrsFunctionDescription").alias("EmployeeFunctionDescription"),
            F.col("e.CardId").alias("CardID"), F.col("s.CardName"),
            F.col("e.SalaryRate").alias("CardSalaryRate"), F.col("e.HourlySalary").alias("CardHourlySalary"),
            F.col("e.ContractHours").alias("CardContractHours"), F.col("e.CardStart"), F.col("e.CardEnd"),
            F.col("e.Function").alias("CardFunction"), F.col("e.FunctionName"),
            F.col("e.Department").alias("DepartmentID"), F.col("e.DepartmentName"),
            F.col("e.ManagerFullName"), F.col("e.DateOfBirth").alias("CardDateofBirth"),
            F.col("e.EmploymentEndDate"), F.col("e.ContractStartDate").alias("HRContractStartDate"),
            F.col("e.EmployeeStartDate"), F.col("e.EmployeeEndDate"), F.col("e.IsActief"),
            F.col("e.VerzuimredenColumn"), F.col("e.EndDateEmployment"),
            F.col("e.FinalEndDate"), F.col("e.FinalEndDateFormatted"),
        )
        .withColumn("BirthdayDayMonth",
            F.when(F.col("CardDateofBirth").isNotNull(), F.date_format("CardDateofBirth", "dd MMMM")).otherwise(F.lit(None).cast("string")))
        .withColumn("BirthdaySortKey",
            F.when(F.col("CardDateofBirth").isNotNull(), F.month("CardDateofBirth") * 100 + F.dayofmonth("CardDateofBirth")).otherwise(F.lit(None).cast("int")))
        .join(latest_seniority, "employeeId", "left")
    )
run_step("bridge_employees", _bridge_employees)

# ---- write results log ----
try:
    log_text = json.dumps(results, indent=2, default=str)
    mssparkutils.fs.put("Files/hr_dl_run_log.json", log_text, overwrite=True)
except Exception:
    pass

print(json.dumps({k: v.get("status") for k, v in results.items()}, indent=2))


# METADATA ********************

# META {
# META   "language": "python",
# META   "language_group": "synapse_pyspark"
# META }
