Week 7 Lecture
========================================================

Last week I hope I convinced you that Bayesian methods are preferred even for the very simplest problems you could do in your sleep using the skills learned in Biometry. In other words, Bayesian methods aren’t just for hard problems – they are for easy problems too. This week, we’ll continue working on relatively simple models, i.e. linear regression.

By way of brief review, the basic problem to be addressed in simple linear regression is:

$$
Y \sim N(\mu,\sigma^{2}) \\
\mu = \alpha+\beta X
$$
where Y is the response, and X is a (generally continuous) covariate that we think influences the value of the mean $\mu$. There are three parameters to be estimated here, $\alpha$, $\beta$, and $\sigma^{2}$, although the last is usually not of direct interest.

Using JAGS to do simple regression is straightforward. Using the example from McCarthy, in which Tree Density was used as a covariate influencing the response of Course Woody Debris, the model part of the code looks like


```r
CWD[i] ~ dnorm(mu[i],prec)
mu[i]<-alpha+beta*TreeDens[i]
```

That’s it! 

Since we are already familiar with the basics of regression from Biometry, and will get some practice with the models themselves on Wednesday. I’ll just go over a few points that differentiate Bayesian regression modeling from what you already know from Biometry.

One such difference is in the process of predicting a value from the fit model or, in the same vein, getting a prediction interval from a regression model. Remember the horrible complicated formulas from Biometry? (If not, McCarthy provides a reminder in Box 5.2.) We don’t have to fuss with any of this using Bayesian methods because the posterior distributions for the parameters $\alpha$, $\beta$, and $\sigma^{2}$ provide everything we need.

What is the predicted value of CWD at TreeDens=1500? There are really two ways to do this. The first way is to plug in the posterior means for $\alpha$ and $\beta$ (which I’ll call $\hat{\alpha}$ and $\hat{\beta}$) as follows:

$$
\widehat{CDW}_{\mbox{mean predicted at 1500}} = \hat{\alpha} + \hat{\beta}*1500
$$
This approach is perhaps the most intuitive, but it is also wrong. Why? By collapsing the information in the posteriors for $\alpha$ and $\beta$ to their posterior means, we ignore any correlations between the samples for $\alpha$ and $\beta$. Its better to sample from the posteriors directly to build up a posterior distribution for $CWD_{1500}$. In other words, just sample from the posterior of $\alpha$, sample from the posterior from $\beta$, and plug those samples into

$$
CDW_{\mbox{mean predicted at 1500}} = \alpha_{\mbox{sample}} + \beta_{\mbox{sample}}*1500
$$
If you put this in a loop and do this, say, 1000 times, then you create a posterior distribution for predicted $CWD$ at TreeDens=1500. The posterior mean is the better estimate of $\widehat{CDW}_{\mbox{1500}}$. Not only that, but now you have more information, because you have the entire posterior distribution. Using this we can directly extract the 95th percentile credible interval. This is analogous to the **confidence interval** from Biometry. In other words, the uncertainty here stems directly and only from the uncertainty in the parameters. To get a **prediction interval**, we need to go one step further and draw samples from

$$
CDW_{\mbox{predicted at 1500}} \sim N(CDW_{\mbox{mean predicted at 1500}},\sigma^{2}_{\mbox{sample}})
$$

Just as before, we should sample from the posterior for $\sigma^{2}$, and not just use the posterior mean. We can do this in JAGS by just adding the calculation to the code; for each sample from the posteriors for $\alpha$, $\beta$, and $\sigma^{2}$, we can sample from this distribution. Since this is done at each iteration of the chain, we end up with a posterior distribution describing the prediction interval. It is generally far better to anticipate what you will want out of the model and have the model calculate this as it samples than to try and **post hoc** propagate all the uncertainities.

Note that there is yet a third way of getting predictions, and that is to include those X values of interest as **missing data** in the original model fit. In other words, if you want a prediction interval for X=1500, add the data point (1500,NA) to the data. JAGS will use the model to fill in the missing data, which is precisely what a prediction interval is anyways.

Class projects
-----------------
For the rest of lecture, we will go over your project proposal. Keep in mind that your proposal is just that, a proposal. You are free to make changes as needed, just as you would with any research project. 

We’ll get into groups of three. Send your proposal to your two classmates so everyone has a copy of each proposal. Discuss each proposal in turn, using the following as guiding questions:

1.	Is this potentially publishable? (Hopefully, yes! Many of the projects from the last two Bayesian classes were published, and the goal should be to finish a publication-worthy analysis.)
2.	What is the model? (Specifically, with equations.) Does everyone understand the model?
3.	What data are available? 
4.	What are the parameters of interest? Is there a specific hypothesis to be tested?
5.	What is the most appropriate distribution for the response data?
6.	Are there going to be missing data? Data can be imputed, so missing response data can be addressed.
7.	Is the focus on understanding past phenomena or predicting future behavior?
8.	Are there other papers in the literature (in your field) that have used similar methods? If not, why not? 

