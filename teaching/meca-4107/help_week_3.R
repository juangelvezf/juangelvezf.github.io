
# librerias
require(pacman)
p_load(tidyverse)


## Punto 1: loops cambiar variables
db = mtcars
recode_vars = c("cyl","disp","hp","drat","wt" )

for (i in recode_vars){
db[,i] = ifelse(test = db[,i]<10 , yes = NA , db[,i])
}

for (i in recode_vars){
     db[,i] = ifelse(test = is.na(db[,i])==T , yes = 0 , db[,i])
}

## Punto 2:


lm(mpg ~ hp , data=db , subset = vs==1)
lm(mpg ~ hp , data=db , subset = vs==0)


db = db %>% mutate(new_var = ifelse(carb==4 & hp>100,1,
                                    ifelse()))

db = db %>% mutate(new_var = case_when(carb==4 & hp>100 ~ 1,
                                       carb==3 & hp<100 ~ 2))

                   