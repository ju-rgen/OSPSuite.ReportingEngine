rm(list = ls())
library(ospsuite)

workflowFolder = paste0("C:/Users/ahamadeh/Dropbox/rproject/workflow/ex_",format(Sys.Date(), "%Y%m%d"), "_", format(Sys.time(), "%H%M%S"))

devtools::load_all("C:/Users/ahamadeh/Dropbox/GitHub/OSP/OSPSuite.ReportingEngine")
tree <- getSimulationTree("C:/Users/ahamadeh/Dropbox/GitHub/OSP/OSPSuite.ReportingEngine/tests/dev/individualPksimSim.pkml")
  ms <- SimulationSet$new(
  simulationSetName = "meansim",
  simulationFile = "C:/Users/ahamadeh/Dropbox/GitHub/OSP/OSPSuite.ReportingEngine/tests/dev/individualPksimSim.pkml",
  pathID = tree$Organism$Heart$Interstitial$smarties$Concentration$path
)

mwf <- MeanModelWorkflow$new(simulationSets = list(ms) , workflowFolder = workflowFolder)
setwd(workflowFolder)



mwf$simulate$settings$showProgress <- TRUE
mwf$meanModelPKParameters$activate()
mwf$meanModelSensitivityAnalysis$inactivate()
#mwf$meanModelSensitivityAnalysis$settings$variableParameterPaths <- c(tree$Organism$Heart$Volume$path)
mwf$runWorkflow()
