#' get aws credentials
#'
#'@export
aws_creds <- function() {
  list(
    aws_key = Sys.getenv("AWS_KEY"),
    aws_secret = Sys.getenv("AWS_SECRET"),
    aws_bucket = Sys.getenv("AWS_BUCKET")
  )
}
