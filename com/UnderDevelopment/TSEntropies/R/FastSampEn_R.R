#' FastSampEn_R
#'
#' This function computes fast sample entropy of given time series. It is implemented in R.
#' @param TS - given time series
#' @param dim - dimension of given time series, default value is 2
#' @param lag - downsampling, default value is 1
#' @param r - radius of searched areas, default value is 0.15*sd(TS)
#' @keywords fast sample entropy FastSampEn R
#' @export
#' @examples
#' timser <- rnorm(2000)
#' FastSampEn_R(timser)
#' FastSampEn_R(timser, r = 0.1*sd(timser))
#' FastSampEn_R(timser, dim = 3, r = 0.1*sd(timser))
#'

FastSampEn_R <- function(TS, dim = 2, lag = 1, r = 0.15*sd(TS))
{
  # TS     : time series
  # dim    : embedded dimension
  # lag    : delay time for downsampling of data
  # r      : tolerance (typically 0.2 * std)

  # missing downsampling

  N <- length(TS)
  Phi <- rep(0, 2)

  for(i in 1:2) {
    m <- dim + i - 1
    dm <- N - m * lag + 1
    ji <- rep(0,dm)
    mtx.data <- NULL
    Ncl <- 0

    for(j in 1:m) {
      mtx.data <- rbind(mtx.data, TS[(1 + lag * (j - 1)) : (dm + lag * (j - 1))])
    }

    while (length(mtx.data) > 0) {
      Ncl <- Ncl + 1
      mtx.temp <- abs(mtx.data - mtx.data[,1])
      mtx.bool <- mtx.temp <= r
      mtx.temp <- mtx.bool[1,]
      for(j in 2:m) {
        mtx.temp <- mtx.temp + mtx.bool[j,]
      }

      mtx.bool <- mtx.temp == m
      ji[Ncl] <- (sum(mtx.bool) - 1)
      mtx.data <- as.matrix(mtx.data[,!mtx.bool])
    }

    Phi[i] <- sum(ji)
  }

  if (Phi[2] != 0) return(log(Phi[1]/Phi[2]))
  else return(NA)
}

