#' Data sources to query from clickhouse
#'
#' List data sources. This list defines which data source to extract from clickhouse.
#'
#' @export
#' @rdname single_source
data_sources_grid <- function() {
  # Create an object for all data sources
  x <- list(
    single_source(
      name = "model_predictions_grid_latest"
    ),
    single_source(
      name = "selected_times_coords_ids"
    ),
    single_source(
      name = "preds_grid_filled_with_null"
    ),
    single_source(
      name = "api_grid"
      ),
    single_source(
      name = "api_streets"
      ),
    single_source(
      name = "api_lor"
    )
    )

  names <- unlist(lapply(x, `[[`, "name"))
  names(x) <- names
  x
}

#' Data sources to query from clickhouse
#'
#' List data sources. This list defines which data source to extract from clickhouse.
#'
#' @export
#' @rdname single_source
data_sources_grid_sim <- function() {
  # Create an object for all data sources
  x <- list(
    single_source(
      name = "model_predictions_grid_sim_latest"
    ),
    single_source(
      name = "selected_times_coords_ids_pct"
    ),
    single_source(
      name = "preds_grid_sim_filled_with_null"
    ),
    single_source(
      name = "api_simulation"
    )
  )
  
  names <- unlist(lapply(x, `[[`, "name"))
  names(x) <- names
  x
}


#' Data sources to query from clickhouse
#'
#' List data sources. This list defines which data source to extract from clickhouse.
#'
#' @export
#' @rdname single_source
data_sources_stations <- function() {
  # Create an object for all data sources
  x <- list(
    single_source(
      name = "model_predictions_stations_latest"
    ),
    single_source(
      name = "pred_stations_filled_with_null"
    ),
    single_source(
      name = "api_stations"
    )
  )
  
  names <- unlist(lapply(x, `[[`, "name"))
  names(x) <- names
  x
}


#' Data sources to query from clickhouse and write to s3
#' 
#' @param year year part of the current date, so that old years are preserved
#' but updates within the year overwrite the old data
#' @export
#' @rdname single_source
s3_data_sources <- function(year = format(Sys.Date(), "%Y")) {
  list(
    single_source(
      name = "s3_pollutant_street_avg",
      filename = sprintf("%s_pollutant_street_avg.csv", year),
      aws_bucket = aws_creds()$aws_bucket,
      aws_key = aws_creds()$aws_key,
      aws_secret = aws_creds()$aws_secret
    ),
    single_source(
      name = "s3_pollutant_grid_avg",
      filename = sprintf("%s_pollutant_grid_avg.csv", year),
      aws_bucket = aws_creds()$aws_bucket,
      aws_key = aws_creds()$aws_key,
      aws_secret = aws_creds()$aws_secret
    ),
    single_source(
      name = "s3_q_kfz_street_avg",
      filename = sprintf("%s_q_kfz_street_avg.csv", year),
      aws_bucket = aws_creds()$aws_bucket,
      aws_key = aws_creds()$aws_key,
      aws_secret = aws_creds()$aws_secret
    ),
    single_source(
      name = "s3_q_kfz_grid_avg",
      filename = sprintf("%s_q_kfz_grid_avg.csv", year),
      aws_bucket = aws_creds()$aws_bucket,
      aws_key = aws_creds()$aws_key,
      aws_secret = aws_creds()$aws_secret
    )
  )  
}


#' Data sources to query from clickhouse
#'
#' List data sources. This list defines which data source to extract from clickhouse.
#'
#' @export
#' @rdname single_source
cleanup_data_sources <- function() {
  # Create an object for all data sources
  x <- list(
    single_source(
      name = "model_predictions_stations_latest",
      cleanup = TRUE,
      optimize = TRUE,
      skip_extract = TRUE
    ),
    single_source(
      name = "model_predictions_grid_latest",
      cleanup = TRUE,
      optimize = TRUE,
      skip_extract = TRUE
    ),
    single_source(
      name = "preds_grid_filled_with_null",
      cleanup = TRUE,
      optimize = TRUE,
      skip_extract = TRUE
    ),
    single_source(
      name = "selected_times_coords_ids_pct",
      cleanup = TRUE,
      optimize = TRUE,
      skip_extract = TRUE
    ),
    single_source(
      name = "selected_times_coords_ids",
      cleanup = TRUE,
      optimize = TRUE,
      skip_extract = TRUE
    ),
    single_source(
      name = "api_grid",
      optimize = TRUE,
      skip_extract = TRUE
    ),
    single_source(
      name = "api_streets",
      optimize = TRUE,
      skip_extract = TRUE
    ),
    single_source(
      name = "api_lor",
      optimize = TRUE,
      skip_extract = TRUE
    ),
    single_source(
      name = "model_predictions_grid",
      optimize = TRUE,
      skip_extract = TRUE
    )
  )
  
  names <- unlist(lapply(x, `[[`, "name"))
  names(x) <- names
  x
}


#' Single source
#'
#' @param name (character) a unique name used as class and to identify target
#'   table on database.
#' @param get_data (function)
#' @param cleanup is there a cleanup step, i.e. a query with cleanup-[name].sql to execute beforehand?
#' @param optimize is there a optimize step, i.e. a query with optimize-[name].sql to execute after?
#' @param skip_extract should the extract step be skipped?
#' @param ... arguments used within methods and available for queries
#'
#' @export
#' @rdname single_source
single_source <- function(name,
                          get_data = fairqDbtools::send_query,
                          cleanup = FALSE,
                          optimize = FALSE,
                          skip_extract = FALSE,
                          ...) {
  # name (character) defines the class and is used for logging
  # get_data (function) a function that given the name and ... can extract data
  # ... passed to send data or otherwise used by methods
  out <- list(
    name = name,
    get_data = get_data,
    cleanup = cleanup,
    optimize = optimize,
    skip_extract = skip_extract,
    mode = mode$env(),
    ...
  )
  class(out) <- c(name, "list")
  
  return(out)
}
