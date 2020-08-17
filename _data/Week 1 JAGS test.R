#############################
#
# Step #1: Set the working directory, and the directory where JAGS lives
#
#############################

jags.directory="/usr/local/bin"
setwd("~/Dropbox/BayesianFiles/Week 1 Introduction/Lab")

#############################
#
# Step #2: Load all the libraries and data
#
#############################

library(R2jags)
library(abind)
library(boot)

#simulate data
sim.data<-rnorm(1000,mean=3.3,sd=2)

#############################
#
# Step #3: Write the statistical model code to a text file
#
#############################

sink("Week1_TestModel.jags")

cat("
model {
  for (i in 1:length(y)) {
		y[i] ~ dnorm(mu, tau)
	}
	mu ~ dnorm(0, .0001)
	tau <- pow(sigma, -2)
	sigma ~ dunif(0, 100)
}",fill = TRUE)

sink()

#############################
#
# Step #4: Make a list where you include all the data the model will need to run
#
#############################


Dat <- list(
  y=sim.data
)

#############################
#
# Step #5: Make a function (with no inputs) where you put a list of parameters and their initial values
#
#############################

InitStage <- function() {list(mu=1,sigma=1)}

#############################
#
# Step #6: Make a column vector with the names of the parameters you want to track
#
#############################

ParsStage <- c("mu","sigma")

#############################
#
# Step #7: Set the variables for the MCMC
#
#############################

ni <- 1100  # number of draws from the posterior
nt <- 1    #thinning rate
nb <- 100  # number to discard for burn-in
nc <- 2  # number of chains

#############################
#
# Step #8: Run the jags function to run the code
#
#############################

m = jags(inits=InitStage,
         n.chains=nc,
         model.file="Week1_TestModel.jags",
         working.directory=getwd(),
         data=Dat,
         parameters.to.save=ParsStage,
         n.thin=nt,
         n.iter=ni,
         n.burnin=nb,
         DIC=T)

#############################
#
# Step #9: Print the sumamry and explore the object that was returned
#
#############################

m   # prints results

# what is m?

names(m)
names(m$BUGSoutput)

# compare these  - whats going on?

dim(m$BUGSoutput$sims.array)
dim(m$BUGSoutput$sims.matrix)

#############################
#
# Step #10: Plot the results
#
#############################


mu.mean<-m$BUGSoutput$summary[row.names(m$BUGSoutput$summary)=="mu",1]
mu.sd<-m$BUGSoutput$summary[row.names(m$BUGSoutput$summary)=="mu",2]
mu.mean
mu.sd

