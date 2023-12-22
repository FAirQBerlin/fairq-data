################################################################################
# This script compares the schema files in inst/db with clickhouse db          #
#                                                                              #
# Job Runs at kubernetes (inwt-prod)                                           #
#                                                                              #
# Schedule: once daily                                                         #
#                                                                              #
# Author: Milan Flach                                                          #
# E-mail: milan.flach@inwt-statistics.de                                       #
################################################################################

# for testing: start the database locally
# docker build -t test-db-1 inst/db/
# docker run --name test-db-1 -p 9001:9000 -d test-db-1

################################################################################

# 00 Preparation ---------------------------------------------------------------
cat("System information:\n")
for (i in seq_along(sysinfo <- Sys.info())) 
  cat(" ", names(sysinfo)[i], ":", sysinfo[i], "\n")
options(warn = 2)

library(fairqData)
sessionInfo()

# 01 Start comparison ---------------------------------------------------------

ch2_tables <- send_query_prod("db_tables")
file_tables <- send_query_local("db_tables")
ch2_types <- send_query_prod("db_column_types")
file_types <- send_query_local("db_column_types")

logging("Scanning for table differences between clickhouse and schema files in inst/db")
compare_dataframes(ch2_tables, file_tables)


logging("Scanning for column and type differences between clickhouse and schema files in inst/db")
compare_dataframes(ch2_types, file_types)

logging("Scanning for differences between dev and prod on clickhouse")
compare_dev_prod(ch2_tables)
compare_dev_prod(ch2_types)
