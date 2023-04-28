Repeat of EXP2_phase 2 with new parameters and measure as listed below.

Note: Confidence values are not the same in both direction of a rule.

Params:
#   Supp > 0.001 (.1%)
#   Conf > 0.01 (1%) 
#   minlen=2, maxlen=4, maxtime=10 (note: minlen=1 outputs an empty itemset on the antecedent side)
#   p-value < 0.5 (fisher)
#   Lift value > 1.2

Apriori returns 3,384,614 rules
After filtering for Lift > 1.2, 	rules = 618,778  ###need to filter before adding measures to save processing time
After filtering for P-value < 0.5, 	rules = 612,052   ###statistically significant rules
After filtering further, 		rules = 6,230   ### to remove none occurance (=0) and to put NMF on rhs and gc on lhs

	
