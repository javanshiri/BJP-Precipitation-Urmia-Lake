library(dplyr)
library(readr)

#########################################
P <- "E:\\Project-proposal\\projects\\Lake Urmia\\output\\prc\\"
for ( i in 1: 12) {
for ( l in 1:4) {
  path <-  paste0(P, "lead", l, "\\Initial", i, "\\BJP\\")
  setwd (path)
  names <- dir (path)
 for (m in 1:4) {
   setwd (paste0 (path, names[m]))
   dir.create ("merge_prob_bjp_1951-2020_global")
  }
}
}
##########################################################
path <- "D:\\Project-proposal\\projects\\Lake Urmia\\csv\\models_prec\\monthly\\"
file.names <- dir (path, pattern= ".csv")
M <- length (file.names)
pathout <- "D:\\Project-proposal\\projects\\Lake Urmia\\output\\prc\\"

for ( m in 1:4) { 
  print(m)
  for (l in 1:4) {
    for (i in 1:12) {
      print(c(l,i))
      pathoutput <- paste0( pathout, "Lead", l, "\\Initial", i, "\\BJP\\", gsub (".csv", "", file.names[m]), "_L",l, "_In", i )
      pathoutput.prob <- paste0(pathoutput, "\\prob_trecile_1991-2020_global\\")
      pathoutput.merge.prob <- paste0(pathoutput, "\\merge_prob_trecile_1951-2020_global\\")
      setwd(pathoutput.prob)
      merge <- list.files(path =pathoutput.prob, full.names = TRUE) %>% 
        lapply(read_csv) %>% 
        bind_rows 
      write.csv( merge, paste0 (pathoutput.merge.prob, "L",l, "_In", i, "bjp.csv"))
    }}}
      
      
 ##########################################################     
      
      
      