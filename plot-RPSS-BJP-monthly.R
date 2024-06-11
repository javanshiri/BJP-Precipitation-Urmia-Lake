path.plot <- "E:\\Papers-Journals\\papers\\BJP\\plot\\RPSS\\monthly\\"
############
In <- function (m, l) {if (m-l+1 > 0 ) {i=m-l+1} else {i=m-l+13}
  return(i)}
#############
RPSS <- read.csv("E:\\Papers-Journals\\papers\\BJP\\output\\monthly\\RPS_BJP.csv")
for ( m in 1:12) {
  jpeg (paste0 (path.plot, m, "RPSS.jpg"))
  layout(matrix(c(1, 2, 3, 4), ncol=2, byrow=TRUE), heights=c(7, 7))
    for (l in 1:4) {
    ini <- In (m, l)
    RPSS_l_i <- RPSS[RPSS$Lead == l & RPSS$Initial == ini, ] 
    mat <- as.matrix (RPSS_l_i[c(6, 9, 12, 15)], 1, 4)
    colnames(mat) <- c("CanCM4i", "CCSM4", "NEMO", "NASA") 
        mycols = c("cyan4",  "pink3",  "khaki4", "darkseagreen4")
    barplot(mat, beside=T, ylim=c(-0.1, 0.4), legend=FALSE, 
            main = paste("Lead", l, "- Initial", ini),
            col=c("brown3",  "chartreuse4",  "blue1", "darkgoldenrod4"),
            cex.axis = 1.5, cex.lab=1.5, cex.names=1.5, font = 2, density=1000, las=2, names.arg = c("","","",""))
            }
  #par(mai=c(0,0,0,0))
  #plot.new()
  #legend(x="center", ncol=4, 
  #       legend =c("RAW-CanCM4i", "BJP-CanCM4i", "RAW-CCSM4", "BJP-CCSM4", "RAW-NEMO", "BJP-NEMO", "RAW-NASA", "BJP-NASA"),
   #      border=c("black", "black", "black", "black", "black", "black", "black", "black"), density=c(1000, 40, 1000, 40, 1000, 40, 1000, 40), 
   #      fill=mycols, cex = 1.1)
dev.off()
}