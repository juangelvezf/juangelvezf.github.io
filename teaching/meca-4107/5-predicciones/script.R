
rm(list=ls())
require(pacman)
p_load(caret,tidyverse,rio,data.table)

files = list.files(".") %>% str_subset("5_test_complete.rds",negate=T)
files
data = import("5_test_complete.rds")

df = list()
for (i in 1:9){
result_i = import(files[i])
db_i = left_join(data,result_i,"id_row")
cm = confusionMatrix(data=factor(db_i$p) , reference=factor(db_i$payment_ccard) , mode="everything" , positive="1")
df[[i]] = tibble(id=files[i] %>% gsub(".rds|.csv","",.),
            Accuracy = cm$overall[1],
            Sensitivity = cm$byClass[1],
            Specificity = cm$byClass[2]) 
}

df = df %>% rbindlist()
export(df,"table.xlsx")
