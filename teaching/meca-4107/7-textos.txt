
## install package
rm(list=ls())
require(pacman)
p_load(rio,tidyverse,sf,leaflet,class,skimr)

##=== 0. load data ===##
house = import("http://eduard-martinez.github.io/data/fill-gis-vars/train.rds")
skim(house)

## dataframe to sf
house = st_as_sf(house,coords=c("lon","lat"),crs=4326)

## plot maps
leaflet() %>% addTiles() %>% addCircles(data=house)

## summary data
table(is.na(house$surface_total))
table(is.na(house$surface_covered))

##=== 1. Extrac text ===##

## stringr
browseURL("https://evoldyn.gitlab.io/evomics-2018/ref-sheets/R_strings.pdf")

## example
word = "Hola mundo, hoy es 19 de julio de 2022"

## Detect Matches
str_detect(string = word , pattern = "19") ## Detect the presence of a pattern match

str_locate(string = word , pattern = "19") ##  Locate the positions of pattern matches in a string

str_count(string = word , pattern = "o") ## Count the number of matches in a string
  
## Subset Strings
str_extract(string = word , pattern = "19") ## Return the first pattern match found in each strin

str_match(string = word , pattern = "19") ## Return the first pattern match found in each string

str_sub(string = word , start = 1, end = 4)

## Mutate Strings
str_replace(string = word , pattern = "19" , replacement = "10+9")

str_to_lower(string = word)

str_to_upper(string = word)

## Regular Expressions
str_replace_all(string = word , pattern = " " , replacement = "-")

str_replace_all(string = word , "[:blank:]" , replacement = "-")

str_replace_all(string = word , "19|2022" , replacement = "-")

str_replace_all(string = word , "[0-9]" , replacement = "-")

## aplicacion
house$surface_total[58] ## not surface_total

house$surface_covered[58] ## not surface_covered

house$description[58] ## explore description

x = "[:space:]+[:digit:]+[:punct:]+[:digit:]+[:space:]+M2" ## pattern

str_locate_all(string = house$description[58] , pattern = x) ## detect pattern

str_extract(string=house$description[58] , pattern= x) ## extrac pattern

## make new var
house = house %>% 
        mutate(new_surface = str_extract(string=house$description , pattern= x))
table(house$new_surface)

## another pattern
y = "[:space:]+[:digit:]+[:space:]+metros"
house = house %>% 
        mutate(new_surface = ifelse(is.na(new_surface)==T,
                                    str_extract(string=house$description , pattern= y),
                                    new_surface))
table(house$new_surface)

##=== 2. vecinos espaciales ===##

## load data
mnz = import("http://eduard-martinez.github.io/data/fill-gis-vars/mnz.rds")
colnames(mnz)

leaflet() %>% addTiles() %>% addPolygons(data=mnz , color="red") %>% addCircles(data=house)

## spatial join
house_mnz = st_join(x = house,y = mnz)
colnames(house_mnz)

## average block
house_mnz = house_mnz %>%
            group_by(MANZ_CCNCT) %>%
            mutate(new_surface_2=median(surface_total,na.rm=T))

table(is.na(house_mnz$surface_total))

table(is.na(house_mnz$surface_total),
      is.na(house_mnz$new_surface)) # ahora solo tenemos 221 missing values

## make buffer
house_buf = st_buffer(house,dist=20)

leaflet() %>% addTiles() %>% addPolygons(data=house_buf , color="red") %>% addCircles(data=house)

house_buf = st_join(house_buf,house[,"surface_total"])

st_geometry(house_buf) = NULL

house_buf_mean = house_buf %>% group_by(property_id) %>% summarise(surface_new_3=mean(surface_total.y,na.rm=T))

house_mnz = left_join(house_mnz,house_buf_mean,"property_id")

##=== 3. CENSO data ===##

## load data
mnz_censo = import("http://eduard-martinez.github.io/data/fill-gis-vars/mnz_censo.rds")

## about data
browseURL("https://eduard-martinez.github.io/teaching/meca-4107/7-censo.txt")

## spatial join
house_censo = st_join(house_mnz,mnz_censo)
colnames(house_censo)



