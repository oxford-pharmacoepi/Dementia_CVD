info(logger, "STARTING INCIDENCE PREVALENCE")
##Overall population cohort 
#generate denominator
info(logger, "Creating denominator")
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

info(logger, "estimate incidence dementia in overall population")
results[["incidence_dementia"]] <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "overall_population",
  outcomeTable = "dementia_cohorts_incprev",
  interval = "years",
  repeatedEvents = FALSE,
  outcomeWashout = Inf,
  completeDatabaseIntervals = TRUE
)
#plotIncidence(inc, facet = c("denominator_age_group", "denominator_sex"))

info(logger, "estimate period prevalence dementia in overall population")
results[["period_prevalence_dementia"]] <- estimatePeriodPrevalence(
  cdm = cdm,
  denominatorTable = "overall_population",
  outcomeTable = "dementia_cohorts_incprev",
  interval = "years",
  completeDatabaseIntervals = TRUE,
  fullContribution = TRUE
)
#plotPrevalence(prev_period, facet = c("denominator_age_group", "denominator_sex"))

info(logger, "estimate incidence cvd in overall population")
results[["incidence_cvd"]] <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "overall_population",
  outcomeTable = "cvd_cohorts_inc",
  interval = "years",
  repeatedEvents = FALSE,
  outcomeWashout = Inf,
  completeDatabaseIntervals = TRUE
)

#plotIncidence(inc, facet = c("denominator_age_group", "denominator_sex"))

#estimate period prevalence of cvd in overall population
info(logger, "estimate period prevalence cvd in overall population")
results[["period_prevalence_cvd"]] <- estimatePeriodPrevalence(
  cdm = cdm,
  denominatorTable = "overall_population",
  outcomeTable = "cvd_cohorts_prev",
  interval = "years",
  completeDatabaseIntervals = TRUE,
  fullContribution = TRUE
)
#plotPrevalence(prev_period, facet = c("denominator_age_group", "denominator_sex"))

info(logger, "estimate incidence inc_dem_cvd in overall population")
results[["incidence_cvd_dementia"]] <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "overall_population",
  outcomeTable = "cvd_dem_cohorts_criteria_incprev",
  interval = "years",
  repeatedEvents = FALSE,
  outcomeWashout = Inf,
  completeDatabaseIntervals = TRUE
)

info(logger, "estimate period prevalence inc_dem_cvd in overall population")
results[["period_prevalence_cvd_dementia"]] <- estimatePeriodPrevalence(
  cdm = cdm,
  denominatorTable = "overall_population",
  outcomeTable = "cvd_dem_cohorts_criteria_incprev",
  interval = "years",
  completeDatabaseIntervals = TRUE,
  fullContribution = TRUE
)

##Dementia_CVD cohort 

