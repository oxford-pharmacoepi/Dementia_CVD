
#install.packages("renv") # if not already installed, install renv from CRAN
renv::restore() # this should prompt you to install the various packages required for the study
renv::activate()

# packages -----
# load the below packages 
# you should have them all available, with the required version, after
# having run renv::restore above
library(DatabaseConnector)
library(CohortDiagnostics)
library(CirceR)
library(CohortGenerator)
library(here)
library(stringr)
library(tibble)
library(dplyr)

# database metadata and connection details -----
# The name/ acronym for the database
db.name <- "..."

# database connection details
server <- "..."
user <- "..."
password <- "..."
port <- "..."
host <- "..."

# sql dialect used with the OHDSI SqlRender package
targetDialect <- "..." 

# driver for DatabaseConnector
downloadJdbcDrivers(targetDialect, here()) # if you already have this you can omit and change pathToDriver below
connectionDetails <- createConnectionDetails(
  dbms = targetDialect, 
  server = server, 
  user = user, 
  password = password, 
  port = port, 
  pathToDriver = here()
)

# schema that contains the OMOP CDM with patient-level data
cdm_database_schema <- "..."
# schema that contains the vocabularie
vocabulary_database_schema <- "..."
# schema where a results table will be created 
results_database_schema <- "..."

# stem for tables to be created in your results schema for this analysis
# You can keep the above names or change them
# Note, any existing tables in your results schema with the same name will be overwritten
cohortTableStem <- "..."

# Run analysis ----
source(here("RunAnalysis.R"))

# merge results -----
CohortDiagnostics::preMergeDiagnosticsFiles(dataFolder = here("Results"))

# To visualize or publish the shiny use:
# https://github.com/oxford-pharmacoepi/DiagnosticsExplorerTemplate

