## Eduard Martinez
## update: 02-07-2022
## R version 4.1.1 (2021-08-10)

## clean environment
rm(list=ls())

## Llamar/instalar las librerías para esta sesión:
require(pacman)
p_load(rio,tidyverse,sf,osmdata,sp,viridis,leaflet,
       png,grid,  # Abrir pictures desde R
       raster, # Manipular datos raster
       stars)  # Manipular datos raster

# raster: raster(), stack() 
# stars: read_stars()
# png, grid: leer graficos

## solucionar conflictos de funciones
select = dplyr::select

##=== obtener datos ===##

## descargar datos
download.file("https://eduard-martinez.github.io/teaching/meca-4107/8-input.zip")

## unzip data
unzip(zipfile="8-input.zip" , exdir="." , overwrite=T) 

#=================#
# [1.] Motivacion #
#=================#

# Night lights and economic growth
dev.off() # clean plot window
grid.raster(readPNG("input/pics/Indonesia.png")) # Tomado de: Measuring Economic Growth from Outer Space
dev.off() # clean plot window
grid.raster(readPNG("input/pics/Rwanda.png"))    # Tomado de: Measuring Economic Growth from Outer Space
browseURL("https://www.aeaweb.org/articles?id=10.1257/aer.102.2.994") # Ir a: Measuring Economic Growth from Outer Space

# Night lights and Covid-19
dev.off()
grid.raster(readPNG("input/pics/covid.png")) 
browseURL("https://economia.uniandes.edu.co/sites/default/files/observatorio/Resultados-luminosidad.pdf") # Ir a: COVID19 y actividad económica: demanda de energía y luminosidad ante la emergencia

# Examining the economic impact of COVID-19 in India through daily electricity consumption and nighttime light intensity
browseURL("https://www.sciencedirect.com/science/article/pii/S0305750X20304149?casa_token=VjcoqRnPQo8AAAAA:DXanp0b9C9w6BvR9C3NF0WfEvWO7uB_DvGBBxC8b8d59l2QVcAdRLGKLf4e-UhGr6HRECXNvxw")

# Measuring the size and growth of cities using nighttime light
browseURL("https://www.sciencedirect.com/science/article/pii/S0094119020300255?casa_token=cMiibzNrYTEAAAAA:YqwYomGC9QgC81nDaYQmQ_z6Fak1WQgtW6JwobSzTOQCfVsqCzprUGK77XEphlO60A0-eWpPCg") 

# Russia-Ukraine War as Seen by DNB
browseURL("https://eogdata.mines.edu/products/special_topics/russia_ukraine_war.html")

#==============#
# [2.] Sources # 
#==============#

#=== Night lights ===#

# DMSPL (1992-2013)
browseURL("https://www.ngdc.noaa.gov/eog/dmsp/downloadV4composites.html") # Anuales 

# VIIRS (2012-Currently)
browseURL("https://eogdata.mines.edu/products/vnl/") # Link del proyecto
browseURL("https://eogdata.mines.edu/nighttime_light/monthly/v10/") # Mensuales
browseURL("https://ngdc.noaa.gov/eog/viirs/download_ut_mos.html") # Diarios

# Harmonized (1992-2018)
browseURL("https://figshare.com/articles/dataset/Harmonization_of_DMSP_and_VIIRS_nighttime_light_data_from_1992-2018_at_the_global_scale/9828827/2") # Anuales 

# Download and tidy data
browseURL("https://gitlab.com/main_data/night_lights/-/tree/main/1_download/scr") # Gitlab

#=== Land cover ===#

# Sentinel - Copernicus
browseURL("https://lcviewer.vito.be/about#available-maps") # about sentinel
browseURL("https://land.copernicus.eu/global/products/lc") # pagina
browseURL("https://zenodo.org/record/4723921#.YZFYNS-B1hE") # Dictionary

#=== NASA ===#

# Temperature, rainfall,...
browseURL("https://disc.gsfc.nasa.gov")

#==================================#
# [3.] Introduccion a datos raster #
#==================================#

##=== Acerca de los raster ===#

## qué es un raster?
dev.off()
grid.raster(readPNG("input/pics/raster.png")) # fuente: https://www.neonscience.org

## resolucion
dev.off()
grid.raster(readPNG("input/pics/rasterize.png")) # poner fuente

## bandas de un raster
dev.off()
grid.raster(readPNG("input/pics/rgb_raster.png")) # Imagen tomada de https://www.neonscience.org

##=== Leer un raster ===#
methods(class = "stars")

## importar raster de luces
luces_r = raster('input/rasters/night_light_202003.tif')
luces_r
luces_s = read_stars("input/rasters/night_light_202003.tif")
luces_s
0.00416667*110000 # resolucion

