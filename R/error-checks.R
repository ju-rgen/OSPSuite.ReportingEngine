isSameLength <- function(...) {
  args <- list(...)
  nrOfLengths <- length(unique(lengths(args)))

  return(nrOfLengths == 1)
}

#' Check if the provided object has nbElements elements
#'
#' @param object An object or a list of objects
#' @param nbElements number of elements that are supposed in object
#'
#' @return TRUE if the object or all objects inside the list have nbElements.
#' Only the first level of the given list is considered.
isOfLength <- function(object, nbElements) {
  return(length(object) == nbElements)
}

validateIsOfLength <- function(object, nbElements) {
  if (isOfLength(object, nbElements)) {
    return()
  }
  logErrorThenStop(messages$errorWrongLength(object, nbElements))
}

#' Check if the provided object is of certain type
#'
#' @param object An object or a list of objects
#' @param type String  representation or Class of the type that should be checked for
#'
#' @return TRUE if the object or all objects inside the list are of the given type.
#' Only the first level of the given list is considered.
isOfType <- function(object, type) {
  if (is.null(object)) {
    return(FALSE)
  }

  type <- typeNamesFrom(type)

  inheritType <- function(x) inherits(x, type)

  if (inheritType(object)) {
    return(TRUE)
  }
  object <- c(object)

  all(sapply(object, inheritType))
}

validateIsOfType <- function(object, type, nullAllowed = FALSE) {
  if (nullAllowed && is.null(object)) {
    return()
  }

  if (isOfType(object, type)) {
    return()
  }
  # Name of the variable in the calling function
  objectName <- deparse(substitute(object))
  objectTypes <- typeNamesFrom(type)

  logErrorThenStop(messages$errorWrongType(objectName, class(object)[1], objectTypes))
}

validateIsInteger <- function(object, nullAllowed = FALSE) {
  validateIsOfType(object, c("numeric", "integer"), nullAllowed)

  if (isFALSE(object %% 1 == 0)) {
    logErrorThenStop(messages$errorWrongType(deparse(substitute(object)), class(object)[1], "integer"))
  }
}

validateIsPositive <- function(object, nullAllowed = FALSE) {
  validateIsOfType(object, c("numeric", "integer"), nullAllowed)

  if (isFALSE(object > 0)) {
    logErrorThenStop(messages$errorWrongType(deparse(substitute(object)), class(object)[1], "positive"))
  }
}

hasPositiveValues <- function(object){
  object <- object[!is.na(object)]
  object <- object[!is.infinite(object)]
  positiveValues <- object > 0
  return(!sum(positiveValues) == 0)
}


validateIsInRange <- function(variableName, value, lowerBound, upperBound, nullAllowed = FALSE) {
  validateIsOfLength(value, 1)
  validateIsOfLength(lowerBound, 1)
  validateIsOfLength(upperBound, 1)
  validateIsOfType(c(value, lowerBound, upperBound), c("numeric"), nullAllowed)
  if ((value < lowerBound) | (value > upperBound)) {
    logErrorThenStop(messages$outsideRange(variableName, value, lowerBound, upperBound))
  }
}

validateEnumValue <- function(enum, value) {
  if (value %in% names(enum)) {
    return()
  }

  logErrorThenStop(messages$errorValueNotInEnum(enum, value))
}

typeNamesFrom <- function(type) {
  if (is.character(type)) {
    return(type)
  }
  type <- c(type)
  sapply(type, function(t) t$classname)
}

validateIsString <- function(object, nullAllowed = FALSE) {
  validateIsOfType(object, "character", nullAllowed)
}

validateIsNumeric <- function(object, nullAllowed = FALSE) {
  validateIsOfType(object, c("numeric", "integer"), nullAllowed)
}

validateIsLogical <- function(object, nullAllowed = FALSE) {
  validateIsOfType(object, "logical", nullAllowed)
}

validateIsSameLength <- function(...) {
  if (isSameLength(...)) {
    return()
  }
  # Name of the variable in the calling function
  objectName <- deparse(substitute(list(...)))

  # Name of the arguments
  argnames <- sys.call()
  arguments <- paste(lapply(argnames[-1], as.character), collapse = ", ")

  logErrorThenStop(messages$errorDifferentLength(arguments))
}

