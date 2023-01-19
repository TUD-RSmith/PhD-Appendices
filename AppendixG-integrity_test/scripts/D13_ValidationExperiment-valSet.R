############################################################################################################
## Validation Experiment 
## Robert Smith 16 Jan 2023
## Algorithms: Apriori
## Data: 
#        D13_validationSet.csv
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


Vdata <- read.csv("./data/D13_ValidationSet.csv", fileEncoding="UTF-8-BOM")

head(Vdata)
summary(Vdata)

## 2 Create Transactions
names(Vdata)
V_cols <- c("NMF_Body_Twist"      ,"NMF_Body_LEAN"          ,"NMF_Body_Shoulder"     ,"NMF_Body_back"        ,
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
Vdata[V_cols] <- lapply(Vdata[V_cols], factor)

V_trans <- as (Vdata, "transactions")

#-- Run rules for Apriori ----------------------------------------------------------------
    V_rules <- apriori(V_trans, parameter=list(support=0.01, confidence=0.1, maxlen=2, maxtime=10))
    V_rules <- unique(V_rules) #remove duplicate rulesAp
    #define a consequent
    #  V_rules_Depict <- subset(V_rules, subset = rhs %pin% "Depicting_pres")
    #  inspect(V_rules_Depict)
    #add IMs
    
    #reduce rules set size (for processing), by filtering out low lift rules. 
    V_rules <- subset(V_rules, subset = lift > 1.2)
    
    quality(V_rules)$lift <- interestMeasure(V_rules, measure="lift", trans = V_trans)
    quality(V_rules)$conviction <- interestMeasure(V_rules, measure="conviction", trans = V_trans) 
    quality(V_rules)$cosine <- interestMeasure(V_rules, measure="cosine", trans = V_trans) 
    quality(V_rules)$jaccard <- interestMeasure(V_rules, measure="jaccard", trans = V_trans) 
    quality(V_rules)$Fisher <- interestMeasure(V_rules, measure="fishersExactTest", trans = V_trans)
    quality(V_rules)$hlift<- interestMeasure(V_rules, measure="hyperLift", trans = V_trans)
    quality(V_rules)$hconf <- interestMeasure(V_rules, measure="hyperConfidence", trans = V_trans)
    quality(V_rules)$chiSquared <- interestMeasure(V_rules, measure="chiSquared", trans = V_trans)
    #round((V_rules)$Fisher, digits=3)
    
    
#------Output ---------------------------------------------------------------------- 
    #Force R not to use exponential notation (e.g. e+10)
    #Apriori_D13_val = format(V_rules,scientific=FALSE) 
    
    #refactor to dataframe
    Apriori_D13_val <- as(V_rules,"data.frame")
    #split LHS from RHS
    
    Apriori_D13_val <- Apriori_D13_val %>%
      separate(rules, c("Antecedent", "Consequent"), "=>")
    head(Apriori_D13_val)
    
    #filter output by pvalue
    Apriori_D13_val <- filter(Apriori_D13_val, Fisher<0.5)
    
    #round column values to remove exponent numbers 
    Apriori_D13_val$Fisher <- round(Apriori_D13_val$Fisher, digits = 3)
    Apriori_D13_val$hlift <- round(Apriori_D13_val$hlift, digits = 3)
    Apriori_D13_val$hconf <- round(Apriori_D13_val$hconf, digits = 3)
    
    
    #All rules
    write.csv(Apriori_D13_val,"./Output/D13_rules_validationSet.csv", row.names = FALSE);
    
#-------visualization-----------------------------------------------------------
    
  
    
    ruleExplorer(V_rules.sub)
    -----------------
    
