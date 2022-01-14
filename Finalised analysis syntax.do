
set more off	
	
*load analysis dataset	
	
	use "C:\Users\heinh\OneDrive - University of Leeds\Work docs\Research\MCS selfharm gender study\MCS analysis data set.dta", clear

*set complex survey design features with non-response adjustment

	svyset sptn00 [pweight=fovwt2], strata(pttype2) fpc(nh2)
			
*delete 12 observations with a missing weight variable
			
	drop if fovwt2<0
								
*delete observations with a missing value on the outcome variable
	
	drop if cm_selfharm==.
			
*Assess missing data

	*[...]	
	
*Recode gang variable to binary

	recode cm_gang (2=0) 
	tab cm_gang
	label drop cm_gang
	label values cm_gang cm_gang
	label define cm_gang /*
	*/ 0 "no" 1 "yes"
	tab cm_gang
	
*Create binvary variable for single-parent household

	gen p_compos=fdhtys00
	recode p_compos (1=0) (2=1)
	label variable p_compos "single-parent hh"
	label values p_compos p_compos
	label define p_compos 0 "no" 1 "yes"
	
*Create binary variable for low hh income	
		
	gen hh_lowinc=foedp000
	label variable hh_lowinc "low household income"
	label values hh_lowinc hh_lowinc
	label define hh_lowinc /*
	*/ 0 "at or above 60% of median income" /*
	*/ 1 "below 60% of median income"
	tab hh_lowinc
	
*Create binary variable for parental unemployment

	gen p_unemp=.
	replace p_unemp=0 if inlist(fdcwrk00,1,2,3,5,9)
	replace p_unemp=1 if inlist(fdcwrk00,4,6)
	label variable p_unemp "parental unemployment"
	label values p_unemp p_unemp
	label define p_unemp 0 "no" 1 "yes"
	tab p_unemp

*Create binary variable for housing tenure

	gen hh_owned=.
	replace hh_owned=1 if inlist(fdroow00,4,5,6,7,8,10)
	replace hh_owned=0 if inlist(fdroow00,1,2,3)
	label variable hh_owned "house owned outright or with mortgage"
	label values hh_owned hh_owned
	label define hh_owned 0 "yes" 1 "no"
	tab hh_owned fdroow00
	
*Create variable for highest parentsl occupation

	egen p_nssec = rowmax(m_nssec f_nssec) if p_compos==0		
	replace p_nssec = m_nssec if p_compos==1 & m_nssec!=.
	replace p_nssec = f_nssec if p_compos==1 & f_nssec!=.
	replace p_nssec=. if p_nssec==-1
	label values p_nssec p_nssec
	label define p_nssec /*
	*/ 1 "higher manag./prof." /*
	*/ 2 "lower manag./prof." /*
	*/ 3 "intermediate" /*
	*/ 4 "small emp/self-emp" /*
	*/ 5 "lower supervisor./tech" /*
	*/ 6 "semi-routine" /*
	*/ 7 "routine"
	tab p_nssec
	
*region within the UK
	
	gen hh_region = faregn00
	recode hh_region /*
	*/ (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (11=10) (12=11)
	label values hh_region hh_region
	label define hh_region /*
	*/ 1 "North East" /*
	*/ 2 "North West" /*
	*/ 3 "Yorkshire and the Humber" /*
	*/ 4 "Midlands" /*
	*/ 5 "East of England" /*
	*/ 6 "London" /*
	*/ 7 "South East" /*
	*/ 8 "South West" /*
	*/ 9 "Wales" /*
	*/ 10 "Scotland" /*
	*/ 11 "Northern Ireland"
		
*urbanicity of the living environment
	
	gen hh_urban2=.
	replace hh_urban2 = 1 if hh_urbanicity==4
	replace hh_urban2 = 2 if hh_urbanicity==1
	replace hh_urban2 = 3 if hh_urbanicity==5
	replace hh_urban2 = 4 if hh_urbanicity==2
	replace hh_urban2 = 5 if hh_urbanicity==6
	replace hh_urban2 = 6 if hh_urbanicity==3
	label values hh_urban2 hh_urban2
	label define hh_urban2 /*
	*/ 1 "urban - denser" /*
	*/ 2 "urban - sparser" /*
	*/ 3 "small towns - denser" /*
	*/ 4 "small towns - sparser" /*
	*/ 5 "villages - denser" /*
	*/ 6 "villages - sparser"
	tab hh_urban2
	
*deprivation

	foreach type in overall income employment health education {
	gen imd04_`type'_bin=.
	replace imd04_`type'_bin=0 if inrange(imd04_`type', 1, 5)
	replace imd04_`type'_bin=1 if inrange(imd04_`type', 6, 10)
	label values imd04_`type'_bin imd04_`type'_bin
	label define imd04_`type'_bin 0 "least deprived 50%" 1 "most deprived 50%"
	}
	
*Table: prevalence of self-harm by wider demographic and socioeconomic characteristics

	tab cm_female cm_selfharm
	svy: tab cm_female cm_selfharm, row
	
	tab cm_age cm_selfharm
	svy: tab cm_age cm_selfharm, row
	
	tab cm_ethnicity cm_selfharm
	svy: tab cm_ethnicity cm_selfharm, row
	
	tab p_nssec cm_selfharm
	svy: tab p_nssec cm_selfharm, row
	
	tab hh_region cm_selfharm
	svy: tab hh_region cm_selfharm, row

	tab hh_urban2 cm_selfharm
	svy: tab hh_urban2 cm_selfharm, row
	
	foreach type in overall income employment health education {	
	tab imd04_`type'_bin cm_selfharm
	svy: tab imd04_`type'_bin cm_selfharm, row
	}
	
*************************************************

	foreach letter in m f {
	summ `letter'_lifesatisfaction
	local lower=r(min)
	local upper=r(max)
	local middle=(`upper'+`lower')/2
	di `middle'
	gen `letter'_lifesat_bin=.
	replace `letter'_lifesat_bin=0 if `letter'_lifesatisfaction<`middle'
	replace `letter'_lifesat_bin=1 if `letter'_lifesatisfaction>=`middle' & `letter'_lifesatisfaction!=.
	label values `letter'_lifesat_bin `letter'_lifesat_bin
	label define `letter'_lifesat_bin /*
	*/ 0 "lower range" /*
	*/ 1 "upper range"
	tab `letter'_lifesat_bin
	}
	
	replace cm_hurt_by_sibs=. if cm_hurt_by_sibs==9
	replace cm_hurt_sibs=. if cm_hurt_sibs==9
	
	foreach var in cm_hurt_by_sibs cm_hurt_sibs {
	gen `var'_bin=.
	replace `var'_bin=0 if inrange(`var', 1, 2)
	replace `var'_bin=1 if inrange(`var', 3, 6)
	label values `var'_bin `var'_bin
	label define `var'_bin /*
	*/ 0 "never or rarely" /*
	*/ 1 "every few months or more often"
	}
	
	rename cm_cbully_by_others cm_cbull_b_oth
	rename cm_cbully_others cm_cbull_oth
	
	foreach var in cm_hurt_by_others cm_hurt_others cm_cbull_b_oth cm_cbull_oth {
	gen `var'_bin=.
	replace `var'_bin=0 if inlist(`var', 1)
	replace `var'_bin=1 if inrange(`var', 2, 6)
	label values `var'_bin `var'_bin
	label define `var'_bin /*
	*/ 0 "never or rarely" /*
	*/ 1 "every few months or more often"
	}

*Create binary variable for lives with mother/father

	foreach parent in mother father {
	gen cm_live_`parent'_bin=.
	replace cm_live_`parent'_bin=0 if cm_live_`parent'==0
	replace cm_live_`parent'_bin=1 if inlist(cm_live_`parent', 1, 9)
	label values cm_live_`parent'_bin cm_live_`parent'_bin
	label define cm_live_`parent'_bin /*
	*/ 0 "yes" /*
	*/ 1 "no, no `parent', or no contact"
	tab cm_live_`parent' cm_live_`parent'_bin
	}

*Create binary variable for close to mother/father

	foreach parent in mother father {
	gen cm_close_`parent'_bin=.
	replace cm_close_`parent'_bin=0 if inlist(cm_close_`parent', 1, 2, 3)
	replace cm_close_`parent'_bin=1 if inlist(cm_close_`parent', 4, 9)
	label values cm_close_`parent'_bin cm_close_`parent'_bin
	label define cm_close_`parent'_bin /*
	*/ 0 "extremely, very or fairly close" /*
	*/ 1 "not very close or no `parent'/contact"
	tab cm_close_`parent' cm_close_`parent'_bin
	}
	
