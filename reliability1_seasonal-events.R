library(verification)
###############################################################
path <- "E:\\Papers-Journals\\papers\\BJP\\output\\seasonal\\prob"
path_plot <- paste0("E:\\Papers-Journals\\papers\\BJP\\plot\\ROC_multi\\seasonal\\")
season <- c("Spring", "Summer", "Fall", "Winter")
Model <- c("CanCM4i", "CCSM4", "NEMO", "NASA")
event <- c("LN", "N", "MN")
COL <- c("red", "forestgreen", "blue", "brown")
LTY <- c(1,2,3, 4)



for (p in 1:3)
{
png (paste0("E:\\Papers-Journals\\papers\\BJP\\plot\\Reliability\\seasonal\\", event[p], "_rel_bjp_micro.png"), res=70)
  par(mar = c(4,4,2,2), oma = c(0.2, 0.2, 0.2, 0.2), mfrow = c(2,2))
  for (s in 1:4) {
   plot(c(0,1), c(0,1), xlim=c(0,1), ylim=c(0,1), type="l", xlab = "Forecast Probability", ylab = c("Observed Relative Frequency"), main = paste0(season[s]))
    for (m in 1:4) {
      print(m)
      model <- Model[m]
      data_m <- read.csv (paste0(path, "\\", model, "\\", season[s], ".csv"))
      ver <- verify (data_m[,p+6], data_m[,p+3], frcst.type = "prob", obs.type = "binary")
    lines.attrib(ver, col = COL[m], lwd = 3, type = "b", lty=LTY[m])
    }
  }
  #legend(0, 1, legend = Model, lwd=3, col = COL, lty = LTY, cex=1)
       dev.off()
  }

    #########################################
