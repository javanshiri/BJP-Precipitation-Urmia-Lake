library(emdbook)
library(gdata)
library(invgamma)
library(mvtnorm)
library(pracma)
library(mcmc)
library(stats4)
library(bbmle)
library(maxLik)
library(MCMCpack)
library(matlib)
library(lubridate)
library(atmcmc)
library(rstan)
library(EBMAforecast)
rstan_options(javascript=FALSE)

################################################MLE function
L_teta <- function(param) {
  
  landa1 = param[1]
  if (landa1 <= 0)
    return (-Inf)
  landa2 = param[2]
  if (landa2 <= 0)
    return (-Inf)
  alpha1 = param[3]
  if (alpha1 <= 0)
    return (-Inf)
  alpha2 = param[4]
  if (alpha2 <= 0)
    return (-Inf)
  
  landa = c(landa1, landa2)
  alpha = c(alpha1, alpha2)
  
  Z <-c()
  for (j in 1:d) { z = 1/landa[j] * log (sinh ( alpha[j] + landa[j] * y[,j]))
  Z <- cbind(Z,z)
  }
  
  mu <- apply (Z, 2, mean)
  SIGMA <- cov ( Z)
  
  #p_ebsilon <- dunif(ebsilon,0,1)
  #p_landa <- dunif(landa,0,1) 
  
  log_p_z <- apply (Z, 1, FUN = function(x) {dmvnorm (x, mu, SIGMA, log=T)})
  log_p_Z <- sum (log_p_z, na.rm=T)
  log_Cof <-c()
  for (i in 1:d) {cof = log (coth (alpha[i] + landa[i] * y[,i]))
  log_Cof <- cbind (log_Cof, cof)
  }
  Sum_log_Cof <- sum(log_Cof, na.rm=T)
  log_p_y <- log_p_Z + Sum_log_Cof
  return (log_p_y ) 
} 

##########################################
set.seed(50)
#create directories
pathoutput <- "E:\\Project-proposal\\projects\\Lake Urmia\\output\\prc\\"

pathouput_L <- function(l) {
  L <- paste0("Lead", l)
  return (paste0(pathoutput, L ))
}

pathoutput_I <- function (l, i) {
  L <- paste0("Lead", l)
  I <- paste0 ("Initial", i)
  return (paste0(pathoutput, L, "\\", I))
}

pathoutput_I <- function (l, i, m) {
  L <- paste0("Lead", l)
  I <- paste0 ("Initial", i)
  return (paste0(pathoutput, L, "\\", I))
}



for ( l in 1:4) {
  setwd(pathoutput)
  L <- paste0("Lead", l)
  dir.create (L)
    for ( i in 1:12 ) {
    setwd (pathouput_L(l))
    I <- paste0 ("Initial", i)
    dir.create (I)
    setwd (pathoutput_I(l,i))
    dir.create ("BJP")
  }
}

#################read observation
OBS <- read.csv ("E:\\Project-proposal\\projects\\Lake Urmia\\csv\\prec_.csv")
#subset data in (1982-2017)
obs <- OBS [OBS$date >= as.Date ("1982-01-01") & OBS$date <= as.Date ("2018-03-01"),]
obs [obs == -Inf] <- NA
obs [obs < 0] <- 0
obs <- obs[,4]
#obs <- as.numeric (as.character(obs))
#################read data of models
path <- "E:\\Project-proposal\\projects\\Lake Urmia\\csv\\models_prec\\monthly\\"
setwd (path)
file.names <- dir (path, pattern= ".csv")
M <- length (file.names)

for ( m in 2:M) { 
  print(m)
  #remove first col and lead 5 to 12
  data <- read.csv (file.names[m], head=T)[,2:8]
  head(data)
  N <- nrow(data)

  #########for every leadtime
  for (l in 1:4) {
    print(l)
    data_L <- data[, c(1:3,l+3)]
    obs_L <- obs [(1 + (l-1) * 957) : (N + (l-1) * 957) ]
    DATA_L <- data.frame(data_L, obs_L)
    #############for every intial time
    for (i in 1:12) {
      print(i)
      data_In <- DATA_L [month(data_L$date)==i ,]
      #remove Nulls
      data_c <- data_In[complete.cases(data_In),]
      dir.name <- paste0( gsub (file.names[m], pattern=".csv", replacement = ""), "_L", l, "_In", i)
      setwd (paste0( pathoutput_I(l,i), "\\BJP\\") )
      dir.create (dir.name) 
      pathoutput_M <- paste0( pathoutput_I(l,i), "\\BJP\\",dir.name)
      setwd (pathoutput_M)
      dir.create ("mcmc")
      dir.create ("param")
      dir.create ("data_test")
      dir.create ("data_train")
      dir.create ("prob")
      dir.create ("eval")
      
      #train and test
      V <- seq (0, 33, by=3)
      for ( v in V) {
        print(v)
        data_test <- data_c[year(data_c$date) >= 1982+v & year(data_c$date) <= 1984+v, ]
        data_train <- data_c[!data_c$date %in% data_test$date, ,drop = FALSE]
        write.csv(data_test, paste0(pathoutput_M, "\\data_test\\", v, ".csv"))
        write.csv(data_train, paste0(pathoutput_M, "\\data_train\\", v, ".csv"))
        
        #only data
        y = data_train[,4:5]
        y_test = data_test[,4:5]
        n = nrow(y)
        str(y)
        d=2
        ####################################################
        #MLE
        ###########################################################
        res <- maxLik (L_teta, start=c( landa1=1, landa2=1, alpha1=1, alpha2=1), method = "BFGS")
        param_hat <- unname(res$estimate)
        #######################################################################################
        #posterior in CDR values
        ###################################################################################################
        param <- param_hat
        landa <- param[1:2]
        alpha <- param[3:4]
        write.csv(param, paste0( pathoutput_M, "\\param\\", v, ".csv"))
        ##################################################
        ##########make matrix of z model data and y obs data
        #data_test <- cbind(Z_test[,1], y_test[,2])
        #colnames(data_test) <- c(gsub(file.names[m], pattern= ".csv", replacement = ""), "y_obs")
        
        ###########################
        #Z_test <- c() 
        #for (j in 1:d) { z_test = 1/landa[j] * log (sinh ( alpha[j] + landa[j] * y_test[,j]))
        #Z_test <- cbind(Z_test,z_test)
        #}
        
        
        Z <-c()
        for (j in 1:d) { z = 1/landa[j] * log (sinh ( alpha[j] + landa[j] * y[,j]))
        Z <- cbind(Z,z)
        }
        
        m_Z <- unname(apply (Z, 2, mean))
        #s_Z <- unname(apply (Z, 2, sd))
        cov_Z <- unname(cov ( Z))
        #R <- cor (Z)
        
        log_Coef <-c()
        for (i in 1:2) {coef = log (coth (alpha[i] + landa[i] * y[,i]))
        log_Coef <- cbind (log_Coef, coef)
        }
        
        ############################
        #mcmc######################
        
        data_mcmc <- list(n = n, 
                          Y = y,
                          Z = Z,
                          coef = log_Coef,
                          #param = param,
                          m_Z = m_Z,
                          cov_Z = cov_Z)
        setwd("E:\\Project-proposal\\projects\\Lake Urmia\\R\\")
        fit <- stan (file = "BJP.stan", data = data_mcmc)
        matrix_mcmc <- as.matrix(fit)
        write.csv(matrix_mcmc, paste0( pathoutput_M, "\\mcmc\\", v, ".csv"))
              }
    }
  }
}
###########################################