validateNoDuplicatedEntries <- function(x) {
  if (any(duplicated(x))) {
    logErrorThenStop(messages$errorDuplicatedEntries(deparse(substitute(x))))
  }
  return()
}

#' Check if the provided object is included in a parent object
#'
#' @param values Vector of values
#' @param parentValues Vector of values
#'
#' @return TRUE if the values are inside the parent values.
isIncluded <- function(values, parentValues) {
  if (is.null(values)) {
    return(FALSE)
  }

  return(as.logical(min(values %in% parentValues)))
}

validateIsIncluded <- function(values, parentValues, nullAllowed = FALSE, groupName = NULL, logFolder = NULL) {
  if (nullAllowed && is.null(values)) {
    return()
  }

  if (isIncluded(values, parentValues)) {
    return()
  }
  if(is.null(logFolder)){
    stop(messages$errorNotIncluded(values, parentValues, groupName))
  }
  logErrorThenStop(messages$errorNotIncluded(values, parentValues, groupName), logFolder)
}

checkIsIncluded <- function(values, parentValues, nullAllowed = FALSE, groupName = NULL, logFolder = NULL) {
  if (nullAllowed && is.null(values)) {
    return()
  }

  if (isIncluded(values, parentValues)) {
    return()
  }
  if(is.null(logFolder)){
    warning(messages$errorNotIncluded(values, parentValues, groupName), call. = FALSE, immediate. = TRUE)
    return()
  }
  logWorkflow(
    message = messages$errorNotIncluded(values, parentValues, groupName),
    pathFolder = logFolder,
    logTypes = c(LogTypes$Debug, LogTypes$Error)
  )
}

validateMapping <- function(mapping, data, nullAllowed = FALSE) {
  if (nullAllowed && is.null(mapping)) {
    return()
  }

  validateIsString(mapping)
  variableNames <- names(data)

  validateIsIncluded(mapping, variableNames)

  return()
}

checkExisitingPath <- function(path, stopIfPathExists = FALSE) {
  if (!dir.exists(path)) {
    return()
  }
  if (stopIfPathExists) {
    logErrorThenStop(messages$warningExistingPath(path))
  }

  warning(messages$warningExistingPath(path))
}

checkOverwriteExisitingPath <- function(path, overwrite) {
  if (!dir.exists(path)) {
    return()
  }
  warning(messages$warningExistingPath(path))
  if (overwrite) {
    warning(messages$warningOverwriting(path))
    unlink(path, recursive = TRUE)
  }
}

fileExtension <- function(file) {
  ex <- strsplit(basename(file), split = "\\.")[[1]]
  return(utils::tail(ex, 1))
}

#' Check if the provided path has required extension
#'
#' @param file file or path name to be checked
#' @param extension extension of the file required after "."
#'
#' @return TRUE if the path includes the extension
isFileExtension <- function(file, extension) {
  extension <- c(extension)
  file_ext <- fileExtension(file)
  file_ext %in% extension
}

validateIsFileExtension <- function(path, extension, nullAllowed = FALSE) {
  if (nullAllowed && is.null(path)) {
    return()
  }
  if (isFileExtension(path, extension)) {
    return()
  }
  logErrorThenStop(messages$errorExtension(path, extension))
}

#' Log the error with a message and then stop, displaying same message.
#'
#' @param message message to display and then log
#' @param logFolderPath path where logs are saved
logErrorThenStop <- function(message, logFolderPath = getwd()) {
  logWorkflow(
    message = message,
    pathFolder = logFolderPath,
    logTypes = c(LogTypes$Info, LogTypes$Debug, LogTypes$Error)
  )
  stop(message, call. = FALSE)
}

#' Log the error with a message
#' @param message message to display and then log
#' @param logFolderPath path where logs are saved
logErrorMessage <- function(message, logFolderPath = getwd()) {
  logWorkflow(
    message = message,
    pathFolder = logFolderPath,
    logTypes = c(LogTypes$Info, LogTypes$Debug, LogTypes$Error)
  )
}

