library(sf)
library(mapview)
library(magrittr)
library(dplyr)

# to view them as points
sheep_sf <- st_as_sf(read.csv(file = "SheepData.csv"),
                     coords = c("Longitude", "Latitude"), crs = 4326) %>%
  st_transform(5343) 
mapview(sheep_sf)

# to view the track as a line
sheep_line_sf <- sheep_sf %>%
  mutate(group = "A") %>%
  group_by(group) %>%
  summarize(do_union = FALSE) %>%
  st_cast("LINESTRING")
mapview(sheep_line_sf)

# create df of sf
sheep_df <- sheep_sf  %>%
  rename(n = X) %>%
  cbind(., st_coordinates(.)) %>%
  st_set_geometry(NULL)