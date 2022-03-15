# analysis parameters
mutations_threshold_readcount <- 100    # include reads about this threshold when counting mutations
cR_nudge <- 10e-9                       # shift when plotting mutation rates on a log scale

threshold_TC_centile <- 0.99            # threshold for calling labelled reads

threshold_coT <- 100                    # threshold for inclusion in delta analysis
threshold_median_cpm_abundant <- 5      # threshold for abundance in tissue of origin in delta analysis 
threshold_delta_basal_centile <- 0.95   # threshold for calling labelled reads in tissue of origin 
threshold_delta_target_centile <- 0.95  # threshold for calling labelled reads in target tissue