Repeat of EXP4_phase 2 with new parameters and measure as listed below.

Params:
#   Supp > 0.001 (.1%)
#   Conf > 0.01 (1%) 
#   minlen=2, maxlen=4, maxtime=10 (note: minlen=1 outputs an empty itemset on the antecedent side)
#   p-value < 0.5 (fisher)
#   Lift value > 1.2

Apriori returns 9,575,186 rules
After filtering for Lift > 1.2, rules = 1,330,896   ###need to filter before adding measures to save processing time
After filtering for P-value < 0.5, rules = 1,317,528   ###statistically significant rules

##this is too many rows for excel so I decided to divide the data into 3 files:

###1 itemset in the anticedent (minlen=2, maxlen=2)  = 8,750 rules (before filter), 585 after lift filter (7% of rules have lift >1.2), 583 after p-value filter.


###2 itemset in the anticedent (minlen=3, maxlen=3)  = 363,696 rules (before filter), 40,641 after lift filter (11% of rules have lift >1.2), 39,945 after p-value filter.

###3 itemset in the anticedent (minlen=4, maxlen=4)  = 9,202,740 rules (before filter), 1,289,670 after lift filter (14% of rules have lift >1.2), 1,277,018 after p-value filter.

### just for kicks I ran a 4 itemset run = 161,314,486 rules... error returned. Too many rules


	rules,	times smaller then next itemset count,	lift filter,	% of rules,	pvalue filter,	% of lift,
1item	8750		41.57					585		6.69%	   583		99.7%
2item	363696		25.30					40641		11.17%	   39945	98.3%
3item	9202740		17.53					1289670		14.01%	   1277018	99.0%
4item	161314486					
