library(h2o)

#Initialize h2o
h2o.init()

#Import data into h2o
train.h <- as.h2o( x = train_clean, destination_frame = "train.h" ) ###Problem is happening here
holdout.h <- as.h2o( x = test_clean, destination_frame = "holdout.h" )
train_nocl.h <- as.h2o( x = train, destination_frame = "train_nocl.h" ) #Uncleaned
holdout_nocl.h <- as.h2o( x = test, destination_frame = "holdout_nocl.h" ) #Uncleaned
