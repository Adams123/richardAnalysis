library(boot)
library(tibble)
library(glmnet)
library(coefplot)
library(MuMIn)
library(sjPlot)
library(performance)
library(dplyr)
library(pROC)
library(graphics)
library(caret)
library(rlist)


INPUT_FILE = "input_data.csv"
important_cols = c("q1_1", "dmt_0" ,"q2_2", "q3_1", "q4_sobrenatural","q5_ufo10___1","q6_1")

independentes = c("q1_", "dmt_", "q2_")
dependentes = c("q3_", "q4_", "q5_", "q6_")
