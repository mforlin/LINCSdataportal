#' Retrieve metadata associated with a Small Molecule (SM) used in LINCS experiments.
#'
#' @param sm String containing the name of a small molecule of interest
#' @return data frame with available small molecule metadata
#' @export
#' @examples
#' SM_metadata("afatinib")
#' SM_metadata("GSK-1070916")
#'

SM_metadata=function(sm)
{
  xnew=paste(toupper(substr(sm, 1, 1)), substr(sm, 2, nchar(sm)), sep="")
  url <- httr::modify_url("http://lincsportal.ccs.miami.edu", path = paste("/dcic/api/fetchentities?searchTerm=entityName:",xnew,"&fields=lincsidentifier,entityName,SM_Alternative_Name,category,source,SM_Category,SM_InChi_Parent,SM_SMILES_Parent",sep = ""))
  resp <- httr::GET(url)
  if(httr::status_code(resp)>400 & httr::status_code(resp)<500) {
     stop("API returned an error", call. = FALSE)
    }

   parsed =  jsonlite::fromJSON(httr::content(resp, "text"))
   if(parsed$results$totalDocuments==0)
   { stop(paste("No small molecule found in LINCS with '",sm, "' name",sep=""), call. = FALSE)
     }

   return(parsed$results$documents)
}
