Week 5 Lab
========================================================

We won’t get into Bayesian regression until Week #7 and #8, but we will use an example of a logistic regression to illustrate the basic method of Metropolis sampling. We will start with an ecological data set that comes from 

[M.P. Johnson and P.H. Raven (1973). Species number and endemism: The Galapagos Archipelago revisited. Science 179, 893-895](https://github.com/hlynch/Bayesian2020/tree/master/_data/JohnsonRaven1973.pdf). 

and which can be downloaded [here](https://github.com/hlynch/Bayesian2020/tree/master/docs/galapagos.txt).

This is really a subset of the original dataset; I have included only the columns relevant for lab:

Island: Name of Island  
Plants: Number of plant species  
PlantEnd: Number of endemic plant species  
Elevation: Maximum elevation (m)  

Let’s focus on endemism as the trait of interest, so for island $i$, $y_{i}=1$ if the plant is endemic and $y_{i}=0$ if the plant is not endemic. We will treat Elevation as the covariate $x_{i}$ of interest, so

$$
Y \sim Binom(n,p)
$$

where $n$ is the total number of plants on the island, and $p$ is the probability that a plant is endemic.

$$
logit(p_{i}) = \beta_{0}+\beta_{1}x_{i}
$$
We might put the following vague priors on the parameters 

$$
\beta_{0} \sim N(0,1) \\
\beta_{1} \sim N(0,1) \\
$$
We will use Metropolis to sample from the posterior distribution. We will use the following proposal distribution

$$
S(\beta,\beta^*) = \frac{1}{\sqrt{2\pi\sigma^2}}e^{-(\beta^*-\beta)^2/2\sigma^2}
$$
(I am letting you find the best $\sigma$.) This proposal distribution is a random-walk proposal distribution.

The pseudocode goes as follows:

1) Choose starting values. 
2) Propose new value of $\beta_{0}$ (a.k.a. $\beta_{0}^*$)
3) Accept $\beta_{0}^*$ with probability $\mbox{min}[1,\pi(x^*)/\pi(x)]$
4) Repeat Steps 2 and 3 with $\beta_{1}$
5) Repeat Steps 2-4 many times (1000? 10000?)

You can also make multivariate draws using the ‘mvrnorm’ function from the MASS package.

**Question**: Why might multivariate draws be preferrable?

Keep in mind the following:

$$
P(\beta_{0}^*,\beta_{1}^*|Y) = \frac{P(Y|\beta_{0}^*,\beta_{1}^*)P(\beta_{0}^*,\beta_{1}^*)}{P(Y)}
$$
and

$$
P(\beta_{0},\beta_{1}|Y) = \frac{P(Y|\beta_{0},\beta_{1})P(\beta_{0},\beta_{1})}{P(Y)}
$$
Therefore

$$
\frac{P(\beta_{0}^*,\beta_{1}^*|Y)}{P(\beta_{0},\beta_{1}|Y)} = \frac{\pi(x^*)}{\pi(x)} = \frac{P(Y|\beta_{0}^*,\beta_{1}^*)P(\beta_{0}^*,\beta_{1}^*)}{P(Y|\beta_{0},\beta_{1})P(\beta_{0},\beta_{1})}
$$
thus eliminating the pesky denominator in both expressions.

We will make a minor modification to step 3 to head off problems with numerical errors. The original formulation would require that we draw a value from Unif(0,1) and accept if this value is less than $\pi(x^*)/\pi(x)$. Since probabilities (esp. joint probabilities) are always very small problematic numbers, we would prefer to log both sides of this, and to log the draw from the Unif(0,1) and compare this value to $\pi(x^*)/\pi(x)=log(\pi(x^*))-log(\pi(x))$.

$$
log(\pi(x^*))-log(\pi(x)) = log(P(Y|\beta_{0}^*,\beta_{1}^*))+log(P(\beta_{0}^*))+log(\beta_{1}^*)-log(P(Y|\beta_{0},\beta_{1}))-log(P(\beta_{0}))-log(P(\beta_{1}))
$$
In other words, we calculate the difference in log probabilities and use this as the acceptance threshold.

**Note – this still may not prevent numerical underflow – what are other possible solutions?** 

<details>
  <summary>Click for Answer</summary>
<span style="color: blueviolet;">
Standardizing the covariate might be needed! (e.g., $(elev-mean(elev))/sd(elev)$). Doing so makes it much easier to get your sampler working efficiently.
</span>
</details> 

