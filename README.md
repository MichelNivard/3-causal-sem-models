# 3-causal-sem-models

This repo describes three structural equation models (SEM) in which, based on cross sectional data, **(cyclical) networks** and **latent variable** models are identified. Because the models can, if assumptions are met, deal with endogeneity (i.e. the fact that frequntly most or  all variables in psychological models are potentially exposure and outcome and cannot easily be experimentally issolated) they are especially **well suited for causal inference in psychological sciences.**

You should probably be falmiliar witht he following techniques/concepts if you want to feel competent and confident applying these models to emperical data, but do not let that hold you back from browsing this repo and trying the interactive notebooks.

- structural equation modeling, or SEM (here is a youtube course, here an online book to refresh or learn)
- instrumental variable analysis (here is a tutorial, here is a longer piece).
- shrinkage estimatators/penalties (applied in SEM)


## Adaptive lasso instrumental variable SEM.

In this technique we leverage insturmental variables to identifiy causal paths. instrumental variables are exogeneous variables (often sudden unanticipated shocks) that influence one of the endogeneous psychological variables you are interested in, and can teen be used to ID causal effects your variable of interest has on other variables even if there are confounders or measurement error provided 3 assumptions hold:

1.  The insturmental variable (IV) causes the exposure variable
2.  the IV isnt correlated with any confounders
3.  the IV doesnt cause the outcome *other than trough the exposure*

Especially assumption 2 and 3 can be problematic in the contex of psychological reseach. However, if we have multiple instruments (perhaps even many!) we can use adaptive lasso shrinkage to distill a set of valid intruments from a larger set of instruments in which up to 50% can de invalid.

- Here is the R script illustrating this technique
- Here is an interactive notebook you can run chunk by cunk in google colabl
- Here are the scripts we used in our paper for monte-carlo simulation, you can adapt these to figure otu whether at your sample size and with your instruments and their expected effect this model makes sense.
