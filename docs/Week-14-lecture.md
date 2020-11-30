Week 14 Lecture
========================================================

Papers to read this week:

* [Gelman and Shalizi 2013](https://github.com/hlynch/Bayesian2020/tree/master/_data/GelmanShalizi2013.pdf)
* [Pitt and Myung 2002](https://github.com/hlynch/Bayesian2020/tree/master/_data/PittMyung2002.pdf)
* [Spiegelhalter et al. 2014](https://github.com/hlynch/Bayesian2020/tree/master/_data/SpiegelhalterEtAl2014.pdf)
* [Greenland and Poole 2013](https://github.com/hlynch/Bayesian2020/tree/master/_data/GreenlandPoole2013.pdf)
* [Ward 2008](https://github.com/hlynch/Bayesian2020/tree/master/_data/Ward2008.pdf)

We’ve spent the last few weeks learning how to run models in JAGS, and now we cycle back to some more basic questions about how hypothesis testing is actually done in a Bayesian framework. **Everything covered this week is a matter of continuing development.**  Different experts and textbooks will disagree on the best method, and the use of any one method may draw ire from reviewers. There are no easy and simply ways to check that your model works; these problems are the same as those in frequentist statistics except that the field is newer and so the approaches are still a matter of some debate and discussion.

We usually have two questions when fitting models with data:

1) How do the models compare to one another?

2) How do the models compare to the data?

We have to be careful that an excessive concern over model comparison does not keep up from asking the very fundamental question: Are any of these models any good? If none of the models are very good, the whole exercise of model comparison may be a waste of time. (But maybe not – perhaps you are interested in statistically significant covariates even though they explain little of the variation in the data.)

McCarthy makes an important point when he says that the model should fit both the central tendency and the variation in the data. In other words, let us not forget that a model such as

$$
Y \sim N(\mu,\sigma^{2})
$$
includes both $\mu$ **and** $\sigma^{2}$, the latter of which should not be dismissed as a nuisance parameter to the “main event” of $\mu$. This is particularly important when building models to be used for prediction.

**Method #1: Plot the model against the data**

While it seems almost too simple to be of any use, you should always plot the model against the data. Sometimes, the parameters look fine but the fit is obviously horrible for one reason or another.  

**Method #2: Mean squared predictive error**

Beyond simply visualizing your model and its fit (that is, the fit of the predicted values) to the original data, you could imagine using out-of-sample data (What do I mean vy out-of-sample? What if we don't have out-of-sample data?) and calculating a squared error term similar to the kind of error one would calculate in a frequentist linear regression type context. We call this a mean squared *predictive* error so as to remind you that this error is relative to some predicted y values.

$$
MSPE = \sum_{i=1}^{n}\frac{(y_{oos,i}-\widehat{y_{oos,i}})^{2}}{n}
$$

where we have calculated the squared error over all $i=1,\dots,n$ out-of-sample data points.

This measure of error, while intuitive and easy to calculate, has a major flaw, in that it does not incorporate any information about our uncertainty. In other words, our posterior distribution for the parameters $\theta$ capture our uncertainty about the parameter values and on top of that, there is a distribution for the predicted y values even for a single parameter value. So, the MSPE measure requires us to collapse all of that uncertainty to a single "point" estimate for $\widehat{y_{oos,i}}$, and that just isn'y very "Bayesian".

**Method #3: Posterior predictive checks**

A more "Bayesian" approach would be to calculate the posterior predictive distribution 

$$
p(\tilde{y}|y) = \int p(\tilde{y}|\theta)p(\theta|y)d\theta
$$
$\tilde{y}$ = new data

y = original data 

$\theta$ = model parameters 

$p(\theta|y)$ = posterior distribution of $\theta$

This explicitly incorporates the relavent uncertainties, not only the posterior distribution for the parameters, but also the probability density function describing the distribution of predicted y values conditional on a set of parameter values $p(\tilde{y}|\theta)$.

Our focus on ABC last week can actually provide some intuition here. $p(\tilde{y}|\theta)$ is the probability of your data conditional on some set of parameters. In ABC, every simulation involved a specific set of parameters drawn from the prior distribution. Because your model was stochastic, running the simulation multiple times with the exact same set of parameters would yield a range of outcomes $y$. That's what we mean when we talk about a distribution conditional on a set of parameter values. (In practice, we don't bother drawing multiple times with the same parameter set, we draw a single outcome with each draw from the prior, but the idea that each parameter set yields an entire distribution of outcomes should be clear.) The posterior predictive check is focused not on the parameters themselves, in fact, they are considered but a necessary step on the journey; what we want is to integrate over ("marginalize out") the posterior distribution of the parameters. You can think of the posterior as being a weight, and the possible outcomes are weighted according to the likelihood of the parameters that were used.

In practice this means doing the following:

Step #1: Sample $m$ values of $\theta$ from the posterior $p(\theta|y)$ 

Step #2: For each of these $m$ values, sample from the likelihood $p(\tilde{y}|\theta)$

These samples represent draws from the posterior predictive distribution $p(\tilde{y}|y)$.

How do we use $p(\tilde{y}|y)$? The most straightforward, and in practice recommended, way to use $p(\tilde{y}|y)$ is to check the model graphically. Does the model “look” correct for whatever key features you are interested in? Where it fails, does it tell you anything about the model? Does it tell you anything about the data?

**Remember: All models are wrong, but some are useful.**

A second, more quantitative (but not necessarily more helpful) approach would be to focus on a key set of test statistics, just the way you would have done for ABC.

Step 1 $\rightarrow$ Come up with a ‘relevant’ test statistic $T$, i.e. one that has the power to distinguish a good model from a bad model. Note that ‘good’ and ‘bad’ here are context dependent, because it depends on the goals of the modeling. You want to compare models based on the most important predictions, which may or may not be straightforward. In other words, in studying the population growth rate of a species, you may be interested in the maximum population growth rate, which is a function of other life history parameters such as age to maturity. It may be that you are not interested in age to maturity at all, except in as far as it influences maximum population growth rate. In this case, you should compare models based on growth rate and not age to maturity.

Often, we are interested in predicting what values we might see if we could “rewind time”; in these cases the posterior predictive distribution is compared against the real data to ask whether or not it is similar in ‘relevant’ ways.  

Step 2 $\rightarrow$ Calculate T for the observed data $y: T(y)$. 

Step 3 $\rightarrow$ Calculate T for each draw from the posterior predictive distribution $\tilde{y}: T(\tilde{y}|y)$. 

Step 4 $\rightarrow$ Calculate the fraction of times that $T(y) < T(\tilde{y}|y)$. (I have flipped this statement around from Gelman and Chalizi 2013 because I think its easier to think of in this way). Sound familiar? It should. This is called the **posterior predictive p-value**. In other words, we are checking to see whether our data would be considered an extreme outcome of the model as defined by the test statistic. Let’s say that our test statistic exceeds the model prediction test statistic $T(\tilde{y}|y)$ for $>95\%$ of model predicted data sets. In this case, the posterior predicted p-value would be $<0.05$, and we would say that we can reject the model as fitting the data. (Bayesians don’t use this phrase, but another way to think about it is that we have established a null hypothesis that the model does fit the data in as far as the characteristic measured by the test statistic $T$, and a p-value$<0.05$ would lead us to reject that null hypothesis.)

Recap: A very low p-value says that it is unlikely, *under the model*, to have obtained data as extreme along the T-dimension as the actual y, i,.e. we are seeing something which would be highly improbable *if the model were true*. In other words, you want your model to make your data look typical, not unusual.

Note that here we have used the data twice – once to build the model and then again to check the model. This is akin to looking at the $R^2$ of a traditional frequentist regression model. Sure, the model probably fits because it was designed to fit the data. This doesn’t really tell us all that much about whether the model would work on new data. As we discussed in Biometry (in our Shmueli discussion), one solution would be to withhold some data from the model fitting, and use only the withheld data to see if the model is any good (at making predictions).

Note that passing the “test” above does not mean the model is guaranteed to be good, because **your test statistic T may have low power to detect certain violations**. However, it may flag problems with the model that are worth investigating further.

**Remember back to the Mona Lisa example from last week.**

As I’ve tried to illustrate below, both frequentist and Bayesian statistics can be thought of as following the hypothetico-deductive framework, but the former relies on $p(data|model)$ and the latter on $p(model|data)$.

Note that in Step #4 of the Bayesian workflow diagram, I’ve stated that the posterior predictive checks can be used to falsify a model. While true, this isn’t all that helpful, because we know a priori that **all models are false**. The way to think about this last step is that **you are checking to see in what way your model is false and whether your model fails in ways that are important to your application.**

(Posterior predictive p-values are not without their critics, and here I would refer to Andrew Gelman’s blog, where he airs out the dirty laundry of posterior predictive p-values [which he himself has helped develop].) 

<div class="figure" style="text-align: center">
<img src="BayesianVsFrequentist.png" alt="Diagram illustrating how Bayesian and frequentist approaches integrate theory, data, and predictions." width="100%" />
<p class="caption">(\#fig:unnamed-chunk-1)Diagram illustrating how Bayesian and frequentist approaches integrate theory, data, and predictions.</p>
</div>

**Method #3: Deviance Information Criteria (DIC)**

Whereas Methods #1 and #2 relate to the question “Does my model fit to the data”, they do not directly address the question “Which of these two competing models is better?”. One way of comparing models in a Bayesian context is the Deviance Information Criterion.

First, a quick recap of Deviance. 

**Likelihood**: The likelihood of a model represents the likelihood (i.e., the probability) that you would have obtained the actual data given a particular model. This is almost always a very small number, since even the “true” model could yield a large number of outcomes, of which yours is just one. Assuming independent data points, the joint likelihood for the whole data set is simply the product of the likelihood of obtaining each data point, and so the joint likelihood is a very very small number (even at its maximum). (This was the moral of the M&M problem set in Biometry.) To deal with these obnoxiously tiny numbers, we focus on the log-likelihood. 

**Deviance**: In Biometry, we introduced the idea of Deviance, which was defined as 

$$
D = -2 * (LL_{\mbox{reduced}} - LL_{\mbox{full}})
$$
where $LL_{\mbox{reduced}}$ refers to the log-likelihood of a reduced (smaller) model, as compared to $LL_{\mbox{full}}$, which refers to the full model. The ‘full’ model remains a statistical abstract, and usually we are comparing two reduced models, one of which is nested inside the other. The discussion then becomes one of differences in deviance

$$
D = -2 * (LL_{\mbox{smaller}} - LL_{\mbox{larger}})
$$

In Bayesian stats, we usually drop the ill-defined ‘full model’ in lieu of simpler definition of ‘deviance’ (which reflects how we use deviance in practice anyways)

$$
D = -2 * LL
$$

(In other words, we now just defined deviance without reference to some mythical full model.)

The parameter estimates that maximize the likelihood (i.e. the MLEs) are equivalent to the mode of the posterior distribution if non-informative priors are used. (Proving this isn’t trivial, so for now accept this as a fact, though it should be a fairly plausible fact.)

Accordingly, the deviance calculated with the posterior mode of each of the parameters will yield the minimum deviance. Put another way, in Bayesian inference, the model with the lowest expected deviance has the highest posterior probability. Since posterior modes are much harder to calculate than posterior means, we usually exploit the symmetry of the posteriors (and hope that they are symmetric) and calculate D with the mean of the posteriors, i.e.

$$
\hat{D} = D(\bar{\theta_{1}},\bar{\theta_{2}},\mbox{etc.})
$$

Easy enough, right? Sadly, no. Because we know that we can always improve fit by adding complexity, but for complex models we have no way to calculate the model complexity. (This will become clearer when we get to hierarchical models in which the number of parameters in the model isn’t even really an integer…)

Spiegelhalter et al. (2002) derived an estimate of the number of effective parameters

$$
p_{D} = \bar{D}-\hat{D}
$$
where $\bar{D}$ is the mean of the posterior deviance. I won’t make you read the original paper on this, since its pretty dense, and likewise I find McCarthy’s explanation for its intuitiveness rather unconvincing. Nevertheless, this is one way to estimate the effective number of parameters, and it can be generated automatically in WinBUGS so its used quite commonly. (I find this more convincing in practice, as we will demonstrate in lab, because non-hierarchical models with little prior information yield $p_{D} \sim$ true number of parameters.)

 (I have assigned the much newer Spiegelhalter et al. (2014) paper because it nicely summarizes the controversies surrounding DIC and reminds us that all this is still a matter of active development among statisticians.)

Now we have a way of quantifying model fit ($\hat{D}$) and a way of quantifying model complexity ($p_{D}$). These are combined into the Deviance Information Criterion, which is a direct analog of Aikake’s Information Criterion.

$$
DIC = \hat{D} + 2p_{D}
$$
We can interpret DIC similar to AIC, in that DICs within $\sim$ 2 are considered equivalent, those falling 2-4 units below the best model having somewhat less support etc.

Criticisms of DIC (from Spiegelhalter et al. 2014):

\tab a) $p_{D}$ is not invariant to re-parameterization: For example, if you were to rewrite your model in terms of $log(\sigma)$ instead of $\sigma$, you would get a different $p_{D}$ even if the priors were made equivalent. ($p_{D}$ can also be negative $\dots$ hmmm $\dots$ hardly convincing)

\tab b) Lack of consistency (As the size of the dataset grows to infinity, DIC may not converge to the true model)

\tab c) Not based on a proper predictive criterion

\tab d) “weak” theoretical justification


