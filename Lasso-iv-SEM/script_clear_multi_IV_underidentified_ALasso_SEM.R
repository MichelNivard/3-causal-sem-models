library(lessSEM)
library(lavaan)
library(dplyr)
library(vioplot)
library(semPlot)


set.seed(666)


n <- 5000
rep <- 100

out <- matrix(NA,rep,105)
bic.out <- matrix(NA,rep,2)
for(i in 1:rep){
  # a network model
  
  b <- matrix(c(   0,  .22,   0,  .24,  .35, 
                   0,   0,   .15,  .31,  .0,
                   .35,  .2,   0, -.14,   .3,
                   .14, -.2,  .36,   0,   .4,
                   0, .30, .15,   -.15,    0), 5,5,byrow=T)
  
  
  # Simulate the residual variables.
  
  
  x <- matrix(rnorm(n*15),n,15)
  
  
  
  y1 <- runif(1,.1,.2)*x[,1] + runif(1,.1,.2)*x[,2] + runif(1,.1,.2)*x[,3] + runif(1,.1,.2)*x[,5] + runif(1,.1,.2)*x[,10] + runif(1,.1,.2)*x[,15] +  runif(1,.1,.2)*x[8] + runif(1,.1,.2)*x[,11] + runif(1,.1,.2)*x[,14] +rnorm(n) 
  y2 <- runif(1,.1,.2)*x[,4] + runif(1,.1,.2)*x[,5] + runif(1,.1,.2)*x[,6] + runif(1,.1,.2)*x[,3] + runif(1,.1,.2)*x[,9]  + runif(1,.1,.2)*x[,12] +  runif(1,.1,.2)*x[,14] + runif(1,.1,.2)*x[,5] + runif(1,.1,.2)*x[,11] +rnorm(n)
  y3 <- runif(1,.1,.2)*x[,7] + runif(1,.1,.2)*x[,8] + runif(1,.1,.2)*x[,9] + runif(1,.1,.2)*x[,4] + runif(1,.1,.2)*x[,6]  + runif(1,.1,.2)*x[,13] +   runif(1,.1,.2)*x[,2] + runif(1,.1,.2)*x[,2] + runif(1,.1,.2)*x[,14] +rnorm(n) 
  y4 <- runif(1,.1,.2)*x[,10] + runif(1,.1,.2)*x[,11] + runif(1,.1,.2)*x[,12] + runif(1,.1,.2)*x[,2] + runif(1,.1,.2)*x[,7]  + runif(1,.1,.2)*x[,14] + runif(1,.1,.2)*x[,5] + runif(1,.1,.2)*x[,8] + runif(1,.1,.2)*x[,11]  +rnorm(n)
  y5 <- runif(1,.1,.2)*x[,13] + runif(1,.1,.2)*x[,14] + runif(1,.1,.2)*x[,15] + runif(1,.1,.2)*x[,1] + runif(1,.1,.2)*x[,8] + runif(1,.1,.2)*x[,11] + runif(1,.1,.2)*x[,5] + runif(1,.1,.2)*x[,11] + runif(1,.1,.2)*x[,2] + rnorm(n) 
  
  
  ye <- cbind(y1,y2,y3,y4,y5)
  
  y <- t(solve(diag(ncol(b)) - b) %*% t(ye))
  
  colnames(x) <- c("x1","x2","x3","x4","x5","x6","x7","x8","x9","x10","x11","x12","x13","x14","x15")
  colnames(y) <- c("y1","y2","y3","y4","y5")
  data <- cbind(y,x)
  
  
  lavaanSyntax <- "
      y1 ~ b12*y2 + b13*y3 + b14*y4 + b15*y5 + a11*x1  + a12*x2 + a13*x3 + a14*x4 + a15*x5 + a16*x6 + a17*x7 + a18*x8  + a19*x9 + a110*x10 + a111*x11 + a112*x12 + a113*x13 + a114*x14 + a115*x15
      y2 ~ b21*y1 + b23*y3 + b24*y4 + b25*y5 + a21*x1  + a22*x2 + a23*x3 + a24*x4 + a25*x5 + a26*x6 + a27*x7 + a28*x8  + a29*x9 + a210*x10 + a211*x11 + a212*x12 + a213*x13 + a214*x14 + a215*x15
      y3 ~ b31*y1 + b32*y2 + b34*y4 + b35*y5 + a31*x1  + a32*x2 + a33*x3 + a34*x4 + a35*x5 + a36*x6 + a37*x7 + a38*x8  + a39*x9 + a310*x10 + a311*x11 + a312*x12 + a313*x13 + a314*x14 + a315*x15
      y4 ~ b41*y1 + b42*y2 + b43*y3 + b45*y5 + a41*x1  + a42*x2 + a43*x3 + a44*x4 + a45*x5 + a46*x6 + a47*x7 + a48*x8  + a49*x9 + a410*x10 + a411*x11 + a412*x12 + a413*x13 + a414*x14 + a415*x15
      y5 ~ b51*y1 + b52*y2 + b53*y3 + b54*y4 + a51*x1  + a52*x2 + a53*x3 + a54*x4 + a55*x5 + a56*x6 + a57*x7 + a58*x8  + a59*x9 + a510*x10 + a511*x11 + a512*x12 + a513*x13 + a514*x14 + a515*x15
      "
  lavaanModel <- lavaan::sem(lavaanSyntax,
                             data = data,
                             meanstructure = TRUE)
  
  # Optional: Plot the model
  # if(!require("semPlot")) install.packages("semPlot")
  # semPlot::semPaths(lavaanModel, 
  #                   what = "est",
  #                   fade = FALSE)
  
  lsem <- adaptiveLasso(
    # pass the fitted lavaan model
    lavaanModel = lavaanModel,
    # names of the regularized parameters:
    regularized = c( "a11", "a12", "a13", "a14", "a15","a16", "a17","a18","a19","a110","a111","a112","a113","a114","a115",
                     "a21", "a22", "a23", "a24", "a25","a26", "a27","a28","a29","a210","a211","a212","a213","a214","a215",
                     "a31", "a32", "a33", "a34", "a35","a36", "a37","a38","a39","a310","a311","a312","a313","a314","a315",
                     "a41", "a42", "a43", "a44", "a45","a46", "a47","a48","a49","a410","a411","a412","a413","a414","a415",
                     "a51", "a52", "a53", "a54", "a55","a56", "a57","a58","a59","a510","a511","a512","a513","a514","a515"
                     ), #"b12","b13","b14","b15","b21","b23","b24","b25","b31","b32","b34","b35","b41","b42","b43","b45","b51","b52","b53","b54"), #
    # in case of lasso and adaptive lasso, we can specify the number of lambda
    # values to use. lessSEM will automatically find lambda_max and fit
    # models for nLambda values between 0 and lambda_max. For the other
    # penalty functions, lambdas must be specified explicitly
    lambdas = seq(1/n,100/n,1/n) )
  
  #### Factor model:
  
  lavaanSyntaxF <- "
      f1 =~ y1 + y2 + y3 + y4 + y5
      y1 ~ a11*x1  + a12*x2 + a13*x3 + a14*x4 + a15*x5 + a16*x6 + a17*x7 + a18*x8  + a19*x9 + a110*x10 + a111*x11 + a112*x12 + a113*x13 + a114*x14 + a115*x15
      y2 ~ a21*x1  + a22*x2 + a23*x3 + a24*x4 + a25*x5 + a26*x6 + a27*x7 + a28*x8  + a29*x9 + a210*x10 + a211*x11 + a212*x12 + a213*x13 + a214*x14 + a215*x15
      y3 ~ a31*x1  + a32*x2 + a33*x3 + a34*x4 + a35*x5 + a36*x6 + a37*x7 + a38*x8  + a39*x9 + a310*x10 + a311*x11 + a312*x12 + a313*x13 + a314*x14 + a315*x15
      y4 ~ a41*x1  + a42*x2 + a43*x3 + a44*x4 + a45*x5 + a46*x6 + a47*x7 + a48*x8  + a49*x9 + a410*x10 + a411*x11 + a412*x12 + a413*x13 + a414*x14 + a415*x15
      y5 ~ a51*x1  + a52*x2 + a53*x3 + a54*x4 + a55*x5 + a56*x6 + a57*x7 + a58*x8  + a59*x9 + a510*x10 + a511*x11 + a512*x12 + a513*x13 + a514*x14 + a515*x15
      f1 ~ al1*x1  + al2*x2 + al3*x3 + al4*x4 + al5*x5 + al6*x6 + al7*x7 + al8*x8  + al9*x9 + al10*x10 + al11*x11 + al12*x12 + al13*x13 + al14*x14 + al15*x15

"
  lavaanModelF <- lavaan::sem(lavaanSyntaxF,
                              data = data,
                              meanstructure = TRUE)
  
  # Optional: Plot the model
  # if(!require("semPlot")) install.packages("semPlot")
  # semPlot::semPaths(lavaanModel, 
  #                   what = "est",
  #                   fade = FALSE)
  
  lsemF <- adaptiveLasso(
    # pass the fitted lavaan model
    lavaanModel = lavaanModelF,
    #  # names of the regularized parameters:
    regularized = c( "a11", "a12", "a13", "a14", "a15","a16", "a17","a18","a19","a110","a111","a112","a113","a114","a115",
                     "a21", "a22", "a23", "a24", "a25","a26", "a27","a28","a29","a210","a211","a212","a213","a214","a215",
                     "a31", "a32", "a33", "a34", "a35","a36", "a37","a38","a39","a310","a311","a312","a313","a314","a315",
                     "a41", "a42", "a43", "a44", "a45","a46", "a47","a48","a49","a410","a411","a412","a413","a414","a415",
                     "a51", "a52", "a53", "a54", "a55","a56", "a57","a58","a59","a510","a511","a512","a513","a514","a515"),
    # in case of lasso and adaptive lasso, we can specify the number of lambda
    # values to use. lessSEM will automatically find lambda_max and fit
    # models for nLambda values between 0 and lambda_max. For the other
    # penalty functions, lambdas must be specified explicitly
    lambdas = seq(1/n,100/n,1/n))
  
  
  
  
  bic.out[i,] <- c(min(BIC(lsem)$BIC),min(BIC(lsemF)$BIC))
  
  # The best parameters can be extracted with:
  output <- coef(lsem, criterion = "BIC")@estimates
  out[i,] <- output 
}

colnames(out) <- colnames(output )






paths <- select(as.data.frame(out),contains('b'))


vioplot(paths,ylim=c(min(b),max(b)))
c <- b # get true network
diag(c) <- NA # omit diag
truth <- na.omit(as.vector(t(c))) # vectorize
points(1:20,truth,pch=19,col=rgb(1,0,0.,.5),cex=2)






# The best parameters can be extracted with:
coef(lsem, criterion = "AIC")
coef(lsem, criterion = "BIC")

sum(bic.out[,1] > bic.out[,2])/rep

lavaanModel <- lessSEM2Lavaan(regularizedSEM = lsem, 
                              criterion = "BIC")

semPaths(lavaanModel,
         what = "std",
         curve=T,
         fade=F,
         exoCov = F,
         exoVar = F,
         residuals = T,
         minimum = 0.05,
         layout=c("spring"),
         intercept=F)



lavaanModelF <- lessSEM2Lavaan(regularizedSEM = lsemF, 
                               criterion = "BIC")

semPaths(lavaanModelF,
         what = "std",
         curve=T,
         fade=F,
         exoCov = F,
         exoVar = F,
         residuals = T,
         minimum = 0.05,
         layout=c("tree"),
         intercept=F)

