## Eduard Martinez
## update: 02-07-2022
## R version 4.1.1 (2021-08-10)

## clean environment
rm(list=ls())

## Llamar/instalar las librerías para esta sesión:
require(pacman)
p_load(tidyverse, caret, rio, 
       modelsummary, # tidy, msummary
       gamlr,        # cv.gamlr
       class)        # knn

##=== 1. K-Nearest Neighbors ===##

## obtener los datos
?mtcars
db <- tibble(mtcars)
head(db)

cat("Intentemos predecir si un automovil tiene transmisión manual (1) o automatica (0):")"

## recategorizar variable
db = db %>% 
     mutate(am=ifelse(am==1,"manual (1)","automatic (0)") %>% as.factor())

## fijar semilla
set.seed(210422)

## generar observaciones aleatorias
test <- sample(x=1:32, size=10)

## reescalar variables (para calcular distancias)
x <- scale(db[,-9]) 
apply(x,2,sd) ## verificar

## k-vecinos
k1 = knn(train=x[-test,], ## base de entrenamiento
         test=x[test,],   ## base de testeo
         cl=db$am[-test], ## outcome
         k=1)        ## vecinos 

tibble(db$am[test],k1)

## matriz de confusión
confusionMatrix(data=k1 , 
                reference=db$am[test] , 
                mode="sens_spec" , 
                positive="manual (1)")
                
cm = confusionMatrix(data=k1 , reference=db$am[test], positive="manual (1)")$table
cm

## obtener los valores manualmente 
(cm[1,1]+cm[2,2])/sum(cm) ## Accuracy
cm[2,2]/sum(cm[,2]) ## Sensitivity
cm[1,1]/sum(cm[,1]) ## Specificity
cm[2,1]/sum(cm[2,]) ## Ratio Falsos Positivos
cm[1,2]/sum(cm[1,]) ## Ratio Falsos Negativos

##=== 2. Regresión: Logit y Probit ===##

## obtener datos
geih <- import("https://eduard-martinez.github.io/teaching/meca-4107/geih.rds")
head(geih)

## modelo a ajustar
model <- as.formula("ocu ~ age + sex + factor(maxEducLevel)")

## estimación logit
logit <- glm(model , family=binomial(link="logit") , data=geih)
tidy(logit)

## estimación probit
probit <- glm(model , family=binomial(link="probit") , data=geih)
tidy(probit)

## ratio de los coeficientes
logit$coefficients / probit$coefficients

## preddicción
geih$ocu_log = predict(logit , newdata=geih , type="response")
geih$ocu_prob = predict(probit , newdata=geih , type="response")
head(geih)

## definir la regla
rule=0.7
geih$ocu_prob = ifelse(geih$ocu_prob>rule,1,0)
geih$ocu_log = ifelse(geih$ocu_log>rule,1,0)
head(geih)


## Clasificación: probit
cm_prob = confusionMatrix(data=factor(geih$ocu) , 
                          reference=factor(geih$ocu_prob) , 
                          mode="sens_spec" , positive="1")
cm_prob

## Clasificación: logit
cm_log = confusionMatrix(data=factor(geih$ocu) , 
                         reference=factor(geih$ocu_log) , 
                         mode="sens_spec" , positive="1")
cm_log

## Clasificación: obtener los valores manualmente
cm = cm_log$table
(cm[1,1]+cm[2,2])/sum(cm) ## Accuracy
cm[2,2]/sum(cm[,2]) ## Sensitivity
cm[1,1]/sum(cm[,1]) ## Specificity
cm[2,1]/sum(cm[2,]) ## Ratio Falsos Positivos
cm[1,2]/sum(cm[1,]) ## Ratio Falsos Negativos



