#' ApEn_C
#'
#' This function computes approximate entropy of given time series. It is implemented in C.
#' @param TS - given time series
#' @param dim - dimension of given time series, default value is 2
#' @param lag - downsampling, default value is 1
#' @param r - radius of searched areas, default value is 0.2*sd(TS)
#' @keywords approximate entropy ApEn C
#' @export
#' @examples
#' timser <- rnorm(2000)
#' ApEn_C(timser)
#' ApEn_C(timser, r = 0.1*sd(timser))
#' ApEn_C(timser, dim = 3, r = 0.1*sd(timser))
#'
#' @useDynLib TSEntropies, ApEn_Cfun

ApEn_C <- function(TS, dim = 2, lag = 1, r = 0.2*sd(TS)){
 
  rmax <- length(TS) - ((dim) * lag) + 1
  res <- rep(-100000, 2)
  
  res <- .C("ApEn_Cfun",
            TS = as.double(TS),
            R_res = as.double(res),
            R_rmax = as.integer(rmax),
            R_dim = as.integer(dim),
            R_lag = as.integer(lag),
            R_r = as.double(r)
  )
  
  phi <- res$R_res[1] - res$R_res[2]

  return(phi)
}


#' ApEn
#'
#' This function computes approximate entropy of given time series.
#' @param TS - given time series
#' @param dim - dimension of given time series, default value is 2
#' @param lag - downsampling, default value is 1
#' @param r - radius of searched areas, default value is 0.2*sd(TS)
#' @keywords approximate entropy ApEn
#' @export
#' @examples
#' timser <- rnorm(2000)
#' ApEn(timser)
#' ApEn(timser, r = 0.1*sd(timser))
#' ApEn(timser, dim = 3, r = 0.1*sd(timser))
#'

ApEn <- ApEn_C

