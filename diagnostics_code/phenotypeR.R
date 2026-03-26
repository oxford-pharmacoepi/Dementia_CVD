#install.packages("PhenotypeR")
library(PhenotypeR)

log4r::info(logger, "Running Phenotype Diagnostics")

##diagnostics
result <- phenotypeDiagnostics(
  cdm[["cvd_dem_cohorts"]], 
  diagnostics = c("databaseDiagnostics", "codelistDiagnostics", "cohortDiagnostics",
                  "populationDiagnostics"),
  populationDateRange = as.Date(c(NA, NA))
  )

# export the results
exportSummarisedResult(result, 
                       fileName = "results_dementia_cvd_cohorts.csv",
                       path = here::here("~/R/Dementia_CVD/diagnostics_code/results"), 
                       minCellCount = minCellCount)


#result <-omopgenerics::importSummarisedResult(here::here("results"))

#shinyDiagnostics(result, here::here())

