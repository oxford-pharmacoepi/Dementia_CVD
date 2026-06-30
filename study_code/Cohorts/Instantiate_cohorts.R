library(omock)
library(CodelistGenerator)
library(PatientProfiles)
library(CohortConstructor)
library(dplyr)
library(CDMConnector)
library(duckdb)
library(CohortCharacteristics)
library(omopgenerics)

log4r::info(logger, "Creating cohorts") 

log4r::info(logger, "Creating dementia condition based cohorts") 

#dementia conditions codes
dementia_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_dem"), 
                                              type = "csv")

cdm$dementia_conditions <- CohortConstructor::conceptCohort(cdm, 
                                                            conceptSet = dementia_codes,
                                                            exit = "event_end_date",
                                                            overlap="merge", 
                                                            name = "dementia_conditions",
                                                            useRecordsBeforeObservation = FALSE
)|>  exitAtObservationEnd()

cdm$dementia_conditions 

#omopgenerics::cohortCount(cdm$dementia_conditions) 
#settings(cdm$dementia_conditions)

#dementia_drugs
log4r::info(logger, "creating drug codelists") 
dementia_drug_codes <- getDrugIngredientCodes(cdm, 
                                              name = c("donepezil",
                                                       "galantamine", 
                                                       "rivastigmine", 
                                                       "memantine"))


log4r::info(logger, "creating dementia drug based cohorts") 
cdm$dementia_drugs <- conceptCohort(cdm,
                                    conceptSet = dementia_drug_codes,
                                    table = "drug_exposure",
                                    exit = "event_end_date",
                                    name = "dementia_drugs"
)|>  exitAtObservationEnd()

#bind dementia drugs and dementia conditions

cdm <- bind(cdm[["dementia_drugs"]],
            cdm[["dementia_conditions"]],
            name="dementia_cohorts")

cdm$dementia_cohorts<- unionCohorts(cdm$dementia_cohorts,
                                    cohortName = "dementia_overall", 
                                    keepOriginalCohorts = TRUE,
                                    name ="dementia_cohorts")

log4r::info(logger, "Creating cvd cohorts") 

#CVD cohorts
cvd_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/diagnostics_code/cohorts/Code_lists_cvd"), 
                                         type = "csv")

cdm$cvd_conditions <- CohortConstructor::conceptCohort(cdm, 
                                                       conceptSet = cvd_codes,
                                                       exit = "event_end_date",
                                                       overlap="merge", 
                                                       name = "cvd_conditions",
                                                       useRecordsBeforeObservation = FALSE)|>
  exitAtObservationEnd()

cdm$cvd_cohorts<- CohortConstructor::unionCohorts(cdm$cvd_conditions,
                                                  cohortName = "cvd_overall", 
                                                  keepOriginalCohorts = TRUE,
                                                  name ="cvd_cohorts")
#settings(cdm$cvd_cohorts)

log4r::info(logger, "binding cohorts") 

#bind exposures and outcomes
cdm$cvd_dem_cohorts<- cdm$dementia_cohorts|> 
  requireCohortIntersect(targetCohortTable="cvd_cohorts",
                         window=c(-Inf, Inf), 
                         intersections=c(1,Inf),
                         targetCohortId = 3,
                         name="cvd_dem_cohorts"
  )%>%
  requireDemographics(ageRange = list(c(18,150),
                      minPriorObservation=180))

cdm$cvd_dem_cohorts_stroketia<- cdm$dementia_cohorts|> 
  requireCohortIntersect(targetCohortTable="cvd_cohorts",
                         window=c(-Inf, Inf), 
                         intersections=c(1,Inf),
                         targetCohortId = #pending
                         name="cvd_dem_cohorts",
  )%>%
  requireDemographics(ageRange = list(c(18,150),
                      minPriorObservation=180))
#settings(cdm$cvd_dem_cohorts)
#cdm$cvd_dem_cohorts%>%
# count(cohort_definition_id)%>%
#collect()

#names <- cdm$cvd_dem_cohorts |> settings() |> pull("cohort_name")
#new_names <- paste0(names, "_", "intersection")
#cdm$cvd_dem_cohorts <- cdm$cvd_dem_cohorts |>
 # renameCohort(new_names, cohortId = names)



