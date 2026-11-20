# create logger ----
resultsFolder <- here("results")
if(!dir.exists(resultsFolder)){
  dir.create(resultsFolder)
}
loggerName <- gsub(":| |-", "", paste0("log_", Sys.Date(),".txt"))
logger <- log4r::create.logger()
log4r::logfile(logger) <- here::here(resultsFolder, loggerName)
log4r::level(logger) <- "INFO"
log4r::info(logger, "LOG CREATED") #to write messages in log file

# correct drug era
cdm$drug_era <- cdm$drug_era |>
  dplyr::mutate(
    drug_era_start_date = as.Date(drug_era_start_date),
    drug_era_end_date = as.Date(drug_era_end_date)
  )

# instantiate necessary cohorts ----
source(here("cohorts","instantiate_cohorts.R"))

# run diagnostics ----

source(here("phenotypeR.R"))


log4r::info(logger, "Finished")
