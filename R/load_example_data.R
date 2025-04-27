#' load_example_data()
#'
#' function to load examplary land surface temperature data for Berlin

#' @return three variables with district polygons, wsf raster
#'    and summer lst mean raster
#' @export

load_example_data <- function() {

  library(sf) # shapefiles and geopackages
  library(terra) # rasters

  filepath_berlin_districts <- system.file("data", "Berlin_Bezirke.shp", package = "WSFCoRRelatoR")
  filepath_lst <- system.file("data", "Berlin_LST_2013-2022_summer_mean.tif", package = "WSFCoRRelatoR")
  filepath_wsf <- system.file("data", "WSF2019_Berlin.tif", package = "WSFCoRRelatoR")

  berlin_districts <- st_read(filepath_berlin_districts)
  berlin_lst <- rast(filepath_lst)
  berlin_wsf <- rast(filepath_wsf)

  return(list(berlin_districts, berlin_lst, berlin_wsf))

}
