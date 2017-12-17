#####Kaggle Competition for Porto Seguro
library(data.table)
library(caret)
library(stringr)

####read csv then convert to data.table format
#Training set (where we devise train and validation set)
train <- fread( "~/Kaggle/Porto Seguro/Data/train.csv" )
View(train)

#Holdout set
test <- fread( "~/Kaggle/Porto Seguro/Data/test.csv" )
View(test)

##Extract feature names and make into a group
start_fea <- str_locate(names(train), "_(\\D*)_")[,1]
end_fea <- str_locate(names(train), "_(\\D*)_")[,2]
#Unique feature names; take out na; use gsub to take out "_"
uni_fea_dirty <- unique( substr( names(train), start = start_fea, stop = end_fea ) )[-1] #Take out NA, need to take out "_"
uni_fea <- gsub( "_", "", uni_fea_dirty )
for( feature in uni_fea ){
  assign( paste0( feature, "_col" ), names(train)[ grep( feature,names(train) ) ] )
}

#Make function that cleans the data by just inputting dataset; Could be used on training and holdout sets
cleaner <- function(data){
  #Make a data.table that is our cleaned data
  data_clean <- data
  
  #Deal with missing values by setting "-1" as NA
  for (col in names(data)){
    data_clean[ data_clean[[col]] == -1, c(col) := NA ]
  }
  
  #Categorical and binary columns clean
  cat_col <- names(data_clean)[(grep( "cat", names(data_clean)))] 
  data_clean[, (cat_col) := lapply(.SD, as.factor), .SDcols = cat_col ]
  #Binary column clean
  bin_col <- names(data)[(grep( "bin", names(data_clean)))] 
  data_clean[, (bin_col) := lapply(.SD, as.factor), .SDcols = bin_col ]
  
  #Make target column into a factor; Checks for any columns with name, "target"
  if( any( names(data_clean) %in% "target" ) ){
    data_clean[, target := base::as.factor(target) ]
  }

  #Return cleaned data
  return(data_clean)
}

#Cleaned data sets
train_clean <- cleaner(train)
test_clean <- cleaner(test)

#Set response and predictors
y <- "target"
x <- base::setdiff( base::names(train_clean), c(y, "id") )

#Create Data Splits for Training and Validation; For Caret
clean_folds <- createFolds(y = train_clean,
                               ## the outcome data are needed
                               k = 10,
                               list = TRUE)
                               ## The format of the results
unclean_folds <- createFolds(y = train,
                           ## the outcome data are needed
                           k = 10,
                           list = TRUE)
                           ## The format of the results
