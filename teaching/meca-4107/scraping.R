



library(RSelenium)

# docker
sudo docker run -d -p 4445:4444 selenium/standalone-firefox:2.53.0
sudo docker ps

sudo docker stop $(sudo docker ps -q)

# establecer servidor
remDr <- remoteDriver(port = 4445L)
remDr$open()

# navegar a la página
remDr$navigate("https://ignaciomsarmiento.github.io/GEIH2018_sample/page1.html")
remDr$getTitle()

# Extracting table
data_1 = remDr$getPageSource()[[1]] %>% read_html() %>% html_table()
data_1



