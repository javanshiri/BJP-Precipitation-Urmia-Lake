path <- "D:\\Project-proposal\\projects\\Lake Urmia\\csv\\models_prec\\monthly\\"
file.names <- dir (path, pattern= ".csv")
M <- length (file.names)

for ( m in 2:M) { 
  for (l in 1:4) {
    for (i in 1:12) {
      print(c(m,l,i))
      pathout <- paste0("D:\\Project-proposal\\projects\\Lake Urmia\\output\\prc\\", "Lead", l, "\\Initial", i, "\\BJP\\", gsub (".csv", "", file.names[m]), "_L",l, "_In", i )
      setwd(pathout)
      #dir.create ("prob_raw_1951-2020_global")

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
    lt <- nrow (data_test)
    

    Q = read.csv (paste0 ("D:\\Project-proposal\\projects\\Lake Urmia\\output\\prc\\quantiles_1951-2021_global\\", v, "_trecile_obs_month.csv"))
    
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
     
      prob1 <-  + (model <= T1)
      prob2 <- + ( model > T1 & model <= T3 )
      prob3 <-  + (model > T3)
      
      O1 <- + (obs <= T1)
      O2 <- + ( obs > T1 & obs <= T3 )
      O3 <- + (obs > T3)
     
      prob <- c(prob1, prob2, prob3,  O1, O2, O3, T1, T3, obs, model)
      PROB <- rbind(PROB, prob)
    }
      colnames (PROB) <- c("p <=T1", "T1 < p <= T3", "P >T3",  "O1", "O2", "O3", "T1", "T3", "obs", "model")
    write.csv(PROB, paste0( pathout, "\\prob_raw_1951-2020_global\\", v, ".csv"))
  }
    }
  }}
#######################################


