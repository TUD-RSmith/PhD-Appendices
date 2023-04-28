############################################################################################################
# A version of this template was used for every experiment
#    every experiment considered a different input/output file and different cols.
#
#
############################################################################################################
## This file was used for the following experiment:
## GramCls_EXP3-ph2-rd2
## Robert Smith 03 Jan 2022
## Algorithms: Apriori
## Data: D14-NMFCV_nouns_pres.csv
#
## This is a *repeat of experiment GramCls_EXP3-phase2 changed/additional parameters, i.e.: 
#   Supp > 0.001 (.1%)
#   Conf > 0.01 (1%) 
#   minlen=2, maxlen=4, maxtime=10
#   p-value < 0.5 (fisher)
#   Lift value > 1.2
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

    
	data <- read.csv("../../Data/D14-NMFCV_nouns_pres.csv",fileEncoding="UTF-8-BOM")

	head(data)
	summary(data)

## 2 Create Transactions
	names(data)
	cols <- c("NMF_Body_Twist"      ,"NMF_Body_LEAN"          ,"NMF_Body_Shoulder"     ,"NMF_Body_back"        ,
          "NMF_Body_forward"     , "NMF_Body_latral"       ,"NMF_CA"                ,"NMF_Cheeks"           ,
          "NMF_EyeAp_SQ"         , "NMF_EyeAp_blink"       ,"NMF_EyeAp_WD"          ,"NMF_EyeAp_CLOSED"     ,
          "NMF_Eyebrows_Raised"  , "NMF_Eyebrows_Furrowed" ,"NMF_Eyegaze_camera"    ,"NMF_Eyegaze_dn"       ,
          "NMF_Eyegaze_up"       , "NMF_Eyegaze_sr"        ,"NMF_Eyegaze_sl"        ,"NMF_Eyegaze_Inter"    ,
          "NMF_Eyegaze_dh"       , "NMF_Eyegaze_nd"        ,"NMF_Eyegaze_hands"     ,"NMF_Head_TILT"        ,
          "NMF_Head_TURN"        , "NMF_Head_PUSH"         ,"NMF_Head_Nod"          ,"NMF_Head_Shake"       ,
          "NMF_Head_back"        , "NMF_Head_forward"      ,"NMF_Head_latral"       , "NP_gc"  ,                 
          "ND_gc"                  ,  "Nloc_gc"                 , "N.fs_gc"    )

    
    	#Use lapply() to coerce and replace the chosen columns:
    	data[cols] <- lapply(data[cols], factor)
     
    	trans <- as (data, "transactions")
    
## 3 Run rules for Apriori, Eclat, FP-Growth
  #Apriori
      Apriori_rules <- apriori(trans, parameter=list(support=0.001, confidence=0.01, minlen=2, maxlen=4, maxtime=10))
      Apriori_rules <- unique(Apriori_rules) #remove duplpicate rulesAp

  #reduce rules set size (for processing), by filtering out low lift rules. 
      Apriori_rules <- subset(Apriori_rules, subset = lift > 1.2)
  
  #make columns for IMs
      quality(Apriori_rules)$lift <- interestMeasure(Apriori_rules, measure="lift", trans = trans)
      quality(Apriori_rules)$conviction <- interestMeasure(Apriori_rules, measure="conviction", trans = trans) 
      quality(Apriori_rules)$cosine <- interestMeasure(Apriori_rules, measure="cosine", trans = trans) 
      quality(Apriori_rules)$jaccard <- interestMeasure(Apriori_rules, measure="jaccard", trans = trans) 
      quality(Apriori_rules)$Fisher <- interestMeasure(Apriori_rules, measure="fishersExactTest", trans = trans)
      quality(Apriori_rules)$hlift<- interestMeasure(Apriori_rules, measure="hyperLift", trans = trans)
      quality(Apriori_rules)$hconf <- interestMeasure(Apriori_rules, measure="hyperConfidence", trans = trans)
      
## 4 Output  
      #refactor to dataframe
        Apriori_D14 <- as(Apriori_rules,"data.frame")

      #split LHS from RHS
        Apriori_D14 <- Apriori_D14 %>%
          separate(rules, c("Antecedent", "Consequent"), "=>")

        head(Apriori_D14)

      #Force R not to use exponential notation (e.g. e+10)
        Apriori_D14 = format(Apriori_D14,scientific=FALSE) 
        
      #filter output by pvalue
        Filtered_significance <- filter(Apriori_D14, Fisher<0.4)
           
        
      #write all rules to file
        write.csv(Filtered_significance,"./Output/GramCls_EXP3_ph2_rd2/GramCls_EXP3_ph2_rd2_Allresults.csv", row.names = FALSE);
        
        
      #filter output based on row content
	  # Filter on Antecedent to exclude rules which imply none occurrence (i.e. = 0)
        # Filter on Antecedent to exclude rules which include grammatical classes (_gc).. 
        # ...so now the Antecedent only include NMFs which are present (= 1)
        Filtered_output <- dplyr::filter(Filtered_significance, !grepl('0|_gc', Antecedent))
        Filtered_output <- dplyr::filter(Filtered_significance, !grepl('0|_gc', Consequent))
       
        # Filter on Consequent to exclude rules which include NMFs
        # ...so now the Consequent only include grammatical classes
        Filtered_output <- dplyr::filter(Filtered_output, !grepl('NMF', Consequent))
       
        str(Filtered_output)
        
        
        #write filtered rules to file
        write.csv(Filtered_output,"../../Output/GramCls_EXPx-rd2/GramCls_EXP3_ph2_rd2/GramCls_EXP3_ph2_rd2_HeadOnly2.csv", row.names = FALSE);
        
 ##5 visualisation
        ruleExplorer(Apriori_rules)
        
       