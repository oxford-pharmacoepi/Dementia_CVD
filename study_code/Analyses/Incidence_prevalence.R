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
    c(0, 64)
  ),
  sex = c("Male", "Female", "Both"),
  daysPriorObservation = 180
)

#estimate incidence dementia in overall population
inc <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "overall_population",
  outcomeTable = "dementia_cohorts",
  interval = "years",
  repeatedEvents = TRUE,
  outcomeWashout = 180,
  completeDatabaseIntervals = TRUE
)
plotIncidence(inc, facet = c("denominator_age_group", "denominator_sex"))


#estimate period prevalence of dementia in overall population
prev_period <- estimatePeriodPrevalence(
  cdm = cdm,
  denominatorTable = "overall_population",
  outcomeTable = "dementia_cohorts",
  interval = "years",
  completeDatabaseIntervals = TRUE,
  fullContribution = TRUE
)
plotPrevalence(prev_period, facet = c("denominator_age_group", "denominator_sex"))

#estimate incidence cvd in overall population
inc <- estimateIncidence(
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
prev_period <- estimatePeriodPrevalence(
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
cdm <- generateDenominatorCohortSet(
  cdm = cdm,
  name = "dementia_cohorts",
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
inc <- estimateIncidence(
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
prev_period <- estimatePeriodPrevalence(
  cdm = cdm,
  denominatorTable = "dementia_cohorts",
  outcomeTable = "cvd_cohorts",
  interval = "years",
  completeDatabaseIntervals = TRUE,
  fullContribution = TRUE
)
plotPrevalence(prev_period, facet = c("denominator_age_group", "denominator_sex"))


git config --global user.email "you@example.com"
git config --global user.name "Your Name"