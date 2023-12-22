test_that("Compare dataframes", {
  df1 <- data.frame(x = 1, y = 1)
  df2 <- data.frame(x = c(1, 2), y = c(1, 1))
  
  exp <- list(
    df1_missings = structure(list(x = 2, y = 1), 
                             class = "data.frame", row.names = c(NA, -1L)), 
    df2_missings = structure(list(x = numeric(0), y = numeric(0)), row.names = integer(0), 
                             class = "data.frame")
    )
  
  expect_warning(compare_dataframes(df1, df2))
  res <- compare_dataframes(df1, df2)
  
  expect_equal(res, exp)
  
})


test_that("Compare dataframes, allowed missings", {
  df1 <- data.frame(x = c(1, 2), table = c(1, 1))
  df2 <- data.frame(x = 1, table = 1)
  
  exp <- list(
    df1_missings = structure(list(x = numeric(0), table = numeric(0)), row.names = integer(0), 
                             class = "data.frame"), 
    df2_missings = structure(list(x = numeric(0), table = numeric(0)), row.names = integer(0), 
                             class = "data.frame")
  )
  res <- compare_dataframes(df1, df2, allowed_missings_df2 = c(1))
  
  expect_equal(res, exp)
  
})
