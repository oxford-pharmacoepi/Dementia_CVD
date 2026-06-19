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
cdm$dementia_cohorts|>
  addSex()%>%
  addAge(ageGroup=list(c(18-64), c(65-150),c(18, 150)))%>%
  CohortCharacteristics::summariseCharacteristics(
  cohort,
  cohortId = NULL,
  strata = list("age", "sex"),
  counts = TRUE,
  demographics = TRUE,
  ageGroup = list (c(18-64), c(65-150),c(18, 150))
)

#Cohort characteristics cvd_any
cdm$cvd_cohorts|>
  addSex()%>%
  addAge(ageGroup=list(c(18-64), c(65-150),c(18, 150)))%>%
  summariseCharacteristics(
    cohort,
    cohortId = NULL,
    strata = list("age", "sex"),
    counts = TRUE,
    demographics = TRUE,
    ageGroup = list (c(18-64), c(65-150),c(18, 150))
                     )
    
#Cohort characteristics dementia_cvd
cdm$cvd_dem_cohorts|>
  addSex()%>%
  addAge(ageGroup=list(c(18-64), c(65-150),c(18, 150)))%>%
summariseCharacteristics(
    cohort,
    cohortId = NULL,
    strata = list("age", "sex"),
    counts = TRUE,
    demographics = TRUE,
    ageGroup = list (c(18-64), c(65-150),c(18, 150))
    )