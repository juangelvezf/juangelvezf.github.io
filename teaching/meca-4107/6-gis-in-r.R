
## Llamar pacman (contiene la función p_load)
require(pacman) 

## Llama/instala-llama las librerías listadas
p_load(tidyverse,rio,
       sf, # Leer/escribir/manipular datos espaciales
       leaflet, # Visualizaciones dinámicas
       tmaptools, # geocode_OSM()
       osmdata) # Get OSM's data

##=== 2.1. Geocodificar direcciones

## Buscar un lugar público por el nombre
geocode_OSM("Casa de Nariño, Bogotá")

## geocode_OSM no reconoce el caracter #, en su lugar se usa %23%
point = geocode_OSM("Cra. 8 %23% 7-26, Bogotá", as.sf=T) 
point

## la función addTiles adiciona la capa de OpenStreetMap
leaflet() %>% addTiles() %>% addCircles(data=point)

##=== Librería osmdata

## 2.2.1. Features disponibles
available_features() 

## dentro de las categorias
available_tags("amenity")


##=== obtener datos

## obtener la caja de coordenada que contiene el polígono de Bogotá
opq(bbox = getbb("Bogotá Colombia"))

## objeto osm
osm = opq(bbox = getbb("Bogotá Colombia")) %>%
      add_osm_feature(key="amenity" , value="bus_station") 
class(osm)

## extraer Simple Features Collection
osm_sf = osm %>% osmdata_sf()
osm_sf

## Obtener un objeto sf
bus_station = osm_sf$osm_points %>% select(osm_id,amenity) 
bus_station

## Pintar las estaciones de autobus
leaflet() %>% addTiles() %>% addCircleMarkers(data=bus_station , col="red")

##=== 3. Operaciones geometrías

## apartamentos
housing = import("https://eduard-martinez.github.io/data/house_points.rds")
housing %>% head()

## precios medianos de las viviendas
mnz = import("https://eduard-martinez.github.io/data/mnz_prices_house.rds")
mnz %>% head()

## bares
bar = opq(bbox = st_bbox(mnz)) %>%
      add_osm_feature(key = "amenity", value = "bar") %>%
      osmdata_sf() %>% .$osm_points %>% select(osm_id,name)
bar %>% head()

## parque de la 93
park = getbb(place_name = "Parque de la 93", 
             featuretype = "amenity",
             format_out = "sf_polygon")

## plot mapas
leaflet() %>% addTiles() %>% 
addPolygons(data=mnz) %>% # manzanas
addPolygons(data=park , col="green") %>%  # parque de la 93
addCircles(data=housing , col="red" , weight=2) %>% # apartamentos
addCircles(data=bar , col="black" , weight=2) # bares

##== 3.2. Precio de las viviendas

## Afinar las transformaciones
st_crs(mnz) == st_crs(housing)
bog = st_transform(bog,st_crs())

## unir dos conjuntos de datos basados en la geometría
housing_p = st_join(x=housing , y=mnz)
housing_p
leaflet() %>% addTiles() %>% addCircles(data=housing_p , col="red" , label=housing_p$median_price)

## precio promedio
leaflet() %>% addTiles() %>% 
addPolygons(data=mnz) %>% 
addPolygons(data=st_buffer(x=housing , dist=50) , col="red")

max_price = st_join(x=st_buffer(x=housing , dist=50) , y=mnz)
st_geometry(max_price) = NULL

## precio máximo
max_price = max_price %>% group_by(cod_apto) %>% summarise(price_max=max(median_price))
max_price

## join data
housing_p = left_join(x=housing_p , y=max_price , by="cod_apto")
housing_p

## 3.3. Distancia a amenities

## Distancia a parque
housing_p$dist_park = st_distance(x=housing_p , y=park)
housing_p

## Distancia a bares
dist_bar = st_distance(x=housing_p , y=bar)
dist_bar

## Distancia minima
min_dist = apply(dist_bar , 1 , min)
min_dist

housing_p$dist_bar = min_dist
housing_p

## regresiones 
lm(median_price ~ price_max + dist_park + dist_bar, data = housing_p)










