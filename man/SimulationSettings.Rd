% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simulation-settings.R
\name{SimulationSettings}
\alias{SimulationSettings}
\title{SimulationSettings}
\description{
R6 class for Population Simulation Settings
}
\section{Active bindings}{
\if{html}{\out{<div class="r6-active-bindings">}}
\describe{
\item{\code{numberOfCores}}{is the number of cores to use for simulation}

\item{\code{showProgress}}{is a logical field  TRUE shows progress of simulation.}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{SimulationSettings$new()}}
\item \href{#method-clone}{\code{SimulationSettings$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\subsection{Method \code{new()}}{
Create a `SimulationSettings` object
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{SimulationSettings$new(
  numberOfCores = defaultSimulationNumberOfCores,
  showProgress = FALSE
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{numberOfCores}}{number of cores for parallel computation}

\item{\code{showProgress}}{simulation progress printed to console if TRUE}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
A new `SimulationSettings` object
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-clone"></a>}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{SimulationSettings$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
