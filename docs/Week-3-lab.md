Week 3 Lab
========================================================

This lab has three objectives:

(1)	To teach you the basics of the Delphi method of expert elicitation

(2)	To provide some practice using Moment Matching

(3)	To provide some intuition for how a prior distribution is combined with data to create a posterior distribution, and how that posterior distribution can be used as a prior distribution for the analysis of additional data

You should all have a bag of Skittles.

In this lab, we’ll walk through the Delphi method to establish a priori probability on the number of Skittles per bag. (Or, more precisely, a prior probability on the Poisson parameter that governs the expected number of Skittles per bag.) The details of the Delphi method aren't important, but whether you are asking a group of experts or just yourself, prior distributions are often derived using informed but ultimately subjective a priori knowledge about a system. Whether this is a "feature"" or a "bug" of Bayesian analysis is something we can discuss.  Before we get started, let's think about why we might use the Poisson distribution to describe the number of Skittles in a bag. Is the Poisson distribution the best one to use for Skittles? Do we expect they will be under- or overdispersed? What are our other options? In this case, we’ll use the Poisson for convenience, but keep in mind that in an actual analysis, the choice of distribution requires careful consideration.

**EXERCISE**: Draw on a piece of paper a "uninformative" probability distribution for the parameter $\lambda$ associated with the Poisson distribution. Is this prior distribution a proper probability distribution? (What are the requirements for a proper probability distribution function?) What distributions might look "close enough" to your "ideal" uninformative prior? Using R, play around with the Gamma distribution to get a distribution you think is "close enough" and write down the parameter values a and b. We will need these later in our lab.

Congugacy
-----------

With modern computers, we often don't worry too much about using a prior distribution that is "congugate" to the likelihood distribution. However, for this lab, we'll use the congugate distribution because it is convenient and it will help us visualize the effect of adding more data. As you will prove for the problem set, the Gamma distribution is conjugate to the Poisson distribution. In other words, ff the prior distribution is

$$
\theta \sim Gamma(a,b)
$$
and you have data with $n$ counts with an average of $\bar{y}$, then the posterior distribution will be

$$
\theta|\bar{y} \sim Gamma(a+n\bar{y},b+n)
$$
Keep in mind that this is equivalent to

$$
\theta|\bar{y} \sim Gamma(a+\sum_{i=1}^{n} y_{i},b+n)
$$
Since a Gamma prior will be easy to work with, we would like to elicit “expert” opinion on $\lambda$ in the form of the gamma distribution. There are multiple methods of this (Lunn et al. introduces the idea of a “pre-prior”) but I like the moment-matching method best. In other words, you will each decide what you think is the expected value of $\lambda$ with a measure of the standard error of your estimate. We can then ask “What would the Gamma distribution parameters a and b have to be to get a distribution (for $\lambda$) with that mean and that variance”? (This is the essence behind matching moments of distributions.)

Moment Matching two distributions
-------------------------------

We'll illustrate the process of moment matching with an example. Look at the handout `DistributionCheatSheet.pdf` kindly provided by the instructor of the SESYNC Bayesian course and look down to the row on the Gamma distribution. The mean and variance of the Gamma distribution is related to the two parameters a and b as follows

$$
E[X] = \frac{a}{b}
$$
$$
Var[X] = \frac{a}{b^{2}}
$$
We can use these two expressions to solve for the a and b associated with a distribution that has mean $\mu$ and variance $\sigma^{2}$

$$
a = \frac{\mu^{2}}{\sigma^{2}}
$$

$$
b = \frac{\mu}{\sigma^{2}}
$$

That's it! So when you think of a distribution that you think describes the number of Skittles in a bag, you can take the mean and variance of that distribution and work out the associated Gamma parameters a and b.

From Prior to Posterior to Prior
-----------------------------

Since we have some intuition for the moments of the distribution, and not the parameters of the gamma distribution, we will use our expert opinion to get a prior distribution for $\lambda$ (and our uncertainty about the estimate). When we have arrived at a consensus about this, we will work out the parameters of the corresponding gamma distribution using moment matching. To make this a little more manageable, we'll break into groups of 4 or 5 for the Delphi Method.

