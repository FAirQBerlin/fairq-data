################################################################################
# This script starts the ETL Process                                           #
#                                                                              #
# Job Runs at kubernetes                                                       #
#                                                                              #
# Schedule: twice monthly                                                      #
#                                                                              #
# Author: Milan Flach                                                          #
# E-mail: milan.flach@inwt-statistics.de                                       #
################################################################################


# 00 Preparation ---------------------------------------------------------------
cat("System information:\n")
for (i in seq_along(sysinfo <- Sys.info())) 
  cat(" ", names(sysinfo)[i], ":", sysinfo[i], "\n")
options(warn = 2)

library(fairqData)
library(methods)
sessionInfo()

# 01 Start ETL -----------------------------------------------------------------
# futile.logger::flog.threshold(futile.logger::DEBUG)
status <- main(s3_data_sources())

q(save = "no", status = status)
