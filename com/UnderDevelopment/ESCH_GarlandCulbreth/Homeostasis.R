
require(lsa)

cosine.similarity <- function(vec_x = c(-1,0), vec_y = c(1,0)) 
{
  if(is.vector(vec_x)==F)
    tmp.vec_x <- as.vector(vec_x)
  else
    tmp.vec_x <- vec_x
  
  if(is.vector(vec_y)==F)
    tmp.vec_y <- as.vector(vec_y)
  else
    tmp.vec_y <- vec_y
  
  return(lsa::cosine(tmp.vec_x,tmp.vec_y))
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

homeostasis.vector.binary <- function(vec_x = 1:100, vec_y = 100:1)
{
  H <- 1-normalized.hamming.distance(vec_x,vec_y)
  return(H)
}

homeostasis.vector.continuous <- function(vec_x = 1:100, vec_y = 100:1)
{
  #By definition, if any of the vectors has a norm = 0, then h <- 0
  if((norm(vec_x,type='f')==0)||(norm(vec_y,type='f')==0))
  {
    return(0)
  }
  
  if(is.matrix(vec_x)!=T || dim(vec_x)[1]>1)
  {
    vec_x <- matrix(vec_x,nrow=1)
  }
  if(is.matrix(vec_y)!=T|| dim(vec_y)[1]>1)
  {
    vec_y <- matrix(vec_y,nrow=1)
  }
  
  H <- cosine.similarity(vec_x,vec_y)
  
  return(H)
}

homeostasis.dataframe.continuous <- function(tmp_df = data.frame(replicate(5,
                                                                sample(0:1,10,
                                                                rep=TRUE))),
                                             b_order = 1)
{
  init.ixes <- seq(from=1,
                   to=(dim(tmp_df)[1]-b_order),
                   by=b_order)
  
  end.ixes  <- seq(from=1+b_order,
                   to=dim(tmp_df)[1],
                   by=b_order)
  
  # time.steps <- (dim(tmp_df)[1]-1)
  time.steps <- (length(end.ixes)-1)
  H   <- 0
  h   <- 1:time.steps
  res <- list()
  
  for(i in 1:(time.steps))
  {
    if(b_order==1)
    {
      tmp_vec_x <- as.matrix(tmp_df[i,],ncol=1)
      tmp_vec_y <- as.matrix(tmp_df[i+1,],ncol=1)
      h[i] <- homeostasis.vector.continuous(tmp_vec_x,tmp_vec_y)
      H <- H + h[i]
    }else{
      tmp_x <- tmp_df[init.ixes[i]:(init.ixes[i+1]-1),]
      tmp_xp<- tmp_df[end.ixes[i]:(end.ixes[i+1]-1),]
      
      t_tmp_x <- colMeans(tmp_x)
      t_tmp_xp<- colMeans(tmp_xp)
      
      tmp_vec_x <- as.matrix(t_tmp_x,ncol=1)
      tmp_vec_y <- as.matrix(t_tmp_xp,ncol=1)
      h[i] <- homeostasis.vector.continuous(tmp_vec_x,tmp_vec_y)
      H <- H + h[i]
    }
  }
  
  H <- H/time.steps
  res[['H_average']] <- H
  res[['homestasis']]<- h
  return(res)
}

homeostasis.dataframe.binary <- function(tmp_df = data.frame(replicate(5,
                                                                       sample(0:1,10,
                                                                              rep=TRUE))),
                                         b_order =1)
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
    
    h[i] <- homeostasis.vector.binary(tmp_x_b,tmp_xp_b)
    H <- H + h[i]
  }
  
  H                   <- H/time.steps
  res[['H_average']]  <- H
  res[['homestasis']] <- h
  return(res)
}




