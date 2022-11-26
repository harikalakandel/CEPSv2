#' FastSampEn_C
#'
#' This function computes fast sample entropy of given time series. It is implemented in C.
#' @param TS - given time series
#' @param dim - dimension of given time series, default value is 2
#' @param lag - downsampling, default value is 1
#' @param r - radius of searched areas, default value is 0.15*sd(TS)
#' @keywords fast sample entropy FastSampEn C
#' @export
#' @examples
#' timser <- rnorm(2000)
#' FastSampEn_C(timser)
#' FastSampEn_C(timser, r = 0.1*sd(timser))
#' FastSampEn_C(timser, dim = 3, r = 0.1*sd(timser))
#'
#' @useDynLib TSEntropies, FastSampEn_Cfun

FastSampEn_C <- function(TS, dim = 2, lag = 1, r = 0.15*sd(TS)){

  result <- -1000  # creating output variable with any value

  result <- .C("FastSampEn_Cfun",
                TS = as.double(TS),
                R_res = as.double(result),
                R_N   = as.integer(length(TS)),
                R_dim = as.integer(dim),
                R_lag = as.integer(lag),
                R_r   = as.double(r)
  )

  return(result$R_res)
}


#' FastSampEn
#'
#' This function computes fast sample entropy of given time series.
#' @param TS - given time series
#' @param dim - dimension of given time series, default value is 2
#' @param lag - downsampling, default value is 1
#' @param r - radius of searched areas, default value is 0.15*sd(TS)
#' @keywords fast sample entropy FastSampEn
#' @export
#' @examples
#' timser <- rnorm(2000)
#' FastSampEn(timser)
#' FastSampEn(timser, r = 0.1*sd(timser))
#' FastSampEn(timser, dim = 3, r = 0.1*sd(timser))
#'

FastSampEn <- FastSampEn_C

