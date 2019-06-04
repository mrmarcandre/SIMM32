* Encoding: UTF-8.

DATASET ACTIVATE DataSet1.
USE ALL.
FILTER BY AGE_new.
EXECUTE.

DATASET ACTIVATE DataSet1.
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA selection 
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT pain
  /METHOD=ENTER age STAI_trait pain_cat cortisol_serum mindfulness weight Sex_New.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) BCOV R ANOVA
  /CRITERIA=PIN(.05) POUT(.10) CIN(95)
  /NOORIGIN 
  /DEPENDENT pain
  /METHOD=BACKWARD age STAI_trait pain_cat cortisol_serum mindfulness weight SEX_new


REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS BCOV R ANOVA SELECTION
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT pain
  /METHOD=ENTER age pain_cat cortisol_serum mindfulness
  /SCATTERPLOT=(*ZRESID ,*ZPRED)
  /RESIDUALS HISTOGRAM(ZRESID).

*New data set 2*

DATASET ACTIVATE DataSet2.
RECODE sex ('female'=0) ('male'=1) INTO SEX_new.
EXECUTE.

COMPUTE Pred_theory=4.449+(-0.076*age)+0.008*STAI_trait+0.068*pain_cat+0.397*
    cortisol_serum+(-0.231 *mindfulness)+(-0.263*SEX_new).
EXECUTE.

COMPUTE Pred_backward=4.623+(-0.079*age)+0.073*pain_cat+0.393*cortisol_serum+(-0.224 
    *mindfulness).
EXECUTE.

COMPUTE Theory_residual=pain - Pred_theory.
EXECUTE.

COMPUTE Backward_residual=pain - Pred_backward.
EXECUTE.

COMPUTE Theory_residual_Sq=Theory_residual * Theory_residual.
EXECUTE.

COMPUTE Backward_residual_Sq=Backward_residual * Backward_residual.
EXECUTE.

DATASET ACTIVATE DataSet2.
DESCRIPTIVES VARIABLES=Theory_residual_Sq Backward_residual_Sq
  /STATISTICS=MEAN SUM STDDEV MIN MAX.


