Repeat of NMF EXP1_phase 1 with new parameters and measure as listed below.

Params:
#   Supp > 0.001 (.1%)
#   Conf > 0.01 (1%) 
#   minlen=2, maxlen=4, maxtime=10 (note: minlen=1 outputs an empty itemset on the antecedent side)
#   p-value < 0.5 (fisher)
#   Lift value > 1.2

Apriori returns 2,842 rules
After filtering for Lift > 1.2, 	rules = 539  ###need to filter before adding measures to save processing time
After filtering for P-value < 0.5, 	rules = 534  ###statistically significant rules


	
