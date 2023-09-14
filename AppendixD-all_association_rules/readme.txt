cite: 
Robert G. Smith, Exploiting Association Rules Mining to Inform the Use of Non-Manual Features in Sign Language Processing,
Ph.D. thesis, Technological University Dublin, Ireland, 2023.

Experiment design and use of datasets are explained in the above thesis. Briefly:

*Experiments were completed in 2 phases. Where new questions arose from phase 1 results, they were explored further in phase 2. Some experiments from phase 1 & 2 were then filtered in a second round of experiments (same experiments, different parameters).

	-Round 1: before filtering for lift and significance (p-value)
	-Round 2: after filtering for lift and significance (p-value)

*Each experiment phase included experiments that may explored - 
	
	- (GramCls_ExpX) Correlations between Grammatical class and NMFs (GramCls) (this includes CA also)
		* For these experiments, the data was divided as follows:
			- all data
			- verb data
			- noun data
			- all grammatical classes except nouns and verbs
	- (NMF_ExpX) Correlations between NMFs and other NMFs (NMF)
	- (SymU_ExpX) Correlations between Symbolic units and NMFs (this includes CA also)

~Robert Smith

Gramcls_EXP4_ph2_rd2 3itemset 16154