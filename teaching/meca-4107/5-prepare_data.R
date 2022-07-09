## Eduard Martinez
## update: 02-07-2022
## R version 4.1.1 (2021-08-10)

## clean environment
rm(list=ls())

## Llamar/instalar las librerías para esta sesión:
require(pacman)
p_load(tidyverse,rio, janitor,caret)

## load data
db = import("https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2022-01.parquet") %>% 
     clean_names() %>% as_tibble() %>% subset(is.na(payment_type)==F)

## source
#browseURL("https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page")
#browseURL("https://www1.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf")

## gen variables
db = db %>% 
     mutate(pickup_hour=substr(lpep_pickup_datetime,12,13) %>% as.numeric(),
            payment_ccard = ifelse(payment_type==1,1,0),
            id_row = 1:nrow(.))

## select vars
df = db %>% 
    select(id_row,payment_ccard,
           trip_type,pickup_hour,trip_distance,passenger_count,pu_location_id,
           do_location_id,fare_amount,tip_amount,tolls_amount,total_amount)

## subset data
set.seed(2104)

train = df[createDataPartition(df$payment_ccard , p = 0.7)[[1]],]

test_complete = df[!df$id_row %in% train$id_row,]

test_class = test_complete %>% select(-payment_ccard)

## export data
export(train,"teaching/meca-4107/5_train.rds")
export(test_class,"teaching/meca-4107/5_test_class.rds")
export(test_complete,"teaching/meca-4107/5_test_complete.rds")







