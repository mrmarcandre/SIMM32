* Encoding: UTF-8.

DATASET ACTIVATE DataSet1.
RECODE sex ('male'=1) ('female'=0) INTO gender_ref_male.
VARIABLE LABELS  gender_ref_male 'gender_ref_male'.
EXECUTE.

**Linear. mixed model**

MIXED pain BY gender_ref_male WITH age STAI_trait pain_cat cortisol_serum mindfulness
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=gender_ref_male age STAI_trait pain_cat cortisol_serum mindfulness | SSTYPE(3)
  /METHOD=REML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(hospital) COVTYPE(VC).

MIXED pain BY gender_ref_male WITH age STAI_trait pain_cat cortisol_serum mindfulness
  /CRITERIA=CIN(95) MXITER(100) MXSTEP(10) SCORING(1) SINGULAR(0.000000000001) HCONVERGE(0, 
    ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)
  /FIXED=gender_ref_male age STAI_trait pain_cat cortisol_serum mindfulness | SSTYPE(3)
  /METHOD=REML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(hospital) COVTYPE(VC)
  /SAVE=FIXPRED.

DESCRIPTIVES VARIABLES=FXPRED_1
  /STATISTICS=MEAN STDDEV VARIANCE MIN MAX.



*Data set 4*

DATASET ACTIVATE DataSet1.
RECODE sex ('male'=1) ('female'=0) INTO gender_ref_male.
VARIABLE LABELS  gender_ref_male 'gender_ref_male'.
EXECUTE.

*Prediction of pain*

DATASET ACTIVATE DataSet1.
COMPUTE pred_pain= 2.233026 + (-0.382293 * gender_ref_male) + (-0.026097 * Age) + (0.014313 * STAI_trait) + 
    0.081692 * pain_cat + 0.53 * cortisol_serum + (-0.24 * mindfulness).
EXECUTE.

DESCRIPTIVES VARIABLES=pain
/STATISTICS=mean 

COMPUTE Pain_residual=pain-pred_pain
EXECUTE. 

COMPUTE RSS=Pain_residual * Pain_residual.
EXECUTE.

COMPUTE TSS=(pain - 4.99) * (pain - 4.99).
EXECUTE.


DATASET ACTIVATE DataSet1.
DESCRIPTIVES VARIABLES=RSS TSS
  /STATISTICS=MEAN SUM STDDEV MIN MAX.

