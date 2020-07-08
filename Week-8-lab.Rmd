Week 8 Lab
========================================================

In lab we are going to work through several examples of fitting GLMs using data from the breeding bird survey program. The data you have been given (BBS data for NY.csv) is, as the name implies, the summary of BBS data for the state of NY. For those not familiar with the BBS data, what we have are essentially counts of individuals recorded along transect surveys. The first two columns of the dataset are the Year and the number of Routes completed (which is related to effort). The other columns are for each species recorded in NY state.

**Exercise #1**: We are going to do a traditional Poisson regression to look at the change in abundance of the Northern Bobwhite: 

$$
Count_{i} \sim \mbox{Pois}(\lambda_{i}) \\
log(\lambda_{i}) = \alpha + \beta*Year_{i}
$$
I suggest centering the Year covariate by subtracting off some middle value, like 1990. (Doesn’t matter, just have to back transform when you plot the results.)

To illustrate the model fit, we will plot four things:

(1) The original data. 
(2) The best fit line, which we find by taking the mean of

$$
exp(\alpha[k]+\beta[k]*Year_{i})
$$

where $k=1,2,\dots,\mbox{number of posterior samples}$.

(3) The Bayesian credible interval, which we find by taking the (2.5,97.5) quantiles of 

$$
exp(\alpha[k]+\beta[k]*Year_{i})
$$

(4) The Bayesian prediction interval, which we find by taking the (2.5,97.5) quantiles of 

$$
\mbox{Pois}(exp(\alpha[k]+\beta[k]*Year_{i})
$$
If you plot these draws as little tiny dots (pch=”.”) than you can see the spread of predicted values and the data at the same time. 

**Exercise #2**: In the same spirit of last week’s problem set, we will now model a larger number of species. Since the entire dataset might take some time to fit, let’s go with all the species up to and including the Northern Bobwhite (so the first 17 columns). We will, for the time being, assume completely independent parameters for each species.

$$
Count_{ij} \sim \mbox{Pois}(\lambda_{ij}) \\
log(\lambda_{ij}) = \alpha_{j} + \beta_{j}*Year_{i}
$$
($i$ is the Year, $j$ is the species)

Plot the data and a sample of the results (enough to convince yourself the code works). Question: What is the difference between this and doing 17 different regressions?

**Exercise #3**: We will now do a hybrid between the first two approaches, by modeling the species-specific slopes as being drawn from a distribution. This is a classic hierarchical Bayesian problem.

$$
Count_{ij} \sim \mbox{Pois}(\lambda_{ij}) \\
log(\lambda_{ij}) = \alpha_{j} +\beta_{j}*Year_{i} \\
\beta_{j} \sim N(\mu_{\beta},\sigma_{\beta}^{2})
$$
Gelman and Hill’s description of such models is quite good. What we have done in going from the second model and the third is reduce the number of parameters from 34 (17 for $\alpha$ and 17 for $\beta$) to 19 (17 for $\alpha$ and 2 for $\beta$).

Plot the data and a sample of the results (enough to convince yourself the code works).  

**Exercise #4**: So far we have been ignoring variation in effort across years. One way of accounting for this is to use an offset, as described in Kery Section 14.3. Using the number of Routes instead of Area (see Kery page 190), include log(Route.Count) as a covariate to your hierarchical model from Exercise #3. How are the coefficients to be interpreted when including this new term? Does including effort as a covariate change the biological interpretation of your results?


