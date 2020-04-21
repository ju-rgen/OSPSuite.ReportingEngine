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

re.tStartAction <- function(...,re.className=NULL,re.methodName=NULL){
  if (tracelibCheck()){
    print(paste0(re.className,"$",re.methodName))
    tracelib::tStartAction(...)
  }
}

re.tEndAction <- function(...){
  if (tracelibCheck()){
    tracelib::tEndAction(...)
  }
}
