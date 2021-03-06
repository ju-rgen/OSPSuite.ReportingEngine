% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/population-workflow.R
\name{PopulationWorkflow}
\alias{PopulationWorkflow}
\title{PopulationWorkflow}
\description{
R6 class for Reporting Engine Population Workflow
}
\section{Super class}{
\code{\link[ospsuite.reportingengine:Workflow]{ospsuite.reportingengine::Workflow}} -> \code{PopulationWorkflow}
}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{workflowType}}{Type of population workflow}

\item{\code{simulate}}{`SimulationTask` object for time profile simulations}

\item{\code{calculatePKParameters}}{`CalculatePKParametersTask` object for PK parameters calculation}

\item{\code{calculateSensitivity}}{`SensitivityAnalysisTask` object for sensitivity analysis}

\item{\code{plotDemography}}{R6 class `Task` for demography plots}

\item{\code{plotTimeProfilesAndResiduals}}{`PlotTask` object for goodness of fit plots}

\item{\code{plotPKParameters}}{R6 class `Task` for PK parameters plot}

\item{\code{plotSensitivity}}{R6 class `Task` for sensitivity plot}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{PopulationWorkflow$new()}}
\item \href{#method-runWorkflow}{\code{PopulationWorkflow$runWorkflow()}}
\item \href{#method-clone}{\code{PopulationWorkflow$clone()}}
}
}
\if{html}{
\out{<details ><summary>Inherited methods</summary>}
\itemize{
\item \out{<span class="pkg-link" data-pkg="ospsuite.reportingengine" data-topic="Workflow" data-id="activateTasks">}\href{../../ospsuite.reportingengine/html/Workflow.html#method-activateTasks}{\code{ospsuite.reportingengine::Workflow$activateTasks()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="ospsuite.reportingengine" data-topic="Workflow" data-id="getActiveTasks">}\href{../../ospsuite.reportingengine/html/Workflow.html#method-getActiveTasks}{\code{ospsuite.reportingengine::Workflow$getActiveTasks()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="ospsuite.reportingengine" data-topic="Workflow" data-id="getAllPlotTasks">}\href{../../ospsuite.reportingengine/html/Workflow.html#method-getAllPlotTasks}{\code{ospsuite.reportingengine::Workflow$getAllPlotTasks()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="ospsuite.reportingengine" data-topic="Workflow" data-id="getAllTasks">}\href{../../ospsuite.reportingengine/html/Workflow.html#method-getAllTasks}{\code{ospsuite.reportingengine::Workflow$getAllTasks()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="ospsuite.reportingengine" data-topic="Workflow" data-id="getInactiveTasks">}\href{../../ospsuite.reportingengine/html/Workflow.html#method-getInactiveTasks}{\code{ospsuite.reportingengine::Workflow$getInactiveTasks()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="ospsuite.reportingengine" data-topic="Workflow" data-id="getWatermark">}\href{../../ospsuite.reportingengine/html/Workflow.html#method-getWatermark}{\code{ospsuite.reportingengine::Workflow$getWatermark()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="ospsuite.reportingengine" data-topic="Workflow" data-id="inactivateTasks">}\href{../../ospsuite.reportingengine/html/Workflow.html#method-inactivateTasks}{\code{ospsuite.reportingengine::Workflow$inactivateTasks()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="ospsuite.reportingengine" data-topic="Workflow" data-id="print">}\href{../../ospsuite.reportingengine/html/Workflow.html#method-print}{\code{ospsuite.reportingengine::Workflow$print()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="ospsuite.reportingengine" data-topic="Workflow" data-id="printReportingEngineInfo">}\href{../../ospsuite.reportingengine/html/Workflow.html#method-printReportingEngineInfo}{\code{ospsuite.reportingengine::Workflow$printReportingEngineInfo()}}\out{</span>}
\item \out{<span class="pkg-link" data-pkg="ospsuite.reportingengine" data-topic="Workflow" data-id="setWatermark">}\href{../../ospsuite.reportingengine/html/Workflow.html#method-setWatermark}{\code{ospsuite.reportingengine::Workflow$setWatermark()}}\out{</span>}
}
\out{</details>}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\subsection{Method \code{new()}}{
Create a new `PopulationWorkflow` object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PopulationWorkflow$new(
  workflowType,
  simulationSets,
  workflowFolder,
  createWordReport = TRUE,
  watermark = NULL
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{workflowType}}{Type of population workflow. Use enum `PopulationWorkflowTypes` to get list of workflow types.}

\item{\code{simulationSets}}{list of `SimulationSet` R6 class objects}

\item{\code{workflowFolder}}{path of the output folder created or used by the Workflow.}

\item{\code{createWordReport}}{logical of option for creating Markdwon-Report only but not a Word-Report.}

\item{\code{watermark}}{displayed watermark in every plot background}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A new `PopulationWorkflow` object
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-runWorkflow"></a>}}
\subsection{Method \code{runWorkflow()}}{
Run population workflow tasks for all simulation sets if tasks are activated
The order of tasks is as follows:
# 1) Run simulations
# 2) Perform PK and sensitivity analyses
# 3) Perform plot tasks
## 3.a) time profiles and residual plots
## 3.b) demography plots
## 3.c) PK and sensitivity analyses tables and plots
# 4) Render report
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PopulationWorkflow$runWorkflow()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
All results and plots as a structured output in the workflow folder
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{PopulationWorkflow$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
