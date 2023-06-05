# Multi-Group-SEM Networks

This technique arose from the econometric literature (Rigobon 2002) and leverages naturally occuring groups (school years, states, neighborhoods, etc) where groups are expected to differ in their exogeneous influences, but assumed identical in their fundemental (structural) model, confounders and measurement error.


- [Here is an interactive notebook](https://github.com/MichelNivard/3-causal-sem-models/blob/main/Identification_of_causal_effects_through_heteroskedasticity_in_a_multi_group_SEM.ipynb) you can run chunk by chunk in google colab
- I this folder are the scripts we used in our paper for monte-carlo simulation, you can adapt these to figure otu whether at your sample size and with your group structure to evaluate whether the model suits you.

In psychological sicence its unlikely that groups are identically confounded or have identical measurement error therefore we also discuss ways in which specific errors, confounders and network parameters can be freed betwen groups. An obvious further development would be to combine the first two techniques and use Adaptive Lasso to shrink violations of equalities betwene groups to arrive at a model that is identified yet allows hetrogeneity betwene groups.

essential references and reading:

**Original method:** Rigobon, R. (2003). Identification through heteroskedasticity. Review of Economics and Statistics, 85(4), 777-792.

**Package we used:**
lavaan Rosseel, Y. (2012). lavaan: An R Package for Structural Equation Modeling. Journal of Statistical Software, 48(2), 1-36. https://doi.org/10.18637/jss.v048.i02
