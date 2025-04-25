#' functions to combine results extracted from the rasters
#' into data frame and and export as csv if needed

#' @param name vector with objective names
#' @param raster vector extracted mean raster values
#' @param wsf vector with extracted wsf values
#' @param export boolean if an export of the matrix in csv-format is needed
#' @return data frame with name columnn and extracted values of examined raster
#'    and wsf
#' @export


combine <- function(name, raster, wsf, export = FALSE) {
  if (!(length(name) == length(raster) && length(raster) == length(wsf))) {
    stop("All input vectors have to be the same length.")
  }

  results <- data.frame(
    name = name,
    raster = raster,
    wsf = wsf
  )

  if (export == TRUE) {
    write.csv(results, file = "combined_results.csv", row.names = FALSE)
  }

  return(results)
}
