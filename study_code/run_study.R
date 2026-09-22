# create logger ----
resultsFolder <- here("results")
if(!dir.exists(resultsFolder)){
  dir.create(resultsFolder)
}
loggerName <- gsub(":| |-", "", paste0("log_", Sys.Date(),".txt"))
logger <- create.logger()
logfile(logger) <- here::here(resultsFolder, loggerName)
level(logger) <- "INFO"
info(logger, "LOG CREATED") #to write messages in log file

# correct drug era
cdm$drug_era <- cdm$drug_era |>
  dplyr::mutate(
    drug_era_start_date = as.Date(drug_era_start_date),
    drug_era_end_date = as.Date(drug_era_end_date)
  )

results <- list()

info(logger, "Summarise snapshot")
results[["snapshot"]] <- summariseOmopSnapshot(cdm)

info(logger, "LOG CREATED")
results[["obs_period"]] <- summariseObservationPeriod(cdm)

# instantiate necessary cohorts ----
log4r::info(logger, "START INSTANTIATING COHORTS") 
source(here("Cohorts","Instantiate_cohorts.R"))
log4r::info(logger, "FINISHING INSTANTIATING COHORTS") 

# run diagnostics ----

source(here("Analyses", "characteristics.R"))
source(here("Analyses", "Incidence_prevalence.R"))

#save results
results<-bind(results)
exportSummarisedResult(results, path = "results")

info(logger, "Finished")
