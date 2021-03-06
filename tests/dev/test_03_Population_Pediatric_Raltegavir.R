rm(list = ls())
library(ospsuite)

# Package directory
rootDir <- "."
devtools::load_all(rootDir)

# Where the sim and pop files for the workflow are located
dataDir <- file.path(rootDir, "tests", "dev", "ex_03_pop")

# Where the workflow results will be stored

workingDir <- file.path(rootDir)
if (!dir.exists(workingDir)) {
  dir.create(workingDir)
}
setwd(workingDir)

# Setup first simulation set input file paths
simulationFileName1 <- "LarsonSim"
populationFileName1 <- "LarsonPop"
simFilePath1 <- file.path(dataDir, paste0(simulationFileName1, ".pkml"))
popFilePath1 <- file.path(dataDir, paste0(populationFileName1, ".csv"))

# Setup Second simulation set input file paths
simulationFileName2 <- "RaltegravirSim"
populationFileName2 <- "RaltegravirPop"
simFilePath2 <- file.path(dataDir, paste0(simulationFileName2, ".pkml"))
popFilePath2 <- file.path(dataDir, paste0(populationFileName2, ".csv"))

# Load simulation trees for path retrieval
load(file.path(dataDir, "simTrees.Rdata"))

# Setup workflow using two simulation sets
popSimSet1 <- PopulationSimulationSet$new(simulationFile = simFilePath1, populationFile = popFilePath1)
popSimSet2 <- PopulationSimulationSet$new(simulationFile = simFilePath2, populationFile = popFilePath2)

# Setup workflow
popWorkFlow <- PopulationWorkflow$new(simulationSets = list(popSimSet1))
# popWorkFlow <- PopulationWorkflow$new(simulationSets = list(popSimSet1,popSimSet2))

# Number of cores for population simulation
popWorkFlow$simulatePopulation$settings$numberOfCores <- 4

# Number of cores for population sensitivity analysis
popWorkFlow$populationSensitivityAnalysis$settings$numberOfCores <- 4
popWorkFlow$populationSensitivityAnalysis$settings$variableParameterPaths <- c(
  simTree1$Organism$Skin$Volume$path,
  simTree1$Organism$Skin$`Specific blood flow rate`$path,
  simTree1$Organism$Pancreas$Volume$path,
  simTree1$Organism$Heart$Volume$path,
  simTree1$Organism$Stomach$Volume$path,
  simTree1$Organism$Spleen$Volume$path,
  simTree1$Organism$Lung$Volume$path,
  simTree1$Organism$Kidney$Volume$path
)

popWorkFlow$populationSensitivityAnalysis$settings$pkParameterSelection <- c("C_max", "t_max")

popWorkFlow$populationSensitivityAnalysis$settings$quantileVec <- c(0.25, 0.75)
popWorkFlow$runWorkflow()
