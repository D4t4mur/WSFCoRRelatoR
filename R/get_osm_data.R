#' @export

get_osm_buildings <- function(boundary_polygon) {
  library(osmdata)
  library(sf)

  if (!inherits(boundary_polygon, "sf")) stop("Boundary has to be a sf-object.")

  # creating bounding box from boundary polygon for osm query
  bbox <- st_bbox(boundary_polygon)

  # osm query for buildings
  osm_query <- opq(bbox = bbox) %>% add_osm_feature(key = "building")

  osm_data <- osmdata_sf(osm_query)

  # extract polygons and combine data types
  buildings <- rbind(
    osm_data$osm_polygons,
    st_cast(osm_data$osm_multipolygons, "POLYGON")
  )

  # drop of all buildings outside the boundary polygon but within bounding box
  buildings <- st_intersection(buildings, boundary_polygon)

  return(buildings)
}





get_osm_nature <- function(boundary_polygon) {
  library(osmdata)
  library(sf)

  if (!inherits(boundary_polygon, "sf")) stop("Boundary has to be a sf-object.")

  # creating bounding box from boundary polygon for osm query
  bbox <- st_bbox(boundary_polygon)

  # osm query for natural area
  osm_query <- opq(bbox = bbox) %>% add_osm_feature(key = "natural")

  osm_data <- osmdata_sf(osm_query)

  # extract polygons and combine data types
  nature <- rbind(
    osm_data$osm_polygons,
    st_cast(osm_data$osm_multipolygons, "POLYGON")
  )

  # drop of all buildings outside the boundary polygon but within bounding box
  nature <- st_intersection(nature, boundary_polygon)

  return(nature)
}


# more filter/making separate tiles
