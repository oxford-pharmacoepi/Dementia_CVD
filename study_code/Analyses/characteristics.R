library(CDMConnector)
library(duckdb)
library(dplyr, warn.conflicts = FALSE)

#Cohort Counts+ Attrition
results[["cohort_count_dementia_any"]] <- cdm$dementia_cohorts|>
  summariseCohortCount()|>tableCohortCount()

results[["cohort_count_cvd_any"]] <- cdm$cvd_cohorts |>
  summariseCohortCount()|>tableCohortCount()

results[["cohort_count_dem_cvd_any"]] <- cdm$cdm$cvd_dem_cohorts |>
  summariseCohortCount()|>tableCohortCount()

results[["cohort_attrition_dementia_any"]] <- cdm$dementia_cohorts |>
  summariseCohortAttrition()

results[["cohort_attrition_cvd_any"]] <- cdm$cvd_cohorts |>
  summariseCohortAttrition()

results[["cohort_attrition_dem_cvd_any"]] <- cdm$cdm$cvd_dem_cohorts |>
  summariseCohortAttrition()

# #Cohort characteristics dementia_any
# cdm$dementia_cohorts|>
#   addSex()%>%
#   addAge(ageGroup=list(c(18-64), c(65-150),c(18, 150)))%>%
#   CohortCharacteristics::summariseCharacteristics(
#   cohort,
#   cohortId = NULL,
#   strata = list("age", "sex"),
#   counts = TRUE,
#   demographics = TRUE,
#   ageGroup = list (c(18-64), c(65-150),c(18, 150))
# )
# 
# #Cohort characteristics cvd_any
# cdm$cvd_cohorts|>
#   addSex()%>%
#   addAge(ageGroup=list(c(18-64), c(65-150),c(18, 150)))%>%
#   summariseCharacteristics(
#     cohort,
#     cohortId = NULL,
#     strata = list("age", "sex"),
#     counts = TRUE,
#     demographics = TRUE,
#     ageGroup = list (c(18-64), c(65-150),c(18, 150))
#                     )
    
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
    )|>
  tableCharacteristics(cdm$cvd_dem_cohorts)|>
  tableCohortOverlap(cdm$ami)|>
  tableCohortOverlap(cdm$af)|>
  tableCohortOverlap(cdm$oh)|>
  cdm$anxiety, cdm$bipolar, cdm$cancer, cdm$carotid, cdm$chronic_liver, cdm$ckd<, cdm$depression, cdm$dlp, cdm$endocarditis, cdm$hearing_loss, cdm$hf, cdm$hta, cdm$osa, cdm$rbd, cdm$rls, cdm$schizo, cdm$valve)
