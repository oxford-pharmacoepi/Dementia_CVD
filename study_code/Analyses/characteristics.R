library(CDMConnector)
library(duckdb)
library(dplyr, warn.conflicts = FALSE)

#Cohort Counts+ Attrition
results[["cohort_count_dementia_any"]] <- cdm$dementia_cohorts|>
  summariseCohortCount()

results[["cohort_count_cvd_any"]] <- cdm$cvd_cohorts |>
  summariseCohortCount()

results[["cohort_count_dem_cvd_any"]] <- cdm$cdm$cvd_dem_cohorts |>
  summariseCohortCount()

results[["cohort_attrition_dementia_any"]] <- cdm$dementia_cohorts |>
  summariseCohortAttrition()

results[["cohort_attrition_cvd_any"]] <- cdm$cvd_cohorts |>
  summariseCohortAttrition()

results[["cohort_attrition_dem_cvd_any"]] <- cdm$cdm$cvd_dem_cohorts |>
  summariseCohortAttrition()

#Cohort characteristics dementia_any

#Cohort characteristics cvd_any

#Cohort characteristics dementia_cvd
