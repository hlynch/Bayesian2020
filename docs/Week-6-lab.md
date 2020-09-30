Week 6 Lab
========================================================

This week we’re going to get our feet wet with JAGS by building some simple models familiar from Biometry.

We’ll start by using the template you were given in Week #1 when we were testing your JAGS installation (Week 1 JAGS test.R). I suggest copying that file over to a new folder for this week’s lab.

(Side note: For the next few weeks, we’ll be sort of sloppy with our initial values. You can set the initial values to just about anything that’s in the range of the prior and the model will work fine. However, once we get into more complex models, the choice of initial values is more important. We’ll discuss this again later in the semester. Just keep in mind that our “set it and forget it” approach early in the semester is not best practice.)

The first thing we’re going to do is demonstrate how Bayesian models, implement in JAGS, can be used to fit statistical distributions. In this case, we have the benefit of ‘fitdistr’ and all the other tools learned in Biometry, so we can check whether JAGS is actually working correctly.

Fitting a distribution
-----------------------

Use R to draw 100 values from a Beta(2,5) distribution, save those values as a .csv, and modify the template JAGS file to estimate the parameters of this distribution. (We’ll assume that we know its from a beta distribution, we just don’t know the parameters.) **You’ll need to think carefully about what the prior should be for the two shape parameters. What is their range?**

**Question #1**: Does your Bayesian model agree with ‘fitdistr’?

**Question #2**: What happens to the posterior distribution as you reduce the number of simulated data points to 50, to 10, to 2? (You can just sub-sample from the initial set of values.)

To get some intuition for what the burn-in is doing, you might try setting burn in to something very small and making your initial values very incorrect. If you plot the chains, you should be able to see the model moving from the initial values to the correct values. It is that portion of the chain (the transients) that we aim to eliminate by setting a burn-in period.

One-way ANOVA
-----------------------

Here we are going to use a small dataset found [here](https://github.com/hlynch/Bayesian2020/tree/master/docs/seaslug.csv). This study has been published: Krug, P.J. and R.K. Zimmer. 2000.  Larval settlement: chemical markers for tracing production, transport, and distribution of a waterborne cue. Marine Ecology Progress Series, vol. 207: 283-296.

From the data source:
\emph{Sea slugs, which live along the Southern California coast, produce thousands of microscopic larvae each year. These larvae locate and settle onto a patch of vaucherian seaweed, before developing into sea slugs. The accompanying data file is from a pilot study on the ability of sea slug larvae to detect this kind of seaweed at different tide heights.  Instead of randomly swimming until they find this seaweed (as was previously believed), these larvae actually "smell" the seaweed when they are passing over it in the water.  They do this, it is believed, by detecting chemicals that slowly leach out of the seaweed.  This study attempts to support this theory by analyzing the ability of larvae to distinguish the smell of this seaweed just as the tide is coming in -- when the chemicals are most concentrated -- and at high tide -- when the chemicals are more dilute due to the rising tide.}

Description of the data: 
\emph{Just before the tide came in, one water sample containing filtered sea water was collected away from the patch of seaweed.  This sample is the control (it is coded 99).  Once the tide washed in, water samples were collected above a patch of vaucherian seaweed every five minutes, for a total of thirty minutes.  Each of these samples was then divided into six, so that there are six replicates for each time point.  There are seven time points (0-30 minutes) so there are a total of 42 observations, excluding the control.  The control was divided into five replicates.}  

\emph{Fifteen slug larvae were then injected into each of the replicates, and the percentage of larvae that metamorphosed was recorded.  This percentage is a function of the ability of the larvae to detect the chemicals from the seaweed.}

I’ve added a column for “Group” to the original dataset and put it in the folder for this week’s lab (seaslug.csv). Its worth noting that in the original experiment, there were not exactly 15 seaslugs in each treatment (some would die before undergoing metamorphosis, etc.). While this experiment nominally lends itself to a Binomial model, the data provided are just percentages (we have no data on final sample sizes in each treatment group). We will keep things simple for now and model the percentages with a Normal distribution. 

There are many ways to fit an ANOVA model. Let's start by writing a script to fit this model

$$
Y_{i} \sim N(\mu_{i},\sigma^{2})
$$
where $Y_{i}$ is the percentage of sea slugs that metamorphosed in Group $i$.

When you get the code working, you should end up with estimates of the mean percentage for each group of sea slug and the standard deviation $\sigma$.

**Question #3**: Is the Normal distribution really appropriate here? What other distribution might we use that would be better? Amend the model with a more appropriate distribution for the data.

**Question #4**: Our model has been set up to estimate the average percentage for each group. No “contrasts” were defined, so our posterior distributions for each group do not lend themselves to testing any particular hypothesis. What would be a more appropriate way to write this model? Amend your model from Question #3 with a more appropriate contrast. (Note that Bayesian models make it really easy to track variables of interest in the model rather than post hoc. Be sure to write your model so that you get a posterior distribution for the quantity [or contrast] of interest.)

