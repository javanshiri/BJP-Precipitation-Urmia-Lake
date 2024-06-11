library(dplyr)
library(readr)
############################
path <- "D:\\Project-proposal\\projects\\Lake Urmia\\csv\\models_prec\\monthly\\"
file.names <- dir (path, pattern= ".csv")
M <- length (file.names)
pathout <- "D:\\Project-proposal\\projects\\Lake Urmia\\output\\prc\\"


RPS_L <- c()
  for (l in 1:4) {
    RPS_In <- c()
    for (i in 1:12) {
      RPS_M <- c()
      for ( m in 1:4) { 
      print(c(m,l,i))
      pathoutput <- paste0( pathout, "Lead", l, "\\Initial", i, "\\BJP\\", gsub (".csv", "", file.names[m]), "_L",l, "_In", i )
      pathoutput.merge.prob.bjp <- paste0(pathoutput, "\\merge_prob_trecile_1991-2020_global\\")
      prob <- read.csv (paste0(pathoutput.merge.prob.bjp, "L",l, "_In", i, "bjp.csv"))
      N <- nrow(prob)
      R <- c()
      for (n in 1:N) {
        x <- prob[n,]
        if (x[12] < x[9]) {r = c(1,0,0)
                                      }  else if (x[12] >= x[10]) {r = c(0,0,1)
                                      }  else {r = c(0,1,0)}
        R <- rbind(R, r)  
      }
      p1 <- R[,1]
      p2 <- R[,2]
      p3 <- R[,3]
      o1 <- prob[,6]
      o2 <- prob[,7]
      o3 <- prob[,8]
      rps <- 1/length(p1) * sum((p1-o1)^2 + (p1+p2-o1-o2)^2 + (p1+p2+p3-o1-o2-o3)^2)
      rps_clim <-  1/length(p1) * sum((1/3-o1)^2 + (2/3-o1-o2)^2 + (1-o1-o2-o3)^2)
      rpss <- 1- rps/rps_clim
      RPS <- c(rps, rps_clim, rpss)
      RPS_M <- c(RPS_M, RPS)
      }
      RPS_In <- rbind(RPS_In, c(i, RPS_M))
    }
    RPS_L <- rbind(RPS_L, cbind(l, RPS_In))
  }
colnames (RPS_L) <-  c("Lead", "Initial", "CanCM4i_rps", "CanCM4i_rps_clim","CanCM4i_rpss","CCSM4_rps", "CCSM4_rps_clim", "CCSM4_rpss", "NEMO_rps", "NEMO_rps_clim", "NEMO_rpss", "NASA_rps", "NASA_rps_clim", "NASA_rpss" )
write.csv(RPS_L, "E:\\Papers-Journals\\papers\\BJP\\output\\monthly\\RPS_RAW.csv")
 
      
      
      