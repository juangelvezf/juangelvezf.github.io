#==========================================#
# Elaborado por: Eduard F Martinez-Gonzalez
# Update: 01-09-2022
# R version 4.1.1 (2021-08-10)
#==========================================#

## Limpiamos nuestro ambiente
rm(list = ls())

## Cargamos los paquetes
library(pacman)
p_load(tidyverse, rio , skimr , fastDummies, caret, glmnet, MLmetrics , janitor)

## load data
browseURL("https://dev.socrata.com/foundry/www.datos.gov.co/epsv-yhtj") ## documentación
browseURL("https://www.datos.gov.co/Salud-y-Protecci-n-Social/51-Casos-de-Desnutrici-n-Aguda-en-menores-de-5-A-o/epsv-yhtj") ## Base de datos 
df <- import("https://www.datos.gov.co/resource/epsv-yhtj.csv")

##=== 1. Data pre-processing ===##

## Analicemos la estructura de la base
skim(df)

## Lidiar con los NA
df <- df %>% select(-cod_ase_) ## Esta variable parece no ess relevante. La vamos a dropear
tabyl(df$estrato)

## No obstante los NAs representan menos del 5% de las entradadas
df <- df %>% mutate(estrato=ifelse(is.na(estrato),2,estrato))

## Seleccionamos las variables relevantes
df <- df %>% select(orden, edad_, uni_med_, grupo_etario, sexo, area_,
                    num_comuna, tipo_de_seguridad_social, estrato, edema,
                    delgadez, oiel_reseca, hiperpigm, cambios_cabello, 
                    palidez, zscorept_aprox, interpretaci_n_zscore_pt)

## Construimos la edad
tabyl(df$uni_med_) ## unidad de medida: 1=dias , 2=mes
tabyl(df$edad_)
df <- df %>% 
      mutate(edad_=case_when(uni_med_ == 1 ~ edad_*365,
                             uni_med_ == 2 ~ edad_*30))
tabyl(df$edad_)                            

## Arreglamos las variables dic?tomas para que sean 1 y 0
variables_dicotomas <- c("edema", "delgadez", "oiel_reseca","hiperpigm", "cambios_cabello", "palidez")
lapply(df[,variables_dicotomas],table)
df[,variables_dicotomas] = df[,variables_dicotomas] - 1
lapply(df[,variables_dicotomas],table)

## Definimos las variables categoricas
variables_categoricas <- c("orden", "uni_med_", "grupo_etario","sexo", "area_", "num_comuna",
                           "tipo_de_seguridad_social", "estrato","edema", "delgadez", "oiel_reseca",
                           "hiperpigm", "cambios_cabello","palidez", "interpretaci_n_zscore_pt")

for (v in variables_categoricas){ df[, v] <- as.factor(df[, v, drop = T])}

## Convertimos el puntaje en positivo
df$zscorept_aprox <- -df$zscorept_aprox

## Relacion entre el puntaje zscore con la desnutricion
ggplot(df, aes(x = edad_, y = zscorept_aprox, color = interpretaci_n_zscore_pt)) +
geom_point() + theme_test() +
labs(x = "Edad en d?as", y = "Puntaje de desnutrici?n") +
scale_color_discrete(name = "Interpretaci?n") +
theme(legend.position="bottom")

## Ahora procedemos a dummyficar la base
df2 <- model.matrix(~ zscorept_aprox + edad_ + uni_med_ +
                      grupo_etario + sexo + area_ + num_comuna + 
                      tipo_de_seguridad_social + estrato + 
                      edema + delgadez + oiel_reseca + 
                      hiperpigm + cambios_cabello + palidez, df) %>% as.data.frame()

## Ahora vamos a revisar la distribucion de nuestra variable a predecir
ggplot(df2, aes(x = zscorept_aprox)) +
geom_histogram(bins = 50, fill = "darkblue") +
labs(x = "Puntaje de desnutrici?n", y = "Cantidad") +
theme_test() 

##=== 2. Estimations ===##

## Ahora vamos a dividir la base en train y test
set.seed(666)
id_train <- sample(1:nrow(df2), size = 0.7*nrow(df2), replace = FALSE)
train <- df2[id_train, ]
test  <- df2[-id_train, ]

## Convertimos la y en log
y_train <- log(train[,"zscorept_aprox"])
X_train <- select(train, -zscorept_aprox)
y_test <- log(test[,"zscorept_aprox"])
X_test <- select(test, -zscorept_aprox)

## estandarizar la variable de edad
mu <- mean(X_train$edad_)
sigma <- sd(X_train$edad_)
X_train$edad_ <- (X_train$edad_ - mu)/sigma
X_test$edad_ <- (X_test$edad_ - mu)/sigma

## Regresion lineal
train2 <- cbind(y_train, X_train)
modelo_reg <- lm("y_train ~ -1 + .", data = train2)
summary(modelo_reg)

df_coeficientes_reg <- modelo_reg$coefficients %>% enframe(name = "predictor", value = "coeficiente")

df_coeficientes_reg %>% filter(predictor != "`(Intercept)`") %>%
ggplot(aes(x = reorder(predictor, abs(coeficiente)), y = coeficiente)) + 
geom_col(fill = "darkblue") + coord_flip() + theme_test() +
labs(title = "Coeficientes del modelo de regresion", x = "Variables", y = "Coeficientes")

## evaluamos el modelo de regresion lineal
y_hat_in1 <- predict(modelo_reg, newdata = X_train)
y_hat_out1 <- predict(modelo_reg, newdata = X_test)

## matrices dentro y fuera de muestra. Paquete MLmetrics
r2_in1 <- R2_Score(y_pred = exp(y_hat_in1), y_true = exp(y_train))
rmse_in1 <- RMSE(y_pred = exp(y_hat_in1), y_true = exp(y_train))

r2_out1 <- R2_Score(y_pred = exp(y_hat_out1), y_true = exp(y_test))
rmse_out1 <- RMSE(y_pred = exp(y_hat_out1), y_true = exp(y_test))

resultados <- data.frame(Modelo = "Regresion lineal", 
                         Muestra = "Dentro",
                         R2_Score = r2_in1, RMSE = rmse_in1) %>%
              rbind(data.frame(Modelo = "Regresion lineal", 
                               Muestra = "Fuera",
                               R2_Score = r2_out1, RMSE = rmse_out1))

## La segunda parte continua en:
browseURL("https://eduard-martinez.github.io/teaching/big-data/week-04_2.txt")

##=== 3. Rmarkdown ===##

## Cheat sheet
browseURL("https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf")

## Tablas en Rmarkdown
browseURL("https://cran.r-project.org/web/packages/kableExtra/vignettes/awesome_table_in_html.html")





