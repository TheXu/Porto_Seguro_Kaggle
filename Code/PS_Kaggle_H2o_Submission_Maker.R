###Function for making Kaggle Submissions
PS_Kaggle_H2o_Submission_Maker <- function( h2o.model, holdout ){
  #Deploy model on Holdout Data set
  target <- h2o.predict( h2o.model, holdout )
  
  #Column bind predicted targets with Holdout data set
  pred_holdout <- h2o.cbind( target, holdout )
  
  #Create submission
  submission <- pred_holdout[,c("id","predict")]
  names(submission)[names(submission)=="predict"] <- "target"
  
  #Convert to data.table
  submission <- as.data.table( submission )
  
  #Write to csv table
  write.csv( submission, paste0( "~/Kaggle/Porto Seguro/Data/submission_%s.csv", Sys.time() ), row.names = FALSE )
}