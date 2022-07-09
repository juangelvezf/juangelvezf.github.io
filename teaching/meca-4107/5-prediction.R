## Eduard Martinez
## update: 09-07-2022
## R version 4.1.1 (2021-08-10)

## clean environment
rm(list=ls())

## Llamar/instalar las librerías para esta sesión:
require(pacman)
p_load(tidyverse , rio , caret ,  modelsummary , gamlr,
       ROCR, # ROC
       pROC) # optimal cutoff

## solver packages conflicts
predict <- stats::predict
  
##=== 1. data acquisition ===##

## source
#browseURL("https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page")
#browseURL("https://www1.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf")

## about data
# id_row: ID row
# payment_ccard: A numeric code signifying how the passenger paid for the trip. 1= credit card ; 0=otherways 
# trip_type: 1= Street-hail ; 2= Dispatch
# pickup_hour: The hour when the meter was engaged
# trip_distance: The elapsed trip distance in miles reported by the taximeter.
# passenger_count: The number of passengers in the vehicle. 
# fare_amount: The time-and-distance fare calculated by the meter.
# tip_amount: Does not include cash tips.
# tolls_amount: Total amount of all tolls paid in trip.
# total_amount: The total amount charged to passengers. Does not include cash tips.
# pu_location_id: TLC Taxi Zone in which the taximeter was engaged
# do_location_id: TLC Taxi Zone in which the taximeter was disengaged

## load data
data <- import("https://eduard-martinez.github.io/teaching/meca-4107/5_train.rds") %>%
        mutate(payment_ccard=factor(payment_ccard,levels=c(1,0),labels=c("Si","No")))
               
data_submission <- import("https://eduard-martinez.github.io/teaching/meca-4107/5_test_class.rds")

##=== 2. prepare data ===##

## proporciones
prop.table(table(data$payment_ccard))

## now create the evaluation and test sets
set.seed(2104)

## set training dataset
split1 <- createDataPartition(data$payment_ccard , p = 0.7)[[1]]

training = data[split1,]

## set evaluation and testing datasets
other <- data[-split1,]

split2 <- createDataPartition(other$payment_ccard , p = 1/3)[[1]]

evaluation <- other[split2,]

testing <- other[-split2,]

## check balance
prop.table(table(training$payment_ccard))

prop.table(table(testing$payment_ccard))

prop.table(table(evaluation$payment_ccard))

##=== 3. predictions: logit ===##

## modelo a ajustar
model <- as.formula("payment_ccard ~ trip_distance + pickup_hour + pu_location_id:do_location_id + factor(passenger_count) + factor(trip_type)")

## estimations
glm_logit <- glm(model , family=binomial(link="logit") , data=training)

## predict payment_ccard
testing$predict_logit <- predict(glm_logit , testing , type="response")

## definir la regla
ggplot(data=testing , mapping = aes(payment_ccard , predict_logit)) + 
geom_boxplot(aes(fill=payment_ccard)) + theme_test()

testing <- testing %>% 
           mutate(p_logit=ifelse(predict_logit>0.35,1,0) %>% 
                                 factor(.,levels=c(1,0),labels=c("Si","No")))

## confusion mnatrix
confusionMatrix(data=testing$p_logit, 
                reference=testing$payment_ccard , 
                mode="sens_spec" , positive="Si")

##=== 4. predictions: CV ===##

## modelo a ajustar
model <- as.formula("payment_ccard ~ trip_distance + pickup_hour + pu_location_id:do_location_id + factor(passenger_count) + factor(trip_type)")

## define control
fiveStats <- function(...) c(twoClassSummary(...), defaultSummary(...))
control <- trainControl(method = "cv", number = 5,
                        summaryFunction = fiveStats, 
                        classProbs = TRUE,
                        verbose=FALSE,
                        savePredictions = T)

## train
caret_logit = train(model,
                    data=training,
                    method="glm",
                    trControl = control,
                    family = "binomial",
                    preProcess = c("center", "scale"))
caret_logit

## predict
testing$p_caret <- predict(caret_logit , testing , type="prob")[1]

## ROC
pred <- prediction(testing$p_caret , testing$payment_ccard)

roc_ROCR <- performance(pred,"tpr","fpr")

plot(roc_ROCR, main = "ROC curve", colorize = T)
abline(a = 0, b = 1)

auc_roc = performance(pred, measure = "auc")
auc_roc@y.values[[1]]

##=== 5. optimal cutoff ===##

evalResults <- data.frame(payment_ccard = evaluation$payment_ccard)


evalResults$Roc <- predict(caret_logit, newdata = evaluation,
                           type = "prob")[,1]

rfROC <- roc(evalResults$payment_ccard, evalResults$Roc, levels = rev(levels(evalResults$payment_ccard)))

rfROC

rfThresh <- coords(rfROC, x = "best", best.method = "closest.topleft")

rfThresh

