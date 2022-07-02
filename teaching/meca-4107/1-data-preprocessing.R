# Eduard Martinez
# update: 10-06-2022

## install pacman
install.packages("pacman")

## llamar librerias de la sesion
require(pacman)
p_load(rio, # import/export data
       tidyverse, # tidy-data
       skimr, # summary data
       caret) # Classification And REgression Training

## set seed
set.seed(0000)

## load data
db <- import("https://gitlab.com/Lectures-R/bd-meca-2022-summer/lecture-01/-/raw/main/data/GEIH_sample1.rds")

## data dictionary is available here:
browseURL("https://ignaciomsarmiento.github.io/GEIH2018_sample/dictionary.html")

## df vs tibble
vignette("tibble") 
db <- as_tibble(db)

##=== 1. inspect data ===##

## view
head(db)
tail(db)

## summary db
skim(db)

## summary var
summary(db$y_salary_m)

##=== 2. visualize data ===##

## data + mapping
ggplot(data = db , mapping = aes(x = age , y = y_ingLab_m))

## + geometry
ggplot(data = db , mapping = aes(x = age , y = y_ingLab_m)) +
geom_point(col = "red" , size = 0.5)

## by group
ggplot(data = db , 
       mapping = aes(x = age , y = y_ingLab_m , group=as.factor(formal) , color=as.factor(formal))) +
       geom_point()

## density: income by sex
p <- ggplot(data=db) + 
     geom_histogram(mapping = aes(x=y_ingLab_m , group=as.factor(sex) , fill=as.factor(sex)))
p

p + scale_fill_manual(values = c("0"="red" , "1"="blue") , label = c("0"="Hombre" , "1"="Mujer") , name = "Sexo")

## box_plot: estrato1 vs totalHoursWorked
box_plot <- ggplot(data=db , mapping = aes(as.factor(estrato1) , totalHoursWorked)) + 
            geom_boxplot() 
box_plot

## add another geometry
box_plot <- box_plot +
            geom_point(aes(colour=as.factor(sex))) +
            scale_color_manual(values = c("0"="red" , "1"="blue") , label = c("0"="Hombre" , "1"="Mujer") , name = "Sexo")
box_plot

## add theme
box_plot + theme_test()

##=== 3. transformations ===##

## centering and scaling
h_hour = ggplot() + geom_histogram(data=db , aes(x=hoursWorkUsual) , fill="#99FF33" , alpha=0.5)
h_hour

db = db %>% mutate(esc_hoursWorkUsual = scale(hoursWorkUsual))

h_hour + geom_histogram(data=db , aes(x=esc_hoursWorkUsual) , fill="#FF0066" , alpha=0.5)

## Skewness: log
BoxCoxTrans(db$y_ingLab_m)

cat("¡En un rato lidiamos con los NA, por ahora vamos a evitarlos!")

BoxCoxTrans(db$y_ingLab_m , na.rm=T)

ggplot() + geom_boxplot(data=db ,aes(x=y_ingLab_m) , fill="darkblue" , alpha=0.5)

db <- db %>% mutate(log_ingLab_m=log(y_ingLab_m))

ggplot() + geom_histogram(data=db , aes(x=log_ingLab_m) , fill="coral1" , alpha=0.5)

## resolve outliers 
quantile(x=db$p6426 , na.rm=T)

IQR(x=db$p6426 , na.rm=T)

iqr <- IQR(x=db$p6426 , na.rm=T)

db_out <- db %>% subset(p6426 <= 2*iqr | is.na(p6426)==T)

cat("¡Elimina las NA!")

quantile(x=db_out$p6426 , na.rm=T)

nrow(db) - nrow(db_out)

##=== 4. add/remove variables ===##

## dummy vars
db = db %>% 
     mutate(p6426_out = ifelse(test = p6426 > 4*iqr, 
                               yes = 1, 
                               no = 0))
table(db$p6426_out)

## categorical vars
q = quantile(db$p6426 , na.rm=T)
q
db = db %>% 
     mutate(p6426_q = case_when(p6426 < q[2] ~ "Q-1", 
                                p6426 >= q[2] & p6426 < q[3] ~ "Q-2", 
                                p6426 >= q[3] & p6426 < q[4] ~ "Q-3", 
                                p6426 >= q[4] ~ "Q-4"))
table(db$p6426_q)

## select: delete a variable
head(db)

db %>% select(-Var.1,-orden)

## select variable: by patter name 
db %>% select(starts_with("p6"))

db %>% select(directorio,contains("salary"))

## select variable: by class
db %>% select_if(is.character)

##=== 5. dealing with missing values ===##

## get missing values
is.na(db$y_total_m)
is.na(db$y_total_m) %>% table()

## replace values:
db %>% select(directorio,contains("salary")) %>% tail()

db = db %>% 
     group_by(directorio) %>% 
     mutate(mean_y_total_m = mean(y_total_m,na.rm=T))

db %>% select(directorio,y_total_m,mean_y_total_m) %>% tail()

db = db %>%
     mutate(y_total_m = ifelse(test = is.na(y_total_m)==T,
                               yes = mean_y_total_m,
                               no = y_total_m))

db %>% select(directorio,y_total_m,mean_y_total_m) %>% tail()

## delete observations
db_c = db %>% subset(is.na(y_total_m)==F)

nrow(db) - nrow(db_c)

is.na(db$y_total_m) %>% table()

db_c = db %>% dplyr::filter(is.na(y_total_m)==F)

### **Referencias**

#-   Kuhn, M., & Johnson, K. (2013). Applied predictive modeling (Vol.
#    26, p. 13). New York: Springer. [[Ver
#    aquí]](https://books.google.com.co/books/about/Applied_Predictive_Modeling.html?id=xYRDAAAAQBAJ&redir_esc=y)

#    -   Cap. 3: Data Pre-processing

#-   Colin Gillespie and Robin Lovelace, 2017. Efficient R Programming, A
#    Practical Guide to Smarter Programming [[Ver
#    aquí]](https://csgillespie.github.io/efficientR/)

#    -   Cap. 3: Efficient programming

