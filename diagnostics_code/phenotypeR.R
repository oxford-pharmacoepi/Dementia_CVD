#install.packages("PhenotypeR")
library(PhenotypeR)

log4r::info(logger, "Running Phenotype Diagnostics")
results <- list()

##diagnostics
results[["cvd_dem_cohorts"]] <- phenotypeDiagnostics(
  cdm[["cvd_dem_cohorts"]], 
  diagnostics = c("databaseDiagnostics", "codelistDiagnostics", "cohortDiagnostics",
                  "populationDiagnostics"),
  populationDateRange = as.Date(c(NA, NA))
  )

results[["dementia_cohorts"]] <- phenotypeDiagnostics(
  cdm[["dementia_cohorts"]], 
  diagnostics = c("databaseDiagnostics", "codelistDiagnostics", "cohortDiagnostics",
                  "populationDiagnostics"),
  populationDateRange = as.Date(c(NA, NA))
)

results[["cvd_cohorts"]] <- phenotypeDiagnostics(
  cdm[["cvd_cohorts"]], 
  diagnostics = c("databaseDiagnostics", "codelistDiagnostics", "cohortDiagnostics",
                  "populationDiagnostics"),
  populationDateRange = as.Date(c(NA, NA))
)

#per evitar error duplicate results
results[["dementia_cohorts"]] <- results[["dementia_cohorts"]]  |> filterSettings(result_type != "summarise_log_file")                  
results[["cvd_dem_cohorts"]] <- results[["cvd_dem_cohorts"]] |> filterSettings(result_type != "summarise_log_file")  
results[["dementia_cohorts"]] <- results[["dementia_cohorts"]]  |> filterSettings(result_type != "summarise_omop_snapshot")                  
results[["cvd_dem_cohorts"]] <- results[["cvd_dem_cohorts"]] |> filterSettings(result_type != "summarise_omop_snapshot")  

results1 <- bind(results) #Marta's code without specifying the name of the database

exportSummarisedResult(
  results1,
  fileName = "results_{cdm_name}_{date}.csv",
  path = here::here("results"),
  minCellCount = minCellCount
)

#result <-omopgenerics::importSummarisedResult(here::here("results"))

#shinyDiagnostics(result, here::here())

