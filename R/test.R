


library(sf) # shapefiles and geopackages
library(terra) # rasters
library(dplyr) # data manipulation
library(exactextractr)  # for accurate raster extraction with polygons
library(Rpollution)

# setting project directory
project_dir <- "C:/Daten/JMU - Dokumente/Air pollution/Project/greyinfra_summertime"

# output file location
output_csv <- file.path(project_dir, 'Results.csv')

# declaring file and import of the uc layer
uc_file <- file.path(project_dir, 'Urban_Boundaries_UC_FUA_MUA_Vectors/GHS_STAT_UCDB2015MT_GLOBE_R2019A_V1_2.gpkg')
layer_name <- "GHS_STAT_UCDB2015MT_GLOBE_R2019A_V1_2"
layer_uc <- st_read(uc_file, layer = layer_name)

# filtering of the specific city boundaries
germany <- filter(layer_uc, XC_NM_LST == 'Germany') # for better overview which German cities exist

cities <- filter(germany, UC_NM_MN %in% c('Duisburg', 'Dusseldorf', 'Dortmund', 'Essen', 'Cologne', 'Stuttgart',
                                          'Frankfurt am Main', 'Bremen', 'Hanover', 'Hamburg', 'Nuremberg',
                                          'Munich', 'Dresden', 'Leipzig', 'Berlin'))
# only 13 entries, Duisburg and Essen do not exist

pol_berlin <- filter(germany, UC_NM_MN == 'Berlin') #1

lst_berlin <- rast(file.path(project_dir, "Land_Surface_Temperature_Summer_Means_Cities/Berlin_LST_2013-2022_summer_mean.tif"))
wsf_berlin <- rast(file.path(project_dir, "WSF2019_v1_12_52, Berlin.tif"))


summary(wsf_berlin)
unique(values(wsf_berlin))
freq(wsf_berlin)


berlin_built <- builtuparea(wsf_berlin, pol_berlin)
mt_berlin <- rastmeancalc(lst_berlin, pol_berlin) %>% print()
mt_berlin_built <- rastmeancalc(lst_berlin, berlin_built) %>% print()

berlin_buildings <- get_osm_buildings(pol_berlin)
berlin_nature <- get_osm_nature(pol_berlin)




hasValues(wsf_berlin)
unique(wsf_berlin)
wsf_berlin
pol_berlin
