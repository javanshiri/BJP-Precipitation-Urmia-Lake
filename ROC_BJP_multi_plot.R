library(verification)
library(multiROC)
library("dplyr")
library(TeachingDemos)


###########################
In <- function (m, l) {if (m-l+1 > 0 ) {i=m-l+1} else {i=m-l+13}
  return(i)}

###############################################################
Model <- c("CanCM4i", "CCSM4", "NEMO", "NASA")
for (mo in 1:12) {
  print(mo)
  png (paste0("E:\\Papers-Journals\\papers\\BJP\\plot\\ROC_multi\\monthly\\roc_bjp", mo, ".png"), res=70)
  par(mar=c(4,4,2,2),oma=c(0.2, 0.2, 0.2, 0.2), mfrow=c(2,2) )
  P <- "D:\\Project-proposal\\projects\\Lake Urmia\\output\\prc\\"
  for ( l in 1:4) {
    print(l)
    ini <- In (mo, l)
    path <-  paste0(P, "lead", l, "\\Initial", ini, "\\BJP\\")
    setwd (path)
    names <- dir (path)
    data_p <- list()
    for (m in 1:4) {
      print(m)
      setwd (paste0 (path, names[m], "\\merge_prob_trecile_1991-2020_global"))
      data_m <- read.csv (paste0("L", l, "_In", ini, "bjp.csv"))
      data_p[[m]] <- data_m[, c(6:8, 3:5)]
    }
    
    roc <- list()
    roc_res <- list()
    for (m in 1:4) {
      DATA <- data_p[[m]]
      colnames (DATA) <- c("G1_true", "G2_true", "G3_true", paste0("G1_pred_", Model[m]), paste0("G2_pred_", Model[m]), paste0("G3_pred_", Model[m]))
      roc_res [[m]]<- multi_roc(DATA) 
      roc_res_df <- plot_roc_data(roc_res[[m]])
      roc [[m]] <- roc_res_df [roc_res_df$Group == "Micro", ]
    }
    names (roc) <- Model
    
    ############################################################
    auc <- data.frame(model = Model, AUC = c(roc_res[[1]]$AUC$CanCM4i[[5]], roc_res[[2]]$AUC$CCSM4[[5]], roc_res[[3]]$AUC$NEMO[[5]], roc_res[[4]]$AUC$NASA[[5]]))
    #############################################################
    mycol = c("brown3",  "chartreuse4",  "blue1", "darkgoldenrod4")
    mylty = c(1:4)
    plot(1-roc[[1]]$Specificity, roc[[1]]$Sensitivity, col = mycol[1], xlab = "1 - Specificity", ylab = "Sensitivity", main = paste0("Lead", l), type = "l", lwd = 3, lty = mylty[1])
    abline(c(0,0), c(1,1), lty = 5)
   for ( m in 2:4) {
     par(new =T)
     plot(1-roc[[m]]$Specificity, roc[[m]]$Sensitivity, col = mycol[m], xlab= "", ylab = "", type = "l", lwd = 3, lty = mylty[m])
   }
    mylegend = c()
    subplot(barplot(auc[,2], names.arg =  auc[,1],  xlab ="", ylab = "", main = "AUC", col = mycol, ylim = c(0.4, 0.9), xpd=FALSE, las=2, cex.axis = 0.8, cex.lab=0.8,  cex.names=0.8, cex.main =0.9),  1, 0.27, hadj=1, vadj=0, size=c(0.7,0.5)) 
  }
  dev.off()
  }

