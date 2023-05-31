
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

for(i in 1:10){
  
  if(i == 1){
    
    r1 <- rnorm(n,mean = 0,sd = runif(1,min = .8,max = 1.3))
    r2 <- rnorm(n,mean = 0,sd = runif(1,min = .8,max = 1.3))
    r3 <- rnorm(n,mean = 0,sd = runif(1,min = .8,max = 1.3))
    r4 <- rnorm(n,mean = 0,sd = runif(1,min = .8,max = 1.3))
    r5 <- rnorm(n,mean = 0,sd = runif(1,min = .8,max = 1.3))
    
    
    x <- cbind(r1,r2,r3,r4,r5)
    data <- cbind(i,t(solve(diag(ncol(b))-b) %*% t(x)))
    data
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

colnames(data) <- c("group","y1","y2","y3","y4","y5") 


model.hogan <- "
y1 ~ y2 + y3 + y4 + y5
y2 ~ y1 + y3 + y4 + y5
y3 ~ y1 + y2 + y4 + y5
y4 ~ y1 + y2 + y3 + y5
y5 ~ y1 + y2 + y3 + y4
"

model.fit.ho <- sem(model = model.hogan,data = data,group = "group",group.equal = c("regressions","loadings"),orthogonal.y = T,orthogonal.x =T)
#summary(model.fit.ho)
out[j,] <- model.fit.ho@ParTable$est[model.fit.ho@ParTable$op == "~"][1:20]

model.f1 <- "F1 =~ y1 + y2 + y3 + y4 + y5"

model.fit.f1 <- sem(model = model.f1,data = data,group = "group",orthogonal.y = T,orthogonal.x =T)


bic.out[j,] <- c(BIC(model.fit.ho),BIC(model.fit.f1))

}

sum(bic.out[,1] > bic.out[,2])/rep


paths <- cbind(out)
vioplot(paths,ylim=c(-.3,0.5))
c <- b # get true network
diag(c) <- NA # omit diag
truth <- na.omit(as.vector(t(c))) # vectorize
points(1:20,truth,pch=19,col=rgb(1,0,0.,.5),cex=2)
