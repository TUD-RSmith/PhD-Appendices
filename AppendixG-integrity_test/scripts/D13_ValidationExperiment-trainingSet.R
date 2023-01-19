############################################################################################################
## Validation Experiment
## Robert Smith 16 Jan 2023
## Algorithms: Apriori
## Data: 
#        D13_trainingData.csv
#
############################################################################################################


## 1 setup packages, import data
library("rJava")
library("rCBA")
library("arules")
library("arulesViz")
library(stringr)
library(dplyr)
library(tidyverse)
library("tidyr")


TData <- read.csv("./data/D13_TrainingSet.csv", fileEncoding="UTF-8-BOM")

head(TData)
summary(TData)


## 2 Create Transactions
names(TData)
T_cols <- c("NMF_Body_Twist"      ,"NMF_Body_LEAN"          ,"NMF_Body_Shoulder"     ,"NMF_Body_back"        ,
          "NMF_Body_forward"     , "NMF_Body_latral"       ,"CA"                ,"NMF_Cheeks"           ,
          "NMF_EyeAp_SQ"         , "NMF_EyeAp_blink"       ,"NMF_EyeAp_WD"          ,"NMF_EyeAp_CLOSED"     ,
          "NMF_Eyebrows_Raised"  , "NMF_Eyebrows_Furrowed" ,"NMF_Eyegaze_camera"    ,"NMF_Eyegaze_dn"       ,
          "NMF_Eyegaze_up"       , "NMF_Eyegaze_sr"        ,"NMF_Eyegaze_sl"        ,"NMF_Eyegaze_Inter"    ,
          "NMF_Eyegaze_dh"       , "NMF_Eyegaze_nd"        ,"NMF_Eyegaze_hands"     ,"NMF_Head_TILT"        ,
          "NMF_Head_TURN"        , "NMF_Head_PUSH"         ,"NMF_Head_Nod"          ,"NMF_Head_Shake"       ,
          "NMF_Head_back"        , "NMF_Head_forward"      ,"NMF_Head_latral"       ,"VP_gc"                   ,
          "VD_gc"                   , "VI_gc"                    ,"Viloc_gc"                 ,"VIDir_gc"                ,
          "V.fs_gc"   )

#Use lapply() to coerce and replace the chosen columns:
TData[T_cols] <- lapply(TData[T_cols], factor)

T_trans <- as (TData, "transactions")

#-- Run rules for Apriori ----------------------------------------------------------------
    T_rules <- apriori(T_trans, parameter=list(support=0.01, confidence=0.1, maxlen=2, maxtime=10))
    T_rules <- unique(T_rules) #remove duplicate rulesAp
    #define a consequent
    #  T_rules_Depict <- subset(T_rules, subset = rhs %pin% "Depicting_pres")
    #  inspect(T_rules_Depict)
    #add IMs
    
    #reduce rules set size (for processing), by filtering out low lift rules. 
    T_rules <- subset(T_rules, subset = lift > 1.2)
    
    quality(T_rules)$lift <- interestMeasure(T_rules, measure="lift", trans = T_trans)
    quality(T_rules)$conviction <- interestMeasure(T_rules, measure="conviction", trans = T_trans) 
    quality(T_rules)$cosine <- interestMeasure(T_rules, measure="cosine", trans = T_trans) 
    quality(T_rules)$jaccard <- interestMeasure(T_rules, measure="jaccard", trans = T_trans) 
    quality(T_rules)$Fisher <- interestMeasure(T_rules, measure="fishersExactTest", trans = T_trans)
    quality(T_rules)$hlift<- interestMeasure(T_rules, measure="hyperLift", trans = T_trans)
    quality(T_rules)$hconf <- interestMeasure(T_rules, measure="hyperConfidence", trans = T_trans)
    quality(T_rules)$chiSquared <- interestMeasure(T_rules, measure="chiSquared", trans = T_trans)
    #round((T_rules)$Fisher, digits=3)
    
#------Output ---------------------------------------------------------------------- 
    #Force R not to use exponential notation (e.g. e+10)
    Apriori_D13_train = format(T_rules,scientific=FALSE) 
    
    #refactor to dataframe
    Apriori_D13_train <- as(T_rules,"data.frame")
    #split LHS from RHS
    
    Apriori_D13_train <- Apriori_D13_train %>%
      separate(rules, c("Antecedent", "Consequent"), "=>")
    head(Apriori_D13_train)
    
    #filter output by pvalue
    Apriori_D13_train <- filter(Apriori_D13_train, Fisher<0.5)
    
    #round column values to remove exponent numbers 
    Apriori_D13_train$Fisher <- round(Apriori_D13_train$Fisher, digits = 3)
    Apriori_D13_train$hlift <- round(Apriori_D13_train$hlift, digits = 3)
    Apriori_D13_train$hconf <- round(Apriori_D13_train$hconf, digits = 3)
    
    #All rules
    write.csv(Apriori_D13_train,"./Output/D13_rules_trainingSet.csv", row.names = FALSE);
    
    
#-------visualization-----------------------------------------------------------
   
    
    ruleExplorer(T_rules.sub)
    
   