cdse_search_products <- function(username, password, sensor = "SENTINEL-5P",
                                 date_from = "2024-03-01", date_to = "2024-03-31",
                                 keyword = "NO2", top_n = 5) {
  library(httr)
  library(jsonlite)

  # 1. Token holen
  token_response <- POST(
    "https://identity.dataspace.copernicus.eu/auth/realms/CDSE/protocol/openid-connect/token",
    body = list(
      client_id = "cdse-public",
      grant_type = "password",
      username = username,
      password = password
    ),
    encode = "form"
  )

  if (status_code(token_response) != 200) {
    stop("Login fehlgeschlagen: ", content(token_response, "text"))
  }

  token <- content(token_response)$access_token

  # 2. Query zusammenbauen (contains statt substringof)
  base_url <- "https://catalogue.dataspace.copernicus.eu/odata/v1/Products"
  query_filter <- sprintf("Collection/Name eq '%s' and ContentDate/Start gt %sT00:00:00Z and ContentDate/Start lt %sT00:00:00Z and contains(Name,'%s')",
                          sensor, date_from, date_to, keyword)

  query_url <- modify_url(base_url, query = list(
    `$filter` = query_filter,
    `$top` = top_n
  ))

  # 3. Request mit Auth
  res <- GET(query_url, add_headers(Authorization = paste("Bearer", token)))

  if (status_code(res) != 200) {
    stop("Fehler bei der Produktsuche: ", content(res, "text"))
  }

  data <- fromJSON(content(res, as = "text"))
  if (length(data$value) == 0) {
    message("Keine Produkte gefunden.")
    return(data.frame())
  }

  # 4. Name & Download-Link extrahieren
  result <- data.frame(
    name = sapply(data$value, function(x) x$Name),
    download_url = sapply(data$value, function(x) x$Assets$data$Href),
    stringsAsFactors = FALSE
  )

  return(result)
}



products <- cdse_search_products(
  username = ####,
  password = ####,
  sensor = "SENTINEL-5P",
  date_from = "2024-03-10",
  date_to = "2024-03-20",
  keyword = "NO2",
  top_n = 3
)
