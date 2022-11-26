
require(lsa)

#Takes a decimal number and converts it to base b.
dec.2.base_b <- function(x, b = 2) 
{
  xi <- as.integer(x)
  if (any(is.na(xi) | ((x - xi) != 0))) 
    print(list(ERROR = "x not integer", x = x))
  N <- length(x)
  xMax <- max(x)
  ndigits <- (floor(logb(xMax, base = 2)) + 1)
  Base.b <- array(NA, dim = c(N, ndigits))
  for (i in 1:ndigits) {
    Base.b[, ndigits - i + 1] <- (x%%b)
    x <- (x%/%b)
  }
  if (N == 1) 
    Base.b[1, ]
  else Base.b
}

#Calculates ESC measures for vectors
complexity.discrete <- function( pmfSample = rnorm(100000, mean = 0, sd = 1), 
                                 no_states = NA )
{
  #This function calculates Discrete Complexity Measures for discrete samples.
  #First, we get the number of observations contained in the sample.
  pmf.Len  <-ifelse(test = is.matrix(pmfSample)|is.data.frame(pmfSample), 
                    yes = dim(pmfSample)[1], 
                    no = length(pmfSample))
  
  if(length(unique(pmfSample))==1)
  {
    resFit  <- data.frame(E = 0, 
                          S = 1, 
                          C = 0,
                          Entrop = 0)
    return(resFit)
  }
  
  #If the number of states of the PMF
  #is known beforehand
  if(!is.na(no_states))
  {
    #Calculate the marginal states probability
    if(is.matrix(pmfSample)|is.data.frame(pmfSample))
    {
      ncol        <- dim(pmfSample)[2]
      margSttProb <- sapply(1:ncol, function(i) table(cut(pmfSample[,i], breaks = no_states))/pmf.Len)
      # rownames(margSttProb) <- as.character(1:30)
    }else if(is.table(pmfSample)){
      no_states   <- length(pmfSample)
      margSttProb <- pmfSample/sum(pmfSample)
    }
    else
    {
      margSttProb <- table(cut(pmfSample, breaks = no_states))/pmf.Len
      # names(margSttProb) <- as.character(1:30)
    }
  }
  else 
  {
    #Use an heuristic to obtain the PMF
    #Obtain the system's unique states,
    #Get the length of the unique states, and,
    #Calculate states marginal probability
    if(is.matrix(pmfSample)|is.data.frame(pmfSample))
    {
      ncol        <- dim(pmfSample)[2]
      no_states   <- sapply(1:ncol, function(i) length(unique(pmfSample[,i])))
      margSttProb <- sapply(1:ncol, function(i) table(cut(pmfSample[,i], breaks = no_states[i]))/pmf.Len)
    }else if(is.table(pmfSample))
    {
      no_states   <- length(pmfSample)
      margSttProb <- pmfSample/sum(pmfSample)
    }
    else
    {
      if(is.numeric(pmfSample))
      {
        no_states   <- length(unique(pmfSample))
        margSttProb <- table(cut(pmfSample, breaks = no_states))/pmf.Len
      }else
      {
        no_states   <- length(unique(pmfSample))
        margSttProb <- table(pmfSample)/length(pmfSample)
      }
      
    }
  }
  
  #Then, calculate entropy for all elements 
  #of the PMF with p(x)>0
  if(is.matrix(pmfSample)|is.data.frame(pmfSample))
  {
    idxes   <- sapply(1:length(margSttProb), function(i) which(margSttProb[[i]]> 0))
    entrop  <- sapply(1:length(idxes), function(i) Entropy(margSttProb[[i]], idxes[[i]]))
    
  }else{
    idxes   <- which(margSttProb > 0)
    entrop  <- Entropy(margSttProb, idxes)
  }
  
  #Calculate ESC measures
  #Define the normalizing constant k
  kConst            <- 1/log2(no_states)
  emergence         <- kConst*entrop
  selfOrganization  <- 1 - emergence
  complexity        <- 4 * emergence * selfOrganization
  
  resFit  <- data.frame(E = emergence, 
                        S = selfOrganization, 
                        C = complexity,
                        Entrop = entrop)
  
  if(is.matrix(pmfSample)|is.data.frame(pmfSample))
  {
    rownames(resFit) <- colnames(pmfSample)
  }
  
  return(resFit)
}

