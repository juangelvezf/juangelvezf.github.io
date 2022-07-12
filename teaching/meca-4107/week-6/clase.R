#==========================================#
# Elaborado por: Eduard F Martinez-Gonzalez
# Update: 06-06-2022
# R version 4.1.1 (2021-08-10)
#==========================================#

# initial configuration
rm(list=ls())
require(pacman) # require pacman
p_load(tidyverse,
       rio,
       sf,
       leaflet,
       viridis,
       osmdata,
       ggsn) # require and/or install packages

#==== Hoy veremos ====# 

## 1. Manipulating Simple Feature Geometries
   ## 1.1. Affine transformations
   ## 1.2. Cliping data
   ## 1.3. Buffer
   ## 1.4. Joining two feature sets based on geometries
   ## 1.5. Centroid   
   ## 1.6. Distances

#==== Gen data ====#

# make points
housing = tibble(cod_apto=c("Apto 101","Apto 102","Apto 103","Apto 104"),
                 lat=c(4.676268724014856,4.6779544376424065,4.677911354610968,4.676429959532716),
                 lon=c(-74.05081358548767,-74.04782427039443,-74.05049129066947, -74.04636785215544)) 
housing = st_as_sf(x=housing,coords=c("lon","lat"),crs=4326)

leaflet() %>% addTiles() %>% addCircleMarkers(data=housing)

# get amenities
chico = getbb(place_name = "UPZ Chicó Lago Bogotá Colombia",
              featuretype = "boundary:administrative",
              format_out = "sf_polygon")

bar = opq(bbox = st_bbox(chico)) %>%
      add_osm_feature(key = "amenity", value = "bar") %>%
      osmdata_sf() %>% .$osm_points

leaflet() %>% addTiles() %>% addCircleMarkers(data=bar)

# gen lines
streets = opq(bbox = st_bbox(housing)) %>%
          add_osm_feature(key = "highway") %>%
          osmdata_sf() %>% .$osm_lines

leaflet() %>% addTiles() %>% addPolylines(data=streets ,col="red")

# gen polygons
park = getbb(place_name = "Parque de la 93",
             featuretype = "amenity",
             format_out = "sf_polygon") %>% mutate(name="Parque de la 93")

leaflet() %>% addTiles() %>% addPolygons(data=park)

#=============================================#
# [1.] Manipulating Simple Feature Geometries #
#=============================================#

## Help
vignette("sf3")
vignette("sf4")

## load data
load("input/mhv_blocks_bog.rds")
leaflet() %>% addTiles() %>% addPolygons(data=mhv_bog)

##=== 1.1. Affine transformations ===##
st_crs(mhv_bog)
st_crs(housing)
housing = st_transform(x=housing , crs=st_crs(mhv_bog))
st_crs(housing)

##=== 1.2. Cliping data ===##

# bares 
leaflet() %>% addTiles() %>% addCircleMarkers(data=bar,col="blue") %>% addCircleMarkers(data=housing,col="red")

bar_housing = st_crop(x=bar , y=st_bbox(housing))

leaflet() %>% addTiles() %>% addCircleMarkers(data=bar_housing,col="blue") %>% addCircleMarkers(data=housing,col="red")

# mhv
mhv_housing = st_crop(x=mhv_bog , y=st_bbox(housing))

leaflet() %>% addTiles() %>% addPolygons(data=mhv_housing,col="blue") %>% addCircleMarkers(data=housing,col="red")

##=== 1.3. Buffer ===##
mhv_housing_bf = st_buffer(x=mhv_housing , dist=10)

leaflet() %>% addTiles() %>% addPolygons(data=mhv_housing_bf,col="green") %>% addCircleMarkers(data=housing,col="red")

##=== 1.4. Joining two feature sets based on geometries ===##
leaflet() %>% addTiles() %>% 
addPolygons(data=mhv_housing_bf,col="green" , label=mhv_housing_bf$MANZ_CCNCT) %>% 
addCircleMarkers(data=housing , col="red" , label=housing$cod_apto)

housing
housing = st_join(x=housing , y=mhv_housing_bf)
housing

##=== 1.5. Centroid ===##
c_park = st_centroid(x = park)

leaflet() %>% addTiles() %>% addCircleMarkers(data=c_park,col="blue") %>% addCircleMarkers(data=housing,col="red")

##=== 1.6. Distances ===##

## Distances to park
leaflet() %>% addTiles() %>% addCircleMarkers(data=c_park,col="blue") %>% addCircleMarkers(data=housing,col="red")

dist_park = st_distance(x=housing , y=c_park)

housing$dist_park = dist_park

housing

## Distances to bar
leaflet() %>% addTiles() %>% addCircleMarkers(data=bar_housing,col="blue") %>% addCircleMarkers(data=housing,col="red")

dist_bar = st_distance(x=housing , y=bar_housing)
dist_bar

min_dist = apply(dist_bar , 1 , min)
min_dist
housing$dist_bar = min_dist
housing

## Distance to street
foot_way = subset(streets,highway="foot_way")
leaflet() %>% addTiles() %>% addPolylines(data=foot_way,col="blue") %>% addCircleMarkers(data=housing,col="red")

dist_street = st_distance(x=housing , y=foot_way)
dist_street

min_dist = apply(dist_street , 1 , min)
min_dist
housing$dist_street = min_dist
housing

## save data 
export(housing,"output/housing.rds")

