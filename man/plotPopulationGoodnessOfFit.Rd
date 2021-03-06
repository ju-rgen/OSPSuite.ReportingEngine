% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utilities-goodness-of-fit.R
\name{plotPopulationGoodnessOfFit}
\alias{plotPopulationGoodnessOfFit}
\title{plotPopulationGoodnessOfFit}
\usage{
plotPopulationGoodnessOfFit(structureSet, logFolder = getwd(), settings = NULL)
}
\arguments{
\item{structureSet}{`SimulationStructure` R6 class object}

\item{logFolder}{folder where the logs are saved}

\item{settings}{List of settings such as `PlotConfiguration` R6 class objects for each goodness of fit plot}
}
\value{
list with `plots`, `tables` and `residuals` objects to be saved
}
\description{
Plot goodness of fit diagnostics including time profiles,
observations vs predictions, residuals plots (residuals vs time, vs predictions, qq-plots and histogram)
}
