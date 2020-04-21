tracelibCheck <- function(){
  return(suppressWarnings(expr = require("tracelib",quietly = TRUE)))
}

re.tStartMetadataCapture <- function(...){
  if (tracelibCheck()){
    tracelib::tStartMetadataCapture(...)
  }
}

re.tEndMetadataCapture <- function(...){
  if (tracelibCheck()){
    tracelib::tEndMetadataCapture(...)
  }
}

re.tStoreFileMetadata <- function(...){
  if (tracelibCheck()){
    tracelib::tStoreFileMetadata(...)
  }
}

re.tStartAction <- function(...){
  if (tracelibCheck()){
    tracelib::tStartAction(...)
  }
}

re.tEndAction <- function(...){
  if (tracelibCheck()){
    tracelib::tEndAction(...)
  }
}
