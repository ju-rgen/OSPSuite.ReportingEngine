#' @title PopulationWorkflow
#' @description R6 class for Reporting Engine Population Workflow
#' @field workflowType Type of population workflow
#' @field simulate `SimulationTask` object for time profile simulations
#' @field calculatePKParameters `CalculatePKParametersTask` object for PK parameters calculation
#' @field calculateSensitivity `SensitivityAnalysisTask` object for sensitivity analysis
#' @field plotDemography R6 class `Task` for demography plots
#' @field plotTimeProfilesAndResiduals `PlotTask` object for goodness of fit plots
#' @field plotPKParameters R6 class `Task` for PK parameters plot
#' @field plotSensitivity R6 class `Task` for sensitivity plot
#' @export
#' @import tlf
#' @import ospsuite
#' @format NULL
PopulationWorkflow <- R6::R6Class(
  "PopulationWorkflow",
  inherit = Workflow,

  public = list(
    workflowType = NULL,
    simulate = NULL,
    calculatePKParameters = NULL,
    calculateSensitivity = NULL,
    plotDemography = NULL,
    plotTimeProfilesAndResiduals = NULL,
    plotPKParameters = NULL,
    plotSensitivity = NULL,

    #' @description
    #' Create a new `PopulationWorkflow` object.
    #' @param workflowType Type of population workflow. Use enum `PopulationWorkflowTypes` to get list of workflow types.
    #' @param simulationSets list of `SimulationSet` R6 class objects
    #' @param workflowFolder path of the output folder created or used by the Workflow.
    #' @param createWordReport logical of option for creating Markdwon-Report only but not a Word-Report.
    #' @param watermark displayed watermark in every plot background
    #' @return A new `PopulationWorkflow` object
    initialize = function(workflowType,
                              simulationSets,
                              workflowFolder,
                              createWordReport = TRUE,
                              watermark = NULL) {
      super$initialize(
        simulationSets = simulationSets,
        workflowFolder = workflowFolder,
        createWordReport = createWordReport,
        watermark = watermark
      )

      validateIsOfType(c(simulationSets), "PopulationSimulationSet")
      if (!isOfType(simulationSets, "list")) {
        simulationSets <- list(simulationSets)
      }

      validateIsIncluded(workflowType, PopulationWorkflowTypes)
      self$workflowType <- workflowType

      # Pediatric and ratio comparison workflows need ONE reference population
      validateHasReferencePopulation(workflowType, simulationSets, logFolder = self$workflowFolder)
      
      self$simulate <- loadSimulateTask(self)
      self$calculatePKParameters <- loadCalculatePKParametersTask(self)
      self$calculateSensitivity <- loadCalculateSensitivityTask(self)
      
      self$plotTimeProfilesAndResiduals <- loadPlotTimeProfilesAndResidualsTask(self)
      self$plotDemography <- loadPlotDemographyTask(self)
      self$plotPKParameters <- loadPlotPKParametersTask(self)
      self$plotSensitivity  <- loadPlotSensitivityTask(self)

      self$taskNames <- enum(self$getAllTasks())
    },

    #' @description
    #' Run population workflow tasks for all simulation sets if tasks are activated
    #' The order of tasks is as follows:
    #' # 1) Run simulations
    #' # 2) Perform PK and sensitivity analyses
    #' # 3) Perform plot tasks
    #' ## 3.a) time profiles and residual plots
    #' ## 3.b) demography plots
    #' ## 3.c) PK and sensitivity analyses tables and plots
    #' # 4) Render report
    #' @return All results and plots as a structured output in the workflow folder
    runWorkflow = function() {
      actionToken1 <- re.tStartMetadataCapture(metaDataCapture = TRUE)
      logWorkflow(
        message = "Starting run of population workflow",
        pathFolder = self$workflowFolder
      )

      if (self$simulate$active) {
        self$simulate$runTask(self$simulationStructures)
      }

      if (self$calculatePKParameters$active) {
        self$calculatePKParameters$runTask(self$simulationStructures)
      }

      if (self$calculateSensitivity$active) {
        self$calculateSensitivity$runTask(self$simulationStructures)
      }

      for (plotTask in self$getAllPlotTasks()) {
        if (self[[plotTask]]$active) {
          self[[plotTask]]$runTask(self$simulationStructures)
        }
      }
      # Merge appendices into final report
      appendices <- as.character(sapply(self$getAllPlotTasks(), function(taskName) {
        self[[taskName]]$fileName
      }))
      appendices <- appendices[file.exists(appendices)]
      if (length(appendices) > 0) {
        mergeMarkdowndFiles(appendices, self$reportFileName, logFolder = self$workflowFolder)
        actionToken2 <- re.tStartAction(actionType = "ReportGeneration", actionNameExtension = "runWorkflow")
        renderReport(self$reportFileName, logFolder = self$workflowFolder, createWordReport = self$createWordReport)
        re.tEndAction(actionToken = actionToken2)
      }

      re.tStoreFileMetadata(access = "write", filePath = file.path(self$workflowFolder, defaultFileNames$logInfoFile()))
      re.tStoreFileMetadata(access = "write", filePath = file.path(self$workflowFolder, defaultFileNames$logDebugFile()))
      if (file.exists(file.path(self$workflowFolder, defaultFileNames$logErrorFile()))) {
        re.tStoreFileMetadata(access = "write", filePath = file.path(self$workflowFolder, defaultFileNames$logErrorFile()))
      }

      re.tEndMetadataCapture(outputFolder = "./", actionToken = actionToken1)
    }
  )
)

#' @title PopulationWorkflowTypes
#' @description List of population workflow available types
#' @export
PopulationWorkflowTypes <- enum(c(
  "pediatric",
  "parallelComparison",
  "ratioComparison"
))