## geometria
st_bbox(luces_s)
st_crs(luces_s)
st_dimensions(luces_s)

## atributos
names(luces_s)
names(luces_s) = "date_202003"

## valores del raster
luces_s[[1]] %>% max(na.rm = T)
luces_s[[1]] %>% min(na.rm = T)
luces_s[[1]] %>% as.vector() %>% summary() 
luces_s[[1]][is.na(luces_s[[1]])==T] # Reemplazar NA's
luces_s[[1]][2000:2010,2000:2010]
luces_s[[1]][2000:2010,2000:2010] %>% table() # Sustraer una parte de la matriz

## puedo reproyectar un raster?
st_crs(luces_s)
luces_new_crs = st_transform(luces_s,crs=4126)
luces_s[[1]][2000:2010,2000:2010] # no se alteran las geometrias
luces_new_crs[[1]][2000:2010,2000:2010] # no se alteran las geometrias

## plot data
plot(luces_s)

##=== Hacer clip a un raster ===#

## download boundary
quilla <- getbb(place_name = "Barranquilla, Colombia", 
                featuretype = "boundary:administrative", 
                format_out = "sf_polygon") %>% .[1,]

leaflet() %>%
addTiles() %>%
addPolygons(data=quilla)

## cliping
l_quilla_1 = st_crop(x = luces_s , y = quilla) # crop luces de Colombia con polygono de Medellin

l_quilla_1[[1]] %>% t()

## Plot data
ggplot() + geom_stars(data=l_quilla_1 , aes(y=y,x=x,fill=date_202003)) + # plot raster
scale_fill_viridis(option="A" , na.value='white') +
geom_sf(data=quilla , fill=NA , col="green") + theme_bw() 

#======================================================#
# [4.] Aplicación: Actividad económica en Barranquilla #
#======================================================#

##=== Importar datos ===#

## load data
l_quilla_0 = read_stars("input/rasters/night_light_202002.tif") %>% st_crop(quilla)
names(l_quilla_0) = "date_202002"

ggplot() + geom_stars(data=l_quilla_0 , aes(y=y,x=x,fill=date_202002)) + # plot raster
scale_fill_viridis(option="A" , na.value='white') +
geom_sf(data=quilla , fill=NA , col="green") + theme_bw() 

##=== Stack rasters ===#

## Unir los daster de 202002 y 202003
l_quilla = c(l_quilla_0,l_quilla_1)
l_quilla

##=== Raster a datos vectoriales ===#

## Opción 2
puntos_quilla = st_as_sf(x = l_quilla, as_points = T, na.rm = T) # raster to sf (points)
puntos_quilla

poly_quilla = st_as_sf(x = l_quilla, as_points = F, na.rm = T) # raster to sf (polygons)
poly_quilla

## Plot data
ggplot() + 
geom_sf(data = puntos_quilla , aes(col=date_202002))  + 
scale_color_viridis(option="A" , na.value='white') +
geom_sf(data=quilla , fill=NA , col="green") + theme_test() 

ggplot() + 
geom_sf(data = poly_quilla , aes(fill=date_202002),col=NA)  + 
scale_fill_viridis(option="A" , na.value='white') +
geom_sf(data=quilla , fill=NA , col="green") + theme_test()

##=== Asignar el valor del pixel a un lugar ===#

## get polygon
puerto <- getbb(place_name = "Puerto de Barranquilla - Sociedad Portuaria, Colombia", 
                featuretype = "barrier:wall", 
                format_out = "sf_polygon")

leaflet() %>%
addTiles() %>%
addPolygons(data=puerto)

## asignar luminosidad
l_puerto = st_join(puerto,poly_quilla)

## variacion promedio 
df = l_puerto
st_geometry(df) = NULL

df %>% 
summarise(pre=mean(date_202002,na.rm=T) , 
          post=mean(date_202003,na.rm=T)) %>%
mutate(ratio=post/pre-1)

#================================================#
# [5.] Aplicación: Cambio de cobertura de suelo? #
#================================================#

# read raster
land_cover = c(read_stars("input/rasters/discreta_2015.tif"),
               read_stars("input/rasters/discreta_2019.tif"))
0.000992063*111000 # resolucion

# read polygon
quilla_border = import("input/poly/borde_barranquilla.rds")
leaflet() %>%
addTiles() %>%
addPolygons(data=quilla_border)

# cliping raster
border = land_cover %>% st_crop(quilla_border)

# view data
plot(border)

# raster to sf
border_sf = st_as_sf(x=border, as_points = F, na.rm = T) 

# cuantos pixeles se urbanizaron?
border_sf = border_sf %>% 
            rename(c_2015=discreta_2015.tif,c_2019=discreta_2019.tif)
border_sf = border_sf %>% 
            mutate(dife = as.numeric(c_2015)-as.numeric(c_2019))

