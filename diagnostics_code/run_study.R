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

# instantiate necessary cohorts ----
source(here("cohorts","instantiate_cohorts.R"))

# run diagnostics ----
source(here("diagnostics_code","phenotypeR.R"))


log4r::info(logger, "Finished")
