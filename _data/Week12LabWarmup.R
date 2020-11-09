#############################
#
# Step #1: Set the working directory, and the directory where JAGS lives
#
#############################

jags.directory="/usr/local/bin"
#setwd("/Volumes/TEACHING/Bayesian stats/Week 13 Mark-recapture and occupancy modeling/Lab/")
setwd("~/Bayes/Week 12 Mark-recapture and occupancy modeling/Lab/")

#############################
#
# Step #2: Load all the libraries and data
#
#############################

library(R2jags)
library(abind)
library(boot)

# Generate data
humidity<-seq(0,100,1)
n.site<-length(humidity)
# Occupancy
alpha.occ <- -3 # Logit-linear intercept for humidity on occurrence
beta.occ <- 0.1 # Logit-linear slope for humidity on occurrence
occ.prob <- exp(alpha.occ + beta.occ * humidity) / (1 + exp(alpha.occ + beta.occ* humidity))


# par(mfrow = c(3,1))
plot(humidity, occ.prob, ylim = c(0,1), main = "True relationship occurrence -
     humidity")
true.presence <- rbinom(n = n.site, size = 1, prob = occ.prob)
true.presence # Look at the true occupancy state of each site
sum(true.presence) # Among the n.sites visited sites

#detection
alpha.p <- 2 # Logit-linear intercept for humidity on detection
beta.p <- -0.1 # Logit-linear slope for humidity on detection
det.prob <- exp(alpha.p + beta.p * humidity) / (1 + exp(alpha.p + beta.p * humidity))
plot(humidity, det.prob, ylim = c(0,1), main = "Observation process: Detection probability")

eff.det.prob <- true.presence * det.prob

R <- n.site
T <- 30
y <- array(dim = c(R, T))
# Simulate results of first through last surveys
for(i in 1:T){
  y[,i] <- rbinom(n = n.site, size = 1, prob = eff.det.prob)
}

y # Look at the detection/nondetection data
sum(apply(y, 1, sum) > 0) # Apparent distribution of the species among 100 visited sites



#############################
#
# Step #3: Write the statistical model code to a text file
#
#############################

sink("Week13Lab_OccupancyModel.jags")

cat("
    model {
    # Priors
    #Set A
    alpha.occ ~ dunif(-10, 10)  #try replacing with dnorm(0, 0.01)
    beta.occ ~ dunif(-10, 10)   #try replacing with dnorm(0, 0.01)
    alpha.p ~ dunif(-10, 10)   #try replacing with dnorm(0, 0.01)
    beta.p ~ dunif(-10, 10)    #try replacing with dnorm(0, 0.01)

    # Likelihood
    for (i in 1:R) {
    # True state model for the only partially observed true state
    z[i] ~ dbern(psi[i]) # True occupancy z at site i
    logit(psi[i]) <- alpha.occ + beta.occ * humidity[i]

    for (j in 1:T) {
    # Observation model for the actual observations
    y[i,j] ~ dbern(eff.p[i,j]) # Detection-nondetection at i and j
    eff.p[i,j] <- z[i] * p[i,j]
    logit(p[i,j]) <- alpha.p + beta.p * humidity[i]
    }
    }
    # Derived quantities
    occ.fs <- sum(z[]) # Number of occupied sites among 100
    }
    ",fill=TRUE)
sink()

#############################
#
# Step #4: Make a list where you include all the data the model will need to run
#
#############################

Dat <- list(
  y = y,
  humidity = humidity,
  R = dim(y)[1],
  T = dim(y)[2]
)
#############################
#
# Step #5: Make a function (with no inputs) where you put a list of parameters and their initial values
#
#############################
zst <- apply(y, 1, max) #Good starting values for the latent state essential !
InitStage <- function() {list(z=zst,alpha.occ=0,beta.occ=0,alpha.p=0,beta.p=0)}

#############################
#
# Step #6: Make a column vector with the names of the parameters you want to track
#
#############################

ParsStage <- c("alpha.occ","beta.occ", "alpha.p", "beta.p", "occ.fs")

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
         model.file="Week13Lab_OccupancyModel.jags",
         working.directory=getwd(),
         data=Dat,
         parameters.to.save=ParsStage,
         n.thin=nt,
         n.iter=ni,
         n.burnin=nb,
         DIC=T)

#############################
#
# Step #9: Print the summary and explore the object that was returned
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


hist(m$BUGSoutput$sims.matrix[,colnames(m$BUGSoutput$sims.matrix)=="alpha.occ"])
hist(m$BUGSoutput$sims.matrix[,colnames(m$BUGSoutput$sims.matrix)=="alpha.p"])
hist(m$BUGSoutput$sims.matrix[,colnames(m$BUGSoutput$sims.matrix)=="beta.occ"])
hist(m$BUGSoutput$sims.matrix[,colnames(m$BUGSoutput$sims.matrix)=="beta.p"])






plot(Concord$MAMTemp,Concord$Amelanchier.canadensis,ylim=c(100,150))
x<-seq(min(Concord$MAMTemp),max(Concord$MAMTemp),0.1)

#plot prediction interval
for (i in 1:1000)
{
  for (j in 1:length(x))
  {
    points(x[j],rnorm(1,mean=m$BUGSoutput$sims.matrix[i,1]+m$BUGSoutput$sims.matrix[i,2]*x[j],sd=m$BUGSoutput$sims.matrix[i,4]),col=2,pch=".")
  }
}

#plot confidence interval
for (i in 1:1000)
{
  for (j in 1:length(x))
  {
    points(x[j],m$BUGSoutput$sims.matrix[i,1]+m$BUGSoutput$sims.matrix[i,2]*x[j],col="blue",pch=".")
}
}