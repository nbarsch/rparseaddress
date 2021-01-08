#' parseaddress()
#'
#' Get address parts from a string address. 
#' @param address string of address to parse
#' @param check_python TRUE or FALSE, DO NOT INSTALL MINICONDA IF PROMPTED! TRUE=check for python dependencies and install if missing, FALSE= skip check (faster if you have already have the python dependencies installed)
#' @param force_stateabb TRUE or FALSE, if TRUE state names are forced to abbreviation format for unified format
#' @param return FORMAT TYPE for RETURNED RESULTS (1. "vertical" or "v" for vertical data.frame, 2. "horizontal" or "h" for horizontal data.frame, "c" or "char" for named character vector )
#' @export
parseaddress <- function(address, check_python=TRUE, force_stateabb=FALSE, return="char"){
  
  if(isTRUE(check_python)){
    system("sudo apt-get install python3-pip -y -qq > /dev/null")
    system("sudo pip3 install usaddress -qq > /dev/null")
  }
  suppressWarnings(if(!require("reticulate")){
    sinfo <- Sys.info()
    opsys <- sinfo["sysname"]
    if(opsys=="Linux"){
      Sys.setenv(RETICULATE_PYTHON = "/usr/bin/python3") 
    }
    install.packages("reticulate")
    })
  library(reticulate)
  
  if(isTRUE(force_stateabb)){
    statein <- which(as.logical(sapply(tolower(state.name), FUN=function(x){grepl(x,tolower(address))}))==TRUE)
    if(length(statein)>0){
      stabb <- state.abb[statein]
      stname <- toupper(state.name[statein])
      address <-gsub(stname,stabb,toupper(address))
    }
  }
  
  py_run_string("
import usaddress
def adusapy(x):
  return usaddress.tag(x)
              ")
  
  adlist <- unlist(py$adusapy(address))
  adtype <- adlist[length(adlist)]
  adlist <- adlist[1:(length(adlist)-1)]
  if(return=="vertical" | tolower(return)=="v"){
    return(data.frame(parsed_address=adlist))
    
  }else{
    if(return=="horizontal" | tolower(return)=="h"){
      return(data.frame(t(data.frame(parsed_address=adlist))))
      
    }else{
      return(adlist)
    }
  }
  
  
  
}

