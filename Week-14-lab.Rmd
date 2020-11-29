Week 14 Lab
========================================================

We are going to redo the analysis by Ward (2008) but using the same time series we worked on a couple of weeks ago on [voles](https://github.com/hlynch/Bayesian2020/tree/master/_data/vole_data.txt) and other times series provided by Clark et al. (2010).

I want you to fit the four different population models used by Ward: 

*(1)* Geometric model

$$
N_{t+1} = N_{t}(1+r)
$$
*(2)* Logistic model

$$
N_{t+1} = N_{t} + r N_{t}\left(1-\frac{N_{t}}{K}\right)
$$

*(3)* Theta-logistic model

$$
N_{t+1} = N_{t} + r N_{t}\left(1-\left(\frac{N_{t}}{K}\right)^{\phi}\right)
$$
*(4)* model with decreased growth rate at low density

$$
N_{t+1} = N_{t} + r N_{t}\left(\frac{(N_{t}-a)(K-N_{t})}{K^{2}}\right)
$$
I want you to fit these models using both likelihood and Bayesian methods, assuming log-normally distributed observation error only. (You have most of the code already from previous exercises.)

Using AICc, BIC, and DIC, compare the four models for the vole dataset. Do they rank the four models in a consistent way? If not, why not? Does the effective number of parameters $p_{D}$ for DIC seem reasonable?

Do a posterior predictive check using a metric of fit of your choice. What test statistic might be relevant here?