*Step 1:*
Without discussing it with the others in your group, write down on a piece of paper how many skittles you think are in a bag of skittles. This is your $\mu$. Now write down what you think your uncertainty about this number is. In other words, if you think there are 50 skittles in a bag, but it could be anywhere from 30 to 70, than $\mu=50$, and $2\sigma = 20$, so your estimate of the variance $\sigma^{2}=100$. Make sure this makes sense. (The 2 is $\sim$ 1.96, this is all sort of "back of the envelope".)

*Step 2:*
Discuss your guesses with each other, explain why you think the number is what you think it is, etc.

*Step 3:* 
Now, having shared your estimates and discussed them, write down your independent assessment of $\mu$ and $\sigma^{2}$.

*Step 4:*
Discuss again! We could continue this cycle indefinitely, but in the interest of time, come to some concensus for $\mu$ and $\sigma^{2}$. You can always just average for estimates together. This will be your prior for $\lambda$. But, remember, we need to use moment matching to get this into a prior estimate for a and b. Work through the math so your group has a single prior estimate for a and b in the Gamma distribution.

Adding data: One at a time or all at once?
------------------------------------------

In frequentist analyses, we worry about "looking at the data" before the data has been fully collected for fear that our preliminary analysis of the data may inform or change our pre-determined experiemental design. Doing so can cause issues with multiple comparisons and inflated Type I error rates, as discussed in Biometry. However, as we will see here, Bayesian analyses are insensitive to this issue, and the data can be added piecewise or all at once.

Now everyone should open up their bags of Skittles and count the number inside. Decide the order in which these counts will be "used" in the analysis. Using one data point, calculate the posterior distribution for $\lambda$. Because the Gamma is congugate to the Poisson, this is easy to do (see above). This posterior distribution will be our new prior distribution. Now include the number of skittle in the second bag as a new data point, turning this new prior (one data point) into a new posterior (2 data points). Working our way through the bags, we update each prior into a posterior, which is then used as the next prior. What is your final posterior distribution? Now redo the calculation treating all the counts as a single dataset (n=4 if you have 4 people in your group). What is your final posterior distribution now?

The following code (an example from last year) can be modified and pasted into R to plot your prior and your slowly changing posterior as data are added


```r
a <- 28.4 # prior on a
b <- 1.78 #prior on b
prior=dgamma(x = 8:22,shape = a,rate = b)
plot(prior, x=8:22,ylim=c(0,0.42),pch=16,typ="b") #plots your prior

data=c(14,13,14,16,16,15,14,14,15,15,14,15,17,14) # put your data in here
for(i in 1:length(data)){
  n= i
  y = data[1:i]
  posterior = dgamma(x = 8:22,shape = a+n*mean(y),rate = b + n)
  lines(posterior,x=8:22,col=rainbow(15)[i])
  
}
```


What impact did the choice of prior have?
---------------------------------------

The choice of a prior distribution can impact your posterior distribution, especially when you have small datasets. This is precisely what gives many frequentists heartburn about Bayesian analysis. Compare the posterior you got using your Delphi method to derive a prior disytribution with the posterior distribution you would get had you used your "close enough to uninformative" prior you generated earlier in the lab. Are these posteriors different? By a little? By a lot? Which is the better method?

**Do the different varieties of Skittles have different numbers in each bag? (a.k.a. dipping our toe in the water of Bayesian inference)**

Now we will have a posterior distribution for the number of Skittles for each variety. We can now ask whether these are "statistically significantly" different? Is that a question we even really ask in a Bayesian analysis? 

The place to get started here is to create a derived quantity representing the difference in number between two varieties. Usually, we will do this in the JAGS model itself, so that we calculate the difference immediately after the sample for each variety. This is one of the nicest features of Bayesian modeling (made easy with JAGS), which is that anything downstream of the model we might be interested in, we can compute along the way. If we are interested in **differences**, than we should store the differences in a new variable and when the sampling is complete we have a posterior for that quantity of interest. In this case, we are not doing any MCMC sampling because we have used conjugate priors and therefore have an analytical expression for the posterior. In this case we can simply sample from from each of the two posteriors and subtract them to create a posterior for the difference. In class we will discuss the ways in which a Bayesian might intepret that posterior for the difference, i.e. how do we actually do Bayesian inference only the sampling is all done.
