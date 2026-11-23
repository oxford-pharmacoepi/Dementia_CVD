#install.packages("PhenotypeR")
library(PhenotypeR)

log4r::info(logger, "Running Phenotype Diagnostics")
results <- list()

options("PhenotypeR_summariseLargeScaleCharacteristics_episodeInWindow" = c("drug_exposure", "visit_occurrence"))

##diagnostics

results[["dementia_cohorts_incprev"]] <- phenotypeDiagnostics(
  cdm[["dementia_cohorts_incprev"]], 
  databaseDiagnostics=list(),
  codelistDiagnostics=list(),
  cohortDiagnostics=list(),
  populationDiagnostics = list(),
  stagingDirectory = "~/Dementia_CVD/diagnostics_code/results")

results[["cvd_cohorts_inc"]] <- phenotypeDiagnostics(
  cdm[["cvd_cohorts_inc"]], 
  databaseDiagnostics=list(),
  codelistDiagnostics=list(),
  cohortDiagnostics=list(),
  populationDiagnostics = list(),
  stagingDirectory = "~/Dementia_CVD/diagnostics_code/results")

results[["cvd_cohorts_prev"]] <- phenotypeDiagnostics(
  cdm[["cvd_cohorts_prev"]], 
  databaseDiagnostics=list(),
  codelistDiagnostics=list(),
  cohortDiagnostics=list(),
  populationDiagnostics = list(),
  stagingDirectory = "~/Dementia_CVD/diagnostics_code/results")

results[["hemorr_conditions"]] <- phenotypeDiagnostics(
  cdm[["hemorr_conditions"]], 
  databaseDiagnostics=NULL,
  codelistDiagnostics=list(),
  cohortDiagnostics=list(),
  populationDiagnostics = list(),
  stagingDirectory = "~/Dementia_CVD/diagnostics_code/results")

#per evitar error duplicate results
results[["dementia_cohorts_incprev"]] <- results[["dementia_cohorts_incprev"]]  |> filterSettings(result_type != "summarise_log_file")                  
results[["cvd_cohorts_inc"]] <- results[["cvd_cohorts_inc"]] |> filterSettings(result_type != "summarise_log_file")  
results[["cvd_cohorts_prev"]] <- results[["cvd_cohorts_prev"]] |> filterSettings(result_type != "summarise_log_file") 
results[["hemorr_conditions"]] <- results[["hemorr_conditions"]]  |> filterSettings(result_type != "summarise_log_file")   
results[["dementia_cohorts_incprev"]] <- results[["dementia_cohorts_incprev"]]  |> filterSettings(result_type != "summarise_omop_snapshot")                  
results[["cvd_cohorts_inc"]] <- results[["cvd_cohorts_inc"]] |> filterSettings(result_type != "summarise_omop_snapshot")  
results[["cvd_cohorts_prev"]] <- results[["cvd_cohorts_prev"]] |> filterSettings(result_type != "summarise_omop_snapshot")   
results[["hemorr_conditions"]] <- results[["hemorr_conditions"]] |> filterSettings(result_type != "summarise_omop_snapshot") 

results1 <- bind(results) #Marta's code without specifying the name of the database

exportSummarisedResult(
  results1,
  fileName = "results_{cdm_name}_{date}.csv",
  path = here::here("results"),
  minCellCount = minCellCount
)

result <-omopgenerics::importSummarisedResult(here::here("results"))

shinyDiagnostics(result, here::here())

