Week 14 Lab
========================================================

We are going to redo the analysis by Ward (2008) but using the same time series we worked on a couple of weeks ago on [voles](https://github.com/hlynch/Bayesian2020/tree/master/_data/vole_data.txt) and other times series provided by Clark et al. (2010).

I want you to fit two of the four different population models used by Ward: 

*(1)* Geometric model

$$
N_{t+1} = N_{t}(1+r)
$$
*(2)* Logistic model

$$
N_{t+1} = N_{t} + r N_{t}\left(1-\frac{N_{t}}{K}\right)
$$

I want you to fit these two models using both likelihood and Bayesian methods, assuming log-normally distributed observation error only. (You have most of the code already from previous exercises.)

Using AICc, BIC (which we didn't cover in lecture but is discussed on page 216 of Hobbs and Hooten), and DIC, compare the two models for the vole dataset. (You might find the code in [this](https://ihrke.github.io/post/2014/10/07/dicjags/) blog post helpful.) Do they rank the models in a consistent way? If not, why not? Does the effective number of parameters $p_{D}$ for DIC seem reasonable?

Do a posterior predictive check using a metric of fit of your choice. What test statistic might be relevant here?
