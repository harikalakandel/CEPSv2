#' SampEn_C
#'
#' This function computes sample entropy of given time series. It is implemented in C.
#' @param TS - given time series
#' @param dim - dimension of given time series, default value is 2
#' @param lag - downsampling, default value is 1
#' @param r - radius of searched areas, default value is 0.2*sd(TS)
#' @keywords sample entropy SampEn C
#' @export
#' @examples
#' timser <- rnorm(2000)
#' SampEn_C(timser)
#' SampEn_C(timser, r = 0.1*sd(timser))
#' SampEn_C(timser, dim = 3, r = 0.1*sd(timser))
#'
#' @useDynLib TSEntropies, SampEn_Cfun

SampEn_C <- function(TS, dim = 2, lag = 1, r = 0.2*sd(TS)){

   rmax <- length(TS) - ((dim) * lag) + 1
   res <- -100000

   res <- .C("SampEn_Cfun",
             TS = as.double(TS),
             R_res = as.double(res),
             R_rmax = as.integer(rmax),
             R_dim = as.integer(dim),
             R_lag = as.integer(lag),
             R_r = as.double(r)
   )

 phi <- res$R_res[1]

 return(phi)
} 


#' SampEn
#'
#' This function computes sample entropy of given time series.
#' @param TS - given time series
#' @param dim - dimension of given time series, default value is 2
#' @param lag - downsampling, default value is 1
#' @param r - radius of searched areas, default value is 0.2*sd(TS)
#' @keywords sample entropy SampEn
#' @export
#' @examples
#' timser <- rnorm(2000)
#' SampEn(timser)
#' SampEn(timser, r = 0.1*sd(timser))
#' SampEn(timser, dim = 3, r = 0.1*sd(timser))
#'

SampEn <- SampEn_C

