# BJP-Precipitation-Urmia-Lake
This project focuses on applying the Bayesian Joint Probability (BJP) method to post-processing of monthly precipitation data from North American Multi-Model Ensemble (NMME) models - specifically CanCM4i, CCSM4, NEMO, and NASA.

The "BJP_calibrated_models_PRC.R" and "BJP.stan" scripts apply the BJP model to outputs from four NMME models - CanCM4i, CCSM4, NEMO, and NASA - covering the years 1982 to 2017 for a four-month forecast horizon. The script utilizes the maximum likelihood method to estimate landa and alpha parameters, while mu and sigma parameters are estimated using the Stan MCMC algorithm.

The "trecile_1951-2021_global.R" script calculates terciles for each month using different training data periods.

The scripts "PROB_BJP_prc_raw_model_1951-2021_global.R" and "PROB_BJP_prc_trecile_1951-2021_global.R" are used to determine the probability of above-normal, normal and below-normal precipitation amounts based on the RAW and BJP models, respectively.

The scripts "merg_prob_bjp.R" and "merg_prob_raw.R" merge the calculated probabilities from different test periods in the cross-validation method into a single file.

The scripts "RPS_RAW_monthly.R" and "RPS_BJP_monthly.R" have been utilized to compute the monthly RPS and RPSS values for both the raw and BIP models.

The scripts "plot_RPSS_RAW_monthly.R" and "plot_RPSS_BJP_monthly.R" generated visual representations of monthly RPSS scores for both raw and BIP models. 

The script "ROC_BJP_multi_plot.R" generates monthly multi-ROC plots for BJP models.

The script "reliability1_seasonal-events.R" generated a seasonal reliability diagram for BJP models. 
