
log4r::info(logger, "Creating cohorts") 
log4r::info(logger, "Creating dementia condition based cohorts") 

##dementia cohorts
#dementia conditions codes
dementia_codes<- omopgenerics::importCodelist(here::here("Cohorts","Code_lists_dem"), 
                                              type = "csv")

cdm$dementia_conditions <- CohortConstructor::conceptCohort(cdm, 
                                                            conceptSet = dementia_codes,
                                                            exit = "event_end_date",
                                                            overlap="merge", 
                                                            name = "dementia_conditions",
                                                            useRecordsBeforeObservation = FALSE) |> 
  exitAtObservationEnd()

#omopgenerics::cohortCount(cdm$dementia_conditions) 
#settings(cdm$dementia_conditions)

#dementia_drugs
log4r::info(logger, "creating drug codelists") 
dementia_drug_codes <- omopgenerics::importCodelist(path = here::here("Cohorts", "Code_lists_drugs"), type = "csv")

log4r::info(logger, "creating dementia drug based cohorts") 
cdm$dementia_drugs <- conceptCohort(cdm,
                                    conceptSet = dementia_drug_codes,
                                    table = "drug_exposure",
                                    exit = "event_end_date",
                                    name = "dementia_drugs")|>  exitAtObservationEnd()

#bind dementia drugs and dementia conditions
log4r::info(logger, "Binding dementia drugs and dementia conditions into the same table") 
cdm <- bind(cdm[["dementia_drugs"]],
            cdm[["dementia_conditions"]],
            name="dementia_cohorts")

log4r::info(logger, "Union dementia drugs and dementia conditions") 
cdm$dementia_cohorts_incprev <- unionCohorts(cdm$dementia_cohorts,
                                     cohortName = "dementia_overall", 
                                     keepOriginalCohorts = TRUE,
                                     name ="dementia_cohorts_incprev")

log4r::info(logger, "Creating cvd cohorts") 

###CVD cohorts
log4r::info(logger, "Import cvd codelists") 
cvd_codes<- omopgenerics::importCodelist(here::here("Cohorts","Code_lists_cvd"), 
                                         type = "csv")

log4r::info(logger, "Instantiate cvd cohorts") 
cdm$cvd_conditions <- CohortConstructor::conceptCohort(cdm, 
                                                       conceptSet = cvd_codes,
                                                       exit = "event_end_date",
                                                       overlap="merge", 
                                                       name = "cvd_conditions",
                                                       useRecordsBeforeObservation = FALSE)|>
  exitAtObservationEnd()

log4r::info(logger, "Union cvd cohorts") 
cdm$cvd_cohorts_incprev <- CohortConstructor::unionCohorts(cdm$cvd_conditions,
                                                  cohortName = "cvd_overall", 
                                                  keepOriginalCohorts = TRUE,
                                                  name ="cvd_cohorts_incprev")
#settings(cdm$cvd_cohorts)


###CVD_dem cohorts
#bind exposures and outcomes for characterisation
log4r::info(logger, "Intersect dem cohortl") 
cdm$cvd_dem_cohorts_criteria_incprev <- cdm$dementia_cohorts_incprev |>
  requireCohortIntersect(cohortId = "dementia_overall",
                         targetCohortTable="cvd_cohorts_incprev",
                         targetCohortId = "cvd_overall",
                         window=c(-Inf, Inf), 
                         intersections=c(1,Inf),
                         name="cvd_dem_cohorts_criteria_incprev")

log4r::info(logger, "Require demographics") 
cdm$cvd_dem_cohorts <- cdm$cvd_dem_cohorts_criteria_incprev |> 
  requireDemographics(indexDate = "cohort_start_date",
                      ageRange = list(c(18,150)),
                      sex=c("Both"),
                      minPriorObservation=180,
                      name = "cvd_dem_cohorts")

log4r::info(logger, "Require demographics to dementia cohorts") 
cdm$dementia_cohorts <- cdm$dementia_cohorts_incprev |>
  requireDemographics(indexDate = "cohort_start_date",
                      ageRange = list(c(18,150)),
                      sex=c("Both"),
                      minPriorObservation=180,
                      name = "dementia_cohorts")

log4r::info(logger, "Require demographics to cvd cohorts") 
cdm$cvd_cohorts <- cdm$cvd_cohorts_incprev |>
  requireDemographics(indexDate = "cohort_start_date",
                      ageRange = list(c(18,150)),
                      sex=c("Both"),
                      minPriorObservation=180,
                      name = "cvd_cohorts")


#settings(cdm$cvd_dem_cohorts)
#cdm$cvd_dem_cohorts%>%
# count(cohort_definition_id)%>%
#collect()

#names <- cdm$cvd_dem_cohorts |> settings() |> pull("cohort_name")
#new_names <- paste0(names, "_", "intersection")
#cdm$cvd_dem_cohorts <- cdm$cvd_dem_cohorts |>
 # renameCohort(new_names, cohortId = names)


###covariates
log4r::info(logger, "Import codelists covariates") 
covariates <- omopgenerics::importCodelist(here::here("Cohorts","Code_lists_covariates"), 
                                               type = "csv")

log4r::info(logger, "Instantiate covariates cohorts") 
cdm$covariates <- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = covariates,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "covariates",
                                           useRecordsBeforeObservation = FALSE) |>  
  exitAtObservationEnd()
