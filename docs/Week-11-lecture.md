Week 11 Lecture
========================================================

We have some more topics to cover in terms of model comparison and hypothesis testing, but first we will cover state-space models so that we can discuss model comparison in terms of various models for population dynamics.

‘State-space’ is a generic term used for any kind of modeling in which the observed variables pass between different states. These are often time series models, in which the states are the different time periods of measurement, or they may represent the transitions between different life stages of an animal (for existence). Bolker talks about “dynamical models”. In this case, the states are assumed to represent time. These would be considered a subset of state-space models. (You might further specify that a model is stage-structured or age-structured…regardless, the process of fitting such models is very similar.) 

We will discuss a tiny slice of state-space models, which is their application to abundance time series. This is where ecological theory meets statistical modeling.

Dynamical (time series) models
-------------------------------

I will follow Ben Bolker’s treatment of the subject quite closely, because it is well laid out and it covers both likelihood methods and Bayesian methods. 

The basic situation is as follows:

$$
N_{t+1,obs} = f(N_{t+1}) \\
N_{t+1} = g(N_{t})
$$

\emph{Different types of error:}

**Observation error**:  Involves the actual observation or measurement process. Observation error does not feed back into the dynamics of the system because the dynamics involve only the true state.

**Process error**:  Involves variation in the dynamical process. I don’t really like the term “error” here, because there is no error involved. (For this reason, some authors call it process noise.) Process error simply refers to variation in the dynamics not otherwise explained by the model (and possibly unexplainable if there is some genuine stochasticity)

<div class="figure" style="text-align: center">
<img src="StateSpaceModel.png" alt="Diagram of a state space model" width="75%" />
<p class="caption">(\#fig:unnamed-chunk-1)Diagram of a state space model</p>
</div>

If you were to simulate 1000 time series from a process-error only model, the time series would diverge over time. By contrast, if you simulated 1000 time series from a model with only observation error, the time series occupy a “band” of constant width over time. Do you see why this is? The process errors accumulate over time because the error in one year affects the dynamics in the next year. Observation errors do not affect the real state of the system, and thus do not accumulate over time.

Some vocabulary is in order here. If you are measuring the state of the system with error, then the true state $N_{t}$] is called a ‘latent’ state. We use the term ‘latent state’ to describe any hidden state which can only be inferred indirectly through observation. 

##Process error

First, some ecological modeling background to get us started. The Ricker model is a classic population dynamics model that accounts for density-dependence in population growth (population growth slows as the density increases). Ricker’s model for population growth is given as

$$
N_{t+1} = N_{t}e^{r(1-N_{t}/K)}
$$
where $r$ is the population growth rate and $K$ is the ‘carrying capacity’. If we explicitly include process error in our formulation, we have at least two choices on how to do so. We could add Normally-distributed error to the effective population growth rate in the exponent; in this case, Ricker’s model looks like

$$
N_{t+1} = N_{t}e^{r(1-N_{t}/K)+\epsilon}
$$
where

$$
\epsilon \sim N(0,\sigma^{2})
$$
If we take the log of both sides

$$
log(N_{t+1}) = log(N_{t}) + r\left(1-\frac{N_{t}}{K}\right)+\epsilon
$$
and rewrite as

$$
log(N_{t+1}) \sim N\left(\mbox{log}(N_{t}) + r\left(1-\frac{N_{t}}{K}\right),\sigma^{2}\right)
$$
we see that process error of this type assumes $N_{t}$ log-normally distributed.

Another way of writing this would be

$$
N_{t+1} = N_{t}e^{r(1-N_{t}/K)+\epsilon} = N_{t}e^{r(1-N_{t}/K)e^{\epsilon}}
$$
Note that $E[e^{\epsilon}] \neq 1$, so $E[N_{t+1}] \neq N_{t}e^{r(1-N_{t}/K)}$ as you might think (or want, if you are building the model). For this reason, people often add a correction factor (see Hilborn and Mangel pg. 146).


Another way of adding process error would be to assume

$$
N_{t+1} = N_{t}e^{r(1-N_{t}/K)}+\epsilon \\
\epsilon \sim N(0,\sigma^{2})
$$
or, equivalently,

$$
N_{t+1} = N(N_{t}e^{r(1-N_{t}/K)},\sigma^{2})
$$
There are no strict rules about how process error should be modeled (or when); such details would be included in the description of a model. The former approach would be called ‘log-normally distributed process error’, whereas the latter would be called ‘normally distributed process error’.


To see how all this gets applied in practice, we will walk through the example provided in McCarthy on mountain pygmy possums. The key elements of the biology are as follows:

