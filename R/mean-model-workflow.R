#' @title MeanModelWorkflow
#' @description  R6 class for Reporting Engine Mean Model Workflow
#' @field simulate `SimulationTask` object for time profile simulations
#' @field calculatePKParameters `CalculatePKParametersTask` object for PK parameters calculation
#' @field calculateSensitivity `SensitivityAnalysisTask` object for sensitivity analysis
#' @field plotTimeProfilesAndResiduals `PlotTask` object for goodness of fit plots
#' @field plotMassBalance `PlotTask` object for mass balance plot
#' @field plotAbsorption `PlotTask` object for absorption plot
#' @field plotPKParameters `PlotTask` object for PK parameters plot
#' @field plotSensitivity `PlotTask` object for sensitivity plot
#' @export
#' @import tlf
#' @import ospsuite
#' @format NULL
MeanModelWorkflow <- R6::R6Class(
  "MeanModelWorkflow",
  inherit = Workflow,

  public = list(
    simulate = NULL,
    calculatePKParameters = NULL,
    calculateSensitivity = NULL,
    plotTimeProfilesAndResiduals = NULL,
    plotMassBalance = NULL,
    plotAbsorption = NULL,
    plotPKParameters = NULL,
    plotSensitivity = NULL,

    #' @description
    #' Create a new `MeanModelWorkflow` object.
    #' @param ... input parameters inherited from R6 class object `Workflow`.
    #' @return A new `MeanModelWorkflow` object
    initialize = function(...) {
      super$initialize(...)

      self$simulate <- loadSimulateTask(self)
      self$calculatePKParameters <- loadCalculatePKParametersTask(self)
      self$calculateSensitivity <- loadCalculateSensitivityTask(self)
      
      self$plotTimeProfilesAndResiduals <- loadPlotTimeProfilesAndResidualsTask(self)
      self$plotMassBalance <- loadPlotMassBalanceTask(self)
      self$plotAbsorption <- loadPlotAbsorptionTask(self)
      self$plotPKParameters <- loadPlotPKParametersTask(self)
      self$plotSensitivity  <- loadPlotSensitivityTask(self)
      
      self$taskNames <- enum(self$getAllTasks())
    },

    #' @description
    #' Run mean model workflow tasks for all simulation sets if tasks are activated
    #' The order of tasks is as follows:
    #' # 1) Run simulations
    #' # 2) Perform PK and sensitivity analyses
    #' # 3) Perform plot tasks
    #' ## 3.a) time profiles and residual plots
    #' ## 3.b) absorption plots
    #' ## 3.c) mass balance plots
    #' ## 3.d) PK and sensitivity analyses tables and plots
    #' # 4) Render report
    #' @return All results and plots as a structured output in the workflow folder
    runWorkflow = function() {
      actionToken1 <- re.tStartMetadataCapture(metaDataCapture = TRUE)
      logWorkflow(
        message = "Starting run of mean model workflow",
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

      if (file.exists(file.path(self$reportFileName))) {
        re.tStoreFileMetadata(access = "write", filePath = self$reportFileName)
      }

      re.tEndMetadataCapture(outputFolder = "./", actionToken = actionToken1)
    }
  )
)
