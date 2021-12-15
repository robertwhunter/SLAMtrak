`%ni%` <- negate(`%in%`)

NA_sub_zero <- function(df) {
  df[is.na(df)] <- 0
  return(df)
}

NA_sub_x <- function(df, x) {
  df[is.na(df)] <- x
  return(df)
}

x_sub_y <- function(df, x, y) {
  df[df == x] <- y
  return(df)
}

CI_95 <- function(x, digits = 2) {
  mean <- mean(x)
  stdev <- sd(x)
  sqrt_n <- sqrt(length(x))
  sem <- stdev/sqrt_n
  CI <- 1.96*sem
  paste0(
    mean %>% round(digits) %>% format(nsmall = digits), 
    " (", 
    (mean-CI) %>% round(digits) %>% format(nsmall = digits), 
    " -- ", 
    (mean+CI) %>% round(digits) %>% format(nsmall = digits), 
    ")"
  )
}

