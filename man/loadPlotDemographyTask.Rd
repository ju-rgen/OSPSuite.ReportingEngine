% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utilities-task.R
\name{loadPlotDemographyTask}
\alias{loadPlotDemographyTask}
\title{loadPlotDemographyTask}
\usage{
loadPlotDemographyTask(workflow, active = FALSE, settings = NULL)
}
\arguments{
\item{workflow}{`PopulationWorkflow` object or derived class}

\item{active}{logical defining if `Task` will be run by workflow.
Default value is `FALSE`}

\item{settings}{specific settings for `plotDemography` task}
}
\value{
A `PlotTask` object
}
\description{
Define `plotDemography` task and its settings
}