Entropy <- function(margSttProb = 1, nonNAidxes = NA)
{
  h <- ifelse(test = any(is.na(nonNAidxes)),
              yes = -1*sum(margSttProb[nonNAidxes]*log2(margSttProb[nonNAidxes])),
              no = -1*sum(margSttProb[nonNAidxes]*log2(margSttProb[nonNAidxes]))
  )
  
  return(h)
}

hamming.distance <- function(vec_x = 1:100, vec_y = 100:1)
{
  if(length(vec_x) != length(vec_y))
  {
    stop(paste("Vectors must be the same length", 'the first vector is of length', length(vec_x),
               'the second vector is of length', length(vec_y)))
  }
  d <- sum(vec_x != vec_y)
  return(d)
}

normalized.hamming.distance <- function(vec_x = 1:100, vec_y = 100:1)
{
  d <- hamming.distance(vec_x, vec_y)
  n_d <- d/length(vec_x)
  return(n_d)
}

manhattan.distance <- function(vec_x = runif(100, min=0, max=1), 
                               vec_y = runif(100, min=0, max=1))
{
  dist <- abs(vec_x-vec_y)
  dist <- sum(dist)
  return(dist)
}

homeostasis.vector <- function(vec_x = 1:100, vec_y = 100:1)
{
  H <- 1-normalized.hamming.distance(vec_x,vec_y)
  return(H)
}

homeostasis.vector.continuous <- function(vec_x = 1:100, vec_y = 100:1)
{
  norm_x <- vec_x/norm(vec_x,type='1')
  norm_y <- vec_y/norm(vec_y,type='1')
  
  norm_sum <- norm(norm_x,type='1')+norm(norm_y,type='1')
  if(norm_sum != 0)
  {
    H <- 1-manhattan.distance(norm_x,norm_y)/norm_sum
  }else{
    H <- 1
  }
  
  return(H)
}

homeostasis.dataframe <- function(tmp_df = data.frame(replicate(5,sample(0:1,10,
                                                                       rep=TRUE)))
                                )
{
  time.steps <- (dim(tmp_df)[1]-1)
  H   <- 0
  h   <- 1:time.steps
  res <- list()
  
  for(i in 1:(time.steps))
  {
    h[i] <- (1-normalized.hamming.distance(tmp_df[i,],tmp_df[i+1,]))
    H <- H + h[i]
  }
  
  H <- H/time.steps
  res[['H_average']] <- H
  res[['homestasis']]<- h
  return(res)
}

homeostasis.dataframe.multScale <- function(tmp_df = data.frame(replicate(5,
                                                                sample(0:1,10,
                                                                rep=TRUE))),
                                            b_bits =1,
                                            start_base=2,
                                            target_base = 2)
{
    init.ixes <- seq(from=1,
                   to=(dim(tmp_df)[1]-b_bits),
                   by=b_bits)
  
  end.ixes  <- seq(from=1+b_bits,
                  to=dim(tmp_df)[1],
                  by=b_bits)
  
  time.steps <- (length(end.ixes)-1)
  H   <- 0
  h   <- 1:time.steps
  res <- list()
  
  for(i in 1:time.steps)
  {
    tmp_x <- tmp_df[init.ixes[i]:(init.ixes[i+1]-1),]
    tmp_xp<- tmp_df[end.ixes[i]:(end.ixes[i+1]-1),]
    
    t_tmp_x <- t(tmp_x)
    t_tmp_xp<- t(tmp_xp)
    
    tmp_x_b <- sapply(1:dim(t_tmp_x)[1], 
                      function(i) paste(t_tmp_x[i,1:b_bits],collapse=''))
    tmp_xp_b<- sapply(1:dim(t_tmp_xp)[1], 
                      function(i) paste(t_tmp_xp[i,1:b_bits],collapse=''))
    
    tmp_x_b_new <- baseConvert(tmp_x_b,
                               starting_base = start_base, 
                               target = target_base)
    
    tmp_xp_b_new<- baseConvert(tmp_xp_b,
                               starting_base = start_base, 
                               target = target_base)
    
    h[i] <- homeostasis.vector(tmp_x_b_new,tmp_xp_b_new)
    H <- H + h[i]
  }
  
  H <- H/time.steps
  res[['H_average']] <- H
  res[['homestasis']]<- h
  return(res)
  # 
  # tmp_x <- tmp_df[init.ixes[1]:(init.ixes[1+1]-1),]
  # tmp_xp<- tmp_df[end.ixes[1]:(end.ixes[1+1]-1),]
  # 
  # t_tmp_x <- t(tmp_x)
  # t_tmp_xp<- t(tmp_xp)
  # 
  # tmp_x_b <- sapply(1:dim(t_tmp_x)[1], 
  #        function(i) paste(t_tmp_x[i,1:b_bits],collapse=''))
  # tmp_xp_b<- sapply(1:dim(t_tmp_xp)[1], 
  #        function(i) paste(t_tmp_xp[i,1:b_bits],collapse=''))
  # 
  # tmp_x_b_new <- baseConvert(tmp_x_b,
  #                            starting_base = 2, 
  #                            target = target_base)
  # 
  # tmp_xp_b_new<- baseConvert(tmp_xp_b,
  #                            starting_base = 2, 
  #                            target = target_base)
  # 
  # homeostasis.vector(tmp_x_b_new,tmp_xp_b_new)
  # 
  # H <- 0
  # 
  # for(i in 1:(time.steps-b_bits))
  # {
  #   H <- H + (1-normalized.hamming.distance(tmp_df[i,],tmp_df[i+1,]))
  # }
  # 
  # H <- H/time.steps
  return(res)
}

