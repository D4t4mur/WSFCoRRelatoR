# function to calculate mean value for land surface temperature raster
# based on polygon if provided

lstcalc <- function(raster, boundary_polygon = NULL) {

  library(sf) # shapefiles and geopackages
  library(terra) # rasters
  library(dplyr) # data manipulation
  library(exactextractr) # for accurate raster extraction with polygons

  lst_data <- rast(raster)
  if (!is.null(boundary_polygon)) {
    boundary <- st_transform(boundary_polygon, crs(lst_data))
    lst_mean <- exact_extract(lst_data, boundary, fun = 'mean') %>% round(3)

  }
  else {
    lst_mean <- global(lst_data, fun = 'mean')
  }


  return(lst_mean)
}