###covariates
##acute MI
MI_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/acute_mi"), 
                                              type = "csv")

cdm$ami<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = MI_codes,
                                          exit = "event_end_date",
                                          overlap="merge",
                                          name = "AMI",
                                        useRecordsBeforeObservation = FALSE
)               

##alcohol_use_disorder
OH_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/alcohol_use"), 
                                        type = "csv")

cdm$oh<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = OH_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "alcohol",
                                           useRecordsBeforeObservation = FALSE)

##anxiety
anxiety_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/anxiety"), 
                                        type = "csv")

cdm$anxiety<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = anxiety_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "anxiety",
                                           useRecordsBeforeObservation = FALSE)

##AF
AF_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/atrial_fibrillation"), 
                                        type = "csv")

cdm$af<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = AF_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "AF",
                                           useRecordsBeforeObservation = FALSE)

##bipolar
bipolar_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/bipolar"), 
                                        type = "csv")

cdm$bipolar<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = bipolar_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "bipolar",
                                           useRecordsBeforeObservation = FALSE)

##cancer
cancer_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/cancer"), 
                                        type = "csv")

cdm$cancer<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = cancer_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "cancer",
                                           useRecordsBeforeObservation = FALSE)

##carotid
carotid_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/carotid"), 
                                        type = "csv")

cdm$carotid<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = carotid_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "carotid",
                                           useRecordsBeforeObservation = FALSE)
##chronic liver
chronic_liver_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/chronic_liver"), 
                                        type = "csv")

cdm$chronic_liver<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = chronic_liver_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "chronic_liver",
                                           useRecordsBeforeObservation = FALSE)

##CKD
ckd_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/ckd"), 
                                        type = "csv")

cdm$ckd<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = ckd_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "ckd",
                                           useRecordsBeforeObservation = FALSE)

##depression
depression_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/depression"), 
                                        type = "csv")

cdm$depression<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = depression_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "depression",
                                           useRecordsBeforeObservation = FALSE)

##DLP
dlp_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/DLP_high"), 
                                        type = "csv")

cdm$dlp<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = dlp_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "DLP",
                                           useRecordsBeforeObservation = FALSE)

##endocarditis
endocarditis_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/endocarditis"), 
                                        type = "csv")

cdm$endocarditis<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = endocarditis_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "endocarditis",
                                           useRecordsBeforeObservation = FALSE)

##hearing loss
hearing_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/hearing_loss"), 
                                        type = "csv")

cdm$hearing_loss<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = hearing_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "hearing_loss",
                                           useRecordsBeforeObservation = FALSE)

##heart failure
HF_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/heart_failure"), 
                                        type = "csv")

cdm$hf<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = HF_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "HF",
                                           useRecordsBeforeObservation = FALSE)

##HTA
HTA_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/hta"), 
                                        type = "csv")

cdm$hta<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = HTA_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "HTA",
                                           useRecordsBeforeObservation = FALSE)

##OSA
osa_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/OSA"), 
                                        type = "csv")

cdm$osa<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = osa_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "OSA",
                                           useRecordsBeforeObservation = FALSE)
##RBD
RBD_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/RBD"), 
                                        type = "csv")

cdm$rbd<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = RBD_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "OSA",
                                           useRecordsBeforeObservation = FALSE)

##RLS
RLS_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/RLS"), 
                                        type = "csv")

cdm$rls<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = RLS_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "RLS",
                                           useRecordsBeforeObservation = FALSE)

##Schizo spectrum
schizo_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/schizo_spectrum"), 
                                        type = "csv")

cdm$schizo<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = schizo_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "schizo_spectrum",
                                           useRecordsBeforeObservation = FALSE)

##valve heart
valve_heart_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/study_code/cohorts/Code_lists_covariates/valve_heart"), 
                                        type = "csv")

cdm$valve<- CohortConstructor::conceptCohort(cdm, 
                                           conceptSet = valve_heart_codes,
                                           exit = "event_end_date",
                                           overlap="merge",
                                           name = "valve_heart",
                                           useRecordsBeforeObservation = FALSE)