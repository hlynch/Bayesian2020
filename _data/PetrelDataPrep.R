library(sf)
library(mapview)
library(magrittr)
library(dplyr)

petrel_sf <- st_as_sf(read.csv(file = "PetrelData.csv"),
                     coords = c("lon", "lat"), crs = 4326) %>%
                     dplyr::filter(birdID == "AP001") %>%   # This selects out the bird AP001, but you can use this to filter for other birds
                     st_transform(3031)    #Projects to Antarctic Polar Stereographic
  
mapview(petrel_sf)
  
# create df of sf
petrel_df <- petrel_sf  %>%
    cbind(., st_coordinates(.)) %>%
    st_set_geometry(NULL)

