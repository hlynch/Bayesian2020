Week 7 Lab
========================================================

This week we’ll be using a [dataset](https://github.com/hlynch/Bayesian2020/tree/master/_data/PLOSdataConcord.csv) on flower phenology that was published in [PLOS ONE](https://github.com/hlynch/Bayesian2020/tree/master/_data/EllwoodEtAl2013.pdf). Please read the paper so you have some context for the modelling that we will be doing. (NB: The temperature data for 1894 was missing, and I have replaced it with the mean temperature from the other years just for the purposes of doing the lab.)

This is as good a time as any to introduce some of the R packages designed to help you plot and evaluate MCMC chains produced by JAGS.  Download the [‘coda’](https://cran.r-project.org/web/packages/coda/index.html) package in R and read through the manual. There is another newer package called [‘MCMCvis'](https://cran.r-project.org/web/packages/MCMCvis/index.html) written by a former PhD student of mine Casey Youngflesh that has many nice features as well.

Exercise: Write a script to use JAGS to fit a linear regression model to the flower data. In other words, write a JAGS script to fit the following model:

$$
Y_{i} \sim N(\alpha + \beta*MAMTemp_{i},\sigma^{2})
$$

where $i$ is an index for a particular year. You can choose any flower you wish to focus on. (Copy and paste code, summary of parameters, and relevant plots.) 

**Question #1**: Is there a statistically significant relationship between mean temperatures and flowering date? (Note that, when doing a Bayesian analysis, we are not strictly involved in “hypothesis testing” (e.g., we have no null model, no p-values, etc.). However, in a loose mapping between Bayesian approaches and frequentists approaches, data analysts will often use overlap between the credible interval and zero [or other null value] as a measure of “statistical significance”.)

**Question #2**: Plot the data, the best-fit regression line, and the confidence and prediction intervals.

