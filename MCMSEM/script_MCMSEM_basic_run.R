library(MCMSEM)
library(vioplot)
set.seed(123)

rep <- 100
out <- matrix(NA,rep,20)
out.bic <- matrix(NA,rep,2)  

n <- 30000

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



mod.network <- MCMmodel(simmdata, n_latent=0,
                        causal_observed = T,scale_data = F ,constrained_a = FALSE)

mod.f1 <- MCMmodel(simmdata, n_latent=1,
                        causal_observed = F,scale_data = F,skew_observed = T,kurt_observed = T,skew_latent = T,kurt_latent = T,var_observed = T ,constrained_a = FALSE)

res.network <- MCMfit(mod.network , simmdata,
                      optimizers=c("rprop", "lbfgs"), optim_iters=c(500,50),
                      learning_rate=c(0.15,.75), monitor_grads = F,debug = F)

res.f1 <- MCMfit(mod.f1 , simmdata,
                      optimizers=c("rprop", "lbfgs"), optim_iters=c(500,50),
                      learning_rate=c(0.15,.75), monitor_grads = F,debug = F)


out[i,]<- as.numeric(res.network$df[1,1:20])
out.bic[i,] <- c(summary(res.network)$bic,summary(res.f1)$bic)
}

paths <- out
vioplot(paths[out.bic[,1] < 2000,],ylim=c(-.3,0.5))
c <- b # get true network
diag(c) <- NA # omit diag
truth <- na.omit(as.vector(t(c))) # vectorize
points(1:20,truth,pch=19,col=rgb(1,0,0.,.5),cex=2)
