# function to calculate mean value for a raster
# based on polygon if provided

rastmeancalc <- function(raster, boundary_polygon = NULL) {

  library(sf) # shapefiles and geopackages
  library(terra) # rasters
  library(dplyr) # data manipulation
  library(exactextractr) # for accurate raster extraction with polygons

  data <- rast(raster)
  if (!is.null(boundary_polygon)) {
    boundary <- st_transform(boundary_polygon, crs(data))
    mean <- exact_extract(data, boundary, fun = 'mean') %>% round(3)

  }
  else {
    mean <- global(data, fun = 'mean')
  }

  return(mean)
}
