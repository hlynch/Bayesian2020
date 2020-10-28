Week 10 Lab
========================================================

On Monday, we introduced the idea of data imputation. As a reminder, the real issue here is when we have missing covariates. In a Bayesian context, missing responses are easy handled without any extra effort because the data are assumed to have been derived from a sampling distribution anyways, so missing data are simply sampled at each iteration. On the other hand, we need to think a bit more carefully about missing covariates, and in lecture we discussed several strategies for doing so.

To gain some practice with various methods for data imputation, we are going to use the phenology dataset from Week #7. As it was, I imputed a missing value for 1894 for Week #7. Not only will we replace that missing data with an “NA” but we will further degrade the dataset by removing other Temperature values. 

*The 1894 value should be permanently removed for all exercises. We will create 4 degraded datasets.

Degraded dataset #1 (Missing completely at random): Remove 9 values completely at random (and replace with “NA”).

Degraded dataset #2 (Missing at random): Assume missingness declines over time.

$$
\mbox{Missing} \sim \mbox{Bernoulli}(p) \\
\mbox{logit}(p) = -0.09*year
$$

You can ensure that you get 9 sampled values by passing your vector of years to the "sample()" function in R and use the probabilities calculated above as weights to that sample function. Note that the sample() function will automatically reweight the probabilities as needed, and using the sample() function you can specify that you want to select 9 Years. (In other words, sample() is just telling you \emph{which} 9 years to select.)

Degraded dataset #3 (Depends on unobserved predictors): Assume all odd numbered years Blue Hill was run by an idiot, and those data have a 75% chance of missingness, and all even numbered years have a 0% chance of missingness.

Degraded dataset #4 (Depends on itself): Assume the following model:

$$
\mbox{Missing} \sim \mbox{Bernoulli}(p) \\
\mbox{logit}(p) = -0.35*TempMAM
$$
You can use the same basic procedure as above, using the sample() function.

We will use four methods of imputation on each of the four degraded datasets.

**Method #1**: Replace with the mean

**Method #2**: Sample with replacement

**Method #3**: Fit a model to the observed cases (you are free to choose the model, keeping in mind that the responses [flowering dates] can be used as predictors when imputing covariates; how might we use multivariate techniques here?) and use the expected value for imputation.

If you were using Flowering Date to model MAMTemp, your model would look like

$$
\mbox{MAMTemp} \sim N(\beta_{0} + \beta_{1}*FD,\sigma^{2})
$$
Note that you need not use the same flower to impute MAMTemp as the flower you are actually focused on. In other words, let's say that Amelanchier canadensis is the focus of your phenology study. To impute missing MAMTemp covariates for this model, you may want to find that species that has the strongest correlation with MAMTemp, since this will provide the best predictions of MAMTemp. You don't need to do that here, but hopefully you understand why you might do this in a real analysis. Here you can use any model for MAMTemp (including one just based on Year).

**Method #4**: Same as #3 but using prediction error as well. In other words, if you used the model suggested above, here you are drawing an imputed value from

$$
\mbox{MAMTemp} \sim N(\beta_{0}+\beta_{1}*FD,\sigma^{2})
$$
rather than just taking the expected value $\beta_{0}+\beta_{1}*FD$.

Once you have your four imputed datasets, run the model you created for the Week #7 lab (one species only). Create a 4x4 table of the 95th percentile posterior CIs (Degradation Method $\times$ Imputation Method) for the slope parameter (i.e. the rate at which phenology is shifting over time). Do any of the imputation methods work better than any others? How might you define “better”?
