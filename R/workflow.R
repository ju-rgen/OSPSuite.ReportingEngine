#' @title Workflow
#' @description R6 class representing Reporting Engine generic Workflow
#' @field simulationStructures `SimulationStructure` R6 class object managing the structure of the workflow output
#' @field workflowFolder path of the folder create by the Workflow
#' @field taskNames Enum of task names
#' @field reportFileName name of the Rmd report file
#' @field createWordReport logical of option for creating Markdwon-Report only but not a Word-Report.
#' @import tlf
#' @import ospsuite
Workflow <- R6::R6Class(
  "Workflow",
  public = list(
    simulationStructures = NULL,
    workflowFolder = NULL,
    taskNames = NULL,
    reportFileName = NULL,
    createWordReport = NULL,
    
    #' @description
    #' Create a new `Workflow` object.
    #' @param simulationSets list of `SimulationSet` R6 class objects
    #' @param workflowFolder path of the output folder created or used by the Workflow.
    #' @param createWordReport logical of option for creating Markdwon-Report only but not a Word-Report.
    #' @param watermark displayed watermark in figures background
    #' @return A new `Workflow` object
    initialize = function(simulationSets,
                              workflowFolder,
                              createWordReport = TRUE,
                              watermark = NULL) {
      private$.reportingEngineInfo <- ReportingEngineInfo$new()

      validateIsString(workflowFolder)
      validateIsString(watermark, nullAllowed = TRUE)
      validateIsOfType(c(simulationSets), "SimulationSet")
      validateIsOfType(createWordReport, "logical")
      self$createWordReport <- createWordReport
      if (!isOfType(simulationSets, "list")) {
        simulationSets <- list(simulationSets)
      }

      allSimulationSetNames <- sapply(simulationSets, function(set) {
        set$simulationSetName
      })
      validateNoDuplicatedEntries(allSimulationSetNames)

      self$workflowFolder <- workflowFolder
      workflowFolderCheck <- file.exists(self$workflowFolder)

      if (workflowFolderCheck) {
        logWorkflow(
          message = workflowFolderCheck,
          pathFolder = self$workflowFolder,
          logTypes = c(LogTypes$Debug)
        )
      }
      dir.create(self$workflowFolder, showWarnings = FALSE)

      logWorkflow(
        message = private$.reportingEngineInfo$print(),
        pathFolder = self$workflowFolder
      )

      self$reportFileName <- file.path(self$workflowFolder, paste0(defaultFileNames$reportName(), ".md"))
      self$taskNames <- enum(self$getAllTasks())

      self$simulationStructures <- list()
      simulationSets <- c(simulationSets)
      for (simulationSetIndex in seq_along(simulationSets)) {
        self$simulationStructures[[simulationSetIndex]] <- SimulationStructure$new(
          simulationSet = simulationSets[[simulationSetIndex]],
          workflowFolder = self$workflowFolder
        )
      }
      self$setWatermark(watermark)
    },

    #' @description
    #' Get a vector with all the names of the tasks within the `Workflow`
    #' @return Vector of `Task` names
    getAllTasks = function() {
      # get isTaskVector as a named vector
      isTaskVector <- unlist(eapply(self, function(x) {
        isOfType(x, "Task")
      }))

      taskNames <- names(isTaskVector[as.logical(isTaskVector)])

      return(taskNames)
    },

    #' @description
    #' Get a vector with all the names of the plot tasks within the `Workflow`
    #' @return Vector of `PlotTask` names
    getAllPlotTasks = function() {
      # get isTaskVector as a named vector
      isPlotTaskVector <- unlist(eapply(self, function(x) {
        isOfType(x, "PlotTask")
      }))

      taskNames <- names(isPlotTaskVector[as.logical(isPlotTaskVector)])

      return(taskNames)
    },

    #' @description
    #' Get a vector with all the names of active tasks within the `Workflow`
    #' @return Vector of active `Task` names
    getActiveTasks = function() {
      return(private$.getTasksWithStatus(status = TRUE))
    },

    #' @description
    #' Get a vector with all the names of inactive tasks within the `Workflow`
    #' @return Vector of inactive `Task` names
    getInactiveTasks = function() {
      return(private$.getTasksWithStatus(status = FALSE))
    },

    #' @description
    #' Activates a series of `Tasks` from current `Workflow`
    #' @param tasks names of the worklfow tasks to activate.
    #' Default activates all tasks of the workflow using workflow method `workflow$getAllTasks()`
    #' @return Vector of inactive `Task` names
    activateTasks = function(tasks = self$getAllTasks()) {
      activateWorkflowTasks(self, tasks = tasks)
    },

    #' @description
    #' Inactivates a series of `Tasks` from current `Workflow`
    #' @param tasks names of the worklfow tasks to inactivate.
    #' Default inactivates all tasks of the workflow using workflow method `workflow$getAllTasks()`
    #' @return Vector of inactive `Task` names
    inactivateTasks = function(tasks = self$getAllTasks()) {
      inactivateWorkflowTasks(self, tasks = tasks)
    },

    #' @description
    #' Print reporting engine information obtained from initiliazing a `Workflow`
    printReportingEngineInfo = function() {
      private$.reportingEngineInfo$print()
    },
    
    #' @description
    #' Get the current watermark to be reprted on figures background
    getWatermark = function() {
      private$.watermark
    },
    
    #' @description
    #' Set the watermark to be reprted on figures background
    #' @param watermark text to be reported on figures background
    setWatermark = function(watermark) {
      validateIsString(watermark, nullAllowed = TRUE)
      private$.watermark <- ""
      if (!private$.reportingEngineInfo$isValidated()) {
        private$.watermark <- workflowWatermarkMessage
      }
      private$.watermark <- watermark %||% private$.watermark
      setWatermarkConfiguration(private$.watermark)
    },

    #' @description
    #' Print workflow list of tasks
    #' @return Task list information
    print = function() {
      tasksInfo <- list()
      for (task in self$getAllTasks()) {
        tasksInfo[[paste0("Task: '", task, "'")]] <- self[[task]]$print()
      }

      invisible(self)
      return(tasksInfo)
    }
  ),

  private = list(
    .reportingEngineInfo = NULL,
    
    .watermark = NULL,

    .getTasksWithStatus = function(status) {
      taskNames <- self$getAllTasks()

      tasksWithStatus <- NULL
      for (taskName in taskNames) {
        if (self[[taskName]]$active == status) {
          tasksWithStatus <- c(tasksWithStatus, taskName)
        }
      }
      return(tasksWithStatus)
    }
  )
)
