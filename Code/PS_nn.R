#Read data in
source( "~/Kaggle/Porto Seguro/Code/PS_dataclean.R" )

#Set up h2o
source( "~/Kaggle/Porto Seguro/Code/PS_h2o_setup.R" )

####multilayer feed forward network
mnn_fit1 <- h2o.deeplearning(x = x,
                         y = y,
                         training_frame = train.h,
                         nfolds = 10,
                         model_id = "mnn_fit1",
                         hidden = c(200,200),
                         use_all_factor_levels = TRUE,
                         seed = 1)
mnn_fit2 <- h2o.deeplearning(x = x,
                             y = y,
                             training_frame = train.h,
                             nfolds = 5,
                             model_id = "mnn_fit2",
                             hidden = c(200,200,200,200),
                             use_all_factor_levels = TRUE,
                             seed = 199)
#Performance Evaluation
h2o.performance(mnn_fit2)
h2o.confusionMatrix(mnn_fit2)

#Make Submissions
source( "~/Kaggle/Porto Seguro/Code/PS_Kaggle_H2o_Submission_Maker.R" )
PS_Kaggle_H2o_Submission_Maker( h2o.model = mnn_fit2, holdout = holdout.h )

#Shutdown
h2o.shutdown()
