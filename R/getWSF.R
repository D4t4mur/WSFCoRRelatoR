# functions to get the World Settlement Footprint from 2019 calculated and published by
# the German Aerospace Center

library(httr)
library(rvest)
library(xml2)
library(stringr)

# Basis-URL für WSF2019 Tiles
base_url <- "https://download.geoservice.dlr.de/WSF2019/"
target_dir <- "wsf2019_data"
dir.create(target_dir, showWarnings = FALSE)

# Optional: Nur bestimmte Region laden (z.B. "EUR", "AFR", "ASI")
region_filter <- NULL  # z.B. "EUR" oder NULL für alle Dateien

# Hole Liste aller GeoTIFF-Dateien auf der Seite
get_file_list <- function() {
  message("[*] Hole Dateiliste von: ", base_url)
  page <- read_html(base_url)
  links <- html_nodes(page, "a")
  hrefs <- html_attr(links, "href")
  tif_files <- hrefs[str_detect(hrefs, "\\.tif$")]

  if (!is.null(region_filter)) {
    tif_files <- tif_files[str_detect(tif_files, region_filter)]
  }
  return(tif_files)
}

# Lade eine einzelne Datei herunter
download_file <- function(filename) {
  url <- paste0(base_url, filename)
  local_path <- file.path(target_dir, filename)
  if (file.exists(local_path)) {
    message("[=] Schon vorhanden: ", filename)
    return()
  }
  message("[↓] Lade herunter: ", filename)
  GET(url, write_disk(local_path, overwrite = TRUE), progress())
}

# Hauptfunktion
main <- function() {
  files <- get_file_list()
  message("[+] ", length(files), " Dateien gefunden.")
  for (f in files) {
    download_file(f)
  }
  message("[✓] Download abgeschlossen.")
}

# Starte das Skript
main()