*Create binary variable for arguing with mother/father

	replace cm_argue_mother=. if cm_argue_mother==9
	replace cm_argue_father=. if cm_argue_father==9

	foreach parent in mother father {
	gen cm_argue_`parent'_bin=.
	replace cm_argue_`parent'_bin=0 if inlist(cm_argue_`parent', 1, 2, 3, 4)
	replace cm_argue_`parent'_bin=1 if inlist(cm_argue_`parent', 5)
	label values cm_argue_`parent'_bin cm_argue_`parent'_bin
	label define cm_argue_`parent'_bin /*
	*/ 0 "a couple of times a week or less" /*
	*/ 1 "most days"
	tab cm_argue_`parent' cm_argue_`parent'_bin
	}
	
*Create binary variable for closeness of parent with child
	
	foreach letter in m f{
	gen `letter'_cm_close_bin=.
	replace `letter'_cm_close_bin=0 if inlist(`letter'_cm_close, 1, 2)
	replace `letter'_cm_close_bin=1 if inlist(`letter'_cm_close, 3, 4)
	label values `letter'_cm_close_bin `letter'_cm_close_bin
	label define `letter'_cm_close_bin /*
	*/ 0 "extremely or very" /*
	*/ 1 "fairly or not very"
	tab `letter'_cm_close `letter'_cm_close_bin
	}
	
*Create binary variable for arguing of parent with child
	
	foreach letter in m f{
	gen `letter'_cm_argue_bin=.
	replace `letter'_cm_argue_bin=0 if inlist(`letter'_cm_argue, 1, 2)
	replace `letter'_cm_argue_bin=1 if inlist(`letter'_cm_argue, 3, 4)
	label values `letter'_cm_argue_bin `letter'_cm_argue_bin
	label define `letter'_cm_argue_bin /*
	*/ 0 "extremely or very" /*
	*/ 1 "fairly or not very"
	tab `letter'_cm_argue `letter'_cm_argue_bin
	}
	
*Create binary variable for feeling safe, trusting and close to others
	
	foreach var in safe trust close{
	gen cm_`var'_bin=.
	replace cm_`var'_bin=0 if cm_`var'==1
	replace cm_`var'_bin=1 if inlist(cm_`var', 2, 3)
	label values cm_`var'_bin cm_`var'_bin
	label define cm_`var'_bin /*
	*/ 0 "very true" /*
	*/ 1 "partly true or not true at all"
	tab cm_`var' cm_`var'_bin
	}
	
	label variable cm_safe_bin "I have family and friends who help me feel safe, secure and happy"
	label variable cm_trust_bin "There is someone I trust whom I would turn to if I had problems"
	label variable cm_close_bin "There is at least one person I feel close to"
	
	tab cm_safe_bin cm_safe
	tab cm_trust_bin cm_trust
	tab cm_close_bin cm_close
	
*Create binary variable for hours spent on social network sites
	
	gen cm_socmed_bin=.
	replace cm_socmed_bin=0 if cm_socmed<=4
	replace cm_socmed_bin=1 if inlist(cm_socmed, 5,6,7,8)
	label variable cm_socmed_bin "time spend on social network sites"
	label values cm_socmed_bin cm_socmed_bin
	label define cm_socmed_bin /*
	*/ 0 "between 1 and 2 hours a day or less" /*
	*/ 1 "more than 2 hours a day"
	tab cm_socmed_bin cm_socmed
	
*Create binary variables for depression screen

	foreach var in unhappy donotenjoy tired restless nogood cried concentrate hateself badperson lonely unloved asgood wrong {
	gen cm_f_`var'_bin=.
	replace cm_f_`var'_bin=0 if cm_f_`var'==0
	replace cm_f_`var'_bin=1 if inlist(cm_f_`var', 1, 2)
	label variable cm_f_`var'_bin "depscreen: `var'"
	label values cm_f_`var'_bin cm_f_`var'_bin
	label define cm_f_`var'_bin /*
	*/ 0 "not true" /*
	*/ 1 "sometimes or always true"
	tab cm_f_`var'_bin cm_f_`var'
	}
	
*Create binary variables for externalising behaviours reported by mother

	foreach number in 1 2 3 4 5 6 7 8 9 10 {
	gen m_cm_ext_`number'_bin=.
	replace m_cm_ext_`number'_bin=0 if m_cm_external_`number'==1
	replace m_cm_ext_`number'_bin=1 if inlist(m_cm_external_`number', 2, 3)
	label values m_cm_ext_`number'_bin m_cm_ext_`number'_bin
	label define m_cm_ext_`number'_bin /*
	*/ 0 "not true" /*
	*/ 1 "somewhat or certainly true"
	tab m_cm_ext_`number'_bin m_cm_external_`number'
	}
	
	label variable m_cm_ext_1_bin "often has temper tantrums"
	label variable m_cm_ext_2_bin "generally disobedient"
	label variable m_cm_ext_3_bin "fights with or bullies other children"
	label variable m_cm_ext_4_bin "steals from home, school or elsewhere"
	label variable m_cm_ext_5_bin "often lies of cheats"
	label variable m_cm_ext_6_bin "restless, overactive, cannot sit still for long"
	label variable m_cm_ext_7_bin "constantly fidgeting"
	label variable m_cm_ext_8_bin "easily distracted"
	label variable m_cm_ext_9_bin "doesn't think before acting"
	label variable m_cm_ext_10_bin "doesn't see tasks through to the end"
	
*Create binary variables for internalising behaviours reported by mother

	foreach number in 1 2 3 4 5 6 7 8 9 {
	gen m_cm_int_`number'_bin=.
	replace m_cm_int_`number'_bin=0 if m_cm_internal_`number'==1
	replace m_cm_int_`number'_bin=1 if inlist(m_cm_internal_`number', 2, 3)
	label values m_cm_int_`number'_bin m_cm_int_`number'_bin
	label define m_cm_int_`number'_bin /*
	*/ 0 "not true" /*
	*/ 1 "somewhat or certainly true"
	tab m_cm_int_`number'_bin m_cm_internal_`number'
	}
	
	label variable m_cm_int_1_bin "complains of headaches/stomach aches/sickness"
	label variable m_cm_int_2_bin "often seems worried"
	label variable m_cm_int_3_bin "often unhappy"
	label variable m_cm_int_4_bin "nervous or clingy in new situations"
	label variable m_cm_int_5_bin "many fears, easily scared"
	label variable m_cm_int_6_bin "tends to play alone"
	label variable m_cm_int_7_bin "has no good friends"
	label variable m_cm_int_8_bin "not liked by other children"
	label variable m_cm_int_9_bin "picked on or bullied by other children"
	
*Create binary variables for happiness

	rename cm_happy_appearance cm_happy_appear

	foreach var in appear family friends school life {
	gen cm_happy_`var'_bin=.
	replace cm_happy_`var'_bin=0 if inlist(cm_happy_`var', 1, 2)
	replace cm_happy_`var'_bin=1 if inlist(cm_happy_`var', 3, 4, 5, 6, 7)
	label values cm_happy_`var'_bin cm_happy_`var'_bin 
	label define cm_happy_`var'_bin /*
	*/ 0 "completely happy or nearly completely happy" /*
	*/ 1 "less happy"
	tab cm_happy_`var'_bin cm_happy_`var'
	}
	
*Create binary variable for willingness to take risk

	sum cm_risk
	local lower=r(min)
	local upper=r(max)
	local middle=(`upper'+`lower')/2
	di `middle'
	
	gen cm_risk_bin=.
	replace cm_risk_bin=0 if cm_risk<`middle'
	replace cm_risk_bin=1 if cm_risk>=`middle' & cm_risk!=.
	label variable cm_risk_bin "how willing is CM to take risks?"
	label values cm_risk_bin cm_risk_bin 
	label define cm_risk_bin /*
	*/ 0 "lower range" /*
	*/ 1 "upper range"
	tab cm_risk_bin 
	
*Create binary variable extent of patience

	sum cm_patient
	local lower=r(min)
	local upper=r(max)
	local middle=(`upper'+`lower')/2
	di `middle'
	
	gen cm_patient_bin=.
	replace cm_patient_bin=0 if cm_patient<`middle'
	replace cm_patient_bin=1 if cm_patient>=`middle' & cm_risk!=.
	label variable cm_patient_bin "how patient is CM?"
	label values cm_patient_bin cm_patient_bin 
	label define cm_patient_bin /*
	*/ 0 "lower range" /*
	*/ 1 "upper range"
	tab cm_patient_bin 
	
*Create binary variable for trusting others

	sum cm_trustothers
	local lower=r(min)
	local upper=r(max)
	local middle=(`upper'+`lower')/2
	di `middle'
	
	gen cm_trustothers_bin=.
	replace cm_trustothers_bin=0 if cm_trustothers<`middle'
	replace cm_trustothers_bin=1 if cm_trustothers>=`middle' & cm_risk!=.
	label variable cm_trustothers_bin "how much does CM trust others?"
	label values cm_trustothers_bin cm_trustothers_bin 
	label define cm_trustothers_bin /*
	*/ 0 "lower range" /*
	*/ 1 "upper range"
	tab cm_trustothers_bin
	
*Create binary variables for selfesteem

	foreach number in 1 2 3 4 5 {
	gen cm_selfest_`number'_bin=.
	replace cm_selfest_`number'_bin=0 if inlist(cm_selfesteem_`number', 1, 2)
	replace cm_selfest_`number'_bin=1 if inlist(cm_selfesteem_`number', 3, 4)
	label values cm_selfest_`number'_bin cm_selfest_`number'_bin
	label define cm_selfest_`number'_bin /*
	*/ 0 "strongly agree or agree" /*
	*/ 1 "disagree or strongly disagree"
	tab cm_selfest_`number'_bin cm_selfesteem_`number'
	}
	
	label variable cm_selfest_1_bin "On the whole, I am satisfied with myself"
	label variable cm_selfest_2_bin "I feel I have a number of good qualities"
	label variable cm_selfest_3_bin "I feel I am able to do things as well as others"
	label variable cm_selfest_4_bin "I am a person of value"
	label variable cm_selfest_5_bin "I feel good about myself"
	
