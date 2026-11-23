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
                                             cohortName = NULL, 
                                             keepOriginalCohorts = TRUE,
                                             name ="dementia_cohorts_incprev")

log4r::info(logger, "Creating cvd cohorts") 

###CVD cohorts
log4r::info(logger, "Import cvd codelists") 
cvd_codes_inc<- omopgenerics::importCodelist(here::here("Cohorts","Code_lists_cvd_inc"), 
                                             type = "csv")
cvd_codes_prev<- omopgenerics::importCodelist(here::here("Cohorts","Code_lists_cvd_prev"), 
                                              type = "csv")

log4r::info(logger, "Instantiate cvd cohorts") 
cdm$cvd_conditions_inc <- CohortConstructor::conceptCohort(cdm, 
                                                           conceptSet = cvd_codes_inc,
                                                           exit = "event_end_date",
                                                           overlap="merge", 
                                                           name = "cvd_conditions_inc",
                                                           useRecordsBeforeObservation = FALSE)|>
  exitAtObservationEnd()

cdm$cvd_conditions_prev <- CohortConstructor::conceptCohort(cdm, 
                                                            conceptSet = cvd_codes_prev,
                                                            exit = "event_end_date",
                                                            overlap="merge", 
                                                            name = "cvd_conditions_prev",
                                                            useRecordsBeforeObservation = FALSE)|>
  exitAtObservationEnd()

log4r::info(logger, "Union cvd cohorts") 
cdm$cvd_cohorts_inc <- CohortConstructor::unionCohorts(cdm$cvd_conditions_inc,
                                                       cohortName = "cvd_overall_inc", 
                                                       keepOriginalCohorts = TRUE,
                                                       name ="cvd_cohorts_inc")

cdm$cvd_cohorts_prev <- CohortConstructor::unionCohorts(cdm$cvd_conditions_prev,
                                                        cohortName = "cvd_overall_prev", 
                                                        keepOriginalCohorts = TRUE,
                                                        name ="cvd_cohorts_prev")
#settings(cdm$cvd_cohorts)

##stroketia cohorts
log4r::info(logger, "Instantiate stroketia cohorts") 
stroketia_inc_codes<- omopgenerics::importCodelist(here::here("Cohorts","Code_lists_cvd_inc"), 
                                                   type = "csv")

stroketia_inc_codes <- stroketia_inc_codes["stroke_tia_inc"]
cdm$stroketia_conditions_inc <- CohortConstructor::conceptCohort(cdm, 
                                                                 conceptSet = stroketia_inc_codes,
                                                                 exit = "event_end_date",
                                                                 overlap="merge", 
                                                                 name = "stroketia_conditions_inc",
                                                                 useRecordsBeforeObservation = FALSE)|>
  exitAtObservationEnd()


#hemorr cohorts
log4r::info(logger, "Instantiate haemorrhagic cohort") 
hemorr_codes<- omopgenerics::importCodelist(here::here("Cohorts","Code_lists_hemorr"), 
                                            type = "csv")

cdm$hemorr_conditions <- CohortConstructor::conceptCohort(cdm, 
                                                          conceptSet = hemorr_codes,
                                                          exit = "event_end_date",
                                                          overlap="merge", 
                                                          name = "hemorr_conditions",
                                                          useRecordsBeforeObservation = FALSE)|>
  exitAtObservationEnd()

log4r::info(logger, "Instantiate hemorr_parenq cohort") 
hemorr_parenq_codes<- omopgenerics::importCodelist(here::here("Cohorts","Code_lists_hemorr", "hemorr_parenq.csv"),
                                                   type = "csv")
cdm$hemorr_parenq <- CohortConstructor::conceptCohort(cdm, 
                                                      conceptSet = hemorr_parenq_codes,
                                                      exit = "event_end_date",
                                                      overlap="merge", 
                                                      name = "hemorr_parenq",
                                                      useRecordsBeforeObservation = FALSE)|>
  exitAtObservationEnd()


log4r::info(logger, "Instantiate ARIA_H cohort") 
aria_h_codes<- omopgenerics::importCodelist(here::here("Cohorts","Code_lists_hemorr", "aria_h.csv"),
                                            type = "csv")

cdm$aria_h <- CohortConstructor::conceptCohort(cdm, 
                                               conceptSet = aria_h_codes,
                                               exit = "event_end_date",
                                               overlap="merge", 
                                               name = "aria_h",
                                               useRecordsBeforeObservation = FALSE)|>
  exitAtObservationEnd()