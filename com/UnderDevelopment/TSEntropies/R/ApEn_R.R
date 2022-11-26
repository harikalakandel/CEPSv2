#' ApEn_R
#'
#' This function computes approximate entropy of given time series. It is implemented in R.
#' @param TS - given time series
#' @param dim - dimension of given time series, default value is 2
#' @param lag - downsampling, default value is 1
#' @param r - radius of searched areas, default value is 0.2*sd(TS)
#' @keywords approximate entropy ApEn R
#' @export
#' @examples
#' timser <- rnorm(2000)
#' ApEn_R(timser)
#' ApEn_R(timser, r = 0.1*sd(timser))
#' ApEn_R(timser, dim = 3, r = 0.1*sd(timser))
#'

ApEn_R <- function(TS, dim = 2, lag = 1, r = 0.2*sd(TS))
{
  # TS     : time series
  # dim    : embedded dimension
  # lag    : delay time for downsampling of data
  # r      : tolerance (typically 0.2 * std)
  
  # missing downsampling
  
  n <- length(TS)
  result <- rep(NA, 2)
  
  for(x in 1:2){
    m <- dim + x - 1
    dm <- n - m * lag + 1
    phi <- rep(NA,dm)
    mtx.data <- NULL

    for(j in 1:m){
      mtx.data <- rbind(mtx.data, TS[(1 + lag * (j - 1)) : (dm + lag * (j - 1))])
    }

    for(i in 1:dm){
      mtx.temp <- abs(mtx.data - mtx.data[,i])
      mtx.bool <- mtx.temp < r
      mtx.temp <- mtx.bool[1,]
      for(j in 2:m){
        mtx.temp <- mtx.temp + mtx.bool[j,]
      }
      mtx.bool <- mtx.temp == m
      phi[i] <- sum(mtx.bool)/dm 
    }

    result[x] <- sum(log(phi)/dm)
  }

  return(result[1] - result[2])
}

