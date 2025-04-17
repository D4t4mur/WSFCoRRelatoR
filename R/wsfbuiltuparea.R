# function to extract all the built up area pixels from world settlement footprint raster
# into new raster

builtuparea <- function(wsf_raster, boundary_polygon = NULL) {

  library(sf) # shapefiles and geopackages
  library(terra) # rasters
  library(dplyr) # data manipulation
  library(exactextractr) # for accurate raster extraction with polygons

  data <- rast(wsf_raster)
  if (!is.null(boundary_polygon)) {
    boundary <- st_transform(boundary_polygon, crs(data))
    builtup <- as.polygons(data == 1, dissolve = TRUE, na.rm = TRUE)
  }

  else {
    builtup <- as.polygons(data == 1, dissolve = TRUE, na.rm = TRUE)
  }

  return(builtup)
}
