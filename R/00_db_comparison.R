#' Send query wrapper to a clickhouse instance available on localhost
#'
#' @param query query as string or file
#'
#' @export
send_query_local <- function(query) {
  
  creds_local <- fairqDbtools::creds("fairq_prod_features", suffix = "_LOCAL")
  
  fairqDbtools::l_send_query(
    creds_local, 
    query,
    settings = fairqDbtools::db_settings()
  )
  
} 

#' Send query wrapper to clickhouse
#' 
#' @param query query as string or file
#'
#' @export
send_query_prod <- function(query) {
  
  fairqDbtools::l_send_query(
    fairqDbtools::creds("fairq_prod_features"), 
    query,
    settings = fairqDbtools::db_settings()
  )
  
}

#' Compare two data.frames: throws a warning if not identical and returns the not identical rows 
#' 
#' @param df1 data.frame 1
#' @param df2 data.frame 2
#' @param allowed_missings_df2 tables which are allowed to be missing in df2
#'
#' @export
compare_dataframes <- function(df1, df2, allowed_missings_df2 = NULL) {
  
  # row in df2 but not in df1
  df1_missings <- anti_join(df2, df1)
  
  # row in df1 but not in df2 
  df2_missings <- anti_join(df1, df2)
  
  # ok when missing:
  df2_missings <- df2_missings[!(df2_missings$table %in% allowed_missings_df2),]
  
  
  if(nrow(df2_missings) > 0) {
    warning(log_warn(sprintf("The following items are missing in df2: %s", toJSON(df2_missings))))
  }
  
  if(nrow(df1_missings) > 0) {
    warning(log_warn(sprintf("The following items are missing in df1: %s", toJSON(df1_missings))))
  }
  
  list(
    df1_missings = df1_missings,
    df2_missings = df2_missings
  )
  
}

#' Compares dev and prod data base on clickhouse
#' 
#' @param ch2_data data.frame of tables or column types available on the clickhouse 2 db 
#'
#' @export
compare_dev_prod <- function(ch2_data) {
  database <- NULL
  
  allowed_missings_on_prod <- c(
    "traffic_model_predictions_nov2021_oct2022",
    "model_predictions_grid_nov2021_oct2022",
    "model_predictions_temporal_tweak_values",
    "model_predictions_passive_samplers",
    "coord_mapping_stadt_passive",
    "traffic_model_predictions_passive_samplers"
  )
  
  # prod vs. dev comparison:
  dev <-  filter(ch2_data, database %in% c("fairq_features", "fairq_output"))
  prod <- filter(ch2_data, database %in% c("fairq_prod_features", "fairq_prod_output"))
  prod$database <- sub("prod_", "", prod$database)
  
  
  compare_dataframes(dev, prod, allowed_missings_on_prod)
}