The DIC is an omnibus measure of fit, and its use is fairly contested among statisticians. (I think some of the complaint is that non-statisticians use it blindly without any knowledge of what it actually is or what the caveats might be.)  

**Method #4: WAIC**

Because of the some of the concerns over DIC as a measure of model fit, many practitioners have started using a measure called WAIC, which has stronger theoretical justification and avoids many of the problems of DIC

$$
WAIC = -2\sum_{i=1}^{n} log \int p(y_{i}|\theta)p(\theta|y)d\theta + 2p_{D}
$$

where now $i=1,\dots,n$ represents the index for all data in the set (not an out-of-sample set but the data used to fit the original model). The WAIC looks a lot like the AIC measure that we use in a frequentist analysis, in that we have a term that reflects the negative log likelihood of the data (the dependence on the parameters has been marginalized out) and a penalty for model complexity.

We can approximate this using the samples from our MCMC chain as

$$
WAIC \sim -2 \left(\sum_{i=1}^{n}log\left(\frac{\sum_{k=1}^{K}p(y_{i}|\theta^{k})}{K}\right)\right) + 2p_{D}
$$
where $k=1,\dots,K$ represents the samples in the MCMC chain itself.

**Method #5: Posterior predictive loss**

Yet another measure of fit is the posterior predictive loss

$$
D_{sel}=\sum_{i=1}^{n}(y_{i}-E[y_{i}^{new}|y])^{2} + \sum_{i=1}^{n}Var[y_{i}^{new}|y]
$$

Notice that in practice this requires just calculating a new data set at each interation of the MCMC chain.

We will discuss yet another method, Bayes Factors, next week when we dig deeper into the world of multimodel inference.

For more information about this week's topic
------------------------

* [Kass and Raftery 1995](https://github.com/hlynch/Bayesian2020/tree/master/_data/KassRaftery1995.pdf)
