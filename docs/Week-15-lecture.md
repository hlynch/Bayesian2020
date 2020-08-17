Week 15 Lecture
========================================================

Papers to read this week:

* [Lunn et al. Sections 8.7 to 8.10](https://github.com/hlynch/Bayesian2020/tree/master/_data/Lunn8_7to8_10.pdf)
* [Link and Barker 2006](https://github.com/hlynch/Bayesian2020/tree/master/_data/LinkBarker2006.pdf)
* [Link and Barker Chapter 7](https://github.com/hlynch/Bayesian2020/tree/master/_data/LinkBarkerChapter7.pdf)
* [Tenan et al. 2014](https://github.com/hlynch/Bayesian2020/tree/master/_data/TenanEtAl2014.pdf)

Whereas DIC is analogous to AIC, Bayes Factors are analogous to likelihood ratios. We can extend Bayes theorem to compare multiple models as follows:

$$
\frac{P(M_{1}|D)}{P(M_{2}|D)} = \frac{P(M_{1})P(D|M_{1})}{P(M_{2})P(D|M_{2})} = \frac{P(M_{1})}{P(M_{2})} \times \frac{P(D|M_{1})}{P(D|M_{2})}
$$

(The denominators involved have canceled, see McCarthy.) The term on the left hand side is the odds ratio. The first term on the right-hand-side is simply the ratio of the prior probability of Model 1 vs. Model 2. The second term on the right-hand-side is known as the “Bayes factor”. (This is similar to the likelihood ratio, but the LR is based on those parameters that **maximize** the likelihood, whereas the Bayes factor **integrates** over the parameter priors.) So this equation works out to be

$$
\mbox{posterior odds} = \mbox{Bayes factor} \times \mbox{prior odds}
$$

In the very simplest case in which you are comparing two point hypotheses (in other words, comparing two models which postulate different point estimates for the parameter in question), the Bayes factor works out to be the likelihood ratio. However, generally speaking, we have to integrate over the prior distribution under each model, e.g., 

$$
P(D|M_{1}) = \int p(D|\theta_{M1})P(\theta_{M1})d\theta
$$

Noting that this is the same as

$$
P(D|M_{1}) = \int p(D,\theta_{M1})d\theta
$$

we can see that what we have done is **calculate the marginal probability of the data by integrating out the value of the parameter**. Even in fairly simple cases, evaluating the Bayes factor can be difficult, because it often has to be done numerically.

Where does parsimony come into this? While we tend to take it for granted that the simplest model is always preferred (all else being equal), there is nothing sacred about this, and sometimes you might prefer the more complex model because it includes covariates that you think are biologically relevant even if the data would not otherwise support its inclusion in the best model. Bayes Factors will automatically select for the simpler model (see Jefferys and Berger [1992]), but additionally parsimony can be included in this framework by placing a higher prior probability on smaller models. Likewise, if you think a covariate should be included, but aren’t absolutely stuck on including it at any cost, you may give higher prior weights to models that include this covariate. If the data suggest that the models with this covariate are so much worse than the ones without it, that the posterior probability for the models will tell you that. You could be leaning one way before the model fitting, but allow overwhelming evidence to tilt you another way.

##A quick step back: What are the goals of model selection?

Its worth pausing for a minute to discuss what the goals of model selection are. If you are considering different models, you really have two options. Option #1 is to find the one “best” model, and use that as “the model” for your data. Option #2 is to weight the models in some way and to base your inference on the set of models and their relative model weights. This latter option is akin to calculating AIC model weights and doing weighted averages for model parameters.

##Bayesian model averaging

We’ve talked on a number of occasions about model averaging approaches, and we can do model averaging in a Bayesian context using the posterior model probabilities. Lunn et al. discuss the difference between “M-closed” situations – in which the true process generating the data is assumed to be in the model set – and “M-open” situations in which one does not believe that any of the models being compared are strictly true. Strictly speaking, Bayesian model averaging assumes truth is in the model set, because the posterior model probabilities really are interpreted as a probability that a model is true. You can also do model averaging using the DIC, just as we did in Biometry using AIC model weights, except that now we are not interpreting the model weights as a probability of model truth, rather we interpret these as a measure of predictive ability. (In other words, model averaging proceeds the same way whether we use the posterior model probabilities or DIC model weights, but the interpretation is different.)

Lunn et al. also introduce a bootstrapping approach to Bayesian model averaging. 

1) sample with replacement from the original data
2) choose the best-fitting model according to some criterion
3) repeat a large number of times
4) if a model is selected as the best model r$\%$ of the time, we can interpret that as the model probability $p(M|\mbox{data})$

I haven’t seen this done in ecological practice and while Lunn et al. provide a couple of references (but only a couple!), its not clear that this approach is actually used very often. This might be worth exploring if you find yourself doing Bayesian model selection, but I don’t think its well developed enough to be used without careful consideration. 

##Beyond Bayes Factors

Unfortunately, Bayes Factors can be difficult to calculate, and so they are rarely used to compare large numbers of models. In many cases, it is better to include the model selection process into the initial Bayesian model. In other word, instead of fitting two models and post hoc deciding which is better, we include both models in the MCMC sampling and allow the samplers to jump between the two models (remember Metropolis-Hastings?). One of the strategies for doing this is called Reversible Jump MCMC (RJMCMC), and it basically allows for “proposals” both within a model (proposals of new parameters) and between models (i.e. you can make jumps between models). In practice this gets a bit complicated, and so we won’t go into more detail. If you do end up going down this road of Bayesian model selection, RJMCMC is worth exploring further. 

##Variable selection for nested models

If you have a comprehensive model with many covariates, and your interest is in paring this down to a smaller set of covariates to make the most parsimonious model, that you can use another trick developed by Kuo and Mallick. This procedure is described in nice detail by Darren Wilkinson on his blog, which I have posted on Bb for you to read. 

##Prior-data conflict

What do we do if the prior and the data do not agree? Perhaps you have an informative prior based on previous work, but it occupies almost non-overlapping parameter space with the data you have in hand? In these cases you have to be careful, as you can end up with posteriors that are \emph{between} the prior and the likelihood, but representing \emph{neither} the prior nor the likelihood. (Lunn et al. cite Stephen Senn’s characterization of this: “a Bayesian is someone who, suspecting a donkey and catching a glimpse of what looks like a horse, strong concludes he has seen a mule”.)

One solution (see Lunn and references therein) is to choose a prior that is a mixture distribution of the informed prior and an uninformative prior; in a vague sense this will force the Bayesian model to choose between these two competing prior (informed vs vague). In practice, this is well into messy Bayesian territory; the actual details here would likely take you so far astray of the science you are interested in that it may be time to go back to the beginning and think about the modeling approach from scratch.

For more information about this week's topic
------------------------

* [Ohara and Sillanpaa 2009](https://github.com/hlynch/Bayesian2020/tree/master/_data/OharaSillanpaa2009.pdf)
* [Jeffreys and Berger 1992](https://github.com/hlynch/Bayesian2020/tree/master/_data/JeffreysBerger1992.pdf)
