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

# export the results
results1 <- bind(results)
exportSummarisedResult (results1, fileName = paste0("results_dementia_cvd_cohorts", Sys.Date(),".csv"),
                        path = here::here("results"), 
                        minCellCount = minCellCount)

#result <-omopgenerics::importSummarisedResult(here::here("results"))

#shinyDiagnostics(result, here::here())

