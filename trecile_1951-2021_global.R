library ("lubridate")
library(dplyr)

data <- read.csv ("D:\\Project-proposal\\projects\\Lake Urmia\\csv\\prec_.csv")
data [ data == -Inf] <- NA
data [data < 0] <- 0
data_m <- aggregate(data[, 4], list(data$date), FUN = function(x) mean(x, na.rm = TRUE))

test <- seq (1982, by=3, length = 12)

for ( v in test) {
  print(v)
  data_s <- data_m [year(data_m[,1]) < v, ]
  Q <- c()
    for ( m in 1:12) {
      print(m)
      data_mon <- data_s [month (data_s[,1]) == m, ]
      vec <- data_mon [,2]
      q <- quantile(vec, c(0.33, 0.5, 0.66), na.rm = TRUE)
      q_m <- c(m, q)
      Q <- rbind (Q, q_m)
    }
   write.csv (Q, paste0 ("D:\\Project-proposal\\projects\\Lake Urmia\\output\\quantiles_1951-2021_global\\", v, "_trecile_obs_month.csv"))  
}

