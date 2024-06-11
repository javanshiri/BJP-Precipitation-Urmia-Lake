path <- "E:\\Project-proposal\\projects\\Lake Urmia\\csv\\models_prec\\monthly\\"
file.names <- dir (path, pattern= ".csv")
M <- length (file.names)

for ( m in 3:M) { 
  print(m)
  for (l in 1:4) {
    for (i in 4:12) {
      pathout <- paste0("E:\\Project-proposal\\projects\\Lake Urmia\\output\\prc\\", "Lead", l, "\\Initial", i, "\\BJP\\", gsub (".csv", "", file.names[m]), "_L",l, "_In", i )
      setwd(pathout)
      dir.create ("prob_trecile_1991-2020_global")

# calculate f(y|x)
#####################
  pathoutput.mcmc <- paste0(pathout, "\\mcmc\\")
  setwd(pathoutput.mcmc)
  mcmc.sample <- dir(pathoutput.mcmc, pattern=".csv")
  length.sample <- length (mcmc.sample)
  V <- seq (0, 33, by=3)
  
  for ( v in V) {
    print(v)
    name <- paste0 (v , ".csv")
    P <- read.csv (name) [,-1]
    data_test <- read.csv (paste0(pathout, "\\data_test\\", name))[,-1]
    data_train <- read.csv (paste0(pathout, "\\data_train\\", name))[,-1]
    
    param <- read.csv (paste0(pathout,"\\param\\", name))[,-1]
    landa <- param[1:2]
    alpha <- param[3:4]
    y1_model <- data_test[,4]
    z1_model <- 1/landa[1] * log (sinh ( alpha[1] + landa[1] * y1_model))
    mu_perim <- lapply(z1_model, F= function (x) {P[,"mu.2."] + P[,"rho"] * P[,"sigma.2."] / P[,"sigma.1."] * (x - P[,"mu.1."])}) 
    sigma_perim_2 <- P[,"sigma.2."] ^ 2 * (1 - P[,"rho"] ^ 2)
    sigma_perim <- sqrt (sigma_perim_2)
    P_perim <- lapply (mu_perim, function(x)  {cbind(x, sigma_perim)})
    z2_dist <- lapply (P_perim, function(x) {apply (x, 1, F= function(y) {rnorm(1, y[1] ,y[2])} )} )
    y2_dist <-  lapply (z2_dist, function(x) { (asinh (exp(x * landa[2]))- alpha[2])/landa[2]})
    y2_dist_nonnegative <- lapply(y2_dist, function(x) { x[x < 0] <- 0;  return (x) })
    
    
    F_y2 <- lapply(y2_dist_nonnegative, function(x) ecdf(x))
    lt <- length (z1_model)
    

    Q = read.csv (paste0 ("E:\\Project-proposal\\projects\\Lake Urmia\\output\\quantiles_1951-2021_global\\", v, "_trecile_obs_month.csv"))
    
    PROB <- c()
    for (t in 1: lt) {
      row_data_test <- data_test[t,]
      obs <- row_data_test$obs_L
      model <- row_data_test[4]
      MO <- function(i,l) { if (i+l-1 <= 12 ) {M=i+l-1} else {M=i+l-13}
        M}
      trecile_m <- Q [Q[,2] == MO(i,l), ]
      T1 <- trecile_m[3]
      T2 <- trecile_m[4]
      T3 <- trecile_m[5]
     
      prob1 <-  F_y2[[t]] (T1)
      prob2 <- F_y2[[t]] ( T3) -  F_y2[[t]] (T1)
      prob3 <-  1 - F_y2[[t]] (T3)
      
      O1 <- + (obs <= T1)
      O2 <- + ( obs > T1 & obs <= T3 )
      O3 <- + (obs > T3)
     
      prob <- c(prob1, prob2, prob3,  O1, O2, O3, T1, T3, obs, model)
      PROB <- rbind(PROB, prob)
    }
      colnames (PROB) <- c("p <=T1", "T1 < p <= T3", "P >T3",  "O1", "O2", "O3", "T1", "T3", "obs", "model")
    write.csv(PROB, paste0( pathout, "\\prob_trecile_1991-2020_global\\", v, ".csv"))
  }
    }
  }}
#######################################

u <- cbind(z2_dist[[1]], y2_dist[[1]])
write.csv (u, "test.csv")
