library(sf)
library(mapview)
library(magrittr)
library(dplyr)
sheep_sf <- st_as_sf(read.csv(file = "SheepData.csv"),
                     coords = c("Longitude", "Latitude"), crs = 4326) %>%
  st_transform(5343) %>%
  st_cast("MULTILINESTRING")
# to view them quickly

mapview(sheep_sf)
# create df of sf
sheep_df <- sheep_sf  %>%
  rename(n = X) %>%
  cbind(., st_coordinates(.)) %>%
  st_set_geometry(NULL)