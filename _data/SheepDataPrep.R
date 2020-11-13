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

###############
#
# And thanks to Brittney Scannell for the code block below for making an animated gif!
#
###############

library(sf)
library(mapview)
library(magrittr)
library(dplyr)
library(gganimate)
library(ggmap)
sheep_df <- read.csv("SheepData.csv")
sheep_sf <- st_as_sf(read.csv(file = "SheepData.csv"),
                     coords = c("Longitude", "Latitude"), crs = 4326)
sheep_coords <- st_coordinates(sheep_sf)
sheep_df$Datetime <- as.POSIXct(paste(sheep_df$Date, sheep_df$Time), format="%m/%d/%y %H:%M:%S",tz="UTC")
mybasemap <- get_stamenmap(bbox = c(left = min(sheep_coords[,1])-0.005, 
                                    bottom = min(sheep_coords[,2])-0.005, 
                                    right = max(sheep_coords[,1])+0.005, 
                                    top = max(sheep_coords[,2])+0.005), 
                           zoom = 13) 
mymap.paths.sheep <-ggmap(mybasemap) + 
  geom_path(data = sheep_df, aes(x = Longitude, y = Latitude), colour = "red")  +
  geom_point(data = sheep_df, aes(x = Longitude, y = Latitude), colour = "firebrick4", size =3) +
  labs(x = "Longitude", y = "Latitude")  +
  transition_reveal(Datetime)  +
  coord_equal() +
  scalebar(data = sheep_sf, transform = TRUE, dist_unit = "km", dist = 0.5,
           st.dist = 0.05, location = "bottomright", st.size=2.5) +
  north(data=sheep_sf, symbol = 12, location = "bottomright", anchor = c(x=-70.51681,y=-41.0205))
# Static plot
mymap.paths.sheep
# Update plot to animate
path.animate.plot <- mymap.paths.sheep +
  transition_reveal(along = Datetime) +
  labs(title = 'Datetime: {frame_along}')
# Animate!
gganimate::animate(path.animate.plot,
                   fps = 5)
# Save as gif
anim_save(path.animate.plot,
          file = "animatedpaths.gif")