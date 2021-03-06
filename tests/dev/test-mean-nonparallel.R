rm(list = ls())
library(ospsuite)
library(ospsuite.reportingengine)
tree <- getSimulationTree("./tests/dev/individualPksimSim.pkml")
ms <- SimulationSet$new(
  simulationSetName = "meansim",
  simulationFile = "./tests/dev/individualPksimSim.pkml",
  outputs = Output$new(path = tree$Organism$Heart$Interstitial$smarties$Concentration$path)
)

mwf <- MeanModelWorkflow$new(simulationSets = list(ms), workflowFolder = "./ex")
mwf$simulate$settings$showProgress <- TRUE
mwf$meanModelPKParameters$activate()
mwf$meanModelSensitivityAnalysis$activate()
mwf$meanModelSensitivityAnalysis$settings$variableParameterPaths <- c(tree$Organism$Heart$Volume$path)
mwf$runWorkflow()
