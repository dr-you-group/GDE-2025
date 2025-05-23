#.libPaths(")
#renv::status()
#renv::restore()


library(GDE2025antiplatelet)

# Optional: specify where the temporary files (used by the Andromeda package) will be created:
options(andromedaTempFolder = "C:/andromedaTemp")

# Maximum number of cores to be used:
maxCores <- parallel::detectCores() - 1

# The folder where the study intermediate and result files will be written:
outputFolder <- "C:/Users/paul9/Rprojects/GDE2025result"

# Details for connecting to the server:
connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = "",
                                                                user = "",
                                                                password = "",
                                                                server = "")
conn <- connect(connectionDetails)

# The name of the database schema where the CDM data can be found:
cdmDatabaseSchema <- "CDM_v531_YUHS.CDM"

# The name of the database schema and table where the study-specific cohorts will be instantiated:
cohortDatabaseSchema <- "cohortdb.changhoonhan"
cohortTable <- "TicaPra"

# Some meta-information that will be used by the export function:
databaseId <- "IBM_MDCR"
databaseName <- "IBM MarketScan® Medicare Supplemental and Coordination of Benefits Database"
databaseDescription <- "IBM MarketScan® Medicare Supplemental and Coordination of Benefits Database (MDCR) represents health services of retirees in the United States with primary or Medicare supplemental coverage through privately insured fee-for-service, point-of-service, or capitated health plans.  These data include adjudicated health insurance claims (e.g. inpatient, outpatient, and outpatient pharmacy). Additionally, it captures laboratory tests for a subset of the covered lives."

# For some database platforms (e.g. Oracle): define a schema that can be used to emulate temp tables:
options(sqlRenderTempEmulationSchema = NULL)

execute(connectionDetails = connectionDetails,
        cdmDatabaseSchema = cdmDatabaseSchema,
        cohortDatabaseSchema = cohortDatabaseSchema,
        cohortTable = cohortTable,
        outputFolder = outputFolder,
        databaseId = databaseId,
        databaseName = databaseName,
        databaseDescription = databaseDescription,
        verifyDependencies = FALSE,
        createCohorts = TRUE,
        synthesizePositiveControls = TRUE,
        runAnalyses = TRUE,
        packageResults = TRUE,
        maxCores = maxCores)

resultsZipFile <- file.path(outputFolder, "export", paste0("Results_", databaseId, ".zip"))
dataFolder <- file.path(outputFolder, "shinyData")

# You can inspect the results if you want:
prepareForEvidenceExplorer(resultsZipFile = resultsZipFile, dataFolder = dataFolder)
launchEvidenceExplorer(dataFolder = dataFolder, blind = TRUE, launch.browser = FALSE)

# Upload the results to the OHDSI SFTP server:
# privateKeyFileName <- ""
# userName <- ""
# uploadResults(outputFolder, privateKeyFileName, userName)
