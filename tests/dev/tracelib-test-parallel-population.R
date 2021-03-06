rm(list = ls())
library(ospsuite)
library(ospsuite.reportingengine)

rootDir <- "C:/Users/ahamadeh/Dropbox/GitHub/OSP/OSPSuite.ReportingEngine"
setwd(rootDir)


runscript <- function() {
  workflowFolder <- file.path(rootDir, paste0("tests/dev/tracelib_par_pop_ex_", format(Sys.Date(), "%Y%m%d"), "_", format(Sys.time(), "%H%M%S")))
  simulationFile <- file.path(rootDir, "tests/dev/individualPksimSim.pkml")
  populationFile <- file.path(rootDir, "tests/dev/popData_short.csv")

  tree <- ospsuite::getSimulationTree(simulationFile)
  ps <- PopulationSimulationSet$new(
    simulationSetName = "nonparpopsim",
    simulationFile = simulationFile,
    populationFile = populationFile,
    outputs = Output$new(
      path = "Organism|VenousBlood|Plasma|smarties|Concentration",
      pkParameters = c("C_max", "CL")
    )
  )
  pwf <- PopulationWorkflow$new(simulationSets = list(ps), workflowFolder = workflowFolder)
  setwd(workflowFolder)
  pwf$simulatePopulation$settings$showProgress <- FALSE
  pwf$simulatePopulation$settings$numberOfCores <- 2
  pwf$simulatePopulation$activate()
  pwf$populationPKParameters$activate()
  pwf$populationSensitivityAnalysis$activate()
  pwf$populationSensitivityAnalysis$settings$showProgress <- TRUE
  pwf$populationSensitivityAnalysis$settings$variableParameterPaths <- c(tree$Organism$Heart$Volume$path, tree$Organism$Liver$Volume$path)
  pwf$populationSensitivityAnalysis$settings$numberOfCores <- 2
  pwf$populationSensitivityAnalysis$settings$quantileVec <- c(0.25, 0.75)
  pwf$plotSensitivity$activate()
  pwf$runWorkflow()
}

runscript()
