library(CDMConnector)
library(IncidencePrevalence)

##Overall population cohort 
#generate denominator
cdm <- generateDenominatorCohortSet(
  cdm = cdm,
  name = "overall_population",
  cohortDateRange = as.Date(c("2005-01-01", "2024-12-31")),
  ageGroup = list(
    c(18, 150),
    c(65, 100),
    c(18, 64)
  ),
  sex = c("Male", "Female", "Both"),
  daysPriorObservation = 180
)

#estimate incidence dementia in overall population
inc_dem <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "overall_population",
  outcomeTable = "dementia_cohorts",
  interval = "years",
  repeatedEvents = TRUE,
  completeDatabaseIntervals = TRUE
)
plotIncidence(inc, facet = c("denominator_age_group", "denominator_sex"))


#estimate period prevalence of dementia in overall population
prev_period_dem <- estimatePeriodPrevalence(
  cdm = cdm,
  denominatorTable = "overall_population",
  outcomeTable = "dementia_cohorts",
  interval = "years",
  completeDatabaseIntervals = TRUE,
  fullContribution = TRUE
)
plotPrevalence(prev_period, facet = c("denominator_age_group", "denominator_sex"))

#estimate incidence cvd in overall population
inc_cvd <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "overall_population",
  outcomeTable = "cvd_cohorts",
  interval = "years",
  repeatedEvents = TRUE,
  outcomeWashout = 180,
  completeDatabaseIntervals = TRUE
)
plotIncidence(inc, facet = c("denominator_age_group", "denominator_sex"))


#estimate period prevalence of cvd in overall population
prev_period_cvd <- estimatePeriodPrevalence(
  cdm = cdm,
  denominatorTable = "overall_population",
  outcomeTable = "cvd_cohorts",
  interval = "years",
  completeDatabaseIntervals = TRUE,
  fullContribution = TRUE
)
plotPrevalence(prev_period, facet = c("denominator_age_group", "denominator_sex"))


##Dementia_CVD cohort 

#generate denominator
cdm <- generateTargetDenominatorCohortSet(
  cdm = cdm,
  name = "denominator_dementia_CVD",
  cohortDateRange = as.Date(c("2005-01-01", "2024-12-31")),
  ageGroup = list(
    c(18, 150),
    c(65, 100),
    c(0, 64)
  ),
  sex = c("Male", "Female", "Both"),
  daysPriorObservation = 180
)

#estimate incidence CVD in dementia population
inc_cvd_dem <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "dementia_cohorts",
  outcomeTable = "cvd_cohorts",
  interval = "years",
  repeatedEvents = TRUE,
  outcomeWashout = 180,
  completeDatabaseIntervals = TRUE
)
plotIncidence(inc, facet = c("denominator_age_group", "denominator_sex"))

#estimate period prevalence of CVD in dementia population
prev_period_cvd_dem <- estimatePeriodPrevalence(
  cdm = cdm,
  denominatorTable = "dementia_cohorts",
  outcomeTable = "cvd_cohorts",
  interval = "years",
  completeDatabaseIntervals = TRUE,
  fullContribution = TRUE
)
plotPrevalence(prev_period, facet = c("denominator_age_group", "denominator_sex"))

##Bind all results
cdm <- bind(cdm[["prev_period_dem"]],
            cdm[["inc_dem"]],
            cdm$"inc_cvd",
            cdm$"prev_period_cvd",
            cdm$"inc_cvd_dem",
            cdm$"prev_period_cvd_dem", 
              name="results_inc_prev")

## Exporting to xlsx
study_path <-"C:/Users/aballve/OneDrive - Nexus365/Dementia_CVD/Project_AD_CVD"
openxlsx::write.xlsx(cdm, 
                     file = paste0(study_path, "incidence_prevalence.xlsx"), 
                     colNames = TRUE, rowNames = FALSE)