#generate denominator
info(logger, "generate denominator dementia")
cdm <- generateTargetDenominatorCohortSet(
  cdm = cdm,
  name = "denominator_dementia",
  targetCohortTable = "dementia_cohorts_incprev",
  targetCohortId="dementia_overall",
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
info(logger, "estimate incidence cvd among dementia pop")
results[["incidence_cvd_among_dementia_pop"]] <- estimateIncidence(
  cdm = cdm,
  denominatorTable = "denominator_dementia",
  outcomeTable = "cvd_cohorts_inc",
  interval = "years",
  repeatedEvents = FALSE,
  outcomeWashout = Inf,
  completeDatabaseIntervals = TRUE
)
#plotIncidence(inc, facet = c("denominator_age_group", "denominator_sex"))

#estimate period prevalence of CVD in dementia population
info(logger, "estimate period prevalence of cvd in dementia pop")
results[["period_prevalence_cvd_among_dementia_pop"]] <- estimatePeriodPrevalence(
  cdm = cdm,
  denominatorTable = "denominator_dementia",
  outcomeTable = "cvd_cohorts_prev",
  interval = "years",
  completeDatabaseIntervals = TRUE,
  fullContribution = TRUE
)
#plotPrevalence(prev_period, facet = c("denominator_age_group", "denominator_sex"))
info(logger, "FINISHING INCIDENCE PREVALENCE")

#estimate 1 and 5 year cumulative incidence of stroke/tia among populations with dementia
info(logger, "estimate 1 and 5 year cumulative incidence of stroke/tia among populations with dementia - 0 washout")
results[["competing_risk_stroke_0_washout"]]  <- estimateCompetingRiskSurvival(cdm,
                                                                               targetCohortTable = "dementia_cohorts",
                                                                               outcomeCohortTable = "stroketia_conditions_inc",
                                                                               outcomeWashout = 0,
                                                                               competingOutcomeCohortTable = "death_dementia")

info(logger, "estimate 1 and 5 year cumulative incidence of stroke/tia among populations with dementia - Inf washout")
results[["competing_risk_stroke_inf_washout"]]  <- estimateCompetingRiskSurvival(cdm,
                                                                               targetCohortTable = "dementia_cohorts",
                                                                               outcomeCohortTable = "stroketia_conditions_inc",
                                                                               outcomeWashout = Inf,
                                                                               competingOutcomeCohortTable = "death_dementia")

#estimate 1 and 5 year cumulative incidence of hemorr stroke among populations with dementia
info(logger, "estimate 1 and 5 year cumulative incidence of hemorr stroke among populations with dementia - 0 washout")
results[["competing_risk_hemorrstroke_0_washout"]]  <- estimateCompetingRiskSurvival(cdm,
                                                                               targetCohortTable = "dementia_cohorts",
                                                                               outcomeCohortTable = "hemorr_conditions",
                                                                               outcomeWashout = 0,
                                                                               competingOutcomeCohortTable = "death_dementia")

info(logger, "estimate 1 and 5 year cumulative incidence of hemorr stroke among populations with dementia - Inf washout")
results[["competing_risk_hemorrstroke_inf_washout"]]  <- estimateCompetingRiskSurvival(cdm,
                                                                                 targetCohortTable = "dementia_cohorts",
                                                                                 outcomeCohortTable = "hemorr_conditions",
                                                                                 outcomeWashout = Inf,
                                                                                 competingOutcomeCohortTable = "death_dementia")

#estimate 1 and 5 year cumulative incidence of ICH among populations with dementia
info(logger, "estimate 1 and 5 year cumulative incidence of parenq hemorr among populations with dementia - 0 washout")
results[["competing_risk_ich_0_washout"]]  <- estimateCompetingRiskSurvival(cdm,
                                                                                     targetCohortTable = "dementia_cohorts",
                                                                                     outcomeCohortTable = "hemorr_parenq",
                                                                                     outcomeWashout = 0,
                                                                                     competingOutcomeCohortTable = "death_dementia")

info(logger, "estimate 1 and 5 year cumulative incidence of hemorr parenq among populations with dementia - Inf washout")
results[["competing_risk_ich_inf_washout"]]  <- estimateCompetingRiskSurvival(cdm,
                                                                                       targetCohortTable = "dementia_cohorts",
                                                                                       outcomeCohortTable = "hemorr_parenq",
                                                                                       outcomeWashout = Inf,
                                                                                       competingOutcomeCohortTable = "death_dementia")

#estimate 1 and 5 year cumulative incidence of ARIA-H among populations with dementia
info(logger, "estimate 1 and 5 year cumulative incidence of hemorr stroke among populations with dementia - 0 washout")
results[["competing_risk_ariah_0_washout"]]  <- estimateCompetingRiskSurvival(cdm,
                                                                            targetCohortTable = "dementia_cohorts",
                                                                            outcomeCohortTable = "aria_h",
                                                                            outcomeWashout = 0,
                                                                            competingOutcomeCohortTable = "death_dementia")

info(logger, "estimate 1 and 5 year cumulative incidence of ARIA-H among populations with dementia - Inf washout")
results[["competing_risk_ariah_inf_washout"]]  <- estimateCompetingRiskSurvival(cdm,
                                                                              targetCohortTable = "dementia_cohorts",
                                                                              outcomeCohortTable = "aria_h",
                                                                              outcomeWashout = Inf,
                                                                              competingOutcomeCohortTable = "death_dementia")