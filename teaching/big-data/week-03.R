# Eduard Martínez
# update: 25-08-2022

## llamar la librería pacman: contiene la función p_load()
rm(list=ls())
require(pacman)
p_load(tidyverse, # contiene las librerías ggplot, dplyr...
       rvest) # web-scraping

##==================================##
## 0. Minimal, Reproducible Example ##
##==================================##

## How to create a Minimal, Reproducible Example?
browseURL(url = "https://stackoverflow.com/help/minimal-reproducible-example")

## Minimal
cat("Use la menor cantidad de código posible que aún produzca el mismo problema.")

## Minimal and readable
cat("No sacrifiques la claridad por la brevedad al crear un ejemplo mínimo. 
     Use nombres y sangrías consistentes, e incluya comentarios de código si es necesario. 
     Use el acceso directo de su editor de código para formatear el código. 
     Además, use espacios en lugar de tabulaciones: es posible que las pestañas no tengan el formato correcto en Stack Overflow.")

## Complete
cat("Que proporcione todas las partes que otra persona necesita para reproducir su problema en la misma pregunta.")

## Reproducible
cat("Pruebe el código que está a punto de proporcionar para asegurarse de que reproduce el problema.")

##=== Example 1 ===## 

## how to select variables that match a pattern?

## get data
cat("Puede generar un ojeto que permita reproducir su pregunta. Por ejemplo:")
df = data.frame(p1=rnorm(10) , 
                x1=runif(10) , 
                a1=runif(10) , 
                p2=rnorm(10) )
df

##=== Example 2 ===## 

## how to select variables that match a pattern?

## view datasets
cat("O puede acceder a algunas de los data sets de las librerías de R. 
    Por ejemplo, la librería datasets contiene mas de 100 data sets disponibles:")
data(package="datasets")

## get data
data(iris)
iris
head(iris)

## Starts with a prefix.
iris %>% select(Species,starts_with("Sepal")) %>% head()

## Ends with a suffix.
iris %>% select(Species,ends_with("Width")) %>% head()

##==============================##
## 1. Introduction wdb-scraping ##
##==============================##

##=== 1.1 robots.txt ===## 

## Acceder al robots.txt de wikipedia
browseURL("https://en.wikipedia.org/robots.txt")

##=== 1.4 Mi primer HTML ===##

## Mi primer HTML


## Exportar y leer el html


##==========##
## 2. rvest ##
##==========##
vignette("rvest")

##=== 2.1 Aplicación en R ===##
my_url = "https://es.wikipedia.org/wiki/Copa_Mundial_de_F%C3%BAtbol"
browseURL(my_url) ## Ir a la página

## leer el html de la página


## ver la clase del objeto


##=== 2.2 Extraer elementos de un HTML ===##

## Obtener los elementos h2 de la página


## Ver los textos


##=== 2.3 Xpath ===##

## Extraer un elemento


## Extraer texto


##=== 2.4 Extraer tablas de un html ===##

## Extraer todas las tablas del html 


## Numero de tablas extraidas


##=== 2.5 Extraer atributos de un elemento ===##

## usar la etiqueta del elemento


## Extraer los elementos con que contiene links a otras páginas


## Extraer el atributo titel:


## Extraer el atributo href que contiene la url a las referencias:


## Crear un objeto que contenga la url de la página y el contenido de la url:


## Navegar hasta la url de Bandera de España







