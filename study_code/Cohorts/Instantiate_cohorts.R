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
dementia_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/diagnostics_code/Cohorts/Code_lists_dem"), 
                                              type = "csv")

cdm$dementia_conditions <- CohortConstructor::conceptCohort(cdm, 
                                                            conceptSet = dementia_codes,
                                                            exit = "event_end_date",
                                                            overlap="merge", 
                                                            name = "dementia_conditions",
                                                            useRecordsBeforeObservation = FALSE
)|>  exitAtObservationEnd()

#cohortCount(cdm$dementia_conditions) 
#settings(cdm$dementia_conditions)

#dementia_drugs
log4r::info(logger, "creating drug codelists") 
dementia_drug_codes <-CohortConstructor::getDrugIngredientCodes(cdm, 
                                              name = c("donepezil",
                                                       "galantamine", 
                                                       "rivastigmine", 
                                                       "memantine"))


log4r::info(logger, "creating dementia drug based cohorts") 
cdm$dementia_drugs <- CohortConstructor::conceptCohort(cdm,
                                    conceptSet = dementia_drug_codes,
                                    table = "drug_exposure",
                                    exit = "event_end_date",
                                    name = "dementia_drugs"
)|>  exitAtObservationEnd()

#bind dementia drugs and dementia conditions

cdm <- bind(cdm[["dementia_drugs"]],
            cdm[["dementia_conditions"]],
            name="dementia_cohorts")

cdm$dementia_cohorts<- CohortConstructor::unionCohorts(cdm$dementia_cohorts,
                                    cohortName = "dementia_overall", 
                                    keepOriginalCohorts = TRUE,
                                    name ="dementia_cohorts")|>

CohortConstructor::requireDemographics(
  "dementia_cohorts",
  cohortId = NULL,
  indexDate = "cohort_start_date",
  ageRange = list(c(18, 150)),
  sex = c("Both"),
  minPriorObservation = 180,
  minFutureObservation = 0,
  atFirst = FALSE,
  name ="dementia_cohorts"
)

log4r::info(logger, "Creating cvd cohorts") 

#CVD cohorts
cvd_codes<- omopgenerics::importCodelist(here::here("~/R/Dementia_CVD/diagnostics_code/Cohorts/Code_lists_cvd"), 
                                         type = "csv")

cdm$cvd_conditions <- CohortConstructor::conceptCohort(cdm, 
                                                       conceptSet = cvd_codes,
                                                       exit = "event_end_date",
                                                       overlap="merge", 
                                                       name = "cvd_conditions",
                                                       useRecordsBeforeObservation = FALSE)|>
  exitAtObservationEnd()

cdm$cvd_cohorts<-CohortConstructor::unionCohorts(cdm$cvd_conditions,
                               cohortName = "cvd_overall", 
                               keepOriginalCohorts = TRUE,
                               name ="cvd_cohorts")|>
  
  CohortConstructor::requireDemographics(
    cohort,
    cohortId = NULL,
    indexDate = "cohort_start_date",
    ageRange = list(c(18, 150)),
    sex = c("Both"),
    minPriorObservation = 180,
    minFutureObservation = 0,
    atFirst = FALSE,
    name =dementia_cohorts
  )

log4r::info(logger, "binding cohorts") 

#intersection of exposures and outcomes
cdm$cvd_dem_cohorts<- cdm$dementia_cohorts|> 
  CohortConstructor::requireCohortIntersect(intersections=c(1,Inf),
                         targetCohortTable="cvd_cohorts",
                         window=c(-Inf, Inf), 
                         name="cvd_dem_cohorts"
  )

names <- cdm$cvd_dem_cohorts |> settings() |> pull("cohort_name")
new_names <- paste0(names, "_", "intersection")
cdm$cvd_dem_cohorts <- cdm$cvd_dem_cohorts |>
  renameCohort(new_names, cohortId = names)

#bind exposures and outcomes
cdm <- bind(cdm[["dementia_cohorts"]],
            cdm[["cvd_conditions"]],
            name="cvd_dem_cohorts")
cdm$cvd_dem_cohorts<- CohortConstructor::unionCohorts(cdm$cvd_dem_cohorts,
                                   cohortName = "cvd_dem", 
                                   keepOriginalCohorts = TRUE,
                                   name ="cvd_dem_cohorts")