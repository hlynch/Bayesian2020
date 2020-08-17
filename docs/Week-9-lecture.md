Week 9 Lecture
========================================================

Papers to read this week:

* [Gelman and Hill Chapter 11](https://github.com/hlynch/Bayesian2020/tree/master/_data/GelmanHillChapter11.pdf)
* [Gelman and Hill Chapter 16](https://github.com/hlynch/Bayesian2020/tree/master/_data/GelmanHillChapter16.pdf)
* [Nice et al. 2014](https://github.com/hlynch/Bayesian2020/tree/master/_data/NiceEtAl2014.pdf)
* [Nice et al. 2014 Appendix A](https://github.com/hlynch/Bayesian2020/tree/master/_data/NiceEtAl2014AppendixA.pdf)

I've also assigned the paper below. This paper is quite long but it is worth reading through quickly and in parts slowly and carefully, because it nicely explains hierarchical modelling in a non-science context (baseball) that may be more accessible than some of the other readings above. 
* [Kruschke and Vanpaemel 2015](https://github.com/hlynch/Bayesian2020/tree/master/_data/KruschkeVanpaemel2015.pdf)

Hierarchical models are simply models in which model parameters themselves have a statistical distribution. Another definition would be the one provided by Gelman and Hill “…multilevel models are extensions of regression in which data are structured in groups and coefficients can vary by group”. We were introduced to the simplest version of hierarchical models in Biometry when we discussed random effects models. Random effects models are hierarchical models, but the latter term encompasses much more complicated models than can be fit using ‘lmer’ or related functions in R.

Let’s say that you are modeling survivorship of fish in five different watersheds $(i = 1,2,3,4,5)$.

$$
S_{i} \sim \mbox{Bern}(p_{i})
$$
You have three choices:

1) Model each of the five watersheds independently. You have to estimate a survivorship probability $p_{i}$ for each of the watersheds. This is analogous to treating ‘watershed’ as a ‘fixed effect’. (I use this terminology now but for reasons discussed in Gelman and Hill, I will drop these terms once you understand the basic idea behind hierarchical modeling.)

2) Lump all the data together, ignore any differences between watersheds, and estimate just one survivorship probability $p$ for the aggregated dataset.

3) Model the parameters as belonging to some distribution, for example, maybe a normal distribution

$$
logit(p_{i}) \sim N(\mu,\sigma^{2})
$$

Now you have to estimate two parameters, $\mu$ and $\sigma^{2}$, which is fewer than Option #1 but less than Option #2. 

There are many advantages to modelling parameters as being drawn from a common distribution, in addition to the issue of the number of model parameters just described. One such advantage is the idea of “borrowing strength” from groups with large sample sizes to inform estimates of groups with small sample sizes. Let’s say you have one watershed with only three fish data points. Using Option #1, we would have to estimate survivorship using only these three fish. Using Option #3, however, we can constrain the watershed-specific survivorship estimate by saying that it has to fall along some distribution; this hyperparameter distribution may be quite well parameterized by the other four watersheds, and this keeps the estimate for the poorly sampling watershed reasonable.

##The probability of estimability

Hierarchical models are often easy to write down, but sometimes they can be difficult to fit. Parameters in a hierarchical model may become entangled: likelihoods can become ridge-shaped or multimodal.

Example:

$$
Y_{i} \sim N(\theta_{i},\sigma^{2}) \\
\theta_{i} \sim N(\mu,\tau^{2})
$$

What’s wrong with this? This is equivalent to

$$
Y_{i} \sim N(\mu, \tau^{2}+\sigma^{2})
$$

No amount of data is ever going to allow you to separately estimate $\tau$ and $\sigma$.

However, the fact that $\tau$ and $\sigma$ have prior distributions does mean that you will technically be able to run these models, and you will get posterior distributions for $\tau$ and $\sigma$ - you just have to be aware that the data are not contributing to the inference regarding the balance between $\tau$ and $\sigma$ in structuring the overall variability in the data. 

In more complex examples, you may not even be aware that parameters are non-estimable (a.k.a. that the data are not contributing to their estimates). One common way to check if this is happening is to compare the prior to the posterior. If the posterior looks just like the prior, then the data probably hasn’t provided much information. (Though this isn’t fail safe – sometimes the posterior “looks” different from the prior as a statistical artifact of marginalization over another parameter.)

Multilevel modelling ala Gelman and Hill
----------------------------------------

No paper or book does a better job explaining the ins and outs of "multilevel" or "hierarchical" modelling than Gelman and Hill (2007). If you foresee doing any kind of serious hierarchical modelling for your research, I can't recommend more highly buying (and reading) Gelman and Hill. Today we will focus on Chapters 11 and 16.

I'm going to walk through the discussion presented in Gelman and Hill Chapter 11 but using a more ecological example.

Let's say we want to study flowering phenology (a concept we should all be fairly familiar with by now), and we do this by measuring the timing of flowering in 100 plants sampled in each of five New York ecosystems. (In other words, we measuring flowering in 100 plants in the Pine Barrens, another 100 plants in the Adirondacks, etc.). We may have some individual-level predictors such as latitude or spring temperature. In other words, these are predictors that are different for each and every individual (n=500) in the study. 

We have many ways that we could model these data. One way would be a "varying-intercept model":

$$
y_{i} = \alpha_{j[i]} + \beta x_{i} + \epsilon_{i}
$$

(The notation $j[i]$ indicates that this is the group $j$ in which individual $i$ is found.)

How do we read this? This says that the flowering date of each plant ($i$) is modelled as a linear function of a group-level intercept and an individual-level covariate ($x_{i}$) with a shared coefficient $\beta$ (and an individual-level error term). In other words, the full model involves 5 intercepts (one for each ecosystem) and one slope term. Let's assume for now we simply estimate these 5 intercept terms as "fixed effects", and that we do not assume a higher level model such as $\alpha_{j[i]} \sim N(\mu,\sigma^{2})$. [NB: There would be nothing wrong with doing this if we thought it was appropriate.]

We could have used a "varying slope" model:

$$
y_{i} = \alpha + \beta_{j[i]}x_{i} + \epsilon_{i}
$$
Now we would have a single intercept and 5 slopes. The interpretation of this model would be that the relationship between phenology and latitude depends on ecosystem. Make sure this makes sense!

We could have used a "varying-intercept, varying-slope" model:

$$
y_{i} = \alpha_{j[i]} + \beta_{j[i]}x_{i} + \epsilon_{i}
$$
Now we would have 5 intercepts and 5 slopes.

Let's consider for a moment a varying slope model like this

$$
y_{i} = \alpha + \beta_{j[i]}x_{i} + \epsilon_{i}
$$

where we want to further model the slopes as coming from a normal distribution:

$$
\beta_{j[i]} \sim N(\mu, \sigma^{2})
$$
Why might we want to do this? We may want to do this because we have some underlying theory that suggests that the slopes follow a normal distribution. We might want to protect ourselves from getting unreasonable slope estimates for groups that have small amounts of data. (In this case, we posited 100 samples from each ecosystem, so not explicitly a concern.) We might want to explicitly estimate some common "mean slope" that averages together the responses of each individual ecosystem. This allows us to estimate the slope for each ecosystem and get a measure of "average slope" at the same time, and even a measure of variance between ecosystems. 

Let's say this is the model we wanted to fit. You might ask yourself, why not fit the first model

$$
y_{i} = \alpha + \beta_{j[i]}x_{i} + \epsilon_{i}
$$
and then afterwards simply fit a normal distribution to the resulting slope estimates. The reason this is NOT equivalent is that there is no way for the constraint on the slopes to "filter back up" to the slope estimates themselves. Make sure this makes sense! Doing a model like this in two stages is called "doing statistics on statistics" and it is generally frowned upon. Why do two models that don't interact when you could do everything in one integrated model that captures all the information you want simultaneously.

So far we have assumed that the covariates we have are specific to each individual, for example, the exact latitude of each plant. But it may be that covariates come in at the ecosystem level, like species diversity. (I'm not saying I know how species diversity might affect flowering phenology, its just an example of a covariate that comes in at the ecosystem level.) Why does this require special consideration? Let's say that the first few rows of our data might look like

| FloweringDay  | Ecosystem       | Latitude           | Ecosystem Species Diversity  |
|               |                 | (Individual level) | (Group level)                |
| -------- ---- |:---------------:|:------------------:|:-----------:|:--------------:|
| 97            |    PineBarrens  |    40.78           |    120      |                |
| 95            |    PineBarrens  |    40.65           |    120      |                |       
| 103           |    PineBarrens  |    40.62           |    120      |                |
| 107           |    PineBarrens  |    40.81           |    120      |                |
| 92            |    PineBarrens  |    40.60           |    120      |                |
| 101           |   Adirondacks   |    44.13           |    235      |                |

Notice that if we use the varying-slope model, we shouldn't write the model like this:

$$
y_{i} = \alpha + \beta_{j[i]}Lat_{i} + \gamma Diversity_{i} + \epsilon_{i}
$$
but like this:

$$
y_{i} = \alpha + \beta_{j[i]}Lat_{i} + \gamma Diversity_{j[i]} + \epsilon_{i}
$$

Do you understand why? Because the former model involves a type of pseudoreplication, whereby the model assumes that each individual has a unique Diversity whereas this predictor comes in at the ecosystem level. The second way of the writing the model is correct.

*Multilevel modelling simply refers to models in which covariates (a.k.a. predictors) enter the model at different levels. Some predictors will be individual-based predictors, some will be at the group level (there may be many "groups").

*Hierarchical modelling refers to models in which the coefficients (i.e. the things you are trying to estimate) are modelled as having additional distributional assumptions. In other words, there is a hierarchy of models, a model for the data, a model for the parameters, possible a model for the parameters of THAT model, and so forth.

Multilevel modelling and Hierarchical modelling are not the same thing, nor are they unique to Bayesian modelling, but they often go hand in hand because multilevel models are often also hierarchical models. Bayesian methods provide a straightforward approach to these types of models, but by no means the only approach. 

Before moving on, we should be clear that multilevel models are not constrained to nested structures. Imagine for example that you want to add random effects for Ecosystem and for flower "Family" (as in Species, Genus, Family). Family will not be nested in Ecosystem, nor will Ecosystem be nested in Family. That's OK! Random effects for Ecosystem and Family present no problem at all.

$$
y_{i} = \alpha+\beta_{j[i]}\mbox{Lat}_{i} + \gamma \mbox{Diversity}_{j[i]} + \mbox{Ecosystem}_{j[i]} + \mbox{Family}_{k[i]} + \epsilon_{i}
$$
(Just to summarize, at this point we have a single intercept for all plants, a slope for Latitude that depends on which Ecosystem you are in, a random effect for Ecosystem, a random effect for Family, and a residual term.)

## In sum....

We have a lot of freedom to build models in whatever way makes the most sense for the data. We can choose to pool coefficients across groups and have a single coefficient or we can allow each group to have its own coefficient. We can do something intermediate, and enforce a distribution for the coefficients so that each individual or group is allowed to have variation for that coefficient but that variation is modelled as following some distribution with its own parameters to estimate. We can and should model predictors on the scale at which they are measured (individual-level, group-level, etc.). There is no "correct" model.

As a final ‘capstone’ application of Bayesian modeling, we are going to work through analyses by Nice et al. (2014). 

##Nice et al. (2014)

The goal: To understand how weather affects the population dynamics of butterflies, both at the individual species level and also at the community level.

Challenges: Traditional methods make it difficult to assess fluctuations at the species level and the community level simultaneously.

Data: Observations on butterfly presence and absence over 38 year period at Donner Pass. (Response variable was the number of “Day Positives” – the number of days in which a species was recorded as present – treated as a Binomial variable.)

GLM model for “Day Positives”

$$
DP_{ij} \sim \mbox{Binomial}(p_{ij},\mbox{Visits}_{j})
$$
where $i$ = species and $j$ = site.

$$
logit(p_{ij}) \sim \mu_{\mbox{species}_{i}} + \beta_{1species_i} \times \mbox{covariate}_{1_ij} + \beta_{2species_i} \times \mbox{covariate}_{2_ij} + \dots
$$
Species-specific intercepts and coefficients were modeled as

$$
\mu_{\mbox{species}_i} \sim N(\mu_{\mu},\tau_{\mu}) \\
\beta_{\mbox{species}_i} \sim N(\mu_{\beta},\tau_{\beta})
$$
The parameters $\mu_{\mu}$,$\mu_{\beta}$ represent the mean community-level response, and $\tau_{\mu}$,$\tau_{\beta}$ represent how much variation there is at the species level (i.e. between species variation $=1/\tau$).

What are the authors talking about in the paragraph starting with “We then asked if differences among species…” on page 2159?

How do the authors represent their results? See Figures 1 and 2. Which approach do you like better (Figure 1 or 2)? Why? Note that in Table 1 and Figure 3 (and elsewhere), the authors have used the median and not the mean to represent the central posterior value. Why might they have done that? 

For more information about this week's topic
------------------------

Below are papers that use hierarchical modelling in a variety of contexts and address some of the issues that arise in their application:
* [Gerlamn 2006](https://github.com/hlynch/Bayesian2020/tree/master/_data/Gelman2006.pdf)
* [Latimer et al. 2006](https://github.com/hlynch/Bayesian2020/tree/master/_data/LatimerEtAl2006.pdf)
* [Fordyce et al. 2006](https://github.com/hlynch/Bayesian2020/tree/master/_data/FordyceEtAl2011.pdf)
* [Stegmueller 2013](https://github.com/hlynch/Bayesian2020/tree/master/_data/Stegmueller2013.pdf)
* [Ver Hoef et al. 2014](https://github.com/hlynch/Bayesian2020/tree/master/_data/VerHoefEtAl2014.pdf)
* [Hatala et al. 2011](https://github.com/hlynch/Bayesian2020/tree/master/_data/HatalaEtAl2011.pdf)




