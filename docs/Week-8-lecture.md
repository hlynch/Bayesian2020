Week 8 Lecture
========================================================

There is almost nothing special to say about Bayesian GLMs because the JAGS language makes it perfectly transparent what model is being used for the data and switching to something other than a normal is straightforward. Nevertheless, it’s a good opportunity to get some more practice with JAGS and review the basic principles of non-linear models/GLMs.

First, we will start with a review of such models, a subject that many people find challenging the first time around (a.k.a. in Biometry). Let’s start with the model equation for a standard regression with normally distributed errors:

$$
Y_{i} \sim N(\mu_{i},\sigma_{i}^{2}) \\
\mu_{i} = \alpha + \beta X_{i}
$$

There are **two** assumptions being made here. (1) a linear relationship between the covariate and the mean response and (2) normally distributed errors. You could imagine changing the first assumption without actually changing the second assumption. You could assume that there was some non-linear relationship between $\mu_{i}$ and $X_{i}$

$$
logit(\mu_{i}) = \alpha + \beta X_{i}
$$
or

$$
\mu_{i} = exp(\alpha + \beta X_{i})
$$
or anything else for that matter. The point is that when we introduce GLMs, we tend to gloss over the fact that we are changing **both** the model for the errors **and*** the relationship between the model parameters and the covariates of interest. (Non-linear regression usually implies that we have kept a normal model but made the relationship between the mean and the covariate non-linear.)

When we have a Bernoulli or Binomial response, we use a Bernoulli or Binomial model for the data

$$
Y_{i} \sim \mbox{Bernoulli}(p_{i}) \\
Y_{i} \sim \mbox{Binomial}(n_{i},p_{i})
$$
where $n_{i}$ is usually assumed known in the latter case. Using either model, we need some way of relating the probability $p_{i}$ to the covariates of interest. We are fairly constrained in ways to do this because $p_{i}$ has to remain bounded (0,1). The logit transformation satisfies this requirement:

$$
logit(p_{i}) = \alpha + \beta X_{i}
$$
We do this in JAGS with the following statement in the model


```r
Y[i] ~ dbern(p[i])
logit(p[i])<-alpha+beta*X[i]
```

Poisson regression works similarly. In this case, we have a response that is Poisson distributed with parameter $\lambda$, and we need some model that relates $\lambda$ to the covariates. In this case, $\lambda \ge 0$ so we use the log link function

$$
log(\lambda) = \alpha + \beta X
$$

The JAGS code for this is analogous to before


```r
Y[i] ~ dpois(lambda[i])
log(lambda[i])<-alpha+beta*X[i]
```

Notice that, as pointed out in McCarthy, the MCMC samplers work better when the covariates are centered on their mean value. Its also true that the samplers are happiest when the numbers are smallish (1-10), so if you have large responses its better to divide your response Y by a constant, do the MCMC analysis, and multiply back by that constant at the end.

While regular Poisson regression is fairly straightforward, there are many ways in which a dataset may be poorly fit by a Poisson. The two most common deviations from “poissonness” are overdispersion (Var>Mean) and an excess of zeros.  As discussed in Biometry, overdispersion and zero-inflation can be dealt with using “standard” likelihood (frequentist) methods. They can also be dealt with using a Bayesian approach. Note that zero-inflation of a Poisson can be thought of as a type of mixture model, whereby a Binomial controls whether there is presence (Abundance>0) or absence (Abundance=0), and a Poisson is used to model Abundance conditional on presence. 

There are many ways to add variance to a Poisson regression. One option is to multiply $\lambda$ by a new parameter that varies among individuals or groups of individuals

$$
Y_{i} \sim Pois(\epsilon_{i}\lambda_{i}) \\
log(\lambda_{i}) = \alpha + \beta X_{i} \\
\epsilon_{i} \sim Gamma(\theta,\theta)
$$
Another option is to add a random variable to the term for $log(\lambda_{i})$

$$
Y_{i} \sim Pois(\lambda_{i}) \\
log(\lambda_{i}) = \alpha + \beta X_{i} + \epsilon_{i} \\
\epsilon_{i} \sim N(0,\sigma^{2})
$$
A third option is to simply use a distribution that allows for Var>Mean; the classic example here is the Negative Binomial, which is similar to the Poisson but with an extra parameter that controls dispersion (Var>Mean only). 

Side note: The first and third options here are actually the same thing. A Poisson distribution with a parameter that varies as a Gamma distribution is actually just a Negative Binomial. The Negative Binomial is also known as the Gamma-Poisson mixture. A nice overview of this can be found [here](https://probabilityandstats.wordpress.com/tag/poisson-gamma-mixture/).

Zero-inflation is another way in which a dataset may diverge from a simple Poisson (or Binomial, Gamma etc.). Zero-inflated Poissons can be dealt with as follows:

$$
\omega_{i} \sim \mbox{Bernoulli}(\theta_{i}) \\
Y_{i} \sim \mbox{Pois}(\omega_{i}\lambda_{i}) \\
log(\lambda_{i}) = \alpha + \beta X_{i}
$$
(NB: Strictly speaking, the Poisson parameter $\lambda$ has to be greater than 0, so you may need to code this as: $Y_{i} \sim \mbox{Pois}(\omega_{i}\lambda_{i} + 0.0001)$.

Note that you are often interpreting the two components of this differently. In an ecological context, you might say that the excess zeros represent sites that are unsuitable for occupancy and the Poisson represents the abundance at sites that are suitable (here I have represented abundance as having a covariate “X”). Keep in mind, however, that the Poisson also yields zeros, and so it is critical not to interpret all the zeros as coming from unsuitable habitat. Sometimes a habitat is suitable and there is no abundance, and the Poisson deals with this just fine.

Side note: We can also have truncated Poisson distributions. For example, let’s say that you are studying litter size. We only have a litter size if there is a litter in the first place, so we don’t have litter sizes of zero. In these cases we have to truncate the Poisson so as to yield only Y>0. 

Side note #2: Question #3 on the problem set asks you to model a parameter of a statistical model as coming from a distribution. This is a simple example of what is known as hierarchical modeling. It sounds super complicated and fancy but its really not. We are simply nesting statistical models within other statistical models. This is why many statisticians, particularly those using Bayesian approaches like this, avoid the terms “fixed effects” and “random effects” (see Gelman and Hill, posted on Bb). By “fixed” effects, all we are saying is that we are not going to model variation as any higher hierarchical level. “Random effects” simply means that we are going to model variation at another hierarchical level. Gellman and Hill argue for the terms “modeled” and “unmodelled” variation, which I prefer over fixed vs. random. It is only because frequentists methods are so awkward dealing with hierarchical variation that we make such a fuss over fixed vs random in Biometry. Using Bayesian methods its not a big deal at all.



