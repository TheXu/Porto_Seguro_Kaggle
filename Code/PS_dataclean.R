#####Kaggle Competition
library(data.table)
library(h2o)
library(caret)
library(stringr)

h2o.init()
#read csv then convert to data.table format
train <- fread( "C:/Users/Alex/Documents/Kaggle/Porto Seguro/train.csv" )
View(train)

test <- fread( "C:/Users/Alex/Documents/Kaggle/Porto Seguro/test.csv" )
View(test)

##Extract feature names and make into a group
start_fea <- str_locate(names(train), "_(\\D*)_")[,1]
end_fea <- str_locate(names(train), "_(\\D*)_")[,2]
#Unique feature names; take out na; use gsub to take out "_"
uni_fea <- gsub( "_", "", unique( substr( names(train), start = start_fea, stop = end_fea ) )[-1] )
for( feature in uni_fea ){
  assign( paste0( feature, "_col" ), names(train)[ grep( feature,names(train) ) ] )
}
#Make function that cleans the data by just inputting dataset
make.cat.bin <- function(data){
  #Categorical column clean
  cat_col <- names(data)[(grep( "cat", names(data)))] 
  data_clean <- data[, lapply(.SD, as.factor), .SDcols = cat_col ]
  #Binary column clean
  bin_col <- names(data)[(grep( "bin", names(data)))] 
  data_clean <- data[, lapply(.SD, as.factor), .SDcols = bin_col ]
  
  #Deal with missing values by setting "-1" as NA
  
  #Return cleaned data
  return(data_clean)
}

#Cleaned data sets
train_clean <- make.cat.bin(train)
test_clean <- make.cat.bin(test)

train.h <- h2o.importFile(path = "C:/Users/Alex/Documents/Kaggle/Porto Seguro/train.csv", destination_frame = "train")
test.h <- h2o.importFile(path = "C:/Users/Alex/Documents/Kaggle/Porto Seguro/test.csv", destination_frame = "test")

####multilayer feed forward network
#Set response and predictors
y <- "target"
x <- setdiff( names(train.h), c(y, "id") )
#Change to factor
train.[,y] <- as.factor(train[,y])
test.[,y] <- as.factor(test[,y])
train.h[,y] <- as.factor(train.h[,y])
test.h[,y] <- as.factor(test.h[,y])

#
fit1 <- h2o.deeplearning(x = x,
                            y = y,
                            training_frame = train,
                            model_id = "fit1_2020",
                            hidden = c(20,20),
                            seed = 1)

h2o.shutdown()
