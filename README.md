# Masters Paper
A look at how rest impacts results in soccer and tennis. 

## Soccer
We look at 4 different models to see whether the number of days since a previous match has an effect on the probability of winning:
* Poisson GLM
* Bivariate poisson
* Linear model for goal difference
* Proportional odds ordered logit

## Tennis
We use a logistic GLM model to evaluate the effect of previous match length on winning probability. We explore different ways of controlling for player ability.

# Folders
* EDA: includes a quick look into the tennis covariates.
* Figures: Makes figures and tables for the paper.
* data-processing: Cleans the data and manipulates it into modelable form.
* writing: rmd file for the paper and intermediate versions.
* models: files in which the models are built.
* Masters_Paper_Chloe.key/pdf: presentation of the work given on 11/01/18

# Data
* Soccer: The data comes from the engsoccerdata R package.
* Tennis: The data was found on kaggle. https://www.kaggle.com/gmadevs/atp-matches-dataset
