# R packages

start_time <- Sys.time()

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

if (!require("DESeq2")) {
  install.packages("DESeq2")
}

if (!require("RColorBrewer")) {
  install.packages("RColorBrewer")
}

if (!require("gplots")) {  
  install.packages("gplots")
}

if (!require("getopt")) {
  install.packages("getopt")
}

if (!require("optparse")) {
  install.packages("optparse")
}

if (!require("data.table")) {
  install.packages("data.table")
}

end_time <- Sys.time()

cat("\nCompleted in", round(end_time - start_time, 2) , "seconds","\n")   





