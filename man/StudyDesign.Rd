% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/population-study-design.R
\name{StudyDesign}
\alias{StudyDesign}
\title{StudyDesign}
\description{
StudyDesign
}
\section{Public fields}{
\if{html}{\out{<div class="r6-fields">}}
\describe{
\item{\code{source}}{expressions used on source data}

\item{\code{targets}}{list of targets of expressions and associated values}
}
\if{html}{\out{</div>}}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-new}{\code{StudyDesign$new()}}
\item \href{#method-print}{\code{StudyDesign$print()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-new"></a>}}
\subsection{Method \code{new()}}{
Create a new `StudyDesign` object.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{StudyDesign$new(data, population, simulation)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{data}}{data.frame read from study design file}

\item{\code{population}}{`Population` object}

\item{\code{simulation}}{`Simulation` object}
}
\if{html}{\out{</div>}}
}
\subsection{Returns}{
`StudyDesign` class object
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-print"></a>}}
\subsection{Method \code{print()}}{
Print study design features
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{StudyDesign$print()}\if{html}{\out{</div>}}
}

\subsection{Returns}{
data.frame
}
}
}
