Repeat of EXP3_phase 2 with new parameters and measure as listed below.

Params:
#   Supp > 0.001 (.1%)
#   Conf > 0.01 (1%) 
#   minlen=2, maxlen=4, maxtime=10 (note: minlen=1 outputs an empty itemset on the antecedent side)
#   p-value < 0.5 (fisher)
#   Lift value > 1.2

Apriori returns 2,755,971 rules
After filtering for Lift > 1.2, 	rules = 521,366  ###need to filter before adding measures to save processing time
After filtering for P-value < 0.5, 	rules = 516,132   ###statistically significant rules
After filtering further, 		rules = 1,867  ### to remove none occurance (=0) and to put NMF on rhs and gc on lhs

	