validateObservedMetaDataFile <- function(observedMetaDataFile, observedDataFile) {
  if (!is.null(observedMetaDataFile)) {
    dictionary <- readObservedDataFile(observedMetaDataFile)
    validateIsIncluded(c(dictionaryParameters$ID, dictionaryParameters$nonmenColumn), names(dictionary))
    validateIsIncluded(c(dictionaryParameters$timeID, dictionaryParameters$dvID), dictionary[, dictionaryParameters$ID])

    observedDataset <- readObservedDataFile(observedDataFile)
    timeVariable <- getDictionaryVariable(dictionary, dictionaryParameters$timeID)
    dvVariable <- getDictionaryVariable(dictionary, dictionaryParameters$dvID)
    lloqVariable <- getDictionaryVariable(dictionary, dictionaryParameters$lloqID)

    checkIsIncluded(c(timeVariable, dvVariable), names(observedDataset))
    checkIsIncluded(lloqVariable, names(observedDataset), nullAllowed = TRUE)
    return()
  }
  stop(messages$errorObservedMetaDataFileNotProvided(observedDataFile))
}

#' Check if the provided values are included all available dimensions
#' @param values Vector of dimensions
#' @return TRUE if the values are included all available dimensions
#' @import ospsuite
isDimension <- function(values) {
  allAvailableDimensions <- ospsuite::allAvailableDimensions()
  return(isIncluded(c(values), allAvailableDimensions))
}

validateIsDimension <- function(values, nullAllowed = FALSE) {
  if (nullAllowed && is.null(values)) {
    return()
  }

  if (isDimension(values)) {
    return()
  }

  logErrorThenStop(messages$errorNotADimension(values))
}

isPathInSimulation <- function(paths, simulation) {
  # Add every paths to the simulation object and
  # check if all of these paths are included
  ospsuite::addOutputs(quantitiesOrPaths = paths, simulation = simulation)
  allSimulationOutputPaths <- sapply(simulation$outputSelections$allOutputs, function(output) {
    output$path
  })
  return(isIncluded(paths, allSimulationOutputPaths))
}

validateIsPathInSimulation <- function(paths, simulation, nullAllowed = FALSE) {
  if (nullAllowed && is.null(paths)) {
    return()
  }
  if (isPathInSimulation(paths, simulation)) {
    return()
  }
  logErrorThenStop(message = messages$invalidOuputPath(paths, simulation$name))
}

validateOutputObject <- function(outputs, simulation, nullAllowed = FALSE) {
  if (nullAllowed && is.null(outputs)) {
    return()
  }
  validateIsOfType(c(outputs), "Output")
  # Check paths existence
  allOutputPaths <- sapply(outputs, function(output) {
    output$path
  })
  validateIsPathInSimulation(allOutputPaths, simulation)

  # Check display unit
  for (output in outputs) {
    outputQuantity <- ospsuite::getQuantity(output$path, simulation)
    validateIsUnitFromDimension(output$displayUnit, outputQuantity$dimension, nullAllowed = TRUE)
  }
}

isUnitFromDimension <- function(unit, dimension) {
  dimensionForUnit <- ospsuite::getDimensionForUnit(unit)
  # Remove molar/mass for units that can cross dimensions using molar weight
  dimension <- sub("(mass)", "", dimension)
  dimension <- sub("(molar)", "", dimension)
  dimensionForUnit <- sub("(mass)", "", dimensionForUnit)
  dimensionForUnit <- sub("(molar)", "", dimensionForUnit)
  if (isOfLength(dimensionForUnit, 0)) {
    return(FALSE)
  }
  return(dimensionForUnit %in% dimension)
}

validateIsUnitFromDimension <- function(unit, dimension, nullAllowed = FALSE) {
  if (nullAllowed && is.null(unit)) {
    return()
  }
  if (isUnitFromDimension(unit, dimension)) {
    return()
  }
  stop(messages$errorUnitNotFromDimension(unit, dimension))
}

validateHasReferencePopulation <- function(workflowType, simulationSets, logFolder = NULL){
  if(isIncluded(workflowType, PopulationWorkflowTypes$parallelComparison)){
    return()
  }
  allSimulationReferences <- sapply(simulationSets, function(set) {set$referencePopulation})
  
  if(isOfLength(allSimulationReferences[allSimulationReferences], 1)){
    return()
  }
  if(is.null(logFolder)){
    stop(messages$warningNoReferencePopulation(workflowType))
  }
  logErrorThenStop(messages$warningNoReferencePopulation(workflowType), logFolder)
}