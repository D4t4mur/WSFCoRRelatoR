library(httr)
library(jsonlite)
library(sf)

get_landsat_lst_appeears <- function(username, password, aoi_sf, start_date, end_date,
                                     product = "Landsat_L2_C2_LST", layer = "LST_ST_B10",
                                     task_name = "landsat_lst_task", output_dir = "appeears_results") {
  # Convert sf to GeoJSON-like list
  aoi_geojson <- st_as_text(st_geometry(aoi_sf)[1])
  coords <- list()
  for (ring in st_coordinates(st_geometry(aoi_sf))[ ,1:2]) {
    coords <- append(coords, list(as.numeric(ring)))
  }
  coords <- append(coords, list(coords[[1]]))  # Close polygon

  geojson_payload <- list(
    type = "FeatureCollection",
    features = list(list(
      type = "Feature",
      properties = list(),  # FIXED
      geometry = list(
        type = "Polygon",
        coordinates = list(coords)
      )
    ))
  )

  # Prepare task body
  task <- list(
    task_type = "area",
    task_name = task_name,
    params = list(
      dates = list(list(startDate = start_date, endDate = end_date)),
      layers = list(list(layer = layer, product = product)),
      output = list(format = list(type = "geotiff")),
      geo = geojson_payload
    )
  )

  # Submit task
  auth <- authenticate(username, password)
  submit_url <- "https://appeears.earthdatacloud.nasa.gov/api/task"
  response <- POST(submit_url, auth, body = task, encode = "json", content_type_json())

  # Überprüfe die Antwort der API
  task_info <- content(response, as = "parsed")
  if (status_code(response) != 200 || is.null(task_info$id)) {
    cat("❌ Fehler bei der Aufgabenübermittlung. Antwort der API:\n")
    print(task_info)  # Zeige die vollständige Antwort
    stop("Task submission failed.")
  }

  cat("✅ Task submitted. Task ID:", task_info$id, "\n")

  # Wait for task to complete
  task_id <- task_info$id
  repeat {
    Sys.sleep(15)
    status_response <- GET(paste0(submit_url, "/", task_id), auth)
    status <- content(status_response, as = "parsed")
    cat("📊 Task status:", status$status, "\n")
    if (status$status == "done") break
  }

  # Get download URLs
  dl_url <- paste0("https://appeears.earthdatacloud.nasa.gov/api/task/", task_id, "/bundle")
  bundle_response <- GET(dl_url, auth)
  bundle_info <- content(bundle_response, as = "parsed")

  dir.create(output_dir, showWarnings = FALSE)
  for (file in bundle_info$files) {
    file_url <- file$href
    destfile <- file.path(output_dir, basename(file_url))
    cat("⬇️ Downloading", destfile, "\n")
    GET(file_url, auth, write_disk(destfile, overwrite = TRUE))
  }

  cat("✅ All files downloaded to", output_dir, "\n")
}


get_landsat_lst_appeears("nitre", "FreeData4al!", pol_berlin, "2023-07-01", "2023-07-15",
                         product = "Landsat_L2_C2_SR", layer = "SR_B4")


# Lade notwendige Bibliotheken
library(httr)
library(jsonlite)

# Deine Earthdata Zugangsdaten
username <- "nitre"
password <- "FreeData4al!"

# Sende GET-Anfrage an die AppEEARS-API, um eine Liste von Produkten zu erhalten
response <- GET("https://appeears.earthdatacloud.nasa.gov/api/product", authenticate(username, password))

# Überprüfe, ob die Anfrage erfolgreich war
if (status_code(response) == 200) {
  # Die Antwort als JSON parsen
  product_response <- content(response, as = "text", encoding = "UTF-8")
  products <- fromJSON(product_response)

  # Zeige die ersten paar Produkte an (optional)
  print(head(products))

  # Optional: Wenn du nur Landsat-Produkte filtern möchtest
  landsat_products <- products %>% filter(grepl("Landsat", ProductAndVersion))
  print(landsat_products)
} else {
  # Fehlerbehandlung: Anfrage war nicht erfolgreich
  cat("Fehler bei der Anfrage. Statuscode:", status_code(response), "\n")
  print(content(response, as = "parsed"))  # Detaillierte Fehlerantwort anzeigen
}


