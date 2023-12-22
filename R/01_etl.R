etl <- function(x, ...) {
  
  if (x$cleanup) {
    logging("--- Cleanup --- %s", x$name)
    x <- cleanup(x, ...)
  }
  
  logging("--- Extract --- %s", x$name)
  x <- extract(x, ...)
  
  if (x$optimize) {
    logging("--- Optimize --- %s", x$name)
    x <- optimize(x, ...)
  }
  
  logging("--- Finished --- %s", x$name)
  return(x)
}

cleanup <- function(x, ...) {
  log_debug("Entering cleanup method for '%s'", x$name)
  x$dat <- do.call(x$get_data, list(query = "cleanup", table = x$name), ...) 
  
  x
}

extract <- function(x, ...) {
  if(!x$skip_extract) {
    log_debug("Entering extract method for '%s'", x$name)
    params <- x[unlist(lapply(x, Negate(is.function)))]
    names(params)[names(params) == "name"] <- "query"
    x$dat <- do.call(x$get_data, params, ...)
  } else {
    log_debug("Skipping extract method for '%s'", x$name)
  }
  
  x
}

optimize <- function(x, ...) {
  log_debug("Entering optimize method for '%s'", x$name)
  x$dat <- do.call(x$get_data, list(query = "optimize", table = x$name), ...) 
  
  x
}