*Create binary variable for SDQ responses

	foreach type in emotion conduct hyper peer prosoc {
	
	sum cm_sdq_`type'
	local lower=r(min)
	local upper=r(max)
	local middle=(`upper'+`lower')/2
	
	gen cm_sdq_`type'_bin=.
	replace cm_sdq_`type'_bin=0 if cm_sdq_`type'<`middle'
	replace cm_sdq_`type'_bin=1 if cm_sdq_`type'>=`middle' & cm_sdq_`type'!=.
	label values cm_sdq_`type'_bin cm_sdq_`type'_bin 
	label define cm_sdq_`type'_bin /*
	*/ 0 "lower range" /*
	*/ 1 "upper range" 
	tab cm_sdq_`type'_bin
	}
	
*Create binary variables for weight

	gen cm_weight_bin=.
	replace cm_weight_bin=0 if cm_weight==1
	replace cm_weight_bin=1 if inlist(cm_weight, 2, 3, 4)
	label values cm_weight_bin cm_weight_bin
	label define cm_weight_bin /*
	*/ 0 "healthy weight" /*
	*/ 1 "underweight, overweight or obese" 
	tab cm_weight_bin cm_weight
	
	gen cm_weight_percept_bin=.
	replace cm_weight_percept_bin=0 if cm_weight_percept==1
	replace cm_weight_percept_bin=1 if inlist(cm_weight_percept, 2, 3, 4)
	label values cm_weight_percept_bin cm_weight_percept_bin
	label define cm_weight_percept_bin /*
	*/ 0 "about right" /*
	*/ 1 "underweight overweight or obese" 
	tab cm_weight_percept_bin cm_weight_percept	
	
	gen cm_weight_goal_bin=.
	replace cm_weight_goal_bin=0 if inlist(cm_weight_goal, 1, 2)
	replace cm_weight_goal_bin=1 if inlist(cm_weight_goal, 3, 4)
	label values cm_weight_goal_bin cm_weight_goal_bin
	label define cm_weight_goal_bin /*
	*/ 0 "nothing or maintain" /*
	*/ 1 "gain or lose weight" 
	tab cm_weight_goal_bin cm_weight_goal	
	
