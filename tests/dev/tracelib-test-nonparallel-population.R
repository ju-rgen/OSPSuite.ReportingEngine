rm(list = ls())
library(ospsuite)

runscript <- function(){
  workflowFolder = paste0("C:/Users/ahamadeh/Dropbox/rproject/workflow/tracelib_nonpar_pop_ex_",format(Sys.Date(), "%Y%m%d"), "_", format(Sys.time(), "%H%M%S"))
  devtools::load_all("C:/Users/ahamadeh/Dropbox/GitHub/OSP/OSPSuite.ReportingEngine")
  tree <- getSimulationTree("C:/Users/ahamadeh/Dropbox/GitHub/OSP/OSPSuite.ReportingEngine/tests/dev/individualPksimSim.pkml")
  ps <- PopulationSimulationSet$new(
    simulationSetName = "nonparpopsim",
    simulationFile = "C:/Users/ahamadeh/Dropbox/GitHub/OSP/OSPSuite.ReportingEngine/tests/dev/individualPksimSim.pkml",
    populationFile = "C:/Users/ahamadeh/Dropbox/GitHub/OSP/OSPSuite.ReportingEngine/tests/dev/popData_short.csv",
    pathID = tree$Organism$VenousBlood$Plasma$smarties$Concentration$path
  )
  pwf <- PopulationWorkflow$new(simulationSets = list(ps), workflowFolder = workflowFolder)
  setwd(workflowFolder)
  pwf$simulatePopulation$settings$showProgress <- FALSE
  pwf$simulatePopulation$activate()
  pwf$populationPKParameters$activate()
  pwf$populationSensitivityAnalysis$activate()
  pwf$populationSensitivityAnalysis$settings$showProgress <- TRUE
  pwf$populationSensitivityAnalysis$settings$variableParameterPaths <- tree$Organism$Heart$Volume$path
  pwf$populationSensitivityAnalysis$settings$pkParameterSelection <- c("C_max", "CL")
  pwf$populationSensitivityAnalysis$settings$quantileVec <- c( 0.25 , 0.75 )
  pwf$plotGoF$activate()
  pwf$plotSensitivity$activate()
  pwf$runWorkflow()
}

runscript()

