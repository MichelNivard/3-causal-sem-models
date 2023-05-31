
library(lavaan)
library(dplyr)
library(vioplot)
library(semPlot)


set.seed(123)

rep <- 100
out <- matrix(NA,rep,20)
bic.out <- matrix(NA,rep,2)
for(j in 1:rep){
  
  b <- matrix(c(   0,  .22,   0,  .24,  .35, 
                   0,   0,   .15,  .31,  .0,
                   .35,  .2,   0, -.14,   .3,
                   .14, -.2,  .36,   0,   .4,
                   0, .30, .15,   -.15,    0), 5,5,byrow=T)
  
  
  n = 500
  groups = 20
  
  for(i in 1:groups){
    
    if(i == 1){
     
      
      r1 <- rnorm(n,mean = 0,sd = runif(1,min = .8,max = 1.3))
      r2 <- rnorm(n,mean = 0,sd = runif(1,min = .8,max = 1.3))
      r3 <- rnorm(n,mean = 0,sd = runif(1,min = .8,max = 1.3))
      r4 <- rnorm(n,mean = 0,sd = runif(1,min = .8,max = 1.3))
      r5 <- rnorm(n,mean = 0,sd = runif(1,min = .8,max = 1.3))
      
      
      x <- cbind(r1,r2,r3,r4,r5)
      data <- cbind(i,t(solve(diag(ncol(b))-b) %*% t(x)))

    }
    if(i != 1){
      

      
      r1 <- rnorm(n,mean = 0,sd = runif(1,min = .8,max = 1.3))
      r2 <- rnorm(n,mean = 0,sd = runif(1,min = .8,max = 1.3))
      r3 <- rnorm(n,mean = 0,sd = runif(1,min = .8,max = 1.3))
      r4 <- rnorm(n,mean = 0,sd = runif(1,min = .8,max = 1.3))
      r5 <- rnorm(n,mean = 0,sd = runif(1,min = .8,max = 1.3))
      
      
      
      x <- cbind(r1,r2,r3,r4,r5)
      temp <- cbind(i,t(solve(diag(ncol(b))-b) %*% t(x)))
      data <- rbind(data,temp)
  
      
    }
    
  }
  
  fc <-  rnorm(n*groups)
  data[,2] <-  data[,2] +  rnorm(n*groups) + fc
  data[,3] <-  data[,3] +  rnorm(n*groups) + fc
  data[,4] <-  data[,4] +  rnorm(n*groups) + fc
  data[,5] <-  data[,5] +  rnorm(n*groups) + fc
  data[,6] <-  data[,6] +  rnorm(n*groups) + fc
  
  colnames(data) <- c("group","y1","y2","y3","y4","y5") 
  
  
  model.hogan <- "
  
  fc =~ y1 + y2 + y3 + y4 + y5
  f1 =~ y1
  f2 =~ y2
  f3 =~ y3
  f4 =~ y4
  f5 =~ y5
  
  fc ~~ f*fc
  
  y1 ~~ a*y1
  y2 ~~ b*y2
  y3 ~~ c*y3
  y4 ~~ d*y4
  y5 ~~ e*y5

  
f1 ~ f2 + f3 + f4 + f5
f2 ~ f1 + f3 + f4 + f5
f3 ~ f1 + f2 + f4 + f5
f4 ~ f1 + f2 + f3 + f5
f5 ~ f1 + f2 + f3 + f4
"
  
  model.fit.ho <- sem(model = model.hogan,data = data,group = "group",group.equal = c("regressions","loadings"),orthogonal.y = T,orthogonal.x =T)
  #summary(model.fit.ho)
  out[j,] <- model.fit.ho@ParTable$est[model.fit.ho@ParTable$op == "~"][1:20]
  
  model.f1 <- "F1 =~ y1 + y2 + y3 + y4 + y5"
  
  model.fit.f1 <- sem(model = model.f1,data = data,group = "group",orthogonal.y = T,orthogonal.x =T)
  
  
  bic.out[j,] <- c(BIC(model.fit.ho),BIC(model.fit.f1))
  print(j)
}

sum(bic.out[,1] > bic.out[,2])/rep


paths <- cbind(out)
vioplot(paths,ylim=c(-.3,0.5))
c <- b # get true network
diag(c) <- NA # omit diag
truth <- na.omit(as.vector(t(c))) # vectorize
points(1:20,truth,pch=19,col=rgb(1,0,0.,.5),cex=2)