Make sure your code works by comparing it to the results obtained using the glm function.

Things to play around with:

1) Once you get the code working, plot the chains for both $\beta_{0}$ and $\beta_{1}$ - have they converged? How would you check? Also, plot the histograms – these represent your posterior distributions. What do you get if you plot a scatterplot of the posteriors for $\beta_{0}$ and $\beta_{1}$?

2) Make your script calculate the acceptance rate. What happens to the acceptance rate when you vary $\sigma$? (We are generally looking for acceptance rates in the vicinity of 0.5. How would you write your script to adaptively sample to get an acceptance rate $\sim$0.5?)

3) What happens if you use other proposal distributions? Does it converge faster or slower?

Gibbs Sampler
-----------------

(This example is basically Lunn et al. Example 4.2.2) For this example, I have generated some random values from a Normal distribution with unknown (to you) mean $\mu$ and variance $\sigma^{2}$. The data are posted [here](https://github.com/hlynch/Bayesian2020/tree/master/docs/Gibbsdata.txt). Since JAGS works with the precision, we will define the precision $\tau=1/\sigma^{2}$.

We will use the following priors 

$$
\mu \sim N(\gamma, \omega^{2}) \\
\tau \sim Gamma(\alpha,\beta)
$$

Note that these are the conjugate priors where precision and mean are known, respectively, but that the joint distribution

$$
P(\mu,\tau) \sim N(\gamma, \omega^{2}) \times Gamma(\alpha,\beta)
$$

is **not** the conjugate prior for the case in which both $\mu$ and $\tau$ are unknown. In this case we have to appeal to some other scheme for sampling from the posterior distribution, like a Gibbs sampler.

What we will need in hand to make the Gibbs sampler work is the conditional distribution for $\mu$ assuming $\tau$ is known, and the conditional distribution for $\tau$ assuming $\mu$ is known. Keep in mind that 

$$
\mbox{posterior} = \mbox{prior} \times \mbox{likelihood}
$$
and the likelihood in this case is simply the pdf for a Normal, since the data are Normally distributed. (With all the focus on priors and posteriors, the likelihood sometimes gets lost in the shuffle, so don’t forget to make sure you have the right likelihood!)

$$
P(y_{1},y_{2},...,y_{n}|\mu,\tau) \propto e^{-\frac{\tau}{2}\sum_{i=1}^{n}(y_{i}-\mu)^{2}}
$$
**Question: Why is there a sum in the exponent?** 

OK, back to the question at hand – what is the distribution for $\mu^{(t)}$ if we have the data y and $\tau^{(t-1)}$? (The beauty of Gibbs sampling is that each draw is conditional on the most recent draw for the other parameters, so the other parameters are assuming “known” at their most recent value.) In other words, what is the conditional posterior for $\mu$ assuming $\tau$ is known? 

$$
P(\mu|y,\tau) \propto e^{-\frac{1}{2\omega^{2}}(\mu-\gamma)^{2}}e^{-\frac{\tau}{2}\sum_{i=1}^{n}(y_{i}-\mu)^{2}}
$$
(This is just the prior for $\mu$ times the likelihood.)

But, because we assume $\tau$ is known here, the prior for $\mu$ is conjugate to the likelihood, and we can simply write down the posterior distribution!

$$
P(\mu^{(t)}|y,\tau^{(t-1)}) \sim N\left(\frac{\tau^{(t-1)}\sum y_{i}+\omega^{-2}\gamma}{n\tau^{(t-1)}+\omega^{-2}},\frac{1}{n\tau^{(t-1)}+\omega^{-2}}\right)
$$
Likewise, if we know $\mu$, then the prior for $\tau$ is conjugate to the likelihood, and its conditional pdf is given by

$$
P(\tau^{(t+1)}|y,\mu^{(t)}) \sim Gamma\left(\alpha+\frac{n}{2},\beta+\frac{1}{2}\sum_{i=1}^{n}(y_{i}-\mu^{(t)})^{2}\right)
$$

**EXERCISE**: Write a script to use Gibbs sampling to get posterior distributions for $\mu$ and $\tau$. Use three chains to check convergence, and provide plots of the chains and the posterior histograms for both $\mu$ and $\tau$. What is the posterior mean and 95th percentile credible intervals?

