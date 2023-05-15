# 3-causal-sem-models

This repo describes three structural equation models (SEM) in which, based on cross sectional data, **(cyclical) networks** and **latent variable** models are identified. Because the models can, if assumptions are met, deal with endogeneity (i.e. the fact that frequntly most or  all variables in psychological models are potentially exposure and outcome and cannot easily be experimentally issolated) they are especially **well suited for causal inference in psychological sciences.**

You should probably be falmiliar witht he following techniques/concepts if you want to feel competent and confident applying these models to emperical data, but do not let that hold you back from browsing this repo and trying the interactive notebooks.

- structural equation modeling, or SEM (here is a [youtube](https://www.youtube.com/watch?v=fGdsiugwO0k&list=PLliBbGBc5nn3m8bXQ4CmOep3UmQ_5tVlC) course, here are [SEM basics in R](https://bookdown.org/njenk001/discovering_structural_equation_modeling_using_stata/) based on asn oldder book to refresh or learn) 
- Lavaan as its the SEM software on which most models in this repo are (loosly) based, here is an online [book chapter](https://bookdown.org/jdholster1/idsr/structural-equation-modeling.html) here a [list of tutorials and materials](https://lavaan.ugent.be/resources/teaching.html).
- instrumental variable (IV) analysis (here is a GREAT [book chapter](https://theeffectbook.net/ch-InstrumentalVariables.html) here is a [tutorial](https://rpsychologist.com/adherence-analysis-IV-brms) that actually also does IV in SEM.
- shrinkage estimatators/penalties ([general intro](https://www.datasklr.com/extensions-of-ols-regression/regularization-and-shrinkage-ridge-lasso-and-elastic-net-regression), and a [tutorial](https://www.mdpi.com/2624-8611/3/4/38) as applied in SEM).


## Technique 1: Adaptive lasso instrumental variable SEM.

In this technique we leverage insturmental variables to identifiy causal paths. instrumental variables are exogeneous variables (often sudden unanticipated shocks) that influence one of the endogeneous psychological variables you are interested in, and can teen be used to ID causal effects your variable of interest has on other variables even if there are confounders or measurement error provided 3 assumptions hold:

1.  The insturmental variable (IV) causes the exposure variable
2.  The IV isnt correlated with any confounders
3.  The IV doesnt cause the outcome *other than trough the exposure*

Especially assumption 2 and 3 can be problematic in the contex of psychological reseach. However, if we have multiple instruments (perhaps even many!) we can use adaptive lasso shrinkage to distill a set of valid intruments from a larger set of instruments in which up to 50% can de invalid.

- Here is the R script illustrating this technique
- [Here is an interactive notebook you can run](https://github.com/MichelNivard/3-causal-sem-models/blob/main/Adaptive_Lasso_instrumental_variable_structural_equation_model.ipynb) chunk by chunk in google colab
- Here are the scripts we used in our paper for monte-carlo simulation, you can adapt these to figure otu whether at your sample size and with your instruments and their expected effect this model makes sense.

expanssions/challenges to the model we considered

- A script for the model in the presense of confounders or measurement error.

essential references and reading:

**Adative Lasso and IV:**
Windmeijer, F., Farbmacher, H., Davies, N., & Davey Smith, G. (2019). On the use of the lasso for instrumental variables estimation with some invalid instruments. Journal of the American Statistical Association, 114(527), 1339-1350.

**Adative Lasso in SEM:**
Jacobucci, R., Grimm, K. J., & McArdle, J. J. (2016). Regularized Structural Equation Modeling. Structural Equation Modeling: A Multidisciplinary Journal, 23(4), 555–566. https://doi.org/10.1080/10705511.2016.1154793

**Package we used:**
Orzek J (2023). lessSEM: Non-Smooth Regularization for Structural Equation Models. R package version 1.4, https://github.com/jhorzek/lessSEM.

**Other R packages that could fit the bill:**
lavaan Rosseel, Y. (2012). lavaan: An R Package for Structural Equation Modeling. Journal of Statistical Software, 48(2), 1-36. https://doi.org/10.18637/jss.v048.i02
regsem: Jacobucci, R. (2017). regsem: Regularized Structural Equation Modeling. ArXiv:1703.08489 [Stat]. https://arxiv.org/abs/1703.08489
lslx: Huang, P.-H. (2020). lslx: Semi-confirmatory structural equation modeling via penalized likelihood. Journal of Statistical Software, 93(7). https://doi.org/10.18637/jss.v093.i07

## Technique 2: Identification through heterokedasticity in a multi-group SEM

This technique arose from the econometric literature and leverages naturally occuring groups (school years, states, neighborhoods, etc) where peopel are exected to differ in their exogeneous influences, but remain identical in their fundemental (structural) model, cponfoudners and measurement error.

- Here is the R script illustrating this technique
- [Here is an interactive notebook](https://github.com/MichelNivard/3-causal-sem-models/blob/main/Identification_of_causal_effects_through_heteroskedasticity_in_a_multi_group_SEM.ipynb) you can run chunk by chunk in google colab
- Here are the scripts we used in our paper for monte-carlo simulation, you can adapt these to figure otu whether at your sample size and with your group structure to evaluate whether the model suits you.


In psychological sicence its unlikely that groups are identically confounded or have identical measurement error therefore we developed a cross betwene this modle and the adaptive lasso introduced in the first model which alows for (penalized/shrunken) between group differences in the variance attributable to a confounder.confounders and betwene group differences in mesasurement error.

- Here is the R script illustrating this expansons of the technique
- Here is an interactive notebook you can run chunk by chunk in google colab of the exanded technique.





