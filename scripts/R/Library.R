# R packages

start_time <- Sys.time()


# check if DESeq2 package exist
is_DESeq_installed <- require("DESeq2")


# check if RColorBrewer package exist
is_RColorBrewer_installed <- require("RColorBrewer")

# check if gplots package exist
is_gplots_installed <- require("gplots")


# check if data.frame package exist
is_data.frame_installed <- require("data.frame")


# check if optparse package exist
is_optparse_installed <- require("optparse")

# check if getopt package exist
is_getopt_installed <- require("getopt")


cat("is_DESeq_installed =", is_DESeq_installed, "\n")
cat("is_RColorBrewer_installed = ", is_RColorBrewer_installed, "\n")
cat("is_getopt_installed = ", is_getopt_installed, "\n")
cat("is_data.frame_installed = ", is_data.frame_installed, "\n")
cat("is_optparse_installed =", is_optparse_installed, "\n")
cat("is_getopt_installed =", is_getopt_installed, "\n")


end_time <- Sys.time()

cat("\nCompleted in", round(end_time - start_time, 2) , "seconds","\n")   





