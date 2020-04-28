tracelibCheck <- function(){
  return(suppressWarnings(expr = require("tracelib",quietly = TRUE)))
}

re.tStartMetadataCapture <- function(...){
  print("tStartMetadataCapture")
  if (tracelibCheck()){
    tracelib::tStartMetadataCapture(...,offset = 2)
  }
}

re.tEndMetadataCapture <- function(...){
  print("tEndMetadataCapture")
  if (tracelibCheck()){
    tracelib::tEndMetadataCapture(...,offset = 2)
  }
}

re.tStoreFileMetadata <- function(...){
  if (tracelibCheck()){
    tracelib::tStoreFileMetadata(...)
  }
}

re.tStartAction <- function(...,re.className=NULL,re.methodName=NULL){
  print("tStartAction")
  if (tracelibCheck()){
    print(paste0(re.className,"$",re.methodName))
    tracelib::tStartAction(...,offset = 1)
  }
}

re.tEndAction <- function(...){
  print("tEndAction")
  if (tracelibCheck()){
    tracelib::tEndAction(...,offset = 1)
  }
}



# re.tStoreFileMetadata(access = "write", filePath = file.path(defaultFileNames$workflowFolderPath(), defaultFileNames$logErrorFile()))
# re.tStoreFileMetadata(access = "write", filePath = file.path(defaultFileNames$workflowFolderPath(), defaultFileNames$logDebugFile()))
# re.tStoreFileMetadata(access = "write", filePath = file.path(defaultFileNames$workflowFolderPath(), defaultFileNames$logInfoFile()))
