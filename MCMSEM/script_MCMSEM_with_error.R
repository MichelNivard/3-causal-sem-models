library(MCMSEM)
library(vioplot)
set.seed(123)

rep <- 110
out <- matrix(NA,rep,21)

n <- 100000

b <- matrix(c(   0,  .22,   0,  .24,  .35,  # The network weights (bidirectional regression paths between endogeneous variables y1 to y5)
                 0,   0,   .15,  .31,  .0,
                 .35,  .2,   0, -.14,   .3,
                 .14, -.2,  .36,   0,   .4,
                 0, .30, .15,   -.15,    0), 5,5,byrow=T)

# Latent variables don't load on the indicators, its as if they aren't there:

a <- matrix(c(0, 0, 0, 0, 0,
              0, 0, 0, 0, 0), ncol=2)


for(i in 1:rep){
  
  
  # use the MCMSEM internal simuation tool:
  many  <- sample(1:4,1,replace = F)
  which <- sample(1:5,many,replace = F)
  
  shape <- round(runif(5,4,12))
  shape[which] <- 0
  
  df <- round(runif(5,6,12))
  df[-which] <- 0
  
  simmdata<- simulate_data(n=n,a=a,b=t(b),shape=shape, df=df,asdataframe = T)
  
  simmdata[,1] <- simmdata[,1] + rnorm(n,0,sqrt(.5)) # add normal error with var ~ .5 
  simmdata[,2] <- simmdata[,2] + rnorm(n,0,sqrt(.4)) 
  simmdata[,3] <- simmdata[,3] + rnorm(n,0,sqrt(.3)) 
  simmdata[,4] <- simmdata[,4] + rnorm(n,0,sqrt(.4)) 
  simmdata[,5] <- simmdata[,5] + rnorm(n,0,sqrt(.5)) 
  
  errornet <- MCMmodel(simmdata,n_latent = 5,constrained_a = F,scale_data = F,causal_observed = F,causal_latent = T,skew_latent = T,skew_observed = F,kurt_latent = T,kurt_observed = F,var_latent = F)
  
  # Free the variance on 5 latent variables (on for each observed):
  errornet <- MCMedit(errornet, pointer="S", list(1:5,1:5), c("sl1","sl2","sl3","sl4","sl5"))
  errornet <- MCMedit(errornet, pointer="S", list(6:10,6:10), c("s1","s2","s3","s4","s5"))
  
  # All cross loading to 0:
  errornet <- MCMedit(errornet, pointer="A", c("a1_2","a1_3","a1_4","a1_5"), 0)
  errornet <- MCMedit(errornet, pointer="A", c("a2_3","a2_4","a2_5"), 0)
  errornet <- MCMedit(errornet, pointer="A", c("a3_4","a3_5"), 0)
  errornet <- MCMedit(errornet, pointer="A", c("a4_5"), 0)
  
  
  # Except for "diagonal" loadings which are 1, so each latent m,asp to a specific observed variable:
  errornet <- MCMedit(errornet, pointer="A", list(6:10,1:5),c(1,1,1,1,1))
  
  
  model.fit.errornet <- MCMfit(errornet,simmdata,compute_se = F,debug = F,monitor_grads=T,use_kurtosis = T,optim_iters = c(800,50),optimizers = c('rprop','lbfgs'),learning_rate = c(.1,.35),loss_type = "mse")
  out[i,]<- c(as.numeric(model.fit.errornet$df[1,1:20]),max(abs(as.numeric(as.data.frame(summary(model.fit.errornet))$last_gradient))))
  print(i)
}

paths <- out
vioplot(paths[,1:20],ylim=c(-.3,0.5))
c <- b # get true network
diag(c) <- NA # omit diag
truth <- na.omit(as.vector(t(c))) # vectorize
points(1:20,truth,pch=19,col=rgb(1,0,0.,.5),cex=2)
