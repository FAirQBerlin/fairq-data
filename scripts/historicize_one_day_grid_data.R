# devtools::install()
devtools::load_all()

### Functions ###

prepare_df_for_parquet <- function(df) {
  df$x <- as.integer(df$x)
  df$y <- as.integer(df$y)
  df$date_time_forecast <- as.integer(df$date_time_forecast)
  df$date_time <- as.integer(df$date_time)
  df$value <- as.integer(round(df$value, 0))
  return(df)
}

print_file_size <- function(file_path) {
  file_size <- file.size(file_path)
  formatted_size <- utils:::format.object_size(file_size, "auto")
  return(paste0(file_path, ": ", formatted_size))
}

get_one_day_grid_history <- function(date_str) {
  out <- fairqDbtools::send_query("one_day_grid_history",
                                  date = date_str)
  logging("Got grid history for %s with %s rows.",
          date_str,
          nrow(out))
  return(out)
}

save_df_as_parquet <-  function(df, file_path) {
  write_parquet(df,
                file_path,
                compression = "gzip",
                compression_level = 9)
  logging("Wrote %s", print_file_size(file_path))
}

### Test case ###

test_data_dir <- "test_data"
if (!dir.exists(test_data_dir)) {
  dir.create(test_data_dir)
}

test_date <- "2023-01-03"
parquet_path <- file.path(test_data_dir, "test.parquet")

get_one_day_grid_history(test_date) %>%
  prepare_df_for_parquet() %>% 
  save_df_as_parquet(parquet_path)
# Parquet file size is around 70-80Mb per day