homeostasis.dataframe.autoregressive <- function(tmp_df = data.frame(replicate(5,
                                                                          sample(0:1,10,
                                                                                 rep=TRUE))),
                                            b_order =2)
{
  init.ixes <- seq(from=1,
                   to=(dim(tmp_df)[1]-b_order),
                   by=b_order)
  
  end.ixes  <- seq(from=1+b_order,
                   to=dim(tmp_df)[1],
                   by=b_order)
  
  time.steps <- (length(end.ixes)-1)
  H   <- 0
  h   <- 1:time.steps
  res <- list()
  
  for(i in 1:time.steps)
  {
    tmp_x <- tmp_df[init.ixes[i]:(init.ixes[i+1]-1),]
    tmp_xp<- tmp_df[end.ixes[i]:(end.ixes[i+1]-1),]
    
    t_tmp_x <- t(tmp_x)
    t_tmp_xp<- t(tmp_xp)
    
    tmp_x_b <- sapply(1:dim(t_tmp_x)[1], 
                      function(i) paste(t_tmp_x[i,1:b_order],collapse=''))
    tmp_xp_b<- sapply(1:dim(t_tmp_xp)[1], 
                      function(i) paste(t_tmp_xp[i,1:b_order],collapse=''))
    
    h[i] <- homeostasis.vector(tmp_x_b,tmp_xp_b)
    H <- H + h[i]
  }
  
  H                   <- H/time.steps
  res[['H_average']]  <- H
  res[['homestasis']] <- h
  return(res)
}

baseConvert <- function(x, starting_base=10, target=2) 
{
  olddim <- dim(x)
  # Value -> Digit
  characters <- c(seq(0,9), LETTERS)
  # Digit -> Value
  numbers <- structure(seq(0,35), names=characters)
  if (is.numeric(x)) 
  {
    x <- abs(x)
  }else if (is.character(x)) 
  {
    x <- toupper(x)
  }
  if (starting_base > 10 && !is.character(x)) 
  {
    stop("Parameter x must be of mode character for bases greater than 10.")
  }
  if (starting_base < 2 || starting_base > 36) 
  {
    stop("Base of x must be [2,36]")
  }
  if (target < 2 || target > 36) 
  {
    stop("Target base for x must be [2,36]")
  }
  if (starting_base != 10) 
  {
    x <- strsplit(as.character(x), "")
    if (any(!unlist(x) %in% characters[seq(starting_base)]))
      stop("Invalid number for starting_base.")
  }
  
  # Convert to base 10
  if (starting_base != 10) {
    l <- lapply(x, length)
    f1 <- function(x, l) {
      sum(numbers[x] * starting_base ^ (seq(l - 1,0)))
    }
    sum <- mapply(f1, x, l)
    names(sum) <- NULL
  } else {
    sum <- x
  }
  
  result <- c()
  # Convert to new base
  if (target != 10) {
    f2 <- function(sum) {
      if (sum > 0) {
        d <- floor(log(sum, target) + 1)
        paste(characters[abs(diff(sum %% target^seq(d,0))) %/% target^seq(d-1,0) + 1], collapse="")
      } else {
        '0'
      }
    }
    result <- mapply(f2, sum)
  } else {
    result <- sum
  }
  
  return(structure(result, dim=olddim))
}


