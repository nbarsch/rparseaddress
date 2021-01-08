#' parseaddressvec()
#'
#' Get address parts from a string addresses in a vector 
#' @param addressvec string vector of addresses to parse, to use a df column use df_name$address_column_name
#' @param return option to return single address characteristic, i.e. Zipcode
#' @export
parseaddressvec <- function(addressvec, return="all"){
  require(tfwstring)
  require(data.table)
  require(dplyr)
  #adf <- data.frame(adnum=c(1:length(addressvec)),address=as.character(addressvec),stringsAsFactors = F)
  dflist <- lapply(c(1:length(addressvec)),FUN=function(x){data.frame(parseaddress(addressvec[x], return="horizontal"),stringsAsFactors = F)})
  dfres <- rbindlist(dflist, fill=T)
  dfres %>% mutate_all(as.character)->dfres
  dfres <- data.frame(dfres,stringsAsFactors = F)
  if(return=="all"){
    return(rbindlist(dflist, fill=T))
  }else{
    dfres$tecreturn <- dfres[,paste0(return)]
    return(dfres$tecreturn)
  }
  
}

