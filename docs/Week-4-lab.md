Week 4 Lab
========================================================

In lab this week, we are going to play around with writing R code to actually do some sampling.

The goal of this week was to introduce you to various alternative methods of sampling from a distribution, with the ultimate aim of being able to sample from the posterior distribution in a Bayesian analysis. 

We have two methods in hand to make draws from an unknown distribution: Rejection Sampling, and Sampling Importance Resampling. Let’s take the following PDF, which is not one of the distributions built-into R and therefore not one we have an easy means of drawing samples from:

$$
f(x|\sigma) = \frac{1}{2\sigma}e^{-|x|/\sigma}
$$

Our choice of $\sigma$ here is arbitrary, so lets work with $\sigma=2$.

**Exercise 1**: Write a script to generate samples from this distribution using Rejection Sampling (RS). Keep in mind that this distribution is valid (i.e. ‘has support’) for all $x \in (-\infty,+\infty)$ and therefore your candidate distribution has to also have support over that range.

**Exercise 2**: Write a script to generate samples from this distribution using Sampling Importance Resampling (SIR). This is quite similar to rejection sampling except that it does not require you to find a constant M that ensures that your candidate function is always larger than your target function. (This can be handy when your target function is unknown.)

Pseudo code for SIR:

*	Sample a large number of random values from a candidate distribution with support over the same range of x values as the target distribution.

*	Find the probability of obtaining those values from the target distribution (i.e. the probability density at each $x$ value drawn).

*	Normalize these probabilities from Step 2 so they sum to 1. 

*	Use the (now normalized) probabilities from Step 3 as weights in a resampling of the random values from Step 1. In other words, use the ‘sample’ function in R to sample with replacement from the values drawn in Step 1, and use the probabilities from Step 3 as weights for that bootstrap sampling.

*	The samples from Step 4 are the draws from the unknown distribution!

**Exercise 3**: Calculate the E[X] of this distribution using either the samples from IS or those from SIR. (If you did everything correctly, they should be roughly the same.) (Stop and work out what E[X] should be mathematically.) Look back at the Week #4 Lecture and make sure you see why this procedure is closely related to the idea of Monte Carlo Integration. What is the function $g(x)$ in this case?

**Exercise 4**: How good is your estimate from Exercise 3? (i.e., calculate the standard error on E[X]. How do we do this? We can either bootstrap from our samples OR [perhaps even better] calculate the SE by actually drawing new sets of samples altogether.)

##Smith and Gelfand (1992)

Key points:

* Bayesian statistics is all about using the data to go from a prior distribution for model parameters to a posterior distribution for model parameters. In some cases, this can be done directly (e.g., when we have conjugate priors). More often than not, this cannot be done directly. In these cases, we have to settle for a somewhat indirect approach focused on using the data to go from samples from the prior distribution to samples from the posterior distribution. We have replaced manipulations of the pdfs, with stochastic samples from those pdfs.

* Rejection methods require that you can calculate some number M such that the ratio of the candidate distribution to the target distribution is always greater than or equal to one. Sometimes this isn’t possible. In these cases, Smith and Gelfand (1992) introduce another approach called the weighted bootstrap approach. What is it, or in what way is it related to a simple bootstrap?  Note that in other places, this approach is called SIR=Sampling – Importance Resampling.

We will now work through the binomial example discussed by Smith and Gelfand (1992). The basic premise is this: Let’s say you have two Binomial variables

$$
X_{i1} \sim Binomial(n_{i1},\theta_{1}) \\
X_{i2} \sim Binomial(n_{i2},\theta_{2})
$$
conditionally independent given $n_{i1}$, $n_{i2}$,$\theta_{1}$, and $\theta_{2}$. Let’s say that you don’t observe $X_{i1}$ and $X_{i2}$ directly, but only their sum

$$
Y_{i} = X_{i1}+X_{i2} 
$$
For simplicity sake, let’s assume you have three data points, so $i=1,2,3$.

I replicate the table from Smith and Gelfand here:

|                     | i=1    | i=2     | i=3       |
| ------------------- |:--------:|:---------:|:---------:| 
| $n_{i1}$            |    5     |    6      |      4    |
| $n_{i2}$            |   5      |     4     |      6    | 
| $y_{i}$             |   7     |    5      |      6    |

So, in words, the situation is this. You have two people flipping coins, and in each trial you know how many each person flipped but you only how many heads they had in total. You want to estimate the probability of each person getting a head.

Before launching into a Bayesian analysis of this, let’s just work out what we would expect using plain-old maximum likelihood estimation.

The likelihood from Smith and Gelfand has two typos, so I am reproducing the correct likelihood below:

$$
\prod^{3}_{i=1}\left[\sum_{ji} {n_{i1} \choose j_i}{n_{i2} \choose y_i-j_i}\theta_{1}^{j_{i}}(1-\theta_{1})^{n_{i1}-j_{i}}\theta_{2}^{y_{i}-j_{i}}(1-\theta_{2})^{n_{i2}-y_{i}+j_{i}}\right]
$$
Note that the bounds on $j_{i}$ are as follows: $max(0,y_{i}-n_{i2}) \leq j_{i} \leq min(n_{i1},y_{i})$.

**Important!** They don't say in the paper, but Smith and Gelfand drop the factorials from their likelihood ${n_{i1} \choose j_{i}}{n_{i2} \choose y_{i}-j_{i}}$ when they plot Figure 2. I **do not want you to drop these coefficients** but if you want to check that your likelihood is correct, you can see what yours looks like if you do drop those coefficients, as it should match Figure 2. (But then add them back!) The constant does not change the $(\theta_{1},\theta_{2})$ location of the peaks of the posterior distribution. (In other words, the peaks are still in the same place but the shape of the likelihood is changed.) However, it does change the posterior and Smith and Gelfand look to have just made a mistake. To get the correct posterior likelihood, the factorials should be left in.  

**Exercise 5**: Use a grid search to find the MLEs. Plot the two-dimensional likelihood.

To apply a Bayesian analysis, we need prior distributions for $\theta_{1}$ and $\theta_{2}$. We will follow Smith and Gelfand’s lead and just use the unit square (so Unif(0,1) for both). What other prior distributions might we have used?

We will use sampling importance resampling to sample from the posterior distribution. 

To do this, first generate a sample from the prior distributions to get prior samples of $(\theta_{1},\theta_{2})$. Then calculate the likelihood of the data for each sample from the prior $(\theta_{1},\theta_{2})$.

The probability of resampling each sample from the prior is

$$
q = \frac{\mbox{Likelihood}(\theta_{1},\theta_{2};y)}{\sum \mbox{Likelihood}(\theta_{1},\theta_{2};y)}
$$
Use this procedure to generate a posterior distribution for $\theta_{1}$ and $\theta_{2}$.

**Exercise 6**: Plot the posterior distribution in the manner of Smith and Gelfand (1992) Figure 2 on top of the likelihood surface from question 2. (It might be easier to visualize if you plot the surface as a contour plot, rather than as a color image.) Are they similar? Different? 

**Exercise 7**: What does this procedure tell us about how the support for the prior (the range of values “permitted” under the prior for which the pdf>0) affects the support for the posterior? In light of this, why does Figure 2 from Smith and Gelfand (1992) look funny?

**Exercise 8**: What would the posterior samples look like if the priors for $\theta_{1}$ and $\theta_{2}$ were drawn from Unif(0,0.5) instead of Unif(0,1)?







