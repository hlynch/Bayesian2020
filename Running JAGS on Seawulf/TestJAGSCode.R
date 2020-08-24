#############################
#
# Step #1: Set the working directory, and the directory where JAGS lives
#
#############################

dir.create("R_libs", showWarnings = FALSE, recursive = TRUE)

#############################
#
# Step #2: Load all the libraries and data
#
#############################

install.packages(c("boot","abind","snowfall","R2WinBUGS"),lib="R_libs", repos = "http://cran.case.edu")

library(rjags)
library(R2jags)
library(abind)
library(boot)
library(snowfall)
library(R2WinBUGS)

Concord<-read.csv("PLOSdataConcord.csv",header=T)

#############################
#
# Step #3: Write the statistical model code to a text file
#
#############################

sink("TestJAGSCode.jags")
model {
  for(i in 1:length(y))
  {
    y[i] ~ dnorm(mu[i], tau)
    mu[i] <- alpha+beta*Year[i]
  }
  alpha ~ dnorm(0.0, 0.000001)
  beta ~ dnorm(0.0, 0.000001)
  tau ~ dgamma(0.001,0.001)
  sigma <- 1 / sqrt(tau)
}
sink()

#############################
#
# Step #4: Make a list where you include all the data the model will need to run
#
#############################

Dat <- list(
  y=Concord$Aquilegia.canadensis,
  Year=Concord$Year
)

#############################
#
# Step #5: Make a function (with no inputs) where you put a list of parameters and their initial values
#
#############################

InitStage <- function() {list(alpha=1,beta=1,tau=100)}

#############################
#
# Step #6: Make a column vector with the names of the parameters you want to track
#
#############################

ParsStage <- c("alpha","beta","sigma")

#############################
#
# Step #7: Set the variables for the MCMC
#
#############################

ni <- 11000  # number of draws from the posterior
nt <- 5    #thinning rate
nb <- 1000  # number to discard for burn-in
nc <- 2  # number of chains

#############################
#
# Step #8: Run the jags function to run the code
#
#############################

m = jags(inits=InitStage,
         n.chains=nc,
         model.file="TestJAGSCode.jags",
         working.directory=getwd(),
         data=Dat,
         parameters.to.save=ParsStage,
         n.thin=nt,
         n.iter=ni,
         n.burnin=nb,
         DIC=T)

#############################
#
# Step #9: Save model results
#
#############################

save(m,file="TestJAGSCode_output.Rdata")

options(scipen=5)
sink("TestJAGSCode_output.txt")
m$JAGSoutput$summary
sink()