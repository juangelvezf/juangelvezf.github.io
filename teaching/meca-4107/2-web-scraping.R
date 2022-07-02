# Eduard Martínez
# update: 18-06-2022

## llamar la librería pacman: contiene la función p_load()
rm(list=ls())
require(pacman)
p_load(tidyverse, # contiene las librerías ggplot, dplyr...
       rvest) # web-scraping

## Acceder al robots.txt de wikipedia
browseURL("https://en.wikipedia.org/robots.txt")

## Mi primer HTML
my_html <- 
'<!DOCTYPE html> 
<html>
<meta charset="utf-8">
<head>
<title> Título de la página: ejemplo de clase </title>
</head>
<body>
<h1> Title 1.</h1>
<h2> Subtitle <u>subrayado-1</u>. </h2>
<p> Este es un párrafo muy pequeño que se encuentra dentro de la etiqueta <b>p</b> de <i>html</i> </p>
<a href="https://es.wikipedia.org/wiki/Copa_Mundial_de_F%C3%BAtbol"> link a wikipedia </a>
</body>
</html>'

## export and read html
write.table(x=my_html , file='my_page.html' , quote=F , col.names=F , row.names=F)
browseURL("my_page.html") ## leer con el navegador de su equipo

## view rvest
vignette("rvest")

## 2.1 Aplicación en R:
my_url = "https://es.wikipedia.org/wiki/Copa_Mundial_de_F%C3%BAtbol"
browseURL(my_url) ## Ir a la página

## leer html
my_html = read_html(my_url) ## leer el html de la página

class(my_html) ## ver la clase del objeto

View(my_html)

## 2.2 Extraer elementos de un HTML

## Obtener los elementos h2 de la página
my_html %>% html_elements("h1")

## Ver los textos
my_html %>% html_elements("h1") %>% html_text()

## 2.3 Xpath
my_html %>% html_node(xpath='//*[@id="mw-content-text"]/div[1]/p[5]')
my_html %>% html_node(xpath='//*[@id="mw-content-text"]/div[1]/p[5]') %>% html_text()


my_html %>% html_node(xpath='//*[@id="mw-content-text"]/div[1]/p[5]') %>% html_elements("a")

## extraer todas las tablas del html 
my_table = my_html %>% html_table()

## numero de tablas extraidas
length(my_table)

my_table[[11]]

## tabla 10
sub_html = my_html %>% html_nodes(xpath='//*[@id="mw-content-text"]/div[1]/table[10]/tbody')
class(sub_html)

elements = sub_html %>% html_nodes("a")
elements[1:5]

titles = elements %>% html_attr("title")
titles[1:5]

refs = elements %>% html_attr("href")
refs[1:5]

db = tibble(titles,url=paste0("https://es.wikipedia.org",refs))
db %>% head()

browseURL(db$url[10])


url = "https://ignaciomsarmiento.github.io/GEIH2018_sample/pages/geih_page_3.html"
tabla = url %>% read_html() %>% html_table()
tabla_clean = tabla[[1]] %>% as_data_frame()



