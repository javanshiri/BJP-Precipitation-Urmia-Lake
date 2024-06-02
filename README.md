# BJP-Precipitation-Urmia-Lake
This project focuses on applying the Bayesian Joint Probability (BJP) method to post-processing of monthly precipitation data from North American Multi-Model Ensemble (NMME) models - specifically CanCM4i, CCSM4, NEMO, and NASA.

The "BJP_calibrated_models_PRC" and "BJP.stan" scripts apply the BJP model to outputs from four NMME models - CanCM4i, CCSM4, NEMO, and NASA - covering the years 1982 to 2017 for a four-month forecast horizon. The script utilizes the maximum likelihood method to estimate landa and alpha parameters, while mu and sigma parameters are estimated using the Stan MCMC algorithm.

The "trecile_1951-2021_global" script is designed to compute terciles for each individual month using various periods of training data. 
