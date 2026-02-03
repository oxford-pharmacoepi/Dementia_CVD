#usethis::edit_r_environ() #Open your .Renviron file

# Run lines below to use renv
#renv::activate()
#renv::restore()
install.packages ("here")
install.packages("OmopSketch")
install.packages("omopgenerics")
install.packages("CohortConstructor")
install.packages("RPostgres")
install.packages("odbc")
install.packages("purrr")
install.packages("CDMConnector")
library(CDMConnector)
library(DBI)
library(dplyr)
library(here)
library(OmopSketch)
library(omopgenerics)
library(CohortConstructor)
library(PhenotypeR)
library(CohortCharacteristics)
library(PatientProfiles)
library(stringr)
library(CodelistGenerator)
library(odbc)
library(RPostgres)
library(readr)
library(purrr)

# database metadata and connection details
# The name/ acronym for the database
dbName <- "CPRD GOLD"

# Database connection details
# In this study we also use the DBI package to connect to the database
# set up the dbConnect details below
# https://darwin-eu.github.io/CDMConnector/articles/DBI_connection_examples.html
# for more details.
# you may need to install another package for this
# eg for postgres
# db <- dbConnect(
#   RPostgres::Postgres(),
#   dbname = server_dbi,i
#   port = port,
#   host = host,
#   user = user,
#   password = password
# )

db <- DBI::dbConnect(RPostgres::Postgres(), 
                     dbname = "cdm_gold_202507",
                     port = Sys.getenv("DB_PORT"),
                     host = Sys.getenv("DB_HOST"),
                     user = Sys.getenv("DB_USER"),
                     password = Sys.getenv("DB_PASSWORD"))

# The name of the schema that contains the OMOP CDM with patient-level data
cdmSchema <- "public_100k"

# A prefix for all permanent tables in the database
writePrefix <- "demencvd"

# The name of the schema where results tables will be created
writeSchema <- "results"

# The name of the schema where the achilles tables are
achillesSchema <- "results"

# minimum counts that can be displayed according to data governance
minCellCount <- 5

# Create cdm object ----
cdm <- cdmFromCon(
  con = db,
  cdmSchema = cdmSchema,
  writeSchema = writeSchema,
  writePrefix = writePrefix,
  cdmName = dbName,
  achillesSchema = achillesSchema
)

summary (cdm)

#to check the CDM version
omopgenerics::cdmVersion(cdm) #5.4

# Run study ----
source(here("run_study.R"))
