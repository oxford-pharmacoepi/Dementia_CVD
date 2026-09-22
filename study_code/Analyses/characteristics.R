#Cohort Counts+ Attrition
info(logger, "Summarise cohort count dementia") 
results[["cohort_count_dementia_any"]] <- cdm$dementia_cohorts|>
  summariseCohortCount()

info(logger, "Summarise cohort count cvd") 
results[["cohort_count_cvd_any"]] <- cdm$cvd_cohorts |>
  summariseCohortCount()

info(logger, "Summarise cohort count cvd dementia") 
results[["cohort_count_dem_cvd_any"]] <- cdm$cvd_dem_cohorts |>
  summariseCohortCount()

info(logger, "Summarise cohort attrition dementia") 
results[["cohort_attrition_dementia_any"]] <- cdm$dementia_cohorts |>
  summariseCohortAttrition()

info(logger, "Summarise cohort attrition cvd") 
results[["cohort_attrition_cvd_any"]] <- cdm$cvd_cohorts |>
  summariseCohortAttrition()

info(logger, "Summarise cohort attrition cvd dementia") 
results[["cohort_attrition_dem_cvd_any"]] <- cdm$cvd_dem_cohorts |>
  summariseCohortAttrition()

info(logger, "Summarise cohort code use dementia") 
cdm |> summariseCohortCodeUse(cohortTable = "dementia_cohorts")

info(logger, "Summarise cohort code use cvd") 
cdm |> summariseCohortCodeUse(cohortTable = "cvd_cohorts")

info(logger, "Summarise cohort code use cvd dementia") 
cdm |> summariseCohortCodeUse(cohortTable = "cvd_dem_cohorts")

info(logger, "Summarise cohort characteristics dementia_cvd") 
results[["summarise_characteristics"]] <- cdm[["cvd_dem_cohorts"]] |>
  addAge(ageGroup = list(c(18,64), c(65, 150))) |>
  addSex() |>
  summariseCharacteristics(
    strata = list("age_group", "sex"),
    "cohortIntersectFlag" = list(
      "Comorbidities prior to index date" = list(
        "targetCohortTable" = "covariates",
        "window" = c(-Inf, 0)
      )
    )
  )
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
    

