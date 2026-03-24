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
dementia_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/diagnostics_code/cohorts/Code_lists_dem"), 
                                           type = "csv")

cdm$dementia_conditions <- CohortConstructor::conceptCohort(cdm, 
                             conceptSet = dementia_codes,
                             exit = "event_end_date",
                             overlap="merge", 
                             name = "dementia_conditions",
                              useRecordsBeforeObservation = FALSE
)

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
                                         name = "dementia_drugs") 

#bind dementia drugs and dementia conditions
cdm <- bind(cdm[["dementia_drugs"]],
            cdm[["dementia_conditions"]],
            name="dementia_cohorts")

cdm$dementia_cohorts

log4r::info(logger, "Creating cvd cohorts") 
#CVD cohorts
cvd_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/diagnostics_code/cohorts/Code_lists_cvd"), 
                                              type = "csv")
cvd_codes

cdm$cvd_conditions <- CohortConstructor::conceptCohort(cdm, 
                                                            conceptSet = cvd_codes,
                                                            exit = "event_end_date",
                                                            overlap="merge", 
                                                            name = "cvd_conditions",
                                                            useRecordsBeforeObservation = FALSE
)


log4r::info(logger, "binding cohorts") 
#bind exposures and outcomes
cdm <- bind(cdm[["dementia_cohorts"]],
            cdm[["cvd_conditions"]],
            name="cvd_dem_cohorts")
cdm$cvd_dem_cohorts
