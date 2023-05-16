# Three causal SEM models

This repo describes three structural equation models (SEM) in which, based on cross sectional data, **(cyclical) networks** and **latent variable** models are identified. Each model imposes a set of additional constraints on the data to identify these causal processes. Because the models can, if assumptions are met, deal with endogeneity (i.e. the fact that frequntly most or  all variables in psychological models are potentially both exposure and outcome and cannot easily be experimentally issolated) they are especially **well suited for causal inference in psychological sciences.** Not all models are devleoped by us, do no cite our work as the original source unless you are describing a specific SEM implementation we developed or atributes we added to a model that are novel, rather cite the original source or ideally both.

If you want to feel competent and confident applying these models to emperical data, you should probably be familiar with the following techniques/concepts, but do not let that hold you back from browsing this repo, trying the interactive notebooks and learning new concepts.

- structural equation modeling, or SEM (here is a [youtube](https://www.youtube.com/watch?v=fGdsiugwO0k&list=PLliBbGBc5nn3m8bXQ4CmOep3UmQ_5tVlC) course, here are [SEM basics in R](https://bookdown.org/njenk001/discovering_structural_equation_modeling_using_stata/) based on asn oldder book to refresh or learn) 
- Lavaan as its the SEM software on which most models in this repo are (loosly) based, here is an online [book chapter](https://bookdown.org/jdholster1/idsr/structural-equation-modeling.html) here a [list of tutorials and materials](https://lavaan.ugent.be/resources/teaching.html).
- instrumental variable (IV) analysis (here is a GREAT [book chapter](https://theeffectbook.net/ch-InstrumentalVariables.html) here is a [tutorial](https://rpsychologist.com/adherence-analysis-IV-brms) that actually also does IV in SEM.
- shrinkage estimatators/penalties ([general intro](https://www.datasklr.com/extensions-of-ols-regression/regularization-and-shrinkage-ridge-lasso-and-elastic-net-regression), and a [tutorial](https://www.mdpi.com/2624-8611/3/4/38) as applied in SEM).

## What this repo offers

1. Code to reproduce the analyses in our preprint
2. Interactive notebooks and clean R scripts implementing each of the causal structural equation models. the notebooks have a button to open them in google colab (free) where you could run them chunk by chunk whih looks like this: <img style="text-align: center;" width="139" alt="image" src="https://github.com/MichelNivard/3-causal-sem-models/assets/11858442/a806df6d-a771-4255-bf52-c65aa0674675">
3. For those we don't like notebooks are are unfamilair we also have clean scripts in which the model is run once on simulated data.

## Technique 1: Adaptive lasso instrumental variable SEM.

In this technique we leverage insturmental variables to identifiy causal paths. instrumental variables are exogeneous variables (often sudden unanticipated shocks) that influence one of the endogeneous psychological variables you are interested in, and can teen be used to ID causal effects your variable of interest has on other variables even if there are confounders or measurement error provided 3 assumptions hold:

1.  The insturmental variable (IV) causes the exposure variable
2.  The IV isnt correlated with any confounder of the relatino betwene exposure and outcome
3.  The IV doesnt cause the outcome *other than through the exposure*

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

This technique arose from the econometric literature (Rigobon 2022) and leverages naturally occuring groups (school years, states, neighborhoods, etc) where groups are expected to differ in their exogeneous influences, but assumed identical in their fundemental (structural) model, confoudners and measurement error.

- Here is the R script illustrating this technique
- [Here is an interactive notebook](https://github.com/MichelNivard/3-causal-sem-models/blob/main/Identification_of_causal_effects_through_heteroskedasticity_in_a_multi_group_SEM.ipynb) you can run chunk by chunk in google colab
- Here are the scripts we used in our paper for monte-carlo simulation, you can adapt these to figure otu whether at your sample size and with your group structure to evaluate whether the model suits you.

In psychological sicence its unlikely that groups are identically confounded or have identical measurement error therefore we also discuss ways in which specific errors, confounders and network parameters can be freed betwen groups. An obvious further development would be to combine the first two techniques and use Adaptive Lasso to shrink violations of equalities betwene groups to arrive at a model that is identified yet allows hetrogeneity betwene groups.

essential references and reading:

**Original method:** Rigobon, R. (2003). Identification through heteroskedasticity. Review of Economics and Statistics, 85(4), 777-792.


**Package we used:**
lavaan Rosseel, Y. (2012). lavaan: An R Package for Structural Equation Modeling. Journal of Statistical Software, 48(2), 1-36. https://doi.org/10.18637/jss.v048.i02


## Technique 3: multi comoment SEM (MCMSEM)

In previous work we have linked causal inference based on higher order moments (which itself is based on a long reseach tradition, for references see below) and a causal SEM model. In the current pre-print we introduce a straightforward mutlivariate extension.

- Here is the R script illustrating this technique
- [Here is an interactive notebook](https://github.com/MichelNivard/3-causal-sem-models/blob/main/Multi_comoment_structural_equation_model_(MCMSEM).ipynb) you can run chunk by chunk in google colab
- Here are the scripts we used in our paper for monte-carlo simulation, you can adapt these to figure otu whether at your sample size and with     your group structure to evaluate whether the model suits you.

In psychological sciences measurement base don scales means that the moments of the measured data quite possibly refects scale as much as it relfects the moments of the underlying constructs. We sugest where necessary first applying an (IRT) measurement model that retain the moments of the undferlying trait could offer a solution.

essential references and reading:

**Original method:** Tamimy, Z., van Bergen, E., van der Zee, M. D., Dolan, C. V., & Nivard, M. G. (2022). Multi Co-Moment Structural Equation Models: Discovering Direction of Causality in the Presence of Confounding.

**Software we used:** currently you can experimetn with the development version of MCMSEM, it requires torch and is under active development https://github.com/zenabtamimy/MCMSEM/tree/dev-torch a specific issue with the use of torch is that results change form CPU to CPU or from GPU to GPU, however the speedup on GPU can be dramatic. 

## cautionary notes

All three models come in the form of deceptively "simple" models/scripts, however their identification fully relies on imposing constraints  that need to be fully grounded in theory and should be the core focus of any scientific application of these models. As outlined in the pre-print, the models come in the form of SEM models, which means they can be integrated with longitudinal, growth, developmental, measurement, and within person/EMA models.

These models are all fairly power hungry so we simulate and explore analyses with anywhere from 5000 to 80.000 simulated observations. These coud be 5000 individuals, or potentially be 14 days of 5 daily brief experience sampling measures for 500 people for a total of 5*14*500 = 35.000 observations. Where it should be nioted any extensions longitudinal or even EMA data aren't currently outlined in this repo but are fairly obvious (though potentially complex, challenging and tedious to implement).

In the emperical application of all three models a huge burden falls on the reseacher to get the assumptions and constraints that are imposed right. Read the original work, evaluate the assumptions, where possible let prior theory inform you on constraints and do not default to letting the algorithm choose the constraints for you. Be sceptical of the models you evaluate. Getting the nuanced constraints you will need to impose on the data wrong is far easier then getting them right.

Some vital concern with these models, especially when applied to cross sectional data deserve highlighting:

**Cyclic causal effect** where A causes B and B causes A, are hard to intepreted. If there is an effect A -> B, and then later in time B -> A, we may pick up both in cross sectional data with these models, though if we measured before B -> A then we wont pick it up. We will be unsure of when the effects played otu, whethery they were a pulse (one time only effect) or a constant static effect. The timescale at which effects play out isnt resovlved easily either, and so to make further inferences on the timescale across whiche ffects play out, reseachers would still require repeated measures data and would need to adapt these models of use iin tht context. 

**Unmodeled features** unmodeled measurent issues like scale ceiling & floor effects or aquescence; and unmodeled samplign issues like selective particiaption or dropout, **WILL** influence the data, if left unmodelled these may bias causal parameter estimates or model comparison. There are no shortcuts nor is there certainty you did get a handle on them. What you can do is faithfully and rigorously model know issues to the best of your ability. 

