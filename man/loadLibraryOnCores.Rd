% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utilities-mpi-error-handling.R
\name{loadLibraryOnCores}
\alias{loadLibraryOnCores}
\title{loadLibraryOnCores}
\usage{
loadLibraryOnCores(libraryName, logFolder)
}
\arguments{
\item{libraryName}{string containing name of library to be loaded}

\item{logFolder}{folder where the logs are saved}
}
\description{
Send libraryName to core, load the library and check that it has been loaded successfully
}