*Factor analysis for data reduction
				
	*Social support
		
		preserve
			sort mcsid fcnum00
			egen id=group(mcsid fcnum00)
			order id

			keep /*
			*/ id /*
			*/ cm_friends /*
			*/ cm_safe /*
			*/ cm_trust /*
			*/ cm_close 

			rename cm_friends friend
			rename cm_safe safe
			rename cm_trust trust
			rename cm_close close
	
			runmplus friend-close, type(efa 1 2) categorical(all) ///
			saveinputfile(c:\temp\mplus\efa_socsup) saveinputdatafile(c:\temp\mplus\efa_socsup)
			
			capture runmplus friend-close id, idvariable(id) categorical(all) ///
			model(f by friend-close) ///
			savedata(save=fscores; file=c:\temp\temp.dat) ///
			savelogfile(c:\temp\temp) saveinputfile(c:\temp\mplus\cfa_socsup) saveinputdatafile(c:\temp\mplus\cfa_socsup)
		restore		
				
		preserve
			runmplus_load_savedata , out(c:/temp/temp.out) clear
			save "c:\temp\fscores.dta", replace	
		restore
		
		sort mcsid fcnum00
		egen id=group(mcsid fcnum00)
		order id
		joinby id using "c:\temp\fscores.dta"
		
		*Check factors scores against those produced within Stata
			preserve
				polychoric /*
				*/ cm_friends /*
				*/ cm_safe /*
				*/ cm_trust /*
				*/ cm_close
				local N=r(sum_w)	
				matrix r=r(R)
				factormat r, n(`N') factors(1)
				predict f1
				scatter f1 f
			restore
		
		rename f fct_socsup
		label variable fct_socsup "poor social support"
		
		sum fct_socsup
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_socsup_bin=.
		replace fct_socsup_bin=0 if fct_socsup<`middle'
		replace fct_socsup_bin=1 if fct_socsup>=`middle' & fct_socsup!=.
		
		label variable fct_socsup_bin "poor social support"
		label values fct_socsup_bin fct_socsup_bin
		label define fct_socsup_bin 0 "lower range" 1 "upper range"
		
		tab fct_socsup_bin	
		
		drop friend-close
		
	*Bullies
		
		preserve
			keep /*
			*/ id /*
			*/ cm_hurt_sibs /*
			*/ cm_hurt_others /*
			*/ cm_cbull_oth 
						
			rename cm_hurt_sibs hrtsib
			rename cm_hurt_others hrtoth
			rename cm_cbull_oth cbull
			
			runmplus hrtsib hrtoth cbull, type(efa 1 1) categorical(all) 
			
			runmplus hrtsib hrtoth cbull id, idvariable(id) categorical(all) ///
			model(f by hrtsib hrtoth cbull;) 
		
			capture runmplus hrtsib hrtoth cbull id, idvariable(id) categorical(all) ///
			model(f by hrtsib hrtoth cbull;) ///
			savedata(save=fscores; file=c:\temp\temp.dat) ///
			savelogfile(c:\temp\temp) saveinputfile(c:\temp\mplus\cfa_bullies) saveinputdatafile(c:\temp\mplus\cfa_bullies)
		restore		
				
		preserve
			runmplus_load_savedata , out(c:/temp/temp.out) clear
			save "c:\temp\fscores.dta", replace	
		restore
		
		joinby id using "c:\temp\fscores.dta"
		
		*Check factors scores against those produced within Stata
			preserve
				polychoric /*
				*/ cm_hurt_sibs /*
				*/ cm_hurt_others /*
				*/ cm_cbull_oth
				local N=r(sum_w)	
				matrix r=r(R)
				factormat r, n(`N') factors(1)
				predict f1
				scatter f1 f
			restore
		
		rename f fct_bullies
		label variable fct_bullies "bullies others"
		drop hrtsib hrtoth cbull
		
		sum fct_bullies
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_bullies_bin=.
		replace fct_bullies_bin=0 if fct_bullies<`middle'
		replace fct_bullies_bin=1 if fct_bullies>=`middle' & fct_bullies!=.
		
		label variable fct_bullies_bin "bullies others"
		label values fct_bullies_bin fct_bullies_bin
		label define fct_bullies_bin 0 "lower range" 1 "upper range"
		
		tab fct_bullies_bin
	
	*Bullied
	
		preserve
			keep /*
			*/ id /*
			*/ cm_hurt_by_sibs /*
			*/ cm_hurt_by_others /*
			*/ cm_cbull_b_oth /*
			*/ cm_bully_verbal /*
			*/ cm_bully_phys /*
			*/ cm_bully_weapon /*
			*/ cm_bully_stolen
						
			rename cm_hurt_by_sibs sibs
			rename cm_hurt_by_others others
			rename cm_cbull_b_oth cbull
			rename cm_bully_verbal verbal
			rename cm_bully_phys phys
			rename cm_bully_weapon weapon
			rename cm_bully_stolen stolen	
			
			runmplus sibs others cbull verbal phys weapon stolen, type(efa 1 2) categorical(all) 
			
			runmplus sibs others cbull verbal phys weapon stolen id, idvariable(id) categorical(all) ///
			model(f1 by sibs others cbull verbal; f2 by phys weapon stolen;) 

			capture runmplus sibs others cbull verbal phys weapon stolen id, idvariable(id) categorical(all) ///
			model(f1 by sibs others cbull verbal; f2 by phys weapon stolen;)  ///
			savedata(save=fscores; file=c:\temp\temp.dat) ///
			savelogfile(c:\temp\temp) saveinputfile(c:\temp\mplus\cfa_bullied) saveinputdatafile(c:\temp\mplus\cfa_bullied)
		restore		
				
		preserve
			runmplus_load_savedata , out(c:/temp/temp.out) clear
			save "c:\temp\fscores.dta", replace	
		restore
		
		joinby id using "c:\temp\fscores.dta"
		
		*Check factors scores against those produced within Stata
			preserve
				polychoric /*
				*/ cm_hurt_by_sibs /*
				*/ cm_hurt_by_others /*
				*/ cm_cbull_b_oth /*
				*/ cm_bully_verbal /*
				*/ cm_bully_phys /*
				*/ cm_bully_weapon /*
				*/ cm_bully_stolen
				local N=r(sum_w)	
				matrix r=r(R)
				factormat r, n(`N') factors(1)
				predict f
				scatter f f1
				scatter f f2
			restore
		
		rename f1 fct_bullied
		label variable fct_bullied "bullied"
		
		rename f2 fct_assaulted
		label variable fct_assaulted "pysically assaulted or stolen from"
		
		drop sibs others cbull verbal phys weapon stolen

		sum fct_bullied
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_bullied_bin=.
		replace fct_bullied_bin=0 if fct_bullied<`middle'
		replace fct_bullied_bin=1 if fct_bullied>=`middle' & fct_bullied!=.
		
		label variable fct_bullied_bin "bullied"
		label values fct_bullied_bin fct_bullied_bin
		label define fct_bullied_bin 0 "lower range" 1 "upper range"
		
		tab fct_bullied_bin
		
		sum fct_assaulted
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_assaulted_bin=.
		replace fct_assaulted_bin=0 if fct_assaulted<`middle'
		replace fct_assaulted_bin=1 if fct_assaulted>=`middle' & fct_assaulted!=.
		
		label variable fct_assaulted_bin "physically assaulted or stolen from"
		label values fct_assaulted_bin fct_assaulted_bin
		label define fct_assaulted_bin 0 "lower range" 1 "upper range"
		
		tab fct_assaulted_bin
		
	*Weight perception
	
		preserve
			keep /*
			*/ id /*
			*/ cm_weight /*
			*/ cm_weight_percept /*
			*/ cm_weight_goal
						
			rename cm_weight weight
			rename cm_weight_percept percep 
			rename cm_weight_goal goal
			
			runmplus weight percep goal, type(efa 1 1) categorical(all) 
			
			runmplus weight percep goal id, idvariable(id) categorical(all) ///
			model(f by weight percep goal;)
			
			capture runmplus weight percep goal id, idvariable(id) categorical(all) ///
			model(f by weight percep goal;) ///
			savedata(save=fscores; file=c:\temp\temp.dat) ///
			savelogfile(c:\temp\temp) saveinputfile(c:\temp\mplus\cfa_weight) saveinputdatafile(c:\temp\mplus\cfa_weight)
		restore		
				
		preserve
			runmplus_load_savedata , out(c:/temp/temp.out) clear
			save "c:\temp\fscores.dta", replace	
		restore
		
		joinby id using "c:\temp\fscores.dta"
		
		*Check factors scores against those produced within Stata
			preserve
				polychoric /*
				*/ cm_weight /*
				*/ cm_weight_percept /*
				*/ cm_weight_goal
				local N=r(sum_w)	
				matrix r=r(R)
				factormat r, n(`N') factors(1)
				predict f1
				scatter f1 f
			restore
		
		rename f fct_weight
		label variable fct_weight "issues with weight"
		drop weight percep goal

		sum fct_weight
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_weight_bin=.
		replace fct_weight_bin=0 if fct_weight<`middle'
		replace fct_weight_bin=1 if fct_weight>=`middle' & fct_weight!=.
		
		label variable fct_weight_bin "issues with weight"
		label values fct_weight_bin fct_weight_bin
		label define fct_weight_bin 0 "lower range" 1 "upper range"
		
		tab fct_weight_bin		
			
	*Low mood
	
		preserve
			keep /*
			*/ id /*
			*/ cm_f_unhappy /*
			*/ cm_f_donotenjoy /*
			*/ cm_f_tired /*
			*/ cm_f_restless /*
			*/ cm_f_nogood /*
			*/ cm_f_cried /*
			*/ cm_f_concentrate /*
			*/ cm_f_hateself /*
			*/ cm_f_badperson /*
			*/ cm_f_lonely /*
			*/ cm_f_unloved /*
			*/ cm_f_asgood /*
			*/ cm_f_wrong
						
			rename cm_f_unhappy unhap
			rename cm_f_donotenjoy nojoy
			rename cm_f_tired tired
			rename cm_f_restless rstls
			rename cm_f_nogood nogood
			rename cm_f_cried cried
			rename cm_f_concentrate concen
			rename cm_f_hateself hate
			rename cm_f_badperson badp
			rename cm_f_lonely lone
			rename cm_f_unloved unlove
			rename cm_f_asgood asgood
			rename cm_f_wrong wrong
			
			runmplus unhap-wrong, type(efa 1 3) categorical(all)
	
			runmplus unhap-wrong id, idvariable(id) categorical(all) ///
			model(f1 by unhap cried nogood nojoy; f2 by tired rstls concen; f3 by wrong asgood unlove badp lone hate;) 			

			capture runmplus unhap-wrong id, idvariable(id) categorical(all) ///
			model(f1 by unhap cried nogood nojoy; f2 by tired rstls concen; f3 by wrong asgood unlove badp lone hate;)  ///
			savedata(save=fscores; file=c:\temp\temp.dat) ///
			savelogfile(c:\temp\temp) saveinputfile(c:\temp\mplus\cfa_dep) saveinputdatafile(c:\temp\mplus\cfa_dep)
		restore		
				
		preserve
			runmplus_load_savedata , out(c:/temp/temp.out) clear
			save "c:\temp\fscores.dta", replace	
		restore
		
		joinby id using "c:\temp\fscores.dta"		
	
		*Check factors scores against those produced within Stata
			
			preserve
				polychoric /*
				*/ cm_f_unhappy /*
				*/ cm_f_donotenjoy /*
				*/ cm_f_tired /*
				*/ cm_f_restless /*
				*/ cm_f_nogood /*
				*/ cm_f_cried /*
				*/ cm_f_concentrate /*
				*/ cm_f_hateself /*
				*/ cm_f_badperson /*
				*/ cm_f_lonely /*
				*/ cm_f_unloved /*
				*/ cm_f_asgood /*
				*/ cm_f_wrong
				local N=r(sum_w)	
				matrix r=r(R)
				factormat r, n(`N') factors(1)
				predict f
				scatter f f1
				scatter f f2 
				scatter f f3
			restore
		
		rename f1 fct_mfq1
		label variable fct_mfq1 "MFQ: low mood"

		rename f2 fct_mfq2 
		label variable fct_mfq2 "MFQ: tired, restless & poor concentration"
		
		rename f3 fct_mfq3 
		label variable fct_mfq3 "MFQ: low self-worth"
		
		sum fct_mfq1
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_mfq1_bin=.
		replace fct_mfq1_bin=0 if fct_mfq1<`middle'
		replace fct_mfq1_bin=1 if fct_mfq1>=`middle' & fct_mfq1!=.
		
		label variable fct_mfq1_bin "MFQ: low mood"
		label values fct_mfq1_bin fct_mfq1_bin
		label define fct_mfq1_bin 0 "lower range" 1 "upper range"
		
		tab fct_mfq1_bin		
		
		sum fct_mfq2
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_mfq2_bin=.
		replace fct_mfq2_bin=0 if fct_mfq2<`middle'
		replace fct_mfq2_bin=1 if fct_mfq2>=`middle' & fct_mfq2!=.
		
		label variable fct_mfq2_bin "MFQ: tired, restless & poor concentration"
		label values fct_mfq2_bin fct_mfq2_bin
		label define fct_mfq2_bin 0 "lower range" 1 "upper range"
		
		tab fct_mfq2_bin		
		
		sum fct_mfq3
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_mfq3_bin=.
		replace fct_mfq3_bin=0 if fct_mfq3<`middle'
		replace fct_mfq3_bin=1 if fct_mfq3>=`middle' & fct_mfq3!=.
		
		label variable fct_mfq3_bin "MFQ: low self-worth"
		label values fct_mfq3_bin fct_mfq3_bin
		label define fct_mfq3_bin 0 "lower range" 1 "upper range"
		
		tab fct_mfq3_bin
		
		drop unhap-wrong
		
	*Substance use
	
		preserve
			keep /*
			*/ id /*
			*/ cm_smokefrequency /*
			*/ cm_ecig /*
			*/ cm_alcohol /*
			*/ cm_cannabis /*
			*/ cm_otherdrug
						
			rename cm_smokefrequency smok
			rename cm_ecig cig
			rename cm_alcohol alc
			rename cm_cannabis can
			rename cm_otherdrug oth
			
			runmplus smok cig alc can oth, type(efa 1 2) categorical(all)
			
			runmplus smok cig alc can oth id, idvariable(id) categorical(all) ///
			model(f by smok cig alc can oth;) 
					
			capture runmplus smok cig alc can oth id, idvariable(id) categorical(all) ///
			model(f by smok cig alc can oth;)  ///
			savedata(save=fscores; file=c:\temp\temp.dat) ///
			savelogfile(c:\temp\temp) saveinputfile(c:\temp\mplus\cfa_subs) saveinputdatafile(c:\temp\mplus\cfa_subs)
		restore		
				
		preserve
			runmplus_load_savedata , out(c:/temp/temp.out) clear
			save "c:\temp\fscores.dta", replace	
		restore
		
		joinby id using "c:\temp\fscores.dta"		
	
		*Check factors scores against those produced within Stata
			
			preserve
				polychoric /*
				*/ cm_smokefrequency /*
				*/ cm_ecig /*
				*/ cm_alcohol /*
				*/ cm_cannabis /*
				*/ cm_otherdrug
				local N=r(sum_w)	
				matrix r=r(R)
				factormat r, n(`N') factors(1)
				predict f1
				scatter f1 f
			restore
		
		rename f fct_subuse
		label variable fct_subuse "substance use"
		drop smok cig alc can oth

		sum fct_subuse
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_subuse_bin=.
		replace fct_subuse_bin=0 if fct_subuse<`middle'
		replace fct_subuse_bin=1 if fct_subuse>=`middle' & fct_subuse!=.
		
		label variable fct_subuse_bin "substance use"
		label values fct_subuse_bin fct_subuse_bin
		label define fct_subuse_bin 0 "lower range" 1 "upper range"
		
		tab fct_subuse_bin			
	
	*Gambling
	
		preserve
			keep /*
			*/ id /*
			*/ cm_fruitmachine /*
			*/ cm_privatebet /*
			*/ cm_bettingshop /*
			*/ cm_othergamble
						
			rename cm_fruitmachine fruit
			rename cm_privatebet priv
			rename cm_bettingshop bshop
			rename cm_othergamble other
			
			runmplus fruit priv bshop other, type(efa 1 1) categorical(all)
			
			runmplus fruit priv bshop other id, idvariable(id) categorical(all) ///
			model(f by fruit priv bshop other;) modindices(all)
					
			capture runmplus fruit priv bshop other id, idvariable(id) categorical(all) ///
			model(f by fruit priv bshop other;)  ///
			savedata(save=fscores; file=c:\temp\temp.dat) ///
			savelogfile(c:\temp\temp) saveinputfile(c:\temp\mplus\cfa_gamb) saveinputdatafile(c:\temp\mplus\cfa_gamb)
		restore		
				
		preserve
			runmplus_load_savedata , out(c:/temp/temp.out) clear
			save "c:\temp\fscores.dta", replace	
		restore
		
		joinby id using "c:\temp\fscores.dta"	
	
		*Check factors scores against those produced within Stata
			
			preserve
				polychoric /*
				*/ cm_fruitmachine /*
				*/ cm_privatebet /*
				*/ cm_bettingshop /*
				*/ cm_othergamble
				local N=r(sum_w)	
				matrix r=r(R)
				factormat r, n(`N') factors(1)
				predict f1
				scatter f1 f
			restore
		
		rename f fct_gamble
		label variable fct_gamble "gambling"
		drop fruit priv bshop other

		sum fct_gamble
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_gamble_bin=.
		replace fct_gamble_bin=0 if fct_gamble<`middle'
		replace fct_gamble_bin=1 if fct_gamble>=`middle' & fct_gamble!=.
		
		label variable fct_gamble_bin "gambling"
		label values fct_gamble_bin fct_gamble_bin
		label define fct_gamble_bin 0 "lower range" 1 "upper range"
		
		tab fct_gamble_bin				
	
	*Antisocial behaviour

		preserve
			keep /*
			*/ id /*
			*/ cm_noisy /*
			*/ cm_shoplift /*
			*/ cm_graffiti /*
			*/ cm_propertydamage /*
			*/ cm_carriedknife /*
			*/ cm_brokenin /*
			*/ cm_hitothers /*
			*/ cm_usedweapon /*
			*/ cm_stolen /*
			*/ cm_quespolice /*
			*/ cm_cautionedpolice /*
			*/ cm_arrested /*
			*/ cm_gang /*
			*/ cm_hack /*
			*/ cm_virus
						
			rename cm_noisy noise
			rename cm_shoplift shopl
			rename cm_graffiti graff
			rename cm_propertydamage propda
			rename cm_carriedknife knife
			rename cm_brokenin broke
			rename cm_hitothers hitoth
			rename cm_usedweapon usedwe
			rename cm_stolen stolen
			rename cm_quespolice ques
			rename cm_cautionedpolice caus 
			rename cm_arrested arres
			rename cm_gang gang 	
			rename cm_hack hack
			rename cm_virus virus

			
			runmplus noise-virus, type(efa 1 4) categorical(all)
			
			runmplus noise-virus id, idvariable(id) categorical(all) ///
			model(f1 by noise shopl graff propda knife broke hitoth usedwe stolen gang hack virus; f2 by ques caus arres;) 
						
			capture runmplus noise-virus id, idvariable(id) categorical(all) ///
			model(f1 by noise shopl graff propda knife broke hitoth usedwe stolen gang hack virus; f2 by ques caus arres;)   ///
			savedata(save=fscores; file=c:\temp\temp.dat) ///
			savelogfile(c:\temp\temp) saveinputfile(c:\temp\mplus\cfa_antisoc) saveinputdatafile(c:\temp\mplus\cfa_antisoc)
		restore		
				
		preserve
			runmplus_load_savedata , out(c:/temp/temp.out) clear
			save "c:\temp\fscores.dta", replace	
		restore
		
		joinby id using "c:\temp\fscores.dta"		
	
		*Check factors scores against those produced within Stata
			
			preserve
				polychoric /*
				*/ cm_noisy /*
				*/ cm_shoplift /*
				*/ cm_graffiti /*
				*/ cm_propertydamage /*
				*/ cm_carriedknife /*
				*/ cm_brokenin /*
				*/ cm_hitothers /*
				*/ cm_usedweapon /*
				*/ cm_stolen /*
				*/ cm_quespolice /*
				*/ cm_cautionedpolice /*
				*/ cm_arrested /*
				*/ cm_gang /*
				*/ cm_hack /*
				*/ cm_virus
				local N=r(sum_w)	
				matrix r=r(R)
				factormat r, n(`N') factors(1)
				predict f
				scatter f f1
				scatter f f2
			restore
		
		rename f1 fct_antisoc1
		label variable fct_antisoc1 "antisocial behaviour: acts"
		
		rename f2 fct_antisoc2
		label variable fct_antisoc2 "antisocial behaviour: police contact"
		
		sum fct_antisoc1
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_antisoc1_bin=.
		replace fct_antisoc1_bin=0 if fct_antisoc1<`middle'
		replace fct_antisoc1_bin=1 if fct_antisoc1>=`middle' & fct_antisoc1!=.
		
		label variable fct_antisoc1_bin "antisocial behaviour: acts"
		label values fct_antisoc1_bin fct_antisoc1_bin
		label define fct_antisoc1_bin 0 "lower range" 1 "upper range"
		
		tab fct_antisoc1_bin
		
		sum fct_antisoc2
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_antisoc2_bin=.
		replace fct_antisoc2_bin=0 if fct_antisoc2<`middle'
		replace fct_antisoc2_bin=1 if fct_antisoc2>=`middle' & fct_antisoc2!=.
		
		label variable fct_antisoc2_bin "antisocial behaviour: police contact"
		label values fct_antisoc2_bin fct_antisoc2_bin
		label define fct_antisoc2_bin 0 "lower range" 1 "upper range"
		
		tab fct_antisoc2_bin
		
		drop noise-virus
		
	*Externalising behaviour (mother's report only)
	
		preserve
			keep /*
			*/ id /*
			*/ m_cm_external_1 /*
			*/ m_cm_external_2 /*
			*/ m_cm_external_3 /*
			*/ m_cm_external_4 /*
			*/ m_cm_external_5 /*
			*/ m_cm_external_6 /*
			*/ m_cm_external_7 /*
			*/ m_cm_external_8 /*
			*/ m_cm_external_9 /*
			*/ m_cm_external_10
						
			rename m_cm_external_1 ext1
			rename m_cm_external_2 ext2
			rename m_cm_external_3 ext3
			rename m_cm_external_4 ext4
			rename m_cm_external_5 ext5
			rename m_cm_external_6 ext6
			rename m_cm_external_7 ext7
			rename m_cm_external_8 ext8
			rename m_cm_external_9 ext9
			rename m_cm_external_10 ext10

			runmplus ext1-ext10, type(efa 1 5) categorical(all)
			
			runmplus ext1-ext10 id, idvariable(id) categorical(all) ///
			model(f1 by ext1-ext3; f2 by ext4-ext5; f3 by ext6-ext7; f4 by ext8-ext10;) modindices(all)

			runmplus ext1-ext10 id, idvariable(id) categorical(all) ///
			model(f1 by ext1-ext3; f2 by ext4-ext5; f3 by ext6-ext8; f4 by ext8-ext10;) 

			capture runmplus ext1-ext10 id, idvariable(id) categorical(all) ///
			model(f1 by ext1-ext3; f2 by ext4-ext5; f3 by ext6-ext8; f4 by ext8-ext10;)  ///
			savedata(save=fscores; file=c:\temp\temp.dat) ///
			savelogfile(c:\temp\temp)
		restore		
				
		preserve
			runmplus_load_savedata , out(c:/temp/temp.out) clear
			save "c:\temp\fscores.dta", replace	
		restore
		
		joinby id using "c:\temp\fscores.dta"		
	
		*Check factors scores against those produced within Stata
			
			preserve
				polychoric /*
				*/ m_cm_external_1 /*
				*/ m_cm_external_2 /*
				*/ m_cm_external_3 /*
				*/ m_cm_external_4 /*
				*/ m_cm_external_5 /*
				*/ m_cm_external_6 /*
				*/ m_cm_external_7 /*
				*/ m_cm_external_8 /*
				*/ m_cm_external_9 /*
				*/ m_cm_external_10 
				local N=r(sum_w)	
				matrix r=r(R)
				factormat r, n(`N') factors(1)
				predict f
				scatter f f1
				scatter f f2 
				scatter f f3 
				scatter f f4
			restore
		
		rename f1 fct_ext1
		label variable fct_ext1 "externalising behaviour: problem behaviour"
		
		rename f2 fct_ext2
		label variable fct_ext2 "externalising behaviour: steals, lies or cheats"
		
		rename f3 fct_ext3 
		label variable fct_ext3 "externalising behaviour: restless"
		
		rename f4 fct_ext4
		label variable fct_ext4 "externalising behaviour: distracted"
		
		sum fct_ext1
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_ext1_bin=.
		replace fct_ext1_bin=0 if fct_ext1<`middle'
		replace fct_ext1_bin=1 if fct_ext1>=`middle' & fct_ext1!=.
		
		label variable fct_ext1_bin "externalising behaviour: problem behaviour"
		label values fct_ext1_bin fct_ext1_bin
		label define fct_ext1_bin 0 "lower range" 1 "upper range"
		
		tab fct_ext1_bin	
		
		sum fct_ext2
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_ext2_bin=.
		replace fct_ext2_bin=0 if fct_ext2<`middle'
		replace fct_ext2_bin=1 if fct_ext2>=`middle' & fct_ext2!=.
		
		label variable fct_ext2_bin "externalising behaviour: steals, lies or cheats"
		label values fct_ext2_bin fct_ext2_bin
		label define fct_ext2_bin 0 "lower range" 1 "upper range"
		
		tab fct_ext2_bin
		
		sum fct_ext3
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_ext3_bin=.
		replace fct_ext3_bin=0 if fct_ext3<`middle'
		replace fct_ext3_bin=1 if fct_ext3>=`middle' & fct_ext3!=.
		
		label variable fct_ext3_bin "externalising behaviour: restless"
		label values fct_ext3_bin fct_ext3_bin
		label define fct_ext3_bin 0 "lower range" 1 "upper range"
		
		tab fct_ext3_bin
		
		sum fct_ext4
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_ext4_bin=.
		replace fct_ext4_bin=0 if fct_ext4<`middle'
		replace fct_ext4_bin=1 if fct_ext4>=`middle' & fct_ext4!=.
		
		label variable fct_ext4_bin "externalising behaviour: distracted"
		label values fct_ext4_bin fct_ext4_bin
		label define fct_ext4_bin 0 "lower range" 1 "upper range"
		
		tab fct_ext4_bin
		
		drop ext1-ext10
			
	*Internalising behaviour (mother's report only)
	
		preserve
			keep /*
			*/ id /*
			*/ m_cm_internal_1 /*
			*/ m_cm_internal_2 /*
			*/ m_cm_internal_3 /*
			*/ m_cm_internal_4 /*
			*/ m_cm_internal_5 /*
			*/ m_cm_internal_6 /*
			*/ m_cm_internal_7 /*
			*/ m_cm_internal_8 /*
			*/ m_cm_internal_9 
			
			rename m_cm_internal_1 int1
			rename m_cm_internal_2 int2
			rename m_cm_internal_3 int3
			rename m_cm_internal_4 int4
			rename m_cm_internal_5 int5
			rename m_cm_internal_6 int6
			rename m_cm_internal_7 int7
			rename m_cm_internal_8 int8
			rename m_cm_internal_9 int9

			runmplus int1-int9, type(efa 1 4) categorical(all)
				
			runmplus int1-int9 id, idvariable(id) categorical(all) ///
			model(f1 by int1-int3; f2 by int4-int5; f3 by int6-int9;) modindices(all)		
			
			runmplus int1-int9 id, idvariable(id) categorical(all) ///
			model(f1 by int1-int3 int9; f2 by int4-int5; f3 by int6-int9;)
			
			capture runmplus int1-int9 id, idvariable(id) categorical(all) ///
			model(f1 by int1-int3 int9; f2 by int4-int5; f3 by int6-int9;)  ///
			savedata(save=fscores; file=c:\temp\temp.dat) ///
			savelogfile(c:\temp\temp)
		restore		
				
		preserve
			runmplus_load_savedata , out(c:/temp/temp.out) clear
			save "c:\temp\fscores.dta", replace	
		restore
		
		joinby id using "c:\temp\fscores.dta"	
	
		*Check factors scores against those produced within Stata
			
			preserve
				polychoric /*
				*/ m_cm_internal_1 /*
				*/ m_cm_internal_2 /*
				*/ m_cm_internal_3 /*
				*/ m_cm_internal_4 /*
				*/ m_cm_internal_5 /*
				*/ m_cm_internal_6 /*
				*/ m_cm_internal_7 /*
				*/ m_cm_internal_8 /*
				*/ m_cm_internal_9
				local N=r(sum_w)	
				matrix r=r(R)
				factormat r, n(`N') factors(1)
				predict f
				scatter f f1
				scatter f f2 
				scatter f f3
			restore
		
		rename f1 fct_int1
		label variable fct_int1 "internalising behaviour: worried, unhapy, somatic symptoms"
		
		rename f2 fct_int2
		label variable fct_int2 "internalising behaviour: nervous, clingy, and easily scared"
		
		rename f3 fct_int3 
		label variable fct_int3 "externalising behaviour: tends to play alone"
		
		sum fct_int1
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_int1_bin=.
		replace fct_int1_bin=0 if fct_int1<`middle'
		replace fct_int1_bin=1 if fct_int1>=`middle' & fct_int1!=.
		
		label variable fct_int1_bin "internalising behaviour: worried, unhappy, somatic symptoms"
		label values fct_int1_bin fct_int1_bin
		label define fct_int1_bin 0 "lower range" 1 "upper range"
		
		tab fct_int1_bin		
	
		sum fct_int2
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_int2_bin=.
		replace fct_int2_bin=0 if fct_int2<`middle'
		replace fct_int2_bin=1 if fct_int2>=`middle' & fct_int2!=.
		
		label variable fct_int2_bin "internalising behaviour: nervous, clingy, easily scared"
		label values fct_int2_bin fct_int2_bin
		label define fct_int2_bin 0 "lower range" 1 "upper range"
		
		tab fct_int2_bin		
	
		sum fct_int3
		local lower=r(min)
		local upper=r(max)
		local middle=(`upper'+`lower')/2
		di `middle'
		
		gen fct_int3_bin=.
		replace fct_int3_bin=0 if fct_int3<`middle'
		replace fct_int3_bin=1 if fct_int3>=`middle' & fct_int3!=.
		
		label variable fct_int3_bin "internalising behaviour: tends to play alone"
		label values fct_int3_bin fct_int3_bin
		label define fct_int3_bin 0 "lower range" 1 "upper range"
		
		tab fct_int3_bin	
		
		drop int1-int9
		
	*Create binary variables for academic attainment
	
		foreach subject in english math science pe {
	
			gen cm_`subject'_bin=.
			replace cm_`subject'_bin=0 if inlist(cm_good_`subject', 1, 2)
			replace cm_`subject'_bin=1 if inlist(cm_good_`subject', 3, 4)
			label variable cm_`subject'_bin "I am good at `subject'"
			label values cm_`subject'_bin cm_`subject'_bin 
			label define cm_`subject'_bin /*
			*/ 0 "strongly agree or agree" 1 "disagree or strongly disagree"
			tab cm_`subject'_bin cm_`subject'
			
		}
		
*Save analysis dataset

	save "C:\Users\heinh\OneDrive - University of Leeds\Work docs\Research\MCS selfharm gender study\analysis dataset.dta", replace
		

*Open analysis dataset

	use "C:\Users\heinh\OneDrive - University of Leeds\Work docs\Research\MCS selfharm gender study\analysis dataset.dta", clear
	
*Compare groups with complete and item-missing data

	preserve
	
		local variables "`variables' cm_live_mother_bin cm_live_father_bin cm_close_mother_bin cm_close_father_bin cm_argue_mother_bin cm_argue_father_bin"
		local variables "`variables' fct_socsup_bin"
		local variables "`variables' fct_bullies_bin fct_bullied_bin fct_assaulted_bin"
		local variables "`variables' cm_sassault"
		local variables "`variables' fct_weight_bin"
		local variables "`variables' fct_mfq1_bin fct_mfq2_bin fct_mfq3_bin"
		local variables "`variables' cm_happy_appear_bin cm_happy_school_bin cm_happy_family_bin cm_happy_friends_bin cm_happy_life_bin"
		local variables "`variables' cm_english_bin cm_math_bin cm_science_bin cm_pe_bin"
		local variables "`variables' cm_selfest_1_bin cm_selfest_2_bin cm_selfest_3_bin cm_selfest_4_bin cm_selfest_5_bin"
		local variables "`variables' cm_socmed_bin"
		local variables "`variables' cm_partner cm_wor_tellpartner cm_wor_tellparents cm_wor_tellsib cm_wor_tellrel cm_wor_tellteach cm_wor_telladult"
		local variables "`variables' cm_risk_bin"
		local variables "`variables' cm_patient_bin"
		local variables "`variables' cm_trust_bin"
		local variables "`variables' fct_subuse_bin"
		local variables "`variables' fct_gamble_bin"
		local variables "`variables' fct_antisoc1_bin fct_antisoc2_bin"
		local variables "`variables' m_longillness f_longillness"
		local variables "`variables' m_lifesat_bin f_lifesat_bin"
		local variables "`variables' m_alcohol_bin f_alcohol_bin"
		local variables "`variables' cm_secondsex"
		local variables "`variables' cm_samesex"
		local variables "`variables' fct_ext1_bin fct_ext2_bin fct_ext3_bin fct_ext4_bin"
		local variables "`variables' fct_int1_bin fct_int2_bin fct_int3_bin"
		local variables "`variables' cm_sdq_emotion_bin"
		local variables "`variables' cm_sdq_conduct_bin"
		local variables "`variables' cm_sdq_hyper_bin"
		local variables "`variables' cm_sdq_peer_bin"
		local variables "`variables' cm_sdq_prosoc_bin"
		
		misstable sum `variables'
		
		tab cm_argue_father_bin, miss
		tab cm_selfest_4_bin, miss
		tab m_lifesat_bin, miss
		
		foreach var in cm_argue_father_bin cm_selfest_4_bin m_lifesat_bin {
		
			gen `var'_m=.
			replace `var'_m=0 if `var'!=.
			replace `var'_m=1 if `var'==.
			tab `var' `var'_m, missing
		}
		
		*Missing data on arguing with father
		
			tab cm_selfharm cm_argue_father_bin_m, col
			svy: tab cm_selfharm cm_argue_father_bin_m, col
			
			tab f_cm_argue_bin cm_argue_father_bin_m, col
			svy: tab f_cm_argue_bin cm_argue_father_bin_m, col
		
		*Missing data on self-esteem item
		
			tab cm_selfharm cm_selfest_4_bin_m, col
			svy: tab cm_selfharm cm_selfest_4_bin_m, col
			
			tab cm_selfest_1_bin cm_selfest_4_bin_m, col
			svy: tab cm_selfest_1_bin cm_selfest_4_bin_m, col
			
			tab cm_selfest_2_bin cm_selfest_4_bin_m, col
			svy: tab cm_selfest_2_bin cm_selfest_4_bin_m, col
	
			tab cm_selfest_3_bin cm_selfest_4_bin_m, col	
			svy: tab cm_selfest_3_bin cm_selfest_4_bin_m, col
			
			tab cm_selfest_5_bin cm_selfest_4_bin_m, col				
			svy: tab cm_selfest_5_bin cm_selfest_4_bin_m, col
		
		*Missing data on maternal life satisfaction
		
			tab cm_selfharm m_lifesat_bin_m, col
			svy: tab cm_selfharm m_lifesat_bin_m, col
			
			tab m_longillnessmh m_lifesat_bin_m, col
			svy: tab m_longillnessmh m_lifesat_bin_m, col
			
			tab f_lifesat_bin m_lifesat_bin_m, col
			svy: tab f_lifesat_bin m_lifesat_bin_m, col
		
	restore

	preserve
	
		local variables "`variables' cm_live_mother_bin cm_live_father_bin cm_close_mother_bin cm_close_father_bin cm_argue_mother_bin cm_argue_father_bin"
		local variables "`variables' fct_socsup_bin"
		local variables "`variables' fct_bullies_bin fct_bullied_bin fct_assaulted_bin"
		local variables "`variables' cm_sassault"
		local variables "`variables' fct_weight_bin"
		local variables "`variables' fct_mfq1_bin fct_mfq2_bin fct_mfq3_bin"
		local variables "`variables' cm_happy_appear_bin cm_happy_school_bin cm_happy_family_bin cm_happy_friends_bin cm_happy_life_bin"
		local variables "`variables' cm_english_bin cm_math_bin cm_science_bin cm_pe_bin"
		local variables "`variables' cm_selfest_1_bin cm_selfest_2_bin cm_selfest_3_bin cm_selfest_4_bin cm_selfest_5_bin"
		local variables "`variables' cm_socmed_bin"
		local variables "`variables' cm_partner cm_wor_tellpartner cm_wor_tellparents cm_wor_tellsib cm_wor_tellrel cm_wor_tellteach cm_wor_telladult"
		local variables "`variables' cm_risk_bin"
		local variables "`variables' cm_patient_bin"
		local variables "`variables' cm_trust_bin"
		local variables "`variables' fct_subuse_bin"
		local variables "`variables' fct_gamble_bin"
		local variables "`variables' fct_antisoc1_bin fct_antisoc2_bin"
		local variables "`variables' m_longillness f_longillness"
		local variables "`variables' m_lifesat_bin f_lifesat_bin"
		local variables "`variables' m_alcohol_bin f_alcohol_bin"
		local variables "`variables' cm_secondsex"
		local variables "`variables' cm_samesex"
		local variables "`variables' fct_ext1_bin fct_ext2_bin fct_ext3_bin fct_ext4_bin"
		local variables "`variables' fct_int1_bin fct_int2_bin fct_int3_bin"
		local variables "`variables' cm_sdq_emotion_bin"
		local variables "`variables' cm_sdq_conduct_bin"
		local variables "`variables' cm_sdq_hyper_bin"
		local variables "`variables' cm_sdq_peer_bin"
		local variables "`variables' cm_sdq_prosoc_bin"
		
		egen missing = rowmiss(`variables')
		tab missing
		
		
		
		
	restore
	
	preserve
		
		***
		*Note exclude father reported variables
		
		local variables "`variables' cm_live_mother_bin cm_live_father_bin cm_close_mother_bin cm_close_father_bin cm_argue_mother_bin cm_argue_father_bin"
		local variables "`variables' fct_socsup_bin"
		local variables "`variables' fct_bullies_bin fct_bullied_bin fct_assaulted_bin"
		local variables "`variables' cm_sassault"
		local variables "`variables' fct_weight_bin"
		local variables "`variables' fct_mfq1_bin fct_mfq2_bin fct_mfq3_bin"
		local variables "`variables' cm_happy_appear_bin cm_happy_school_bin cm_happy_family_bin cm_happy_friends_bin cm_happy_life_bin"
		local variables "`variables' cm_english_bin cm_math_bin cm_science_bin cm_pe_bin"
		local variables "`variables' cm_selfest_1_bin cm_selfest_2_bin cm_selfest_3_bin cm_selfest_4_bin cm_selfest_5_bin"
		local variables "`variables' cm_socmed_bin"
		local variables "`variables' cm_partner cm_wor_tellpartner cm_wor_tellparents cm_wor_tellsib cm_wor_tellrel cm_wor_tellteach cm_wor_telladult"
		local variables "`variables' cm_risk_bin"
		local variables "`variables' cm_patient_bin"
		local variables "`variables' cm_trust_bin"
		local variables "`variables' fct_subuse_bin"
		local variables "`variables' fct_gamble_bin"
		local variables "`variables' fct_antisoc1_bin fct_antisoc2_bin"
		local variables "`variables' m_longillness"
		local variables "`variables' m_lifesat_bin"
		local variables "`variables' m_alcohol_bin"
		local variables "`variables' cm_secondsex"
		local variables "`variables' cm_samesex"
		local variables "`variables' fct_ext1_bin fct_ext2_bin fct_ext3_bin fct_ext4_bin"
		local variables "`variables' fct_int1_bin fct_int2_bin fct_int3_bin"
		local variables "`variables' cm_sdq_emotion_bin"
		local variables "`variables' cm_sdq_conduct_bin"
		local variables "`variables' cm_sdq_hyper_bin"
		local variables "`variables' cm_sdq_peer_bin"
		local variables "`variables' cm_sdq_prosoc_bin"
		
		egen missing = rowmiss(`variables')
		tab missing		
		recode missing (1/16=1)
		tab missing
		
		*Table:

			tab cm_female missing
			svy: tab cm_female missing, col
			
			tab cm_age missing
			svy: tab cm_age missing, col
			
			tab cm_ethnicity missing
			svy: tab cm_ethnicity missing, col
			
			tab p_nssec missing
			svy: tab p_nssec missing, col
			
			tab hh_region missing
			svy: tab hh_region missing, col

			tab hh_urban2 missing
			svy: tab hh_urban2 missing, col
			
			foreach type in overall income employment health education {	
			tab imd04_`type'_bin missing
			svy: tab imd04_`type'_bin missing, col
			}
		
		
	restore
		
*Gender differences in prevalence/levels of exposure

	svy: tab cm_live_mother_bin cm_female, col 
	svy: tab cm_live_father_bin cm_female, col 
	svy: tab cm_close_mother_bin cm_female, col 
	svy: tab cm_close_father_bin cm_female, col 
	svy: tab cm_argue_mother_bin cm_female, col 
	svy: tab cm_argue_father_bin cm_female, col 
	svy: tab fct_socsup_bin cm_female, col
	svy: tab fct_bullies_bin cm_female, col 
	svy: tab fct_bullied_bin cm_female, col 
	svy: tab fct_assaulted_bin cm_female, col
	svy: tab cm_sassault cm_female, col 	
	svy: tab fct_weight_bin cm_female, col 
	svy: tab fct_mfq1_bin cm_female, col
	svy: tab fct_mfq2_bin cm_female, col
	svy: tab fct_mfq3_bin cm_female, col
	svy: tab cm_happy_appear_bin cm_female, col
	svy: tab cm_happy_school_bin cm_female, col
	svy: tab cm_happy_family_bin cm_female, col
	svy: tab cm_happy_friends_bin cm_female, col
	svy: tab cm_happy_life_bin cm_female, col
	svy: tab cm_english_bin cm_female, col
	svy: tab cm_math_bin cm_female, col
	svy: tab cm_science_bin cm_female, col
	svy: tab cm_pe_bin cm_female, col
	svy: tab cm_selfest_1_bin cm_female, col
	svy: tab cm_selfest_2_bin cm_female, col
	svy: tab cm_selfest_3_bin cm_female, col
	svy: tab cm_selfest_4_bin cm_female, col
	svy: tab cm_selfest_5_bin cm_female, col
	svy: tab cm_socmed_bin cm_female, col
	svy: tab cm_partner cm_female, col
	svy: tab cm_wor_tellpartner cm_female, col
	svy: tab cm_wor_tellparents cm_female, col
	svy: tab cm_wor_tellsib cm_female, col
	svy: tab cm_wor_tellrel cm_female, col
	svy: tab cm_wor_tellteach cm_female, col
	svy: tab cm_wor_telladult cm_female, col
	svy: tab cm_risk_bin cm_female, col
	svy: tab cm_patient_bin cm_female, col
	svy: tab cm_trust_bin cm_female, col
	svy: tab fct_subuse_bin cm_female, col
	svy: tab fct_gamble_bin cm_female, col
	svy: tab fct_antisoc1_bin cm_female, col
	svy: tab fct_antisoc2_bin cm_female, col
	svy: tab m_longillness cm_female, col
	svy: tab f_longillness cm_female, col
	svy: tab m_lifesat_bin cm_female, col
	svy: tab f_lifesat_bin cm_female, col
	svy: tab m_alcohol_bin cm_female, col
	svy: tab f_alcohol_bin cm_female, col
	svy: tab cm_secondsex cm_female, col
	svy: tab cm_samesex cm_female, col
	svy: tab fct_ext1_bin cm_female, col	
	svy: tab fct_ext2_bin cm_female, col	
	svy: tab fct_ext3_bin cm_female, col	
	svy: tab fct_ext4_bin cm_female, col	
	svy: tab fct_int1_bin cm_female, col	
	svy: tab fct_int2_bin cm_female, col	
	svy: tab fct_int3_bin cm_female, col	
	svy: tab cm_sdq_emotion_bin cm_female, col
	svy: tab cm_sdq_conduct_bin cm_female, col
	svy: tab cm_sdq_hyper_bin cm_female, col
	svy: tab cm_sdq_peer_bin cm_female, col
	svy: tab cm_sdq_prosoc_bin cm_female, col
	
*Analysis of exposure-outcome association

	*Input grouping variable here: 

		local groupvar "cm_selfharm"

	*Input other characteristics here:
		
		local variables "`variables' cm_live_mother_bin cm_live_father_bin cm_close_mother_bin cm_close_father_bin cm_argue_mother_bin cm_argue_father_bin"
		local variables "`variables' fct_socsup_bin"
		local variables "`variables' fct_bullies_bin fct_bullied_bin fct_assaulted_bin"
		local variables "`variables' cm_sassault"
		local variables "`variables' fct_weight_bin"
		local variables "`variables' fct_mfq1_bin fct_mfq2_bin fct_mfq3_bin"
		local variables "`variables' cm_happy_appear_bin cm_happy_school_bin cm_happy_family_bin cm_happy_friends_bin cm_happy_life_bin"
		local variables "`variables' cm_english_bin cm_math_bin cm_science_bin cm_pe_bin"
		local variables "`variables' cm_selfest_1_bin cm_selfest_2_bin cm_selfest_3_bin cm_selfest_4_bin cm_selfest_5_bin"
		local variables "`variables' cm_socmed_bin"
		local variables "`variables' cm_partner cm_wor_tellpartner cm_wor_tellparents cm_wor_tellsib cm_wor_tellrel cm_wor_tellteach cm_wor_telladult"
		local variables "`variables' cm_risk_bin"
		local variables "`variables' cm_patient_bin"
		local variables "`variables' cm_trust_bin"
		local variables "`variables' fct_subuse_bin"
		local variables "`variables' fct_gamble_bin"
		local variables "`variables' fct_antisoc1_bin fct_antisoc2_bin"
		local variables "`variables' m_longillness f_longillness"
		local variables "`variables' m_lifesat_bin f_lifesat_bin"
		local variables "`variables' m_alcohol_bin f_alcohol_bin"
		local variables "`variables' cm_secondsex"
		local variables "`variables' cm_samesex"
		local variables "`variables' fct_ext1_bin fct_ext2_bin fct_ext3_bin fct_ext4_bin"
		local variables "`variables' fct_int1_bin fct_int2_bin fct_int3_bin"
		local variables "`variables' cm_sdq_emotion_bin"
		local variables "`variables' cm_sdq_conduct_bin"
		local variables "`variables' cm_sdq_hyper_bin"
		local variables "`variables' cm_sdq_peer_bin"
		local variables "`variables' cm_sdq_prosoc_bin"

*************************************************

	foreach var in `variables' {
	tab `var', miss
	}

	di "`variables'"
	tokenize "`variables'"
	
	foreach var in `variables' {
		svytable1 `var' `groupvar' "C:\Users\heinh\OneDrive - University of Leeds\Work docs\Research\MCS selfharm gender study\finalised output\2021\Scales combined as factors\Table 1\"
	}

	local n_vars : word count `variables'
	
	forvalues i = 1/`n_vars' {
		local n`i' : word `i' of `variables'
	}
	
	use "C:\Users\heinh\OneDrive - University of Leeds\Work docs\Research\MCS selfharm gender study\finalised output\2021\Scales combined as factors\Table 1\\`1'.dta", clear
	
	forvalues i = 2 /`n_vars' {
		append using "C:\Users\heinh\OneDrive - University of Leeds\Work docs\Research\MCS selfharm gender study\finalised output\2021\Scales combined as factors\Table 1\\``i''.dta"
	}
	
	export excel using "C:\Users\heinh\OneDrive - University of Leeds\Work docs\Research\MCS selfharm gender study\finalised output\2021\Scales combined as factors\Table 1\Table 1.xls", firstrow(variables) replace

	forvalues i = 1 /`n_vars' {
		erase "C:\Users\heinh\OneDrive - University of Leeds\Work docs\Research\MCS selfharm gender study\finalised output\2021\Scales combined as factors\Table 1\\``i''.dta"
	}

