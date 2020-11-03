Week 11 Lab
========================================================

In this lab, we're going to gain some practice fitting models with (1) only observation error, (2) only process error, and (3) observation AND process error together. Let's stop and remind ourselves why this distinction is so important. 

Let's assume we have a simple exponential growth model for a population of fish (or cats, or humans, or money, whatever).

$$
N_{t} = N_{0}e^{rt}
$$
which equates to the following "regression-type" linear model on logged abundance (unless I specify otherwise, we're always using natural logs since we usually need to "undo" the exponential).

$$
log(N_{t}) = log(N_{0})+rt
$$

On the log-scale, this is now a straightforward linear regression model, with $log(N_{0})$ as the intercept and $r$ as the slope. (I could have chosen to model this differently, see Box 1 at end, but here I will do everything on the log scale for mathematical simplicity.)

If I assume I **only** have observation error, then the model can be written as

$$
log(N_{t,obs}) \sim N(log(N_{t}),\sigma^{2}_{obs})
$$

or, equivalently

$$
log(N_{t,obs}) \sim N(log(N_{0})+rt,\sigma^{2}_{obs})
$$

and I assume that "deviations" from the expected value of $log(N_{0})+rt$ are due to observation error. (Implicitly, this is what we do when we do linear regression; the residuals of the model can be thought of as observation error.) In other words, we assume the true abundance really is $log(N_{0})+rt$ and we chaulk up any disparity in the measured value in year to an error in the measurement of abundance in year $t$. Since that measurement error in year $t-1$ has no influence on the measurement in year $t$, the predicted value in year $t$ is just $log(N_{0})+rt$ or, alternatively, $log(N_{t-1})+r$. 

In sum, we can write this model in two ways, (1) as before, where time $t$ is the predictor

$$
log(N_{t,obs}) \sim N(log(N_{0})+rt,\sigma^{2}_{obs})
$$
or (2) using the previous state

$$
log(N_{t,obs}) \sim N(log(N_{t-1})+r,\sigma^{2}_{obs})
$$

On the other hand, if you assume that our measurements are perfect (no observation error), then the difference between what you were expecting and what you measured must be due to variation in the value of $r$ itself. (Process error could involve stochasticity on any demographic parameter but here I am assuming stochastic variation on $r$ specifically.)  That means that if your measured value in year $t$ was larger than expected, than it really was truly larger, and the expected value in year $t+1$ would also be larger. In this case, we \emph{have} to write the model as

$$
log(N_{t,obs}) = log(N_{t}) \sim N(log(N_{t-1})+r,\sigma^{2}_{proc})
$$
Process error \emph{compounds} (like interest on a bank account) whereas observation error does not. In this case, we cannot (easily) write the model as a function of $N_{0}$ and $t$.

In practice, we often build models that assume both observation and process error, and the task is to distinguish how much of the variation is due to each component. This is sometimes quite difficult to do.

In lab, we are going to start with the simple logistic model, which adds to the exponential growth model a term for density-dependence. In other words, the model looks like

$$
N_{t+1} = N_{t}e^{r\left(1-N_{t/K}\right)}
$$
We have added a new parameter, which is the carrying capacity $K$.

At the end, we’ll move on to a variation of the logistic model called the theta-logistic model. As you’ll see, while the simple logistic model is fairly straightforward to fit (i.e. no major convergence issues), the theta-logistic model is exceptionally hard to use, as is described in some detail by Clark et al.

Simple logistic
----------------

With the simple logistic model described above, we will work through the process of fitting (1) observation error only models, (2) process error only models, and (3) observation and process error models. 

The observation error only model can be easily fit using both likelihood methods and Bayesian methods. For the observation+process error model, we will jump straight to the Bayesian approaches, noting that Bolker describes a Kalman filter approach that could be used if we wanted to stick with likelihood-based methods. (This is a classic example of a problem that is quite difficult to solve using likelihood methods, but which is rather straightforward to solve using Bayesian methods.)

##Observation-error-only model

**Exercise #1**: The equations representing an observation-error only model (assuming the simple logistic equation is responsible for the year-to-year dynamics of the population and assuming log-normally-distributed observation error) are given by

$$
log(N_{t,obs}) \sim N(log(N_{t}),\sigma^{2}_{obs}) \\
log(N_{t}) = log(N_{t-1})+r*\left(1-\frac{N_{t-1}}{K}\right)
$$
Notice that if you combine the two statements above into one equation

$$
log(N_{t,obs}) \sim N(log(N_{t-1})+r*\left(1-\frac{N_{t-1}}{K}\right),\sigma^{2}_{obs})
$$
Here you have a statement that is the likelihood for a single observed abundance. In other words, if you observe abundance $N_{t,obs}$, then dnorm applied to the above expression yields the likelihood for year $t$. The product of likelihoods across all years in your time series would yield the joint likelihood for the entire dataset.

What to do with $t=0$ (the first data point)? A reasonable model for this would be

$$
log(N_{0,abs}) \sim N(log(N_{0}),\sigma^{2}_{obs})
$$
where $N_{0}$ (i.e. true abundance in year 0) is a free parameter the model will estimate. How many parameters do you have?  There are 5 total: $r$, $\theta$, $K$, $\sigma^{2}_{obs}$ and somewhat less obviously, $N_{0}$. How many likelihoods are being multiplied together? You have 30 data points (assuming you simply impute the missing datapoint) so there will be 30 PDFs multiplied together, 29 of which will take the form of Eq. 1 and then one more for the first year (Eq. 2).

**Exercise #1**: Fit this model using JAGS. Plot the posterior mean and 95th credible intervals for $N_{t}$ on the original data. Plot scatterplots of the posterior chains for r vs K– do we have correlations among these two parameters?

##Process-error-only model

A process-error only model assuming the simple logistic equation is responsible for the year-to-year dynamics and assuming normally-distributed process error. 

$$
N_{t,obs} = N_{t} \\
log(N_{t} \sim N\left(log(N_{t-1})+r*\left(1-\frac{N_{t-1}}{K}\right),\sigma^{2}_{proc}\right)
$$
What to do with $t=0$ (the first data point)? In this case there is no observation error so the first year has no uncertainty, it is the value measured ($N_{0,obs} = N_{0} = 8$). So your likelihood has only 29 terms in it, starting at $t=1$. (Your statistical model is now for **transitions** between one year and the next, and there are only 29 transitions.) How many parameters do you have now?  There are now 4 total: $r$, $\theta$, $K$, and $\sigma^{2}_{obs}$ . As before, we will fit this model using JAGS, but make sure you understand how you would fit this model using maximum likelihood as well.

**Exercise #2**: Fit the process error only model using JAGS. Plot the posterior mean and 95th credible intervals for  on the original data. Plot scatterplots of the posterior chains for r vs K– do we have correlations among these two parameters? (Note that your best fitting model now "connects the dots" of the data. Does it make sense to you why this would be? With no observation error, your model has to connect the data by construction.)

Note that JAGS does not allow you to have your data on the left side of an assignment operator, as it will throw an error similar to “XXX is a logical node and cannot be observed”, so you cannot write your JAGS code in the way you would write the equations by hand

$$
N_{t,obs} \rightarrow N_{t} \\ 
\mbox{This will throw an error in JAGS!!}
$$
In this case, we have to find a way to write the model so the data is on the left hand side of a probability distribution, and we can do that by combining the process model and observation model as follows:

$$
log(N_{t,obs}) \sim N\left(log(N_{t-1})+r*\left(1-\frac{N_{t-1}}{K}\right),\sigma^{2}_{proc}\right)
$$

Make sure you understand why this is equivalent to the original model description.

But wait! This looks nearly identical to the observation only model above (Eq. 1)! How are these different you say? In this specific case, we have modelled observation error and process as being normally distributed on the log-scale, and as such they are in fact identical models. The interpretation of the  terms are different (and they would be different in simulation, see below), but the estimates will be the same. 

##Process-error and observation-error together

**Exercise #3**: Write a JAGS script to fit a model with both process error and observation error. Plot the posterior mean and 95th credible intervals for  on the original data. Plot scatterplots of the posterior chains for r vs K– do we have correlations among these two parameters? How about when we plot $\sigma^{2}_{proc}$ vs $\sigma^{2}_{obs}$? You should find $\sigma^{2}_{proc}$ and $\sigma^{2}_{obs}$ strongly correlated with one another. This reflects the fundamental non-identifiability of this model. There is not enough information for the model to distinguish process error and observation error because both are modeled in the same way and so it cannot distinguish them. While such non-identifiability is fairly easy to see from the model itself, in more complex models it is not always easy to see when parameters are non-identifiable, and so plotting posteriors against each other is a good way to check whether parameters are simply “trading off” in the MCMC chains.

Final thoughts
----------------

In the example provided at the beginning of lab, we modelled observation error on the log scale as follows

$$
log(N_{t,obs}) \sim N(log(N_{t}),\sigma^{2}_{obs})
$$
We can have, alternatively, modelled observation error on the linear scale

$$
N_{t,obs} \sim N(N_{t},\sigma^{2}_{obs})
$$

How to choose? It comes down to which you think better captures the observation error process. For example, if you are counting a group of birds and your counting procedure is highly accurate but birds keep running in and out of the study area, you might want to model observation error on the linear scale. However, if your process has a certain error percentage (i.e. $\pm15\%$) than perhaps the observation is better modelled on the log-scale.