*	we will build a model that lumps all age-classes together into a single population. In other words, there will be no age- or stage-structure included in the model, although doing so would be a rather straightforward modification of the code. (Stage- and age-structured models are fairly easy to code, but unless there is a lot of information of the abundance of each stage or age, they can be quite difficult to fit...)
*	female pygmy possums are highly territorial, so we need to include density dependence. We do this here using a Ricker model: $N_{t+1} = N_{t}e^{r(1-N_{t}/K)}$, although there are many ways you might want to do this, and various models can be compared as we will discuss next week.
*	Pygmy possums have small population sizes, and thus experience demographic stochasticity. In other words, just by random chance, their populations can fluctuate, and these fluctuations can be important when population sizes are small. We will use the Poisson distribution to model their abundance. (Side note: Abundances are discrete and non-negative and so a Poisson is an obvious choice. However, abundances are often quite large and are frequently modeled with a continuous distribution such as a Normal. The advantage of a Normal distribution is that you can model the variance independent of the mean. The downside is that a normal distribution does not enforce non-negativity, and for this reason, the log-normal is often used.)

The model that McCarthy suggests is the following:

$$
N_{t+1} \sim \mbox{Pois}(\lambda_{t+1}) \\
log(\lambda_{t+1}) = log(N_{t}) + r\left(1-\frac{N_{t}}{K}\right) + \epsilon \\
\epsilon \sim N(0,\sigma^{2})
$$
and the code for fitting this in WinBUGS/JAGS is included in Box 9.1.
(I have changed his notation to be consistent with the activities in the lab on Wednesday.)

Note that McCarthy added some Normally distributed process error to account for environmental variation not otherwise included in the model. 

* Walk through the code in Box 9.1 – any questions?

Note that this model ONLY models process error, there is nothing here to deal with observation error. We would have to layer on top of this a model for the observed counts as a function for the true count. We will discuss some ways of doing that now.

##Observation error

Observation models also come with a lot of choices, but usually these are more closely linked to information you have because you probably know something about the way in which the data were collected. As above, you could be choosing between log-normally distributed or normally distributed errors. Alternatively, you may have some other observation process altogether (Binomial, Poisson, etc.).

Note that in ecology, observation models for an abundance often assume that the number of counted individuals is some fraction of the true number of individuals, such as

$$
N_{t+1,obs} \sim \mbox{Binom}(N_{t+1},\theta)
$$
This will not work when there are false positives or double counting or some other "failure mode" for your observations that does not fit into this Binomial framework. 

Other kinds of state=space models
-----------------------------

Clark and Bjornstad is a classic paper on state-space models. Let’s walk through their discussion on epidemiological models since they represent a different flavor of state-space models that the ones we have been discussing. These so-called S-I-R models track the number of individuals that are S=Susceptible to a disease, I = Infected with a disease, and R=Recovered from a disease (we usually assume no reinfection after recovery). Like all state-space models, the hard part is just getting accounting right, and working out the transition rates or flow of individuals among different states.

The number of susceptible individuals in Year $t$ is given by

$$
S_{t} = S_{t-1} + B_{t-1} - I_{t,new}
$$
where $B_{t-1}$ is the number of births in the previous year (these are newly susceptible individuals) and $I_{t}$ is the number who are infected in the current time step and are therefore no longer in the susceptible category. The probability of infection in Year $t$ is modeled with a Binomial

$$
I_{t,new} \sim \mbox{Binom}(S_{t-1},\phi_{t-1})
$$
where $\phi_{t-1}$ is the transmission rate

$$
\phi_{t-1} = \beta_{t} \times \frac{I_{t-1,new}}{N_{t-1}}
$$
and $\beta_{t}$ is the constant of proportionality between the transmission rate and the fraction of the population that is infected. (Here we have assumed that your probability of being infected increases as the fraction of infected persons in the population also increases.) Clark and Bjornstad, in their modeling of measles, model $\beta_{t}$ as varying bi-weekly, since they found that the transmission rate depended strongly on whether schools were in or out of session. I am leaving $\beta_{t}$ as a function of year because this is the more general formulation.

Because not all infections are reported, we model reported infections as a Binomial draw from the true number of infections, with the probability $\rho$ being the detection probability (from a health services perspective).

$$
I_{t,new,obs} \sim \mbox{Binom}(I_{t,new},\rho)
$$
Note that in fitting this model, Clark and Bjornstad use a slightly informative prior for $\rho$. This is precisely when Bayesian methods become most useful, because you might have good information on reporting rates in other epidemics that can inform the data at hand.

Note that Clark and Bjornstad do not actually track the total number of infected individuals, which would require some accounting like:

$$
I_{t} = I_{t,new}-R_{t}
$$
In their case, they have only (imperfect) observations on newly infected individuals, and are not keeping track of the total number of infected individuals (as you might, for example, when modeling HIV in which regular surveys are conducted to assess infection status).

State-space models can get arbitrarily complicated, and are limited almost exclusively by the quality and quantity of data you have to fit the models. 

Missing data
---------------

One of the most important take-home messages from Clark and Bjornstad has to do with the way that missing data can be accommodated in state-space models:

<div class="figure" style="text-align: center">
<img src="ClarkBjornstad.png" alt="From Clark and Bjornstad" width="75%" />
<p class="caption">(\#fig:unnamed-chunk-2)From Clark and Bjornstad</p>
</div>

