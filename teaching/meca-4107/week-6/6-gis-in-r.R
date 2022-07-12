#==========================================#
# Elaborado por: Eduard F Martinez-Gonzalez
# Update: 26-04-2022
# R version 4.1.1 (2021-08-10)
#==========================================#

# initial configuration
rm(list=ls())
require(pacman) # Llamar pacman (contiene la función p_load)

# Llamar/instalar librerías
p_load(tidyverse,rio,
       sf, # Leer/escribir/manipular datos espaciales
       leaflet, # Visualizaciones dinámicas
       geocodeOSM, # geocode_OSM()
       osmdata) # Get OSM's data

#====================#
# [2.] OpenStreetMap #
#====================#

#=== 2.1. About OMS ===#

# view keys
browseURL("https://wiki.openstreetmap.org/wiki/Map_features")

## features disponibles
available_features()  

available_tags("amenity")

## getting data
osm_bus = opq(bbox = getbb("Bogotá Colombia")) %>%
          add_osm_feature(key="amenity" , value="bus_station") %>%
          osmdata_sf()
osm_bus

## getting data (cont.)
bus_station = osm_bus$osm_points %>% select(osm_id,amenity) 

## getting data: view data
leaflet() %>% addTiles() %>%
addCircleMarkers(data=bus_station , weight=1 , col="red")


## get street
osm_street = opq(bbox = getbb("Bogotá Colombia")) %>%
             add_osm_feature(key="highway",value="cycleway") %>%
             osmdata_sf() 
transp = osm_street$osm_lines %>% select(osm_id,name) %>%
         subset(str_detect(name,"Avenida")==T | str_detect(name,"TransMilenio")==T)
transp

## get street (cont.)
leaflet() %>% addTiles() %>% 
addPolylines(data=transp ,col="red") # se usó 200 lugares para rápida compilación.

#==================#
# [3.] Google Maps #
#==================#

geocode(location="Casa de Nariño, Bogotá D.C.", output="latlon", source="google")

google = geocode(location="Calle 26b # 4-29 , Bogota", output="latlon", source="google")

google = st_as_sf(x=google , coords=c("lon","lat") , crs=4326) %>% mutate(place="Casa de Nariño")
google

leaflet() %>% addTiles() %>% addCircleMarkers(data=google,col="red")

#=================#
# [4.] googleway  #
#=================#

#=====================#
# Para seguir leyendo #
#=====================#

##  Lovelace, R., Nowosad, J., & Muenchow, J. (2019). Geocomputation with R. [Ver aquí]

    # Cap. 4: Spatial Data Operations
    # Cap. 5: Geometry Operations
    # Cap. 6: Reprojecting geographic data
    # Cap. 11: Statistical learning

## Bivand, R. S., Pebesma, E. J., Gómez-Rubio, V., & Pebesma, E. J. (2013). Applied spatial data analysis with R. [Ver aquí]

    # Cap. 7: Spatial Point Pattern Analysis
    # Cap. 8: Interpolation and Geostatistics
