############################################################################################################
## Validation Experiment
## Robert Smith 16 Jan 2023
## Algorithms: Apriori
## Data: 
#        D5_trainingData.csv
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


data <- read.csv("./data/D5_TrainingSet.csv", fileEncoding="UTF-8-BOM")

head(data)
summary(data)


## 2 Create Transactions
names(data)
cols <- c("Body_pres",  "CA_pres"   ,   "Cheeks_pres" ,  "EyeAp_pres"  ,  "Eyebrows_pres" ,"Eyegaze_pres" , "Head_pres" ,   
          "Verb_Dom"     , "Noun_Dom"   ,   "WHQ_Dom"    ,   "ND_Hold"   )

#Use lapply() to coerce and replace the chosen columns:
data[cols] <- lapply(data[cols], factor)

trans <- as (data, "transactions")

#-- Run rules for Apriori ----------------------------------------------------------------
    Apriori_rules <- apriori(trans, parameter=list(support=0.01, confidence=0.1, maxlen=2, maxtime=10))
    Apriori_rules <- unique(Apriori_rules) #remove duplicate rulesAp
    #define a consequent
    #  Apriori_rules_Depict <- subset(Apriori_rules, subset = rhs %pin% "Depicting_pres")
    #  inspect(Apriori_rules_Depict)
    #add IMs
    
    #reduce rules set size (for processing), by filtering out low lift rules first. 
    Apriori_rules <- subset(Apriori_rules, subset = lift > 1.2)
    
    quality(Apriori_rules)$lift <- interestMeasure(Apriori_rules, measure="lift", trans = trans)
    quality(Apriori_rules)$conviction <- interestMeasure(Apriori_rules, measure="conviction", trans = trans) 
    quality(Apriori_rules)$cosine <- interestMeasure(Apriori_rules, measure="cosine", trans = trans) 
    quality(Apriori_rules)$jaccard <- interestMeasure(Apriori_rules, measure="jaccard", trans = trans) 
    quality(Apriori_rules)$Fisher <- interestMeasure(Apriori_rules, measure="fishersExactTest", trans = trans)
    quality(Apriori_rules)$hlift<- interestMeasure(Apriori_rules, measure="hyperLift", trans = trans)
    quality(Apriori_rules)$hconf <- interestMeasure(Apriori_rules, measure="hyperConfidence", trans = trans)
    quality(Apriori_rules)$chiSquared <- interestMeasure(Apriori_rules, measure="chiSquared", trans = trans)
    #round((Apriori_rules)$Fisher, digits=3)
    
#------Output ---------------------------------------------------------------------- 
    #Force R not to use exponential notation (e.g. e+10)
    Apriori_D5_train = format(Apriori_rules,scientific=FALSE) 
    
    #refactor to dataframe
    Apriori_D5_train <- as(Apriori_rules,"data.frame")
    #split LHS from RHS
    
    Apriori_D5_train <- Apriori_D5_train %>%
      separate(rules, c("Antecedent", "Consequent"), "=>")
    head(Apriori_D5_train)
    
    #filter output by pvalue
    Apriori_D5_train <- filter(Apriori_D5_train, Fisher<0.5)
    
    #round column values to remove exponent numbers 
    Apriori_D5_train$Fisher <- round(Apriori_D5_train$Fisher, digits = 3)
    Apriori_D5_train$hlift <- round(Apriori_D5_train$hlift, digits = 3)
    Apriori_D5_train$hconf <- round(Apriori_D5_train$hconf, digits = 3
    
    #All rules
    write.csv(Apriori_D5_train,"./Output/D5_rules_trainingSet.csv", row.names = FALSE);
    

#-------visualization-----------------------------------------------------------
    ruleExplorer(Apriori_rules)