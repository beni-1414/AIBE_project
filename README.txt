PREPROCESS - R
##################

This step was performed using R. Initially we had 700000 subjects and 14 variables. Variables are:

  - Index
  - ID
  - Age
  - Gender
  - Height
  - Weight
  - Systolic pressure max value
  - Systolic pressure low value
  - Cholesterol
  - Glucose
  - Smoke
  - Alcohol
  - Active
  - Cardiovascular disease

First of all we added a BMI variable, divived Age by 365 as initially it was given in days, and Indez and ID were eliminated.

Using boxplot outlier functions we eliminated a total of 1819 subjects due to non-credible values.

Finally investigation to get which gender is Male or Female we plotted mean values of height and weight, correctly predicting it.


