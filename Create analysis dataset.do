
set more off

/*
Notes: 

1) Clean up the CM data 
2) Clean and combine mother and mother derived data
3) Clean and combine father and father derived data
4) Clean and combine mother reporting on CM data
5) Clean and combine father reporting on CM data
6) Clean up the CM_derived data
7) Combine all datasets

*/

*Step 1A - Install table 1

*Install table1
	/*
	sysdir set PLUS "M:\ado\plus"
	findit table1
	*/
	
*Set local for data location

local data "C:\Users\heinh\OneDrive - University of Leeds\Data\UKDA-8156-stata\stata\stata13"
local temp "C:\Users\heinh\OneDrive - University of Leeds\Data\Temp"

**************************************************************************************
*Step 1: Clean up the CM data

	*Open CM interview dataset
		
		use13 "`data'\mcs6_cm_interview.dta", clear
		keep MCSID FCNUM00 FCCSEX00 FCCAGE00 FCHARM00 FCROLE00 FCIMWK00 FCRLQM00 FCRLQF00 /*
		*/ FCQUAM00 FCQUAF00 FCNUFR00 FCFRBY00 FCFRGL00 FCSAFF00 FCTRSS00 FCNCLS00 /*
		*/FCBULB00 FCBULP00 FCHURT00 FCPCKP00 FCCYBU00 FCCYBO00 FCVICG00 FCVICA00 /*
		*/FCVICC00 FCVICE00 FCVICF0A FCWEGT00 FCLSWT00 FCSCWK00 FCWYLK00 FCFMLY00 /*
		*/FCFRNS00 FCSCHL00 FCLIFE00 FCSATI00 FCGDQL00 FCDOWL00 FCVALU00 FCGDSF00 /*  
		*/FCSOME00 FCENGL00 FCWLSH00 FCMTHS00 FCSCIE00 FCGDPE00 FCMAAB00 FCCOMO00 /*
		*/FCSEMA00 FCPAAB00 FCCOFA00 FCWRRY0A FCWRRY0B FCWRRY0C FCWRRY0D /*
		*/FCWRRY0E FCWRRY0F FCWRRY0G FCBGFR00 FCROMG00 FCROMB00 FCPUHG00 FCPUBH00 /*
		*/FCPUSK00 FCPUVC00 FCPUFH00 FCPUBR00 FCPUMN00 FCAGMN0A FCMDSA00 FCMDSB00 /*
		*/FCMDSC00 FCMDSD00 FCMDSE00 FCMDSF00 FCMDSG00 FCMDSH00 FCMDSI00 FCMDSJ00 /*
		*/FCMDSK00 FCMDSL00 FCMDSM00 FCRISK00 FCPTNT00 FCTRST0A /*
        *//*
		*/FCSMOK00 FCAGSM00 FCECIG00 FCALCD00 FCALAG00 FCALNF00 FCCANB00 FCOTDR00 /*
        */FCGAMA00 FCGMBL00 FCGAEM00 FCGAMJ00 FCRUDE00 FCSTOL00 FCSPRY00 FCDAMG00 /*
		*/FCKNIF00 FCROBH00 FCHITT00 FCWEPN00 FCSTLN00 FCPOLS00 FCCAUT00 FCARES00 /*
		*/FCGANG00 FCVIRS00 FCHACK00
				
*DATA MANAGEMENT

	*Selfharm
	
		gen cm_selfharm=.
		replace cm_selfharm=0 if FCHARM00==2
		replace cm_selfharm=1 if FCHARM00==1
		label variable cm_selfharm "past year self-harmed?"
		label values cm_selfharm cm_selfharm
		label define cm_selfharm /*
		*/ 1 "yes" 0 "no" 
		tab cm_selfharm FCHARM00, miss
		tab cm_selfharm, miss
		
	*Gender
	
		gen cm_female=.
		replace cm_female=0 if FCCSEX00==1
		replace cm_female=1 if FCCSEX00==2
		label variable cm_female "respondent female?"
		label values cm_female cm_female
		label define cm_female /*
		*/ 1 "yes" 0 "no" 
		tab cm_female FCCSEX00, miss
		tab cm_female, miss
		
	*Age
	
		gen cm_age=FCCAGE00
		label variable cm_age "respondent's age at last birthday"
		label value cm_age cm_age
		label define cm_age 13 "13" 14 "14" 15 "15"
		tab cm_age

	*Gender roles
	
		gen cm_role1=. 
		replace cm_role1=1 if FCROLE00==1
		replace cm_role1=2 if FCROLE00==2		
		replace cm_role1=3 if FCROLE00==3	
		replace cm_role1=4 if FCROLE00==4
		tab cm_role1 FCROLE00
		label variable cm_role1 "m & w should do same jobs around the house"
		label values cm_role1 cm_role1
		label define cm_role1 /*
		*/ 1 "s agree" 2 "agree" 3 "disagree" 4 "s disagree"
		tab cm_role1 FCROLE00, miss
		tab cm_role1, miss
		
		**
		
 		gen cm_role2=. 
		replace cm_role2=1 if FCIMWK00==4
		replace cm_role2=2 if FCIMWK00==3		
		replace cm_role2=3 if FCIMWK00==2	
		replace cm_role2=4 if FCIMWK00==1
		tab cm_role2 FCIMWK00
		label variable cm_role2 "less important for w to work than for m"
		label values cm_role2 cm_role2
		label define cm_role2 /*
		*/ 1 "s disagree" 2 "disagree" 3 "agree" 4 "s agree"
		tab cm_role2 FCIMWK00, miss
		tab cm_role2, miss
		
	*Closeness to parents
	
		gen cm_close_mother=.
		replace cm_close_mother=1 if FCRLQM00==4
		replace cm_close_mother=2 if FCRLQM00==3
		replace cm_close_mother=3 if FCRLQM00==2
		replace cm_close_mother=4 if FCRLQM00==1
		replace cm_close_mother=9 if FCRLQM00==5
		
		label variable cm_close_mother "respondent close to m?"
		label values cm_close_mother cm_close_mother 
		label define cm_close_mother /*
		*/ 1 "extremely close" 2 "very close" 3 "fairly close" 4 "not very close" 9 "no mother/not in contact" 
		tab cm_close_mother FCRLQM00, miss
		tab cm_close_mother, miss
	
		**
		
		gen cm_close_father=.
		replace cm_close_father=1 if FCRLQF00==4
		replace cm_close_father=2 if FCRLQF00==3
		replace cm_close_father=3 if FCRLQF00==2
		replace cm_close_father=4 if FCRLQF00==1
		replace cm_close_father=9 if FCRLQF00==5
		
		label variable cm_close_father "respondent close to f?"
		label values cm_close_father cm_close_father 
		label define cm_close_father /*
		*/ 1 "extremely close" 2 "very close" 3 "fairly close" 4 "not very close" 9 "no father/no contact" 
		tab cm_close_father FCRLQF00, miss
		tab cm_close_father, miss
		
		**
				
		gen cm_argue_mother=.
		replace cm_argue_mother=1 if FCQUAM00==5
		replace cm_argue_mother=2 if FCQUAM00==4
		replace cm_argue_mother=3 if FCQUAM00==3
		replace cm_argue_mother=4 if FCQUAM00==2
		replace cm_argue_mother=5 if FCQUAM00==1
		replace cm_argue_mother=9 if cm_close_mother==9
			
		label variable cm_argue_mother "how often argue with m?"
		label values cm_argue_mother cm_argue_mother 
		label define cm_argue_mother /*
		*/ 5 "most days" 4 ">once/week" 3 "<once/week" 2 "hardly ever" 1 "never" 9 "no mother/no contact"
		tab cm_argue_mother FCQUAM00, miss
		tab cm_argue_mother, miss

		**
			
		gen cm_argue_father=.
		replace cm_argue_father=1 if FCQUAF00==5
		replace cm_argue_father=2 if FCQUAF00==4
		replace cm_argue_father=3 if FCQUAF00==3
		replace cm_argue_father=4 if FCQUAF00==2
		replace cm_argue_father=5 if FCQUAF00==1
		replace cm_argue_father=9 if cm_close_father==9
			
		label variable cm_argue_father "how often argue with f?"
		label values cm_argue_father cm_argue_father 
		label define cm_argue_father /*
		*/ 5 "most days" 4 ">once/week" 3 "<once/week" 2 "hardly ever" 1 "never" 9 "no father/no contact"
		tab cm_argue_father FCQUAF00, miss
		tab cm_argue_father, miss

	* Close Friends	
	
		gen cm_friends=.
		replace cm_friends=0 if FCNUFR00==1
		replace cm_friends=1 if FCNUFR00==2
			
		label variable cm_friends "any close friends?"
		label values cm_friends cm_friends 
		label define cm_friends /*
		*/ 1 "no" 0 "yes" 
		tab cm_friends FCNUFR00, miss
		tab cm_friends, miss
	
		**
	
		gen cm_friends_b=.
		replace cm_friends_b=1 if FCFRBY00==1
		replace cm_friends_b=2 if FCFRBY00==2
		replace cm_friends_b=3 if FCFRBY00==3
		replace cm_friends_b=4 if FCFRBY00==4
		replace cm_friends_b=9 if cm_friends==1
			
		label variable cm_friends_b "how many of your close friends are boys?"
		label values cm_friends_b cm_friends_b 
		label define cm_friends_b /*
		*/ 1 "all" 2 "most" 3 "some" 4 "none" 9 "don't have close friends"
		tab cm_friends_b FCFRBY00, miss
		tab cm_friends_b, miss
	
		**
	
		gen cm_friends_g=.
		replace cm_friends_g=1 if FCFRGL00==1
		replace cm_friends_g=2 if FCFRGL00==2
		replace cm_friends_g=3 if FCFRGL00==3
		replace cm_friends_g=4 if FCFRGL00==4
		replace cm_friends_g=9 if cm_friends==1
			
		label variable cm_friends_g "how many of your close friends are girls?"
		label values cm_friends_g cm_friends_g 
		label define cm_friends_g /*
		*/ 1 "all" 2 "most" 3 "some" 4 "none" 9 "don't have close friends"
		tab cm_friends_g FCFRGL00, miss
		tab cm_friends_g, miss
				
	* Social support
	
		gen cm_safe=.
		replace cm_safe=1 if FCSAFF00==1
		replace cm_safe=2 if FCSAFF00==2
		replace cm_safe=3 if FCSAFF00==3
		tab cm_safe FCSAFF00
			
		label variable cm_safe "I have family and friends who help me feel safe, secure and happy"
		label values cm_safe cm_safe 
		label define cm_safe /*
		*/ 1 "very true" 2 "partly true" 3 "not true at all" 
		tab cm_safe FCSAFF00, miss
		tab cm_safe, miss
			
		**
			
		gen cm_trust=.
		replace cm_trust=1 if FCTRSS00==1
		replace cm_trust=2 if FCTRSS00==2
		replace cm_trust=3 if FCTRSS00==3
		tab cm_trust FCTRSS00
			
		label variable cm_trust "There is someone I trust whom I would turn to if I had problems"
		label values cm_trust cm_trust 
		label define cm_trust /*
		*/ 1 "very true" 2 "partly true" 3 "not true at all" 
		tab cm_trust FCTRSS00, miss
		tab cm_trust, miss
	
		**
	
		gen cm_close=.
		replace cm_close=1 if FCNCLS00 ==3
		replace cm_close=2 if FCNCLS00 ==2
		replace cm_close=3 if FCNCLS00 ==1
		tab cm_close FCNCLS00 
			
		label variable cm_close "There is no one I feel close to"
		label values cm_close cm_close 
		label define cm_close /*
		*/ 3 "very true" 2 "partly true" 1 "not true at all" 
		tab cm_close FCNCLS00, miss
		tab cm_close, miss
	
	* Bullying
	
		gen cm_hurt_by_sibs=.
		replace cm_hurt_by_sibs=1 if FCBULB0==6
		replace cm_hurt_by_sibs=2 if FCBULB0==5
		replace cm_hurt_by_sibs=3 if FCBULB0==4
		replace cm_hurt_by_sibs=4 if FCBULB0==3
		replace cm_hurt_by_sibs=5 if FCBULB0==2
		replace cm_hurt_by_sibs=6 if FCBULB0==1
		replace cm_hurt_by_sibs=9 if FCBULB0==7
		
		label variable cm_hurt_by_sibs "How often sibs hurt/pick on CM"
		label values cm_hurt_by_sibs cm_hurt_by_sibs 
		label define cm_hurt_by_sibs /*
		*/ 1 "Never" 2 "Less often" 3 "Every few months" 4 "once a month" 5 "About once a week" 6 "most days" 9 "don't have sibs"
		tab cm_hurt_by_sibs FCBULB0, miss
		tab cm_hurt_by_sibs, miss
		
		**

		gen cm_hurt_sibs=.
		replace cm_hurt_sibs=1 if FCBULP00==6
		replace cm_hurt_sibs=2 if FCBULP00==5
		replace cm_hurt_sibs=3 if FCBULP00==4
		replace cm_hurt_sibs=4 if FCBULP00==3
		replace cm_hurt_sibs=5 if FCBULP00==2
		replace cm_hurt_sibs=6 if FCBULP00==1
		replace cm_hurt_sibs=9 if FCBULP00==7
		
		label variable cm_hurt_sibs "How often CM hurts/picks on sibs"
		label values cm_hurt_sibs cm_hurt_sibs 
		label define cm_hurt_sibs /*
		*/ 1 "Never" 2 "Less often" 3 "Every few months" 4 "once a month" 5 "About once a week" 6 "most days" 9 "don't have sibs"
		tab cm_hurt_sibs FCBULP00, miss
		tab cm_hurt_sibs, miss
	
		**
			
		gen cm_hurt_others=.
		replace cm_hurt_others=1 if FCPCKP00==6
		replace cm_hurt_others=2 if FCPCKP00==5
		replace cm_hurt_others=3 if FCPCKP00==4
		replace cm_hurt_others=4 if FCPCKP00==3
		replace cm_hurt_others=5 if FCPCKP00==2
		replace cm_hurt_others=6 if FCPCKP00==1
		
		label variable cm_hurt_others "How often CM hurts/picks on other children"
		label values cm_hurt_others cm_hurt_others 
		label define cm_hurt_others /*
		*/ 1 "Never" 2 "Less often" 3 "Every few months" 4 "once a month" 5 "About once a week" 6 "most days" 
		tab cm_hurt_others FCPCKP00, miss
		tab cm_hurt_others, miss
		
		**
		
		gen cm_hurt_by_others=.
		replace cm_hurt_by_others=1 if FCHURT00==6
		replace cm_hurt_by_others=2 if FCHURT00==5
		replace cm_hurt_by_others=3 if FCHURT00==4
		replace cm_hurt_by_others=4 if FCHURT00==3
		replace cm_hurt_by_others=5 if FCHURT00==2
		replace cm_hurt_by_others=6 if FCHURT00==1
		
		label variable cm_hurt_by_others "How often others hurts/pick on CM"
		label values cm_hurt_by_others cm_hurt_by_others 
		label define cm_hurt_by_others /*
		*/ 1 "Never" 2 "Less often" 3 "Every few months" 4 "once a month" 5 "About once a week" 6 "most days" 
		tab cm_hurt_by_others FCHURT00, miss
		tab cm_hurt_by_others, miss
		
		**
		
		gen cm_onlinebully_by_others=.
		replace cm_onlinebully_by_others=1 if FCCYBU00==6
		replace cm_onlinebully_by_others=2 if FCCYBU00==5
		replace cm_onlinebully_by_others=3 if FCCYBU00==4
		replace cm_onlinebully_by_others=4 if FCCYBU00==3
		replace cm_onlinebully_by_others=5 if FCCYBU00==2
		replace cm_onlinebully_by_others=6 if FCCYBU00==1
		
		label variable cm_onlinebully_by_others "How often others bully CM online"
		label values cm_onlinebully_by_others cm_onlinebully_by_others 
		label define cm_onlinebully_by_others /*
		*/ 1 "Never" 2 "Less often" 3 "Every few months" 4 "once a month" 5 "About once a week" 6 "most days" 
		tab cm_onlinebully_by_others FCCYBU00, miss
		tab cm_onlinebully_by_others, miss
		
		**
		
		gen cm_onlinebully_others=.
		replace cm_onlinebully_others=1 if FCCYBO00==6
		replace cm_onlinebully_others=2 if FCCYBO00==5
		replace cm_onlinebully_others=3 if FCCYBO00==4
		replace cm_onlinebully_others=4 if FCCYBO00==3
		replace cm_onlinebully_others=5 if FCCYBO00==2
		replace cm_onlinebully_others=6 if FCCYBO00==1
		
		label variable cm_onlinebully_others "How often CM bullies others online"
		label values cm_onlinebully_others cm_onlinebully_others 
		label define cm_onlinebully_others /*
		*/ 1 "Never" 2 "Less often" 3 "Every few months" 4 "once a month" 5 "About once a week" 6 "most days" 
		tab cm_onlinebully_others FCCYBO00, miss
		tab cm_onlinebully_others, miss
		
	* Victim Grid
	
		gen cm_bully_verbal=.
		replace cm_bully_verbal=1 if FCVICG00==1
		replace cm_bully_verbal=0 if FCVICG00==2
		tab cm_bully_verbal FCVICG00
		
		label variable cm_bully_verbal "CM insulted, threatened, shouted at"
		label values cm_bully_verbal cm_bully_verbal 
		label define cm_bully_verbal /*
		*/ 1 "Yes" 0 "No"  
		tab cm_bully_verbal FCVICG00, miss
		tab cm_bully_verbal, miss
		
		**

		gen cm_bully_phys=.
		replace cm_bully_phys=1 if FCVICA00==1
		replace cm_bully_phys=0 if FCVICA00==2
		tab cm_bully_phys FCVICA00
		
		label variable cm_bully_phys "Physically violent towards CM"
		label values cm_bully_phys cm_bully_phys 
		label define cm_bully_phys /*
		*/ 1 "Yes" 0 "No"  
		tab cm_bully_phys FCVICA00, miss
		tab cm_bully_phys, miss
		
		**
		
		gen cm_bully_weapon=.
		replace cm_bully_weapon=1 if FCVICC00==1
		replace cm_bully_weapon=0 if FCVICC00==2
		tab cm_bully_weapon FCVICC00
		
		label variable cm_bully_weapon "hit/used weapon against CM"
		label values cm_bully_weapon cm_bully_weapon 
		label define cm_bully_weapon /*
		*/ 1 "Yes" 0 "No"  
		tab cm_bully_weapon FCVICC00, miss
		tab cm_bully_weapon, miss
		
		**
		
		gen cm_bully_stolen=.
		replace cm_bully_stolen=1 if FCVICE00==1
		replace cm_bully_stolen=0 if FCVICE00==2
		tab cm_bully_stolen FCVICE00
		
		label variable cm_bully_stolen "stolen something from CM"
		label values cm_bully_stolen cm_bully_stolen 
		label define cm_bully_stolen /*
		*/ 1 "Yes" 0 "No"  
		tab cm_bully_stolen FCVICE00, miss
		tab cm_bully_stolen, miss
		
		**
		
		gen cm_sassault=.
		replace cm_sassault=1 if FCVICF0A==1
		replace cm_sassault=0 if FCVICF0A==2
		tab cm_sassault FCVICF0A
		
		label variable cm_sassault "sexually assaulted CM"
		label values cm_sassault cm_sassault 
		label define cm_sassault /*
		*/ 1 "Yes" 0 "No"  
		tab cm_sassault FCVICF0A, miss
		tab cm_sassault, miss
		
	*weight perception
	
		gen cm_weight_percept=.
		replace cm_weight_percept=1 if FCWEGT00==2
		replace cm_weight_percept=2 if FCWEGT00==1
		replace cm_weight_percept=3 if FCWEGT00==3
		replace cm_weight_percept=4 if FCWEGT00==4
		
		label variable cm_weight_percept "CM perception of weight"
		label values cm_weight_percept cm_weight_percept 
		label define cm_weight_percept /*
		*/ 1 "about right" 2 "underweight" 3 "sl overweight" 4 "v overweight"
		tab cm_weight_percept FCWEGT00, miss
		tab cm_weight_percept, miss
		
		**

		gen cm_weight_goal=.
		replace cm_weight_goal=1 if FCLSWT00==4
		replace cm_weight_goal=2 if FCLSWT00==3
		replace cm_weight_goal=3 if FCLSWT00==2
		replace cm_weight_goal=4 if FCLSWT00==1
		tab cm_weight_goal FCLSWT00
		
		label variable cm_weight_goal "What CM is trying to do about their weight"
		label values cm_weight_goal cm_weight_goal 
		label define cm_weight_goal /*
		*/ 1 "nothing" 2 "maintain" 3 "gain" 4 "lose"
		tab cm_weight_goal FCLSWT00, miss
		tab cm_weight_goal, miss
		
	* Wellbeing
	
		gen cm_happy_schwork=.
		replace cm_happy_schwork=1 if FCSCWK00==1
		replace cm_happy_schwork=2 if FCSCWK00==2
		replace cm_happy_schwork=3 if FCSCWK00==3
		replace cm_happy_schwork=4 if FCSCWK00==4
		replace cm_happy_schwork=5 if FCSCWK00==5
		replace cm_happy_schwork=6 if FCSCWK00==6
		replace cm_happy_schwork=7 if FCSCWK00==7
		
		label variable cm_happy_schwork "How happy with schoolwork"
		label values cm_happy_schwork cm_happy_schwork 
		label define cm_happy_schwork /*
		*/ 1 "completely happy" 7 "not at all"
		tab cm_happy_schwork FCSCWK00, miss
		tab cm_happy_schwork, miss
	
		**

		gen cm_happy_appearance=.
		replace cm_happy_appearance=1 if FCWYLK00==1
		replace cm_happy_appearance=2 if FCWYLK00==2
		replace cm_happy_appearance=3 if FCWYLK00==3
		replace cm_happy_appearance=4 if FCWYLK00==4
		replace cm_happy_appearance=5 if FCWYLK00==5
		replace cm_happy_appearance=6 if FCWYLK00==6
		replace cm_happy_appearance=7 if FCWYLK00==7
		
		label variable cm_happy_appearance "How happy with appearance"
		label values cm_happy_appearance cm_happy_appearance 
		label define cm_happy_appearance /*
		*/ 1 "completely happy" 7 "not at all"
		tab cm_happy_appearance FCWYLK00, miss
		tab cm_happy_appearance, miss
		
		**
		
		gen cm_happy_family=.
		replace cm_happy_family=1 if FCFMLY00==1
		replace cm_happy_family=2 if FCFMLY00==2
		replace cm_happy_family=3 if FCFMLY00==3
		replace cm_happy_family=4 if FCFMLY00==4
		replace cm_happy_family=5 if FCFMLY00==5
		replace cm_happy_family=6 if FCFMLY00==6
		replace cm_happy_family=7 if FCFMLY00==7
		
		label variable cm_happy_family "How happy with family"
		label values cm_happy_family cm_happy_family 
		label define cm_happy_family /*
		*/ 1 "completely happy" 7 "not at all"
		tab cm_happy_family FCFMLY00, miss
		tab cm_happy_family, miss
		
		**
		
		gen cm_happy_friends=.
		replace cm_happy_friends=1 if FCFRNS00==1
		replace cm_happy_friends=2 if FCFRNS00==2
		replace cm_happy_friends=3 if FCFRNS00==3
		replace cm_happy_friends=4 if FCFRNS00==4
		replace cm_happy_friends=5 if FCFRNS00==5
		replace cm_happy_friends=6 if FCFRNS00==6
		replace cm_happy_friends=7 if FCFRNS00==7
		
		label variable cm_happy_friends "How happy with friends"
		label values cm_happy_friends cm_happy_friends 
		label define cm_happy_friends /*
		*/ 1 "completely happy" 7 "not at all"
		tab cm_happy_friends FCFRNS00, miss
		tab cm_happy_friends, miss
		
		**

		gen cm_happy_school=.
		replace cm_happy_school=1 if FCSCHL00==1
		replace cm_happy_school=2 if FCSCHL00==2
		replace cm_happy_school=3 if FCSCHL00==3
		replace cm_happy_school=4 if FCSCHL00==4
		replace cm_happy_school=5 if FCSCHL00==5
		replace cm_happy_school=6 if FCSCHL00==6
		replace cm_happy_school=7 if FCSCHL00==7
		
		label variable cm_happy_school "How happy with school"
		label values cm_happy_school cm_happy_school 
		label define cm_happy_school /*
		*/ 1 "completely happy" 7 "not at all"
		tab cm_happy_school FCSCHL00, miss
		tab cm_happy_school, miss

		**
	
		gen cm_happy_life=.
		replace cm_happy_life=1 if FCLIFE00==1
		replace cm_happy_life=2 if FCLIFE00==2
		replace cm_happy_life=3 if FCLIFE00==3
		replace cm_happy_life=4 if FCLIFE00==4
		replace cm_happy_life=5 if FCLIFE00==5
		replace cm_happy_life=6 if FCLIFE00==6
		replace cm_happy_life=7 if FCLIFE00==7
		
		label variable cm_happy_life "How happy with life"
		label values cm_happy_life cm_happy_life 
		label define cm_happy_life /*
		*/ 1 "completely happy" 7 "not at all"
		tab cm_happy_life FCLIFE00, miss
		tab cm_happy_life, miss
				
	* Self-esteem
	
		gen cm_selfesteem_1=.
		replace cm_selfesteem_1=1 if FCSATI00==1
		replace cm_selfesteem_1=2 if FCSATI00==2
		replace cm_selfesteem_1=3 if FCSATI00==3
		replace cm_selfesteem_1=4 if FCSATI00==4
		
		label variable cm_selfesteem_1 "On the whole I am satisfied with myself"
		label values cm_selfesteem_1 cm_selfesteem_1 
		label define cm_selfesteem_1 /*
		*/ 1 "s agree" 2 "agree" 3 "disagree" 4 "s disagree"
		tab cm_selfesteem_1 FCSATI00, miss
		tab cm_selfesteem_1, miss
		
		**
		
		gen cm_selfesteem_2=.
		replace cm_selfesteem_2=1 if FCGDQL00==1
		replace cm_selfesteem_2=2 if FCGDQL00==2
		replace cm_selfesteem_2=3 if FCGDQL00==3
		replace cm_selfesteem_2=4 if FCGDQL00==4
		
		label variable cm_selfesteem_2 "I feel I have a number of good qualities"
		label values cm_selfesteem_2 cm_selfesteem_2 
		label define cm_selfesteem_2 /*
		*/ 1 "s agree" 2 "agree" 3 "disagree" 4 "s disagree"
		tab cm_selfesteem_2 FCGDQL00, miss
		tab cm_selfesteem_2, miss
		
		**
			
		gen cm_selfesteem_3=.
		replace cm_selfesteem_3=1 if FCDOWL00==1
		replace cm_selfesteem_3=2 if FCDOWL00==2
		replace cm_selfesteem_3=3 if FCDOWL00==3
		replace cm_selfesteem_3=4 if FCDOWL00==4
		
		label variable cm_selfesteem_3 "I feel I am able to do things as well as others"
		label values cm_selfesteem_3 cm_selfesteem_3 
		label define cm_selfesteem_3 /*
		*/ 1 "s agree" 2 "agree" 3 "disagree" 4 "s disagree"
		tab cm_selfesteem_3 FCDOWL00, miss
		tab cm_selfesteem_3, miss
		
		**

		gen cm_selfesteem_4=.
		replace cm_selfesteem_4=1 if FCVALU00==1
		replace cm_selfesteem_4=2 if FCVALU00==2
		replace cm_selfesteem_4=3 if FCVALU00==3
		replace cm_selfesteem_4=4 if FCVALU00==4
		
		label variable cm_selfesteem_4 "I am a person of value"
		label values cm_selfesteem_4 cm_selfesteem_4 
		label define cm_selfesteem_4 /*
		*/ 1 "s agree" 2 "agree" 3 "disagree" 4 "s disagree"
		tab cm_selfesteem_4 FCVALU00, miss
		tab cm_selfesteem_4, miss
		
		**
		
		gen cm_selfesteem_5=.
		replace cm_selfesteem_5=1 if FCGDSF00==1
		replace cm_selfesteem_5=2 if FCGDSF00==2
		replace cm_selfesteem_5=3 if FCGDSF00==3
		replace cm_selfesteem_5=4 if FCGDSF00==4
		
		label variable cm_selfesteem_5 "I feel good about myself"
		label values cm_selfesteem_5 cm_selfesteem_5 
		label define cm_selfesteem_5 /*
		*/ 1 "s agree" 2 "agree" 3 "disagree" 4 "s disagree"
		tab cm_selfesteem_5 FCGDSF00, miss
		tab cm_selfesteem_5, miss
		
		**
		
		gen cm_selfesteem_sum = cm_selfesteem_1 + cm_selfesteem_2 + cm_selfesteem_3 + cm_selfesteem_4 + cm_selfesteem_5
	
	* Social media
	
		gen cm_socmed=.
		replace cm_socmed=1 if FCSOME00==1
		replace cm_socmed=2 if FCSOME00==2
		replace cm_socmed=3 if FCSOME00==3
		replace cm_socmed=4 if FCSOME00==4
		replace cm_socmed=5 if FCSOME00==5
		replace cm_socmed=6 if FCSOME00==6
		replace cm_socmed=7 if FCSOME00==7
		replace cm_socmed=8 if FCSOME00==8
		
		label variable cm_socmed "Hours on social network sites"
		label values cm_socmed cm_socmed 
		label define cm_socmed /*
		*/ 1 "None" 2 "<30m" 3 "30m-<1h" 4 "1h-<2h" 5 "2h-<3h" 6 "3h-<5h" 7 "5h-<7h" 8 "7h+"
		tab cm_socmed FCSOME00, miss
		tab cm_socmed, miss
		
	* Academic confidence

		gen cm_good_english=.
		replace cm_good_english=1 if FCENGL00==4
		replace cm_good_english=2 if FCENGL00==3
		replace cm_good_english=3 if FCENGL00==2
		replace cm_good_english=4 if FCENGL00==1
		
		label variable cm_good_english "I am good at English"
		label values cm_good_english cm_good_english 
		label define cm_good_english /*
		*/ 1 "S agree" 2 "<agree" 3 "disagree" 4 "s disagree" 
		tab cm_good_english FCENGL00, miss
		tab cm_good_english, miss
		
		**
			
		gen cm_good_welsh=.
		replace cm_good_welsh=1 if FCWLSH00==4
		replace cm_good_welsh=2 if FCWLSH00==3
		replace cm_good_welsh=3 if FCWLSH00==2
		replace cm_good_welsh=4 if FCWLSH00==1
		
		label variable cm_good_welsh "I am good at Welsh"
		label values cm_good_welsh cm_good_welsh 
		label define cm_good_welsh /*
		*/ 1 "S agree" 2 "<agree" 3 "disagree" 4 "s disagree" 
		tab cm_good_welsh FCWLSH00, miss
		tab cm_good_welsh, miss
		
		**
		
		gen cm_good_maths=.
		replace cm_good_maths=1 if FCMTHS00==4
		replace cm_good_maths=2 if FCMTHS00==3
		replace cm_good_maths=3 if FCMTHS00==2
		replace cm_good_maths=4 if FCMTHS00==1
		
		label variable cm_good_maths "I am good at Maths"
		label values cm_good_maths cm_good_maths 
		label define cm_good_maths /*
		*/ 1 "S agree" 2 "<agree" 3 "disagree" 4 "s disagree" 
		tab cm_good_maths FCMTHS00, miss
		tab cm_good_maths, miss
    
		**
		
		gen cm_good_science=.
		replace cm_good_science=1 if FCSCIE00==4
		replace cm_good_science=2 if FCSCIE00==3
		replace cm_good_science=3 if FCSCIE00==2
		replace cm_good_science=4 if FCSCIE00==1
		
		label variable cm_good_science "I am good at Science"
		label values cm_good_science cm_good_science 
		label define cm_good_science /*
		*/ 1 "S agree" 2 "<agree" 3 "disagree" 4 "s disagree" 
		tab cm_good_science FCSCIE00, miss
		tab cm_good_science, miss
		
		**
	
		gen cm_good_PE=.
		replace cm_good_PE=1 if FCGDPE00==4
		replace cm_good_PE=2 if FCGDPE00==3
		replace cm_good_PE=3 if FCGDPE00==2
		replace cm_good_PE=4 if FCGDPE00==1
		
		label variable cm_good_PE "I am good at PE"
		label values cm_good_PE cm_good_PE 
		label define cm_good_PE /*
		*/ 1 "S agree" 2 "<agree" 3 "disagree" 4 "s disagree" 
		tab cm_good_PE FCGDPE00, miss
		tab cm_good_PE, miss
		       
	* Living with natural parents

		gen cm_live_mother=.
		replace cm_live_mother=0 if FCMAAB00==1
		replace cm_live_mother=1 if FCMAAB00==2
		replace cm_live_mother=9 if FCRLQM00==5
		
		label variable cm_live_mother "Lives with natural mother"
		label values cm_live_mother cm_live_mother 
		label define cm_live_mother /*
		*/ 1 "No" 0 "yes" 9 "No mother / no contact"
		tab cm_live_mother FCMAAB00, miss
		tab cm_live_mother, miss
		
		**
	
		gen cm_live_father=.
		replace cm_live_father=0 if FCPAAB00==1
		replace cm_live_father=1 if FCPAAB00==2
		replace cm_live_father=9 if FCRLQF00==5
		
		label variable cm_live_father "Lives with natural father"
		label values cm_live_father cm_live_father 
		label define cm_live_father /*
		*/ 1 "No" 0 "yes" 9 "No father / no contact"
		tab cm_live_father FCPAAB00, miss
		tab cm_live_father, miss
		
	* When worried
	
		gen cm_wor_keepself=.
		replace cm_wor_keepself=0 if FCWRRY0A==0
		replace cm_wor_keepself=1 if FCWRRY0A==1
		
		label variable cm_wor_keepself "When worried - keep to myself"
		label values cm_wor_keepself cm_wor_keepself 
		label define cm_wor_keepself /*
		*/ 0 "No" 1 "yes" 
		tab cm_wor_keepself FCWRRY0A, miss
		tab cm_wor_keepself, miss
		
		**
		
		gen cm_wor_tellparents=.
		replace cm_wor_tellparents=0 if FCWRRY0B==1
		replace cm_wor_tellparents=1 if FCWRRY0B==0
		
		label variable cm_wor_tellparents "When worried - tell parents"
		label values cm_wor_tellparents cm_wor_tellparents 
		label define cm_wor_tellparents /*
		*/ 1 "No" 0 "yes" 
		tab cm_wor_tellparents FCWRRY0B, miss
		tab cm_wor_tellparents, miss
		
		**

		gen cm_wor_tellsib=.
		replace cm_wor_tellsib=0 if FCWRRY0C==1
		replace cm_wor_tellsib=1 if FCWRRY0C==0
		
		label variable cm_wor_tellsib "When worried - tell siblings"
		label values cm_wor_tellsib cm_wor_tellsib 
		label define cm_wor_tellsib /*
		*/ 1 "No" 0 "yes" 
		tab cm_wor_tellsib FCWRRY0C, miss
		tab cm_wor_tellsib, miss
		
		**

		gen cm_wor_tellpartner=.
		replace cm_wor_tellpartner=0 if FCWRRY0D==1
		replace cm_wor_tellpartner=1 if FCWRRY0D==0
		
		label variable cm_wor_tellpartner "When worried - tell boy/girlfriend"
		label values cm_wor_tellpartner cm_wor_tellpartner 
		label define cm_wor_tellpartner /*
		*/ 1 "No" 0 "yes" 
		tab cm_wor_tellpartner FCWRRY0D, miss
		tab cm_wor_tellpartner, miss
		
		**
			
		gen cm_wor_tellrel=.
		replace cm_wor_tellrel=0 if FCWRRY0E==1
		replace cm_wor_tellrel=1 if FCWRRY0E==0
		
		label variable cm_wor_tellrel "When worried - tell other relative"
		label values cm_wor_tellrel cm_wor_tellrel 
		label define cm_wor_tellrel /*
		*/ 1 "No" 0 "yes" 
		tab cm_wor_tellrel FCWRRY0E, miss
		tab cm_wor_tellrel, miss
		
		
		**

		gen cm_wor_tellteach=.
		replace cm_wor_tellteach=0 if FCWRRY0F==1
		replace cm_wor_tellteach=1 if FCWRRY0F==0
		
		label variable cm_wor_tellteach "When worried - tell teacher"
		label values cm_wor_tellteach cm_wor_tellteach 
		label define cm_wor_tellteach /*
		*/ 1 "No" 0 "yes" 
		tab cm_wor_tellteach FCWRRY0F, miss
		tab cm_wor_tellteach, miss
		
		
		**

		gen cm_wor_telladult=.
		replace cm_wor_telladult=0 if FCWRRY0G==1
		replace cm_wor_telladult=1 if FCWRRY0G==0
		
		label variable cm_wor_telladult "When worried - tell other adult"
		label values cm_wor_telladult cm_wor_telladult 
		label define cm_wor_telladult /*
		*/ 1 "No" 0 "yes" 
		tab cm_wor_telladult FCWRRY0G, miss
		tab cm_wor_telladult, miss
		
	* Relationships
		
		gen cm_partner=.
		replace cm_partner=1 if FCBGFR00==1
		replace cm_partner=0 if FCBGFR00==2
		tab cm_partner FCBGFR00 
		
		label variable cm_partner "Does CM have boy/girlfriend"
		label values cm_partner cm_partner 
		label define cm_partner /*
		*/ 0 "No" 1 "yes" 
		tab cm_partner FCBGFR00, miss
		tab cm_partner, miss
		
		**
		
		gen cm_attracted_females=.
		replace cm_attracted_females=1 if FCROMG00==1
		replace cm_attracted_females=0 if FCROMG00==2
		
		label variable cm_attracted_females "CM ever attracted to females"
		label values cm_attracted_females cm_attracted_females 
		label define cm_attracted_females /*
		*/ 0 "No" 1 "yes" 
		tab cm_attracted_females FCROMG00, miss
		tab cm_attracted_females, miss
		
		**
	
		gen cm_attracted_males=.
		replace cm_attracted_males=1 if FCROMB00==1
		replace cm_attracted_males=0 if FCROMB00==2
		
		label variable cm_attracted_males "CM ever attracted to males"
		label values cm_attracted_males cm_attracted_males 
		label define cm_attracted_males /*
		*/ 0 "No" 1 "yes" 
		tab cm_attracted_males FCROMB00, miss
		tab cm_attracted_males, miss
		
	* Puberty
	
		gen cm_pgrowth=.
		replace cm_pgrowth=1 if FCPUHG00==1
		replace cm_pgrowth=2 if FCPUHG00==2
		replace cm_pgrowth=3 if FCPUHG00==3
		replace cm_pgrowth=4 if FCPUHG00==4
		
		label variable cm_pgrowth "Growth Spurt"
		label values cm_pgrowth cm_pgrowth 
		label define cm_pgrowth /*
		*/ 1 "not started" 2 "barely started" 3 "definitely started" 4 "complete" 
		tab cm_pgrowth FCPUHG00, miss
		tab cm_pgrowth, miss
		
		**
		
		gen cm_phair=.
		replace cm_phair=1 if FCPUBH00==1
		replace cm_phair=2 if FCPUBH00==2
		replace cm_phair=3 if FCPUBH00==3
		replace cm_phair=4 if FCPUBH00==4
		
		label variable cm_phair "Body Hair"
		label values cm_phair cm_phair 
		label define cm_phair /*
		*/ 1 "not started" 2 "barely started" 3 "definitely started" 4 "complete" 
		tab cm_phair FCPUBH00, miss
		tab cm_phair
		
		**
		
		gen cm_pskin=.
		replace cm_pskin=1 if FCPUSK00==1
		replace cm_pskin=2 if FCPUSK00==2
		replace cm_pskin=3 if FCPUSK00==3
		replace cm_pskin=4 if FCPUSK00==4
		
		label variable cm_pskin "Skin changes"
		label values cm_pskin cm_pskin 
		label define cm_pskin /*
		*/ 1 "not started" 2 "barely started" 3 "definitely started" 4 "complete" 
		tab cm_pskin FCPUSK00, miss
		tab cm_pskin, miss
		
		**
		
		gen cm_pvoice=.
		replace cm_pvoice=1 if FCPUVC00==1
		replace cm_pvoice=2 if FCPUVC00==2
		replace cm_pvoice=3 if FCPUVC00==3
		replace cm_pvoice=4 if FCPUVC00==4
		replace cm_pvoice=9 if FCCSEX00==2
		
		label variable cm_pvoice "Voice change"
		label values cm_pvoice cm_pvoice 
		label define cm_pvoice /*
		*/ 1 "not started" 2 "barely started" 3 "definitely started" 4 "complete" 9 "respondent not male"
		tab cm_pvoice FCPUVC00, miss
		tab cm_pvoice, miss
		
		**
		
		gen cm_pfacehair=.
		replace cm_pfacehair=1 if FCPUFH00==1
		replace cm_pfacehair=2 if FCPUFH00==2
		replace cm_pfacehair=3 if FCPUFH00==3
		replace cm_pfacehair=4 if FCPUFH00==4
		replace cm_pfacehair=9 if FCCSEX00==2
		
		label variable cm_pfacehair "Facial hair"
		label values cm_pfacehair cm_pfacehair 
		label define cm_pfacehair /*
		*/ 1 "not started" 2 "barely started" 3 "definitely started" 4 "complete" 9 "respondent not male"
		tab cm_pfacehair FCPUFH00, miss
		tab cm_pfacehair, miss
		
		**
	
		gen cm_pbreast=.
		replace cm_pbreast=1 if FCPUBR00==1
		replace cm_pbreast=2 if FCPUBR00==2
		replace cm_pbreast=3 if FCPUBR00==3
		replace cm_pbreast=4 if FCPUBR00==4
		replace cm_pbreast=9 if FCCSEX00==1

		
		label variable cm_pbreast "Breast Growth"
		label values cm_pbreast cm_pbreast 
		label define cm_pbreast /*
		*/ 1 "not started" 2 "barely started" 3 "definitely started" 4 "complete" 9 "respondent is not female"
		tab cm_pbreast FCPUBR00, miss
		tab cm_pbreast, miss
		        
		**
			
		gen cm_pmenarche=.
		replace cm_pmenarche=1 if FCPUMN00==1
		replace cm_pmenarche=0 if FCPUMN00==2
		replace cm_pmenarche=9 if FCCSEX00==1
		
		label variable cm_pmenarche "Menarche"
		label values cm_pmenarche cm_pmenarche 
		label define cm_pmenarche /*
		*/ 1 "yes" 0 "no" 9 "respondent is not female"
		tab cm_pmenarche FCPUMN00, miss
		tab cm_pmenarche, miss
		
		**
		
		gen cm_pmenarcheage=.
		replace cm_pmenarcheage=7 if FCAGMN0A==7
		replace cm_pmenarcheage=8 if FCAGMN0A==8
		replace cm_pmenarcheage=9 if FCAGMN0A==9
		replace cm_pmenarcheage=10 if FCAGMN0A==10
		replace cm_pmenarcheage=11 if FCAGMN0A==11
		replace cm_pmenarcheage=12 if FCAGMN0A==12
		replace cm_pmenarcheage=13 if FCAGMN0A==13
		replace cm_pmenarcheage=14 if FCAGMN0A==14
		replace cm_pmenarcheage=15 if FCAGMN0A==15
		replace cm_pmenarcheage=-1 if FCCSEX00==1
	
		
		label variable cm_pmenarcheage "Menarche age"
		label values cm_pmenarcheage cm_pmenarcheage
		label define cm_pmenarceage -1 "respondent not female"
		tab cm_pmenarcheage FCAGMN0A, miss
		tab cm_pmenarcheage, miss
		
	* Feelings grid

		gen cm_f_unhappy=.
		replace cm_f_unhappy=0 if FCMDSA00==1
		replace cm_f_unhappy=1 if FCMDSA00==2
		replace cm_f_unhappy=2 if FCMDSA00==3
		
		label variable cm_f_unhappy "I feel miserable/unhappy"
		label values cm_f_unhappy cm_f_unhappy 
		label define cm_f_unhappy /*
		*/ 0 "Not true" 1 "Sometimes" 2 "True" 
		tab cm_f_unhappy FCMDSA00, miss
		tab cm_f_unhappy, miss
		
		**
		
		gen cm_f_donotenjoy=.
		replace cm_f_donotenjoy=0 if FCMDSB00==1
		replace cm_f_donotenjoy=1 if FCMDSB00==2
		replace cm_f_donotenjoy=2 if FCMDSB00==3
		
		label variable cm_f_donotenjoy "I don't enjoy anything at all"
		label values cm_f_donotenjoy cm_f_donotenjoy 
		label define cm_f_donotenjoy /*
		*/ 0 "Not true" 1 "Sometimes" 2 "True" 
		tab cm_f_donotenjoy FCMDSB00, miss
		tab cm_f_donotenjoy, miss
		
		**
		
		gen cm_f_tired=.
		replace cm_f_tired=0 if FCMDSC00==1
		replace cm_f_tired=1 if FCMDSC00==2
		replace cm_f_tired=2 if FCMDSC00==3
		
		label variable cm_f_tired "I felt so tired I just sat around and did nothing"
		label values cm_f_tired cm_f_tired 
		label define cm_f_tired /*
		*/ 0 "Not true" 1 "Sometimes" 2 "True" 
		tab cm_f_tired FCMDSC00, miss
		tab cm_f_tired, miss
		
		**
		
		gen cm_f_restless=.
		replace cm_f_restless=0 if FCMDSD00==1
		replace cm_f_restless=1 if FCMDSD00==2
		replace cm_f_restless=2 if FCMDSD00==3
		
		label variable cm_f_restless "I was very restless"
		label values cm_f_restless cm_f_restless 
		label define cm_f_restless /*
		*/ 0 "Not true" 1 "Sometimes" 2 "True" 
		tab cm_f_restless FCMDSD00, miss
		tab cm_f_restless, miss
		
		**
	
		gen cm_f_nogood=.
		replace cm_f_nogood=0 if FCMDSE00==1
		replace cm_f_nogood=1 if FCMDSE00==2
		replace cm_f_nogood=2 if FCMDSE00==3
		
		label variable cm_f_nogood "I felt I was no good anymore"
		label values cm_f_nogood cm_f_nogood 
		label define cm_f_nogood /*
		*/ 0 "Not true" 1 "Sometimes" 2 "True" 
		tab cm_f_nogood FCMDSE00, miss
		tab cm_f_nogood, miss
		
		**
		
		gen cm_f_cried=.
		replace cm_f_cried=0 if FCMDSF00==1
		replace cm_f_cried=1 if FCMDSF00==2
		replace cm_f_cried=2 if FCMDSF00==3
		
		label variable cm_f_cried "I cried a lot"
		label values cm_f_cried cm_f_cried 
		label define cm_f_cried /*
		*/ 0 "Not true" 1 "Sometimes" 2 "True" 
		tab cm_f_cried FCMDSF00, miss
		tab cm_f_cried, miss
		
		**
		
		gen cm_f_concentrate=.
		replace cm_f_concentrate=0 if FCMDSG00==1
		replace cm_f_concentrate=1 if FCMDSG00==2
		replace cm_f_concentrate=2 if FCMDSG00==3
		
		label variable cm_f_concentrate "I found it hard to think/concentrate"
		label values cm_f_concentrate cm_f_concentrate 
		label define cm_f_concentrate /*
		*/ 0 "Not true" 1 "Sometimes" 2 "True" 
		tab cm_f_concentrate FCMDSG00, miss
		tab cm_f_concentrate, miss
		
		**
		
		gen cm_f_hateself=.
		replace cm_f_hateself=0 if FCMDSH00==1
		replace cm_f_hateself=1 if FCMDSH00==2
		replace cm_f_hateself=2 if FCMDSH00==3
		
		label variable cm_f_hateself "I hated myself"
		label values cm_f_hateself cm_f_hateself 
		label define cm_f_hateself /*
		*/ 0 "Not true" 1 "Sometimes" 2 "True" 
		tab cm_f_hateself FCMDSH00, miss
		tab cm_f_hateself, miss
		
		**
	
		gen cm_f_badperson=.
		replace cm_f_badperson=0 if FCMDSI00==1
		replace cm_f_badperson=1 if FCMDSI00==2
		replace cm_f_badperson=2 if FCMDSI00==3
		
		label variable cm_f_badperson "I was a bad person"
		label values cm_f_badperson cm_f_badperson 
		label define cm_f_badperson /*
		*/ 0 "Not true" 1 "Sometimes" 2 "True" 
		tab cm_f_badperson FCMDSI00, miss
		tab cm_f_badperson, miss
		
		**

		gen cm_f_lonely=.
		replace cm_f_lonely=0 if FCMDSJ00==1
		replace cm_f_lonely=1 if FCMDSJ00==2
		replace cm_f_lonely=2 if FCMDSJ00==3
		
		label variable cm_f_lonely "I felt lonely"
		label values cm_f_lonely cm_f_lonely 
		label define cm_f_lonely /*
		*/ 0 "Not true" 1 "Sometimes" 2 "True" 
		tab cm_f_lonely FCMDSJ00, miss
		tab cm_f_lonely, miss
		
		**
	
		gen cm_f_unloved=.
		replace cm_f_unloved=0 if FCMDSK00==1
		replace cm_f_unloved=1 if FCMDSK00==2
		replace cm_f_unloved=2 if FCMDSK00==3
		
		label variable cm_f_unloved "I thought nobody really loved me"
		label values cm_f_unloved cm_f_unloved 
		label define cm_f_unloved /*
		*/ 0 "Not true" 1 "Sometimes" 2 "True" 
		tab cm_f_unloved FCMDSK00, miss
		tab cm_f_unloved, miss
		
		**
		
		gen cm_f_asgood=.
		replace cm_f_asgood=0 if FCMDSL00==1
		replace cm_f_asgood=1 if FCMDSL00==2
		replace cm_f_asgood=2 if FCMDSL00==3
		
		label variable cm_f_asgood "I thought I could never be as good as others"
		label values cm_f_asgood cm_f_asgood 
		label define cm_f_asgood /*
		*/ 0 "Not true" 1 "Sometimes" 2 "True" 
		tab cm_f_asgood FCMDSL00, miss
		tab cm_f_asgood, miss
		
		**
			
		gen cm_f_wrong=.
		replace cm_f_wrong=0 if FCMDSM00==1
		replace cm_f_wrong=1 if FCMDSM00==2
		replace cm_f_wrong=2 if FCMDSM00==3
		
		label variable cm_f_wrong "I did everything wrong"
		label values cm_f_wrong cm_f_wrong 
		label define cm_f_wrong /*
		*/ 0 "Not true" 1 "Sometimes" 2 "True" 
		tab cm_f_wrong FCMDSM00, miss
		tab cm_f_wrong, miss
		
	* Risk/Patience/Trust
	
		gen cm_risk=.
		replace cm_risk=0 if FCRISK00==0
		replace cm_risk=1 if FCRISK00==1
		replace cm_risk=2 if FCRISK00==2
		replace cm_risk=3 if FCRISK00==3
		replace cm_risk=4 if FCRISK00==4
		replace cm_risk=5 if FCRISK00==5
		replace cm_risk=6 if FCRISK00==6
		replace cm_risk=7 if FCRISK00==7
		replace cm_risk=8 if FCRISK00==8
		replace cm_risk=9 if FCRISK00==9
		replace cm_risk=10 if FCRISK00==10
		
		label variable cm_risk "How willing is CM to take risks?"
		label values cm_risk cm_risk 
		label define cm_risk /*
		*/ 0 "Never" 10 "Always"
		tab cm_risk FCRISK00, miss
		tab cm_risk, miss
		
		
		**
	
		gen cm_patient=.
		replace cm_patient=10 if FCPTNT00==0
		replace cm_patient=9 if FCPTNT00==1
		replace cm_patient=8 if FCPTNT00==2
		replace cm_patient=7 if FCPTNT00==3
		replace cm_patient=6 if FCPTNT00==4
		replace cm_patient=5 if FCPTNT00==5
		replace cm_patient=4 if FCPTNT00==6
		replace cm_patient=3 if FCPTNT00==7
		replace cm_patient=2 if FCPTNT00==8
		replace cm_patient=1 if FCPTNT00==9
		replace cm_patient=0 if FCPTNT00==10
		
		label variable cm_patient "How patient is CM?"
		label values cm_patient cm_patient 
		label define cm_patient /*
		*/ 0 "Always" 10 "Never"
		tab cm_patient FCPTNT00, miss
		tab cm_patient, miss
		
		**
		
		gen cm_trustothers=.
		replace cm_trustothers=10 if FCTRST0A==0
		replace cm_trustothers=9 if FCTRST0A==1
		replace cm_trustothers=8 if FCTRST0A==2
		replace cm_trustothers=7 if FCTRST0A==3
		replace cm_trustothers=6 if FCTRST0A==4
		replace cm_trustothers=5 if FCTRST0A==5
		replace cm_trustothers=4 if FCTRST0A==6
		replace cm_trustothers=3 if FCTRST0A==7
		replace cm_trustothers=2 if FCTRST0A==8
		replace cm_trustothers=1 if FCTRST0A==9
		replace cm_trustothers=0 if FCTRST0A==10
		
		label variable cm_trustothers "How much does CM trust others?"
		label values cm_trustothers cm_trustothers 
		label define cm_trustothers /*
		*/ 0 "Completely" 10 "Not at all"
		tab cm_trustothers FCTRST0A, miss
		tab cm_trustothers, miss
		
	* Risk Behaviours
	
		* Smoking
	
		gen cm_smokefrequency=.
		replace cm_smokefrequency=1 if FCSMOK00==1
		replace cm_smokefrequency=2 if FCSMOK00==2
		replace cm_smokefrequency=3 if FCSMOK00==3
		replace cm_smokefrequency=4 if FCSMOK00==4
		replace cm_smokefrequency=5 if FCSMOK00==5
		replace cm_smokefrequency=6 if FCSMOK00==6
		
		label variable cm_smokefrequency "How often does CM smoke?"
		label values cm_smokefrequency cm_smokefrequency 
		label define cm_smokefrequency /*
		*/ 1 "Never" 2 "Used to" 3 "Tried only" 4 "<1/week" 5 "1-6/week" 6 ">6/week"
		tab cm_smokefrequency FCSMOK00, miss
		tab cm_smokefrequency, miss
		
		**
	
		gen cm_agesmoke=.
		replace cm_agesmoke=0 if FCAGSM00==0
		replace cm_agesmoke=1 if FCAGSM00==1
		replace cm_agesmoke=5 if FCAGSM00==5
		replace cm_agesmoke=6 if FCAGSM00==6
		replace cm_agesmoke=7 if FCAGSM00==7
		replace cm_agesmoke=8 if FCAGSM00==8
		replace cm_agesmoke=9 if FCAGSM00==9
		replace cm_agesmoke=10 if FCAGSM00==10
		replace cm_agesmoke=11 if FCAGSM00==11
		replace cm_agesmoke=12 if FCAGSM00==12
		replace cm_agesmoke=13 if FCAGSM00==13
		replace cm_agesmoke=14 if FCAGSM00==14
		replace cm_agesmoke=15 if FCAGSM00==15
		replace cm_agesmoke=-1 if FCSMOK00==1
			
		label variable cm_agesmoke "Age started smoking"
		label values cm_agesmoke cm_agesmoke 
		label define cm_agesmoke /*
		*/ -1 "Never smoked" 
		tab cm_agesmoke FCAGSM00, miss
		tab cm_agesmoke, miss
				
		**
		
		gen cm_ecig=.
		replace cm_ecig=1 if FCECIG00==1
		replace cm_ecig=2 if FCECIG00==2
		replace cm_ecig=3 if FCECIG00==3
		replace cm_ecig=4 if FCECIG00==4
		
		label variable cm_ecig "How often does CM smoke e-cigs?"
		label values cm_ecig cm_ecig 
		label define cm_ecig /*
		*/ 1 "Never" 2 "Used to" 3 "Occaisionally" 4 "Daily"
		tab cm_ecig FCECIG00, miss
		tab cm_ecig, miss
		
		*Alcohol
		
		gen cm_alcohol=.
		replace cm_alcohol=1 if FCALCD00==1
		replace cm_alcohol=0 if FCALCD00==2
		
		label variable cm_alcohol "Has CM ever had alcohol?"
		label values cm_alcohol cm_alcohol 
		label define cm_alcohol /*
		*/ 1 "Yes" 0 "No" 
		tab cm_alcohol FCALCD00, miss
		tab cm_alcohol, miss
		
		**
		
		gen cm_agealcohol=.
		replace cm_agealcohol=0 if FCALAG00==0
		replace cm_agealcohol=1 if FCALAG00==1
		replace cm_agealcohol=2 if FCALAG00==2
		replace cm_agealcohol=3 if FCALAG00==3
		replace cm_agealcohol=4 if FCALAG00==4
		replace cm_agealcohol=5 if FCALAG00==5
		replace cm_agealcohol=6 if FCALAG00==6
		replace cm_agealcohol=7 if FCALAG00==7
		replace cm_agealcohol=8 if FCALAG00==8
		replace cm_agealcohol=9 if FCALAG00==9
		replace cm_agealcohol=10 if FCALAG00==10
		replace cm_agealcohol=11 if FCALAG00==11
		replace cm_agealcohol=12 if FCALAG00==12
		replace cm_agealcohol=13 if FCALAG00==13
		replace cm_agealcohol=14 if FCALAG00==14
		replace cm_agealcohol=15 if FCALAG00==15
		replace cm_agealcohol=-1 if FCALCD00==2
	
		label variable cm_agealcohol "Age 1st drink"
		label values cm_agealcohol cm_agealcohol 
		label define cm_agealcohol /*
		*/ -1 "Never drank alcohol" 
		tab cm_agealcohol FCALAG00, miss
		tab cm_agealcohol, miss
		
		**
	
		gen cm_alcmonth=.
		replace cm_alcmonth=1 if FCALNF00==1
		replace cm_alcmonth=2 if FCALNF00==2
		replace cm_alcmonth=3 if FCALNF00==3
		replace cm_alcmonth=4 if FCALNF00==4
		replace cm_alcmonth=5 if FCALNF00==5
		replace cm_alcmonth=6 if FCALNF00==6
		replace cm_alcmonth=7 if FCALNF00==7
		replace cm_alcmonth=-1 if FCALCD00==2

		label variable cm_alcmonth "How many times had drink in last 4 weeks?"
		label values cm_alcmonth cm_alcmonth 
		label define cm_alcmonth /*
		*/ 1 "Never" 2 "1-2" 3 "3-5" 4 "6-9" 5 "10-19" 6 "20-39" 7 "40+" -1 "Never drank alcohol"
		tab cm_alcmonth FCALNF00, miss
		tab cm_alcmonth, miss

		**
	
		gen cm_cannabis=.
		replace cm_cannabis=1 if FCCANB00==1
		replace cm_cannabis=0 if FCCANB00==2
		
		label variable cm_cannabis "Smoked cannabis?"
		label values cm_cannabis cm_cannabis 
		label define cm_cannabis /*
		*/ 1 "yes" 0 "no"
		tab cm_cannabis FCCANB00, miss
		tab cm_cannabis, miss
		
		**
	
		gen cm_otherdrug=.
		replace cm_otherdrug=1 if FCOTDR00==1
		replace cm_otherdrug=0 if FCOTDR00==2
		
		label variable cm_otherdrug "Other drugs?"
		label values cm_otherdrug cm_otherdrug 
		label define cm_otherdrug /*
		*/ 1 "yes" 0 "no"
		tab cm_otherdrug FCOTDR00, miss
		tab cm_otherdrug, miss
		
	* Gambling
		       
		gen cm_fruitmachine=.
		replace cm_fruitmachine=1 if FCGAMA00==1
		replace cm_fruitmachine=0 if FCGAMA00==2
		
		label variable cm_fruitmachine "Used fruit machines?"
		label values cm_fruitmachine cm_fruitmachine 
		label define cm_fruitmachine /*
		*/ 1 "yes" 0 "no"
		tab cm_fruitmachine FCGAMA00, miss
		tab cm_fruitmachine, miss
		
		**
    
		gen cm_privatebet=.
		replace cm_privatebet=1 if FCGMBL00==1
		replace cm_privatebet=0 if FCGMBL00==2
		
		label variable cm_privatebet "Made private bet?"
		label values cm_privatebet cm_privatebet 
		label define cm_privatebet /*
		*/ 1 "yes" 0 "no"
		tab cm_privatebet FCGMBL00, miss
		tab cm_privatebet, miss
		        
		**
			       
		gen cm_bettingshop=.
		replace cm_bettingshop=1 if FCGAEM00==1
		replace cm_bettingshop=0 if FCGAEM00==2
		
		label variable cm_bettingshop "Used betting shop?"
		label values cm_bettingshop cm_bettingshop 
		label define cm_bettingshop /*
		*/ 1 "yes" 0 "no"
		tab cm_bettingshop FCGAEM00, miss
		tab cm_bettingshop, miss
		
		**
				       
		gen cm_othergamble=.
		replace cm_othergamble=1 if FCGAMJ00==1
		replace cm_othergamble=0 if FCGAMJ00==2
		
		label variable cm_othergamble "Other gambling?"
		label values cm_othergamble cm_othergamble 
		label define cm_othergamble /*
		*/ 1 "yes" 0 "no"
		tab cm_othergamble FCGAMJ00, miss
		tab cm_othergamble, miss
		
	* Antisocial
		
		gen cm_noisy=.
		replace cm_noisy=1 if FCRUDE00==1
		replace cm_noisy=0 if FCRUDE00==2
		
		label variable cm_noisy "Last year - noisy/rude in public?"
		label values cm_noisy cm_noisy 
		label define cm_noisy /*
		*/ 1 "yes" 0 "no"
		tab cm_noisy FCRUDE00, miss
		tab cm_noisy, miss
		
		**
			
		gen cm_shoplift=.
		replace cm_shoplift=1 if FCSTOL00==1
		replace cm_shoplift=0 if FCSTOL00==2
		
		label variable cm_shoplift "Last year - shoplifted?"
		label values cm_shoplift cm_shoplift 
		label define cm_shoplift /*
		*/ 1 "yes" 0 "no"
		tab cm_shoplift FCSTOL00, miss
		tab cm_shoplift, miss
		
		**
	
		gen cm_graffiti=.
		replace cm_graffiti=1 if FCSPRY00==1
		replace cm_graffiti=0 if FCSPRY00==2
		
		label variable cm_graffiti "Last year - graffiti?"
		label values cm_graffiti cm_graffiti 
		label define cm_graffiti /*
		*/ 1 "yes" 0 "no"
		tab cm_graffiti FCSPRY00, miss
		tab cm_graffiti, miss
		
		**
	
		gen cm_propertydamage=.
		replace cm_propertydamage=1 if FCDAMG00==1
		replace cm_propertydamage=0 if FCDAMG00==2
		
		label variable cm_propertydamage "Last year - damage property?"
		label values cm_propertydamage cm_propertydamage 
		label define cm_propertydamage /*
		*/ 1 "yes" 0 "no"
		tab cm_propertydamage FCDAMG00, miss
        tab cm_propertydamage, miss
		
		**
	
		gen cm_carriedknife=.
		replace cm_carriedknife=1 if FCKNIF00==1
		replace cm_carriedknife=0 if FCKNIF00==2
		
		label variable cm_carriedknife "Ever carried knife/weapon?"
		label values cm_carriedknife cm_carriedknife 
		label define cm_carriedknife /*
		*/ 1 "yes" 0 "no"
		tab cm_carriedknife FCKNIF00, miss
		tab cm_carriedknife, miss
		
		**
			
		gen cm_brokenin=.
		replace cm_brokenin=1 if FCROBH00==1
		replace cm_brokenin=0 if FCROBH00==2
		
		label variable cm_brokenin "Ever entered home to steal/damage?"
		label values cm_brokenin cm_brokenin 
		label define cm_brokenin /*
		*/ 1 "yes" 0 "no"
		tab cm_brokenin FCROBH00, miss
		tab cm_brokenin, miss
		
		**
		
		gen cm_hitothers=.
		replace cm_hitothers=1 if FCHITT00==1
		replace cm_hitothers=0 if FCHITT00==2
		
		label variable cm_hitothers "Ever hit/punched/slapped/pushed someone?"
		label values cm_hitothers cm_hitothers 
		label define cm_hitothers /*
		*/ 1 "yes" 0 "no"
		tab cm_hitothers FCHITT00, miss
		tab cm_hitothers, miss
		
		**
			
		gen cm_usedweapon=.
		replace cm_usedweapon=1 if FCWEPN00==1
		replace cm_usedweapon=0 if FCWEPN00==2
		
		label variable cm_usedweapon "Ever used weapon"
		label values cm_usedweapon cm_usedweapon 
		label define cm_usedweapon /*
		*/ 1 "yes" 0 "no"
		tab cm_usedweapon FCWEPN00, miss
		tab cm_usedweapon, miss
		
		**
		
		gen cm_stolen=.
		replace cm_stolen=1 if FCSTLN00==1
		replace cm_stolen=0 if FCSTLN00==2
		
		label variable cm_stolen "Ever stolen from someone?"
		label values cm_stolen cm_stolen 
		label define cm_stolen /*
		*/ 1 "yes" 0 "no"
		tab cm_stolen FCSTLN00, miss
		tab cm_stolen, miss
		
		**

		gen cm_quespolice=.
		replace cm_quespolice=1 if FCPOLS00==1
		replace cm_quespolice=0 if FCPOLS00==2
		
		label variable cm_quespolice "Ever stopped by/questioned by police"
		label values cm_quespolice cm_quespolice 
		label define cm_quespolice /*
		*/ 1 "yes" 0 "no"
		tab cm_quespolice FCPOLS00, miss
		tab cm_quespolice, miss
		
		**
	
		gen cm_cautionedpolice=.
		replace cm_cautionedpolice=1 if FCCAUT00==1
		replace cm_cautionedpolice=0 if FCCAUT00==2
		
		label variable cm_cautionedpolice "Ever cautioned/formal warning by police"
		label values cm_cautionedpolice cm_cautionedpolice 
		label define cm_cautionedpolice /*
		*/ 1 "yes" 0 "no"
		tab cm_cautionedpolice FCCAUT00, miss
		tab cm_cautionedpolice, miss
		
		**
		
		gen cm_arrested=.
		replace cm_arrested=1 if FCARES00==1
		replace cm_arrested=0 if FCARES00==2
		
		label variable cm_arrested "Ever arrested"
		label values cm_arrested cm_arrested 
		label define cm_arrested /*
		*/ 1 "yes" 0 "no"
		tab cm_arrested FCARES00, miss
		tab cm_arrested, miss
		
		**
		
		gen cm_gang=.
		replace cm_gang=1 if FCGANG00==1
		replace cm_gang=0 if FCGANG00==2
		replace cm_gang=2 if FCGANG00==3
		
		label variable cm_gang "In a gang"
		label values cm_gang cm_gang 
		label define cm_gang /*
		*/ 1 "yes" 0 "never"  2 "not any more"
		tab cm_gang FCGANG00, miss
		tab cm_gang, miss
		
		**
		
		gen cm_hack=.
		replace cm_hack=1 if FCHACK00==1
		replace cm_hack=0 if FCHACK00==2
		
		label variable cm_hack "Past year: hacked computer/online account?" 
		label values cm_hack cm_hack 
		label define cm_hack /*
		*/ 1 "yes" 0 "no"
		tab cm_hack FCHACK00, miss
		tab cm_hack, miss
		
		**
	
		gen cm_virus=.
		replace cm_virus=1 if FCVIRS00==1
		replace cm_virus=0 if FCVIRS00==2
		
		label variable cm_virus "Past year: sent computer viruses?" 
		label values cm_virus cm_virus 
		label define cm_virus /*
		*/ 1 "yes" 0 "no"
		tab cm_virus FCVIRS00, miss
		tab cm_virus, miss
		
		keep MCSID FCNUM00 cm_*
		
		save "`temp'\cm_clean.dta", replace
			
**************************************************************************************
*Step 2: Clean and combine mother and mother derived data

local data "C:\Users\heinh\OneDrive - University of Leeds\Data\UKDA-8156-stata\stata\stata13"
local temp "C:\Users\heinh\OneDrive - University of Leeds\Data\Temp"

*merge parent_interview and parent_derived files

	use13 "`data'\mcs6_parent_derived.dta", clear
	save "`data'\mcs6_parent_derived_stata12.dta", replace

	use13 "`data'\mcs6_parent_interview.dta"
	count
	keep MCSID FPNUM00 FPPSEX00 FPLOIL00 FPLOLR0G FPDEAN00 FPSATN00 FPHARE00 FPFORC00
	joinby MCSID FPNUM00 using "`data'\mcs6_parent_derived_stata12.dta", _merge(_merge)
	count
	tab _merge
	drop _merge
	save "`temp'\parent interview and derived.dta", replace
	
*Obtain relationship to CM from the household grid file

	use13 "`data'\mcs6_hhgrid.dta", clear
	keep MCSID FPNUM00 FHCREL00
	save "`temp'\relationship to CM.dta", replace
	
*Open parent interview and derived dataset and add information on relationship to CM

	use "`temp'\parent interview and derived.dta", clear
	count
	joinby MCSID FPNUM00 using "`temp'\relationship to CM.dta", _merge(_merge)
	tab _merge
	drop _merge
	
		*Keep only mothers (natural/adoptive/foster/step)
		
			keep if inlist(FHCREL00, 7, 8, 9, 10)
			keep if FPPSEX00==2
			
			drop FPNUM00 
			
			rename FHCREL00 m_FHCREL00
			rename FPPSEX00 m_FPPSEX00
			rename FPLOIL00 m_FPLOIL00
			rename FPLOLR0G m_FPLOLR0G
			rename FPDEAN00 m_FPDEAN00
			rename FPSATN00 m_FPSATN00
			rename FPHARE00 m_FPHARE00
			rename FPFORC00 m_FPFORC00
			rename FD11E00 m_FD11E00
			rename FDACT00 m_FDACT00 
			rename FDAUDIT m_FDAUDIT  
			rename FD07S00 m_FD07S00

			count
			
			keep m_FHCREL00 m_FPPSEX00 m_FPLOIL00 m_FPLOLR0G m_FPDEAN00 m_FPSATN00 m_FPHARE00 m_FPFORC00 m_FD11E00 m_FDACT00 m_FDAUDIT m_FD07S00 MCSID 

			save "`temp'\mothers.dta", replace
			
* PARENT VARIABLES

	* Longstanding Illness
		
		gen m_longillness=.
		replace m_longillness=1 if m_FPLOIL00==1
		replace m_longillness=0 if m_FPLOIL00==2
		
		label variable m_longillness "Mother has longstanding illness"
		label values m_longillness m_longillness 
		label define m_longillness /*
		*/ 1 "Yes" 0 "No" 
		tab m_longillness m_FPLOIL00, miss
		tab m_longillness, miss
		
	* Longstanding Illness, Mental Health

		gen m_longillnessMH=.
		replace m_longillnessMH=0 if m_FPLOIL00==2		
		replace m_longillnessMH=1 if m_FPLOLR0G==0
		replace m_longillnessMH=2 if m_FPLOLR0G==1
				
		label variable m_longillnessMH "Mother has longstanding illness - mental health"
		label values m_longillnessMH m_longillnessMH 
		label define m_longillnessMH /*
		*/ 0 "no lsi" 1 "lsi, but no dep" 2 "lsi with dep"
		tab m_longillnessMH m_FPLOLR0G, miss
		tab m_longillnessMH, miss
		
/*				
Note: This question is routed ('fed forward') by a variable in a prior questionnaire, i.e. 
      FF.DEAN, which I can't locate in the wave 6 data		
		
	* Depression/Anxiety Diagnosis
	
		gen m_depanx=.
		replace m_depanx=1 if m_FPDEAN00==1
		replace m_depanx=0 if m_FPDEAN00==2
				
		label variable m_depanx "Mother has ever been diagnosed with depression/serious anxiety"
		label values m_depanx m_depanx 
		label define m_depanx /*
		*/ 1 "Yes" 0 "No"
		tab m_depanx m_FPDEAN00, miss
		tab m_depanx, miss
		
*/
		
	* Life satisfaction

		gen m_lifesatisfaction=.
		replace m_lifesatisfaction=10 if m_FPSATN00==0
		replace m_lifesatisfaction=9 if m_FPSATN00==1
		replace m_lifesatisfaction=8 if m_FPSATN00==2
		replace m_lifesatisfaction=7 if m_FPSATN00==3
		replace m_lifesatisfaction=6 if m_FPSATN00==4
		replace m_lifesatisfaction=5 if m_FPSATN00==5
		replace m_lifesatisfaction=4 if m_FPSATN00==6
		replace m_lifesatisfaction=3 if m_FPSATN00==7
		replace m_lifesatisfaction=2 if m_FPSATN00==8
		replace m_lifesatisfaction=1 if m_FPSATN00==9
		replace m_lifesatisfaction=0 if m_FPSATN00==10
		
		
		label variable m_lifesatisfaction "Mother - Satisfied with life"
		label values m_lifesatisfaction m_lifesatisfaction 
		label define m_lifesatisfaction /*
		*/ 0 "Completely satisfied" 10 "Completely dissatisfied" 
		tab m_lifesatisfaction m_FPSATN00, miss
		tab m_lifesatisfaction, miss

/*
Note: These questions are routed on a variable in the HH (household?) questionnaire, i.e. 
      HQ.PRER, which isn't available in the wave 6 data			
		
	* Happy with partner relationship 

		gen m_partnersatisfaction=.
		replace m_partnersatisfaction=1 if m_FPHARE00==1
		replace m_partnersatisfaction=2 if m_FPHARE00==2
		replace m_partnersatisfaction=3 if m_FPHARE00==3
		replace m_partnersatisfaction=4 if m_FPHARE00==4
		replace m_partnersatisfaction=5 if m_FPHARE00==5
		replace m_partnersatisfaction=6 if m_FPHARE00==6
		replace m_partnersatisfaction=7 if m_FPHARE00==7
			
		label variable m_partnersatisfaction "Mother - How happy in relationship with partner"
		label values m_partnersatisfaction m_partnersatisfaction 
		label define m_partnersatisfaction /*
		*/ 1 "Very happy" 7 "Very unhappy" 
		tab m_partnersatisfaction m_FPHARE00, miss
		tab m_partnersatisfaction, miss

	* Partner ever used force  
		
		gen m_relationshipforce=.
		replace m_relationshipforce=1 if m_FPFORC00==1
		replace m_relationshipforce=0 if m_FPFORC00==2
		
		label variable m_relationshipforce "Mother - has partner ever used force"
		label values m_relationshipforce m_relationshipforce 
		label define m_relationshipforce /*
		*/ 1 "Yes" 0 "No" 99 "Don't know/don't wish to answer"
		tab m_relationshipforce m_FPFORC00, miss
		tab m_relationshipforce, miss
		
*/ 
		
* PARENT DERIVED VARIABLES
	
	*Ethnicity
		
		gen m_ethnicity=. 
		replace m_ethnicity=1 if m_FD11E00==1
		replace m_ethnicity=2 if m_FD11E00==2		
		replace m_ethnicity=3 if m_FD11E00==3	
		replace m_ethnicity=4 if m_FD11E00==4
		replace m_ethnicity=5 if m_FD11E00==5
		replace m_ethnicity=6 if m_FD11E00==6		
		replace m_ethnicity=7 if m_FD11E00==7	
		replace m_ethnicity=8 if m_FD11E00==8
		replace m_ethnicity=9 if m_FD11E00==9		
		replace m_ethnicity=10 if m_FD11E00==10	
		replace m_ethnicity=11 if m_FD11E00==11
		replace m_ethnicity=99 if m_FD11E00==-9
		
		label variable m_ethnicity "Mother Ethnicity"
		label values m_ethnicity m_ethnicity
		label define m_ethnicity /*
		*/ 99 "Refused to answer" 1 "White" 2 "Mixed" 3 "Indian" 4 "Pakistani" 5 "Bangladeshi" 6 "Other Asian" 7 "Black Carribean" 8 "Black African" 9 "Other Black" 10 "Chinese" 11 "Other"
		tab m_ethnicity m_FD11E00, miss
		tab m_ethnicity, miss
		
	*Employment status 
	
		gen m_employment=. 
		replace m_employment=1 if m_FDACT00==1
		replace m_employment=2 if m_FDACT00==2		
		replace m_employment=3 if inrange(m_FDACT00, 3, 10)	

		label variable m_employment "Mother Employment"
		label values m_employment m_employment
		label define m_employment /*
		*/ 1 "Employed" 2 "Self-employed" 3 "Not currently employed"
		tab m_employment m_FDACT00, miss
		tab m_employment, miss
		
	* Parent Audit/Alcohol Consumption

		gen m_alcohol=. 
		replace m_alcohol=0 if m_FDAUDIT==0
		replace m_alcohol=1 if m_FDAUDIT==1
		replace m_alcohol=2 if m_FDAUDIT==2		
		replace m_alcohol=3 if m_FDAUDIT==3	
		replace m_alcohol=4 if m_FDAUDIT==4
		replace m_alcohol=5 if m_FDAUDIT==5
		replace m_alcohol=6 if m_FDAUDIT==6		
		replace m_alcohol=7 if m_FDAUDIT==7	
		replace m_alcohol=8 if m_FDAUDIT==8
		replace m_alcohol=9 if m_FDAUDIT==9		
		replace m_alcohol=10 if m_FDAUDIT==10	
		replace m_alcohol=11 if m_FDAUDIT==11
		replace m_alcohol=12 if m_FDAUDIT==12		
		replace m_alcohol=13 if m_FDAUDIT==13	
		replace m_alcohol=14 if m_FDAUDIT==14
		replace m_alcohol=15 if m_FDAUDIT==15
		replace m_alcohol=16 if m_FDAUDIT==16		
		replace m_alcohol=17 if m_FDAUDIT==17	
		replace m_alcohol=18 if m_FDAUDIT==18
		replace m_alcohol=19 if m_FDAUDIT==19		
		replace m_alcohol=20 if m_FDAUDIT==20	
		
		label variable m_alcohol "Mother Alcohol/AUDIT"
		pwcorr m_alcohol m_FDAUDIT
		tab m_alcohol, miss
		
	*Generate Alcohol risk categories 
		
		gen m_alcohol_cutoff=. 
		replace m_alcohol_cutoff=0 if m_alcohol<=4
		replace m_alcohol_cutoff=1 if m_alcohol>=5 & m_alcohol!=.
			
		label variable m_alcohol_cutoff "M-Alcohol risk category"
		label values m_alcohol_cutoff m_alcohol_cutoff
		label define m_alcohol_cutoff /*
		*/ 0 "Low risk" 1 "Risky/Harmful"
		tab m_alcohol_cutoff m_alcohol, miss
		tab m_alcohol_cutoff, miss
				
	*NS-SEC
	
		gen m_nssec7 = m_FD07S00
		label variable m_nssec7 "Mother - NS-SEC based on current job"
		label values m_nssec7 m_nssec7
		label define m_nssec7 /*
		*/ -1 "not applicable" /*
		*/ 1 "higher manag./profes." /*
		*/ 2 "lower manag./profes." /*
		*/ 3 "intermediate" /*
		*/ 4 "small emp./self-emp." /*
		*/ 5 "lower supervis./tech." /*
		*/ 6 "semi-routine" /*
		*/ 7 "routine"
		
		drop m_F* 
		save "`temp'\mother_clean.dta", replace

**************************************************************************************
*Step 3: Clean and combine father and father derived data		
		
local data "C:\Users\heinh\OneDrive - University of Leeds\Data\UKDA-8156-stata\stata\stata13"
local temp "C:\Users\heinh\OneDrive - University of Leeds\Data\Temp"		
		
*merge parent_interview and parent_derived files

	use13 "`data'\mcs6_parent_derived.dta", clear
	save "`data'\mcs6_parent_derived_stata12.dta", replace

	use13 "`data'\mcs6_parent_interview.dta", clear
	count
	keep MCSID FPNUM00 FPPSEX00 FPLOIL00 FPLOLR0G FPDEAN00 FPSATN00 FPHARE00 FPFORC00
	joinby MCSID FPNUM00 using "`data'\mcs6_parent_derived_stata12.dta", _merge(_merge)
	count
	tab _merge
	drop _merge
	save "`temp'\parent interview and derived.dta", replace
	
*Obtain relationship to CM from the household grid file

	use13 "`data'\mcs6_hhgrid.dta", clear
	keep MCSID FPNUM00 FHCREL00
	save "`temp'\relationship to CM.dta", replace
	
*Open parent interview and derived dataset and add information on relationship to CM

	use "`temp'\parent interview and derived.dta", clear
	count
	joinby MCSID FPNUM00 using "`temp'\relationship to CM.dta", _merge(_merge)
	tab _merge
	drop _merge
	
		*Keep only fathers (natural/adoptive/foster/step)
		
			keep if inlist(FHCREL00, 7, 8, 9, 10)
			keep if FPPSEX00==1
			
			drop FPNUM00 
			
			rename FHCREL00 f_FHCREL00
			rename FPPSEX00 f_FPPSEX00
			rename FPLOIL00 f_FPLOIL00
			rename FPLOLR0G f_FPLOLR0G
			rename FPDEAN00 f_FPDEAN00
			rename FPSATN00 f_FPSATN00
			rename FPHARE00 f_FPHARE00
			rename FPFORC00 f_FPFORC00
			rename FD11E00 f_FD11E00
			rename FDACT00 f_FDACT00 
			rename FDAUDIT f_FDAUDIT 
			rename FD07S00 f_FD07S00
			
			count
			
			keep f_FHCREL00 f_FPPSEX00 f_FPLOIL00 f_FPLOLR0G f_FPDEAN00 f_FPSATN00 f_FPHARE00 f_FPFORC00 f_FD11E00 f_FDACT00 f_FDAUDIT  f_FD07S00 MCSID 
			
			save "`temp'\fathers.dta", replace
		
* PARENT VARIABLES

	* Longstanding Illness

		tab f_FPLOIL00 	
		tab f_FPLOIL00, nol
		
		gen f_longillness=.
		replace f_longillness=1 if f_FPLOIL00==1
		replace f_longillness=0 if f_FPLOIL00==2
				
		label variable f_longillness "Father has longstanding illness"
		label values f_longillness f_longillness 
		label define f_longillness /*
		*/ 1 "Yes" 0 "No" 
		tab f_longillness f_FPLOIL00, miss
		tab f_longillness, miss
		
	* Longstanding Illness, Mental Health

		gen f_longillnessMH=.
		replace f_longillnessMH=0 if f_FPLOIL00==2		
		replace f_longillnessMH=1 if f_FPLOLR0G==0
		replace f_longillnessMH=2 if f_FPLOLR0G==1
				
		label variable f_longillnessMH "Father has longstanding illness - mental health"
		label values f_longillnessMH f_longillnessMH 
		label define f_longillnessMH /*
		*/ 0 "no lsi" 1 "lsi, but no dep" 2 "lsi with dep"
		tab f_longillnessMH f_FPLOLR0G, miss
		tab f_longillnessMH, miss
		
/*				
Note: This question is routed ('fed forward') by a variable in a prior questionnaire, i.e. 
      FF.DEAN, which I can't locate in the wave 6 data				
		
	* Depression/Anxiety Diagnosis
		
		gen f_depanx=.
		replace f_depanx=1 if f_FPDEAN00==1
		replace f_depanx=0 if f_FPDEAN00==2
				
		label variable f_depanx "Father has ever been diagnosed with depression/serious anxiety"
		label values f_depanx f_depanx 
		label define f_depanx /*
		*/ 1 "Yes" 0 "No" 
		tab f_depanx f_FPDEAN00, miss
		tab f_depanx, miss
		
*/ 
		
	* Life satisfaction
		
		gen f_lifesatisfaction=.
		replace f_lifesatisfaction=10 if f_FPSATN00==0
		replace f_lifesatisfaction=9 if f_FPSATN00==1
		replace f_lifesatisfaction=8 if f_FPSATN00==2
		replace f_lifesatisfaction=7 if f_FPSATN00==3
		replace f_lifesatisfaction=6 if f_FPSATN00==4
		replace f_lifesatisfaction=5 if f_FPSATN00==5
		replace f_lifesatisfaction=4 if f_FPSATN00==6
		replace f_lifesatisfaction=3 if f_FPSATN00==7
		replace f_lifesatisfaction=2 if f_FPSATN00==8
		replace f_lifesatisfaction=1 if f_FPSATN00==9
		replace f_lifesatisfaction=0 if f_FPSATN00==10
				
		label variable f_lifesatisfaction "Father - Satisfied with life"
		label values f_lifesatisfaction f_lifesatisfaction 
		label define f_lifesatisfaction /*
		*/ 0 "Completely satisfied" 10 "Completely dissatisfied" 
		tab f_lifesatisfaction f_FPSATN00, miss
		tab f_lifesatisfaction, miss

/*
Note: These questions are routed on a variable in the HH (household?) questionnaire, i.e. 
      HQ.PRER, which isn't available in the wave 6 data				
		
	* Happy with partner relationship 
		
		gen f_partnersatisfaction=.
		replace f_partnersatisfaction=1 if f_FPHARE00==1
		replace f_partnersatisfaction=2 if f_FPHARE00==2
		replace f_partnersatisfaction=3 if f_FPHARE00==3
		replace f_partnersatisfaction=4 if f_FPHARE00==4
		replace f_partnersatisfaction=5 if f_FPHARE00==5
		replace f_partnersatisfaction=6 if f_FPHARE00==6
		replace f_partnersatisfaction=7 if f_FPHARE00==7
			
		label variable f_partnersatisfaction "Father - How happy in relationship with partner"
		label values f_partnersatisfaction f_partnersatisfaction 
		label define f_partnersatisfaction /*
		*/ 1 "Very happy" 7 "Very unhappy" 99 "Don't know/don't wish to answer"
		tab f_partnersatisfaction f_FPHARE00, miss
		tab f_partnersatisfaction, miss

	* Partner ever used force  
	
		gen f_relationshipforce=.
		replace f_relationshipforce=1 if f_FPFORC00==1
		replace f_relationshipforce=0 if f_FPFORC00==2
		
		label variable f_relationshipforce "Father - has partner ever used force"
		label values f_relationshipforce f_relationshipforce 
		label define f_relationshipforce /*
		*/ 1 "Yes" 0 "No" 99 "Don't know/don't wish to answer"
		tab f_relationshipforce f_FPFORC00, miss
		tab f_relationshipforce, miss
		
*/
	
* PARENT DERIVED VARIABLES
	
	*Ethnicity
	
		gen f_ethnicity=. 
		replace f_ethnicity=1 if f_FD11E00==1
		replace f_ethnicity=2 if f_FD11E00==2		
		replace f_ethnicity=3 if f_FD11E00==3	
		replace f_ethnicity=4 if f_FD11E00==4
		replace f_ethnicity=5 if f_FD11E00==5
		replace f_ethnicity=6 if f_FD11E00==6		
		replace f_ethnicity=7 if f_FD11E00==7	
		replace f_ethnicity=8 if f_FD11E00==8
		replace f_ethnicity=9 if f_FD11E00==9		
		replace f_ethnicity=10 if f_FD11E00==10	
		replace f_ethnicity=11 if f_FD11E00==11
		
		label variable f_ethnicity "Father Ethnicity"
		label values f_ethnicity f_ethnicity
		label define f_ethnicity /*
		*/ 1 "White" 2 "Mixed" 3 "Indian" 4 "Pakistani" 5 "Bangladeshi" 6 "Other Asian" 7 "Black Carribean" 8 "Black African" 9 "Other Black" 10 "Chinese" 11 "Other"
		tab f_ethnicity f_FD11E00, miss
		tab f_ethnicity, miss
		
	*Employment status 
			
		gen f_employment=. 
		replace f_employment=1 if f_FDACT00==1
		replace f_employment=2 if f_FDACT00==2		
		replace f_employment=3 if inrange(f_FDACT00, 3, 10)
		
		label variable f_employment "Father Employment"
		label values f_employment f_employment
		label define f_employment /*
		*/ 1 "Employed" 2 "Self-employed" 3 "Not currently employed" 
		tab f_employment f_FDACT00, missing
		tab f_employment, miss
		
	* Parent Audit/Alcohol Consumption
	
		gen f_alcohol=. 
		replace f_alcohol=0 if f_FDAUDIT==0
		replace f_alcohol=1 if f_FDAUDIT==1
		replace f_alcohol=2 if f_FDAUDIT==2		
		replace f_alcohol=3 if f_FDAUDIT==3	
		replace f_alcohol=4 if f_FDAUDIT==4
		replace f_alcohol=5 if f_FDAUDIT==5
		replace f_alcohol=6 if f_FDAUDIT==6		
		replace f_alcohol=7 if f_FDAUDIT==7	
		replace f_alcohol=8 if f_FDAUDIT==8
		replace f_alcohol=9 if f_FDAUDIT==9		
		replace f_alcohol=10 if f_FDAUDIT==10	
		replace f_alcohol=11 if f_FDAUDIT==11
		replace f_alcohol=12 if f_FDAUDIT==12		
		replace f_alcohol=13 if f_FDAUDIT==13	
		replace f_alcohol=14 if f_FDAUDIT==14
		replace f_alcohol=15 if f_FDAUDIT==15
		replace f_alcohol=16 if f_FDAUDIT==16		
		replace f_alcohol=17 if f_FDAUDIT==17	
		replace f_alcohol=18 if f_FDAUDIT==18
		replace f_alcohol=19 if f_FDAUDIT==19		
		replace f_alcohol=20 if f_FDAUDIT==20	
		
		label variable f_alcohol "Father Alcohol/AUDIT"
		pwcorr f_alcohol f_FDAUDIT
		table f_alcohol, miss	
		
	*Generate Alcohol risk categories 
		
		gen f_alcohol_cutoff=. 
		replace f_alcohol_cutoff=0 if f_alcohol<=4
		replace f_alcohol_cutoff=1 if f_alcohol>=5 & f_alcohol!=. 
	
		label variable f_alcohol_cutoff "F-Alcohol risk category"
		label values f_alcohol_cutoff f_alcohol_cutoff
		label define f_alcohol_cutoff /*
		*/ 0 "Low risk" 1 "Risky/Harmful"
		tab f_alcohol_cutoff f_alcohol, miss
		tab f_alcohol_cutoff, miss
		
	*NS-SEC
	
		gen f_nssec7 = f_FD07S00
		label variable f_nssec7 "Father - NS-SEC based on current job"
		label values f_nssec7 f_nssec7
		label define f_nssec7 /*
		*/ -1 "not applicable" /*
		*/ 1 "higher manag./profes." /*
		*/ 2 "lower manag./profes." /*
		*/ 3 "intermediate" /*
		*/ 4 "small emp./self-emp." /*
		*/ 5 "lower supervis./tech." /*
		*/ 6 "semi-routine" /*
		*/ 7 "routine"
		
		drop f_F*
		save "`temp'\father_clean.dta", replace

**************************************************************************************
*Step 4: Clean and combine mother reporting on CM data

local data "C:\Users\heinh\OneDrive - University of Leeds\Data\UKDA-8156-stata\stata\stata13"
local temp "C:\Users\heinh\OneDrive - University of Leeds\Data\Temp"	

*Mother reporting on first child	
	
	*Obtain relationship to CM from the household grid file

		use13 "`data'\mcs6_hhgrid.dta", clear
		keep MCSID FPNUM00 FHCREL00
		save "`temp'\relationship to CM.dta", replace
		
	*Open parent dataset and add information on relationship to CM

		use13 "`data'\mcs6_parent_interview.dta", clear
		count
		keep MCSID FPNUM00 FPPSEX00 FPLOIL00 FPLOLR0G FPDEAN00 FPSATN00 FPHARE00 FPFORC00
		joinby MCSID FPNUM00 using "`temp'\relationship to CM.dta", _merge(_merge)
		tab _merge
		drop _merge
		
			*Keep only mothers (natural/adoptive/foster/step)
			
				preserve
					use13 "`data'\mcs6_parent_cm_interview.dta", clear
					save "`data'\mcs6_parent_cm_interview_stata12.dta", replace
				restore
				
				keep if inlist(FHCREL00, 7, 8, 9, 10)
				keep if FPPSEX00==2
							
				rename FHCREL00 m_FHCREL00
				rename FPPSEX00 m_FPPSEX00
				rename FPLOIL00 m_FPLOIL00
				rename FPLOLR0G m_FPLOLR0G
				rename FPDEAN00 m_FPDEAN00
				rename FPSATN00 m_FPSATN00
				rename FPHARE00 m_FPHARE00
				rename FPFORC00 m_FPFORC00
				
				drop m_FPPSEX00 m_FPLOIL00 m_FPLOLR0G m_FPDEAN00 m_FPHARE00 m_FPFORC00 m_FPSATN00 m_FHCREL00
				
				joinby MCSID FPNUM00 using "`data'\mcs6_parent_cm_interview_stata12.dta", _merge(_merge) unmatched(master)
				drop _merge
				
				keep if FCNUM00==1
				count
				
				order MCSID FPNUM00 FCNUM00
				
				keep MCSID FPNUM00 FCNUM00 FPCLSI00 FPCLSM0G FPSCHC00 FPQARP00 FPSDHS00 /*
				*/ FPSDMW00 FPSDUD00 FPSDNC00 FPSDFE00 FPSDSP00 FPSDGF00 FPSDLC00 FPSDPB00 /*
				*/ FPSDTT00 FPSDOR00 FPSDFB00 FPSDCS00 FPSDOA00 FPSDRO00 FPSDFS00 FPSDDC00 /*
				*/ FPSDST00 FPSDTE00
				
				foreach var of varlist FPCLSI00-FPSDTE00 {
				rename `var' m_cm1_`var'
				}
				
	*Mother - 1st - Long standing illness

		gen m_cm1_illness=. 
		replace m_cm1_illness=1 if m_cm1_FPCLSI00==1
		replace m_cm1_illness=0 if m_cm1_FPCLSI00==2		
		
		label variable m_cm1_illness "Mother, 1st child has longstanding illness"
		label values m_cm1_illness m_cm1_illness
		label define m_cm1_illness /*
		*/ 1 "Yes" 0 "No"
		tab m_cm1_illness m_cm1_FPCLSI00, miss
		tab m_cm1_illness, miss
		
	*Mother - 1st - Long standing illness mental health
	
		gen m_cm1_illnessMH=. 
		replace m_cm1_illnessMH=1 if m_cm1_FPCLSM0G==1
		replace m_cm1_illnessMH=0 if m_cm1_FPCLSM0G==0
		replace m_cm1_illnessMH=9 if m_cm1_FPCLSI00==2
		
		label variable m_cm1_illnessMH "Mother, 1st child has longstanding illness - mental health"
		label values m_cm1_illnessMH m_cm1_illnessMH
		label define m_cm1_illnessMH /*
		*/ 1 "Yes" 0 "No" 9 "No longstanding illness"
		tab m_cm1_illnessMH m_cm1_FPCLSM0G, miss
		tab m_cm1_illnessMH, miss
		
	*Mother - 1st - How close 
		
		gen m_cm1_close=. 
		replace m_cm1_close=1 if m_cm1_FPSCHC00==1
		replace m_cm1_close=2 if m_cm1_FPSCHC00==2
		replace m_cm1_close=3 if m_cm1_FPSCHC00==3
		replace m_cm1_close=4 if m_cm1_FPSCHC00==4
		
		label variable m_cm1_close "Mother, 1st child - how close"
		label values m_cm1_close m_cm1_close
		label define m_cm1_close /*
		*/ 1 "Not very close" 2 "Fairly close" 3 "Very close" 4 "Extremely close" 
		tab m_cm1_close m_cm1_FPSCHC00, miss
		tab m_cm1_close, miss
		
	*Mother - 1st - Arguments 
	
		gen m_cm1_argue=. 
		replace m_cm1_argue=1 if m_cm1_FPQARP00==1
		replace m_cm1_argue=2 if m_cm1_FPQARP00==2
		replace m_cm1_argue=3 if m_cm1_FPQARP00==3
		replace m_cm1_argue=4 if m_cm1_FPQARP00==4
		
		label variable m_cm1_argue "Mother, 1st child - how often quarrel"
		label values m_cm1_argue m_cm1_argue
		label define m_cm1_argue /*
		*/ 1 "Most days" 2 ">once/week" 3 "<once/week" 4 "Hardly ever" 
		tab m_cm1_argue m_cm1_FPQARP00, miss
		tab m_cm1_argue, miss
		
	*Mother - 1st - Internalising behaviour
	
		gen m_cm1_internal_1 = m_cm1_FPSDHS00
		gen m_cm1_internal_2 = m_cm1_FPSDMW00
		gen m_cm1_internal_3 = m_cm1_FPSDUD00
		gen m_cm1_internal_4 = m_cm1_FPSDNC00
		gen m_cm1_internal_5 = m_cm1_FPSDFE00
		gen m_cm1_internal_6 = m_cm1_FPSDSP00
		gen m_cm1_internal_7 = m_cm1_FPSDGF00
		gen m_cm1_internal_8 = m_cm1_FPSDLC00
		gen m_cm1_internal_9 = m_cm1_FPSDPB00
		
		recode m_cm1_internal_7 (3=1) (1=3)
		recode m_cm1_internal_8 (3=1) (1=3)
		
		foreach number of numlist 1/6 9 {
		label values m_cm1_internal_`number' m_cm1_internal_`number'
		label define m_cm1_internal_`number' /*
		*/ 1 "not true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "certainly true"
		}
		
		foreach number of numlist 7/8 {
		label values m_cm1_internal_`number' m_cm1_internal_`number'
		label define m_cm1_internal_`number' /*
		*/ 1 "certainly true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "not true"
		}		
		
		label variable m_cm1_internal_1 "complains of headaches/stomach aches/sickness"
		label variable m_cm1_internal_2 "often seems worried"
		label variable m_cm1_internal_3 "often unhappy"
		label variable m_cm1_internal_4 "nervous or clingy in new situations"
		label variable m_cm1_internal_5 "many fears, easily scared"
		label variable m_cm1_internal_6 "tends to play alone"
		label variable m_cm1_internal_7 "has at least one good friend"
		label variable m_cm1_internal_8 "generally liked by other children"
		label variable m_cm1_internal_9 "picked on or bullied by other children"
		
		foreach number of numlist 1/9 {
			replace m_cm1_internal_`number'=. if m_cm1_internal_`number'<0
		}
		
		tab1 m_cm1_internal_*, miss
		
		egen m_cm1_internal_sum = rowtotal(m_cm1_internal_*)
			
		order MCSID FPNUM00 FCNUM00 /*
		*/ m_cm1_FPCLSI00 m_cm1_FPCLSM0G /*
		*/ m_cm1_FPSCHC00 m_cm1_FPQARP00 /*
		*/ m_cm1_internal_1 /*
		*/ m_cm1_internal_2 /*
		*/ m_cm1_internal_3 /*
		*/ m_cm1_internal_4 /*
		*/ m_cm1_internal_5 /*
		*/ m_cm1_internal_6 /*
		*/ m_cm1_internal_7 /*
		*/ m_cm1_internal_8 /*
		*/ m_cm1_internal_9 

	*Mother - 1st - Externalising behaviour
	
		gen m_cm1_external_1 = m_cm1_FPSDTT00
		gen m_cm1_external_2 = m_cm1_FPSDOR00
		gen m_cm1_external_3 = m_cm1_FPSDFB00
		gen m_cm1_external_4 = m_cm1_FPSDCS00
		gen m_cm1_external_5 = m_cm1_FPSDOA00
		gen m_cm1_external_6 = m_cm1_FPSDRO00
		gen m_cm1_external_7 = m_cm1_FPSDFS00
		gen m_cm1_external_8 = m_cm1_FPSDDC00
		gen m_cm1_external_9 = m_cm1_FPSDST00		
		gen m_cm1_external_10 = m_cm1_FPSDTE00

		recode m_cm1_external_2 (3=1) (1=3)
		recode m_cm1_external_9 (3=1) (1=3)
		recode m_cm1_external_10 (3=1) (1=3)

		foreach number of numlist 1 3/8 {
		label values m_cm1_external_`number' m_cm1_external_`number'
		label define m_cm1_external_`number' /*
		*/ 1 "not true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "certainly true"
		}
		
		foreach number of numlist 2 9/10 {
		label values m_cm1_external_`number' m_cm1_external_`number'
		label define m_cm1_external_`number' /*
		*/ 1 "certainly true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "not true"
		}		
		
		label variable m_cm1_external_1 "often has temper tantrums"
		label variable m_cm1_external_2 "generally obedient"
		label variable m_cm1_external_3 "fights with or bullies other children"
		label variable m_cm1_external_4 "steals from home, school or elsewhere"
		label variable m_cm1_external_5 "often lies or cheats"
		label variable m_cm1_external_6 "restless, overactive, cannot stay still for long"
		label variable m_cm1_external_7 "constantly fidgeting"
		label variable m_cm1_external_8 "easily distracted"
		label variable m_cm1_external_9 "can stop and think before acting"
		label variable m_cm1_external_10 "sees tasks through to the end"
		
		foreach number of numlist 1/10 {
			replace m_cm1_external_`number'=. if m_cm1_external_`number'<0
		}
		
		tab1 m_cm1_external_*, miss
		
		egen m_cm1_external_sum = rowtotal(m_cm1_external_*)
			
		order MCSID FPNUM00 FCNUM00 /*
		*/ m_cm1_illness m_cm1_illnessMH /*
		*/ m_cm1_close m_cm1_argue /*
		*/ m_cm1_internal_1 /*
		*/ m_cm1_internal_2 /*
		*/ m_cm1_internal_3 /*
		*/ m_cm1_internal_4 /*
		*/ m_cm1_internal_5 /*
		*/ m_cm1_internal_6 /*
		*/ m_cm1_internal_7 /*
		*/ m_cm1_internal_8 /*
		*/ m_cm1_internal_9 /*
		*/ m_cm1_internal_sum
		*/ m_cm1_external_1 /*
		*/ m_cm1_external_2 /*
		*/ m_cm1_external_3 /*
		*/ m_cm1_external_4 /*
		*/ m_cm1_external_5 /*
		*/ m_cm1_external_6 /*
		*/ m_cm1_external_7 /*
		*/ m_cm1_external_8 /*
		*/ m_cm1_external_9 /*	
		*/ m_cm1_external_10 /*
		*/ m_cm1_external_sum
		
	drop m_cm1_F*

	save "`temp'\mothers about first child.dta", replace
	
*Mother reporting on second child

local data "C:\Users\heinh\OneDrive - University of Leeds\Data\UKDA-8156-stata\stata\stata13"
local temp "C:\Users\heinh\OneDrive - University of Leeds\Data\Temp"

	*Obtain relationship to CM from the household grid file

		use13 "`data'\mcs6_hhgrid.dta", clear
		keep MCSID FPNUM00 FHCREL00
		save "`temp'\relationship to CM.dta", replace	
	
	*Open parent dataset and add information on relationship to CM

		use13 "`data'\mcs6_parent_interview.dta", clear
		count
		keep MCSID FPNUM00 FPPSEX00 FPLOIL00 FPLOLR0G FPDEAN00 FPSATN00 FPHARE00 FPFORC00
		joinby MCSID FPNUM00 using "`temp'\relationship to CM.dta", _merge(_merge)
		tab _merge
		drop _merge
		
			*Keep only mothers (natural/adoptive/foster/step)
			
				keep if inlist(FHCREL00, 7, 8, 9, 10)
				keep if FPPSEX00==2
							
				rename FHCREL00 m_FHCREL00
				rename FPPSEX00 m_FPPSEX00
				rename FPLOIL00 m_FPLOIL00
				rename FPLOLR0G m_FPLOLR0G
				rename FPDEAN00 m_FPDEAN00
				rename FPSATN00 m_FPSATN00
				rename FPHARE00 m_FPHARE00
				rename FPFORC00 m_FPFORC00
				
				drop m_FPPSEX00 m_FPLOIL00 m_FPLOLR0G m_FPDEAN00 m_FPHARE00 m_FPFORC00 m_FPSATN00 m_FHCREL00
				
				joinby MCSID FPNUM00 using "`data'\mcs6_parent_cm_interview_stata12.dta", _merge(_merge) unmatched(master)
				drop _merge
				
				keep if FCNUM00==2
				count
				
				keep MCSID FPNUM00 FCNUM00 FPCLSI00 FPCLSM0G FPSCHC00 FPQARP00 FPSDHS00 /*
				*/ FPSDMW00 FPSDUD00 FPSDNC00 FPSDFE00 FPSDSP00 FPSDGF00 FPSDLC00 FPSDPB00 /*
				*/ FPSDTT00 FPSDOR00 FPSDFB00 FPSDCS00 FPSDOA00 FPSDRO00 FPSDFS00 FPSDDC00 /*
				*/ FPSDST00 FPSDTE00
				
				foreach var of varlist FPCLSI00-FPSDTE00 {
				rename `var' m_cm2_`var'
				}
				
	*Mother - 2nd - Long standing illness
			
		gen m_cm2_illness=. 
		replace m_cm2_illness=1 if m_cm2_FPCLSI00==1
		replace m_cm2_illness=0 if m_cm2_FPCLSI00==2		
		tab m_cm2_illness m_cm2_FPCLSI00
		
		label variable m_cm2_illness "Mother, 2nd child has longstanding illness"
		
		label values m_cm2_illness m_cm2_illness
		label define m_cm2_illness /*
		*/ 1 "Yes" 0 "No"
		tab m_cm2_illness m_cm2_FPCLSI00, miss
		tab m_cm2_illness, miss
		
	*Mother - 2nd - Long standing illness mental health
		
		gen m_cm2_illnessMH=. 
		replace m_cm2_illnessMH=1 if m_cm2_FPCLSM0G==1
		replace m_cm2_illnessMH=0 if m_cm2_FPCLSM0G==0
		replace m_cm2_illnessMH=9 if m_cm2_FPCLSI00==2
		
		label variable m_cm2_illnessMH "Mother, 2nd child has longstanding illness - mental health"
		label values m_cm2_illnessMH m_cm2_illnessMH
		label define m_cm2_illnessMH /*
		*/ 1 "Yes" 0 "No" 9 "No longstanding illness"
		tab m_cm2_illnessMH m_cm2_FPCLSM0G, miss
		tab m_cm2_illnessMH, miss
		
	*Mother - 2nd - How close 

		gen m_cm2_close=. 
		replace m_cm2_close=1 if m_cm2_FPSCHC00==1
		replace m_cm2_close=2 if m_cm2_FPSCHC00==2
		replace m_cm2_close=3 if m_cm2_FPSCHC00==3
		replace m_cm2_close=4 if m_cm2_FPSCHC00==4
		
		label variable m_cm2_close "Mother, 2nd child - how close"
		label values m_cm2_close m_cm2_close
		label define m_cm2_close /*
		*/ 1 "Not very close" 2 "Fairly close" 3 "Very close" 4 "Extremely close" 
		tab m_cm2_close m_cm2_FPSCHC00, miss
		tab m_cm2_close, miss
		
	*Mother - 2nd - Arguements 
	
		gen m_cm2_argue=. 
		replace m_cm2_argue=1 if m_cm2_FPQARP00==1
		replace m_cm2_argue=2 if m_cm2_FPQARP00==2
		replace m_cm2_argue=3 if m_cm2_FPQARP00==3
		replace m_cm2_argue=4 if m_cm2_FPQARP00==4
		
		label variable m_cm2_argue "Mother, 2nd child - how often quarrel"
		label values m_cm2_argue m_cm2_argue
		label define m_cm2_argue /*
		*/ 1 "Most days" 2 ">once/week" 3 "<once/week" 4 "Hardly ever" 
		tab m_cm2_argue m_cm2_FPQARP00, miss
		tab m_cm2_argue, miss
		
	*Mother - 2nd - Internalising behaviour
	
		gen m_cm2_internal_1 = m_cm2_FPSDHS00
		gen m_cm2_internal_2 = m_cm2_FPSDMW00
		gen m_cm2_internal_3 = m_cm2_FPSDUD00
		gen m_cm2_internal_4 = m_cm2_FPSDNC00
		gen m_cm2_internal_5 = m_cm2_FPSDFE00
		gen m_cm2_internal_6 = m_cm2_FPSDSP00
		gen m_cm2_internal_7 = m_cm2_FPSDGF00
		gen m_cm2_internal_8 = m_cm2_FPSDLC00
		gen m_cm2_internal_9 = m_cm2_FPSDPB00
		
		recode m_cm2_internal_7 (3=1) (1=3)
		recode m_cm2_internal_8 (3=1) (1=3)
		
		foreach number of numlist 1/6 9 {
		label values m_cm2_internal_`number' m_cm2_internal_`number'
		label define m_cm2_internal_`number' /*
		*/ 1 "not true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "certainly true"
		}
		
		foreach number of numlist 7/8 {
		label values m_cm2_internal_`number' m_cm2_internal_`number'
		label define m_cm2_internal_`number' /*
		*/ 1 "certainly true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "not true"
		}		
		
		label variable m_cm2_internal_1 "complains of headaches/stomach aches/sickness"
		label variable m_cm2_internal_2 "often seems worried"
		label variable m_cm2_internal_3 "often unhappy"
		label variable m_cm2_internal_4 "nervous or clingy in new situations"
		label variable m_cm2_internal_5 "many fears, easily scared"
		label variable m_cm2_internal_6 "tends to play alone"
		label variable m_cm2_internal_7 "has at least one good friend"
		label variable m_cm2_internal_8 "generally liked by other children"
		label variable m_cm2_internal_9 "picked on or bullied by other children"
		
		foreach number of numlist 1/9 {
			replace m_cm2_internal_`number'=. if m_cm2_internal_`number'<0
		}
		
		tab1 m_cm2_internal_*, miss
		
		egen m_cm2_internal_sum = rowtotal(m_cm2_internal_*)
			
		order MCSID FPNUM00 FCNUM00 /*
		*/ m_cm2_FPCLSI00 m_cm2_FPCLSM0G /*
		*/ m_cm2_FPSCHC00 m_cm2_FPQARP00 /*
		*/ m_cm2_internal_1 /*
		*/ m_cm2_internal_2 /*
		*/ m_cm2_internal_3 /*
		*/ m_cm2_internal_4 /*
		*/ m_cm2_internal_5 /*
		*/ m_cm2_internal_6 /*
		*/ m_cm2_internal_7 /*
		*/ m_cm2_internal_8 /*
		*/ m_cm2_internal_9 

	*Mother - 2nd - Externalising behaviour
	
		gen m_cm2_external_1 = m_cm2_FPSDTT00
		gen m_cm2_external_2 = m_cm2_FPSDOR00
		gen m_cm2_external_3 = m_cm2_FPSDFB00
		gen m_cm2_external_4 = m_cm2_FPSDCS00
		gen m_cm2_external_5 = m_cm2_FPSDOA00
		gen m_cm2_external_6 = m_cm2_FPSDRO00
		gen m_cm2_external_7 = m_cm2_FPSDFS00
		gen m_cm2_external_8 = m_cm2_FPSDDC00
		gen m_cm2_external_9 = m_cm2_FPSDST00		
		gen m_cm2_external_10 = m_cm2_FPSDTE00

		recode m_cm2_external_2 (3=1) (1=3)
		recode m_cm2_external_9 (3=1) (1=3)
		recode m_cm2_external_10 (3=1) (1=3)

		foreach number of numlist 1 3/8 {
		label values m_cm2_external_`number' m_cm2_external_`number'
		label define m_cm2_external_`number' /*
		*/ 1 "not true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "certainly true"
		}
		
		foreach number of numlist 2 9/10 {
		label values m_cm2_external_`number' m_cm2_external_`number'
		label define m_cm2_external_`number' /*
		*/ 1 "certainly true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "not true"
		}		
		
		label variable m_cm2_external_1 "often has temper tantrums"
		label variable m_cm2_external_2 "generally obedient"
		label variable m_cm2_external_3 "fights with or bullies other children"
		label variable m_cm2_external_4 "steals from home, school or elsewhere"
		label variable m_cm2_external_5 "often lies or cheats"
		label variable m_cm2_external_6 "restless, overactive, cannot stay still for long"
		label variable m_cm2_external_7 "constantly fidgeting"
		label variable m_cm2_external_8 "easily distracted"
		label variable m_cm2_external_9 "can stop and think before acting"
		label variable m_cm2_external_10 "sees tasks through to the end"
		
		foreach number of numlist 1/10 {
			replace m_cm2_external_`number'=. if m_cm2_external_`number'<0
		}
		
		tab1 m_cm2_external_*, miss
		
		egen m_cm2_external_sum = rowtotal(m_cm2_external_*)
			
		order MCSID FPNUM00 FCNUM00 /*
		*/ m_cm2_illness m_cm2_illnessMH /*
		*/ m_cm2_close m_cm2_argue /*
		*/ m_cm2_internal_1 /*
		*/ m_cm2_internal_2 /*
		*/ m_cm2_internal_3 /*
		*/ m_cm2_internal_4 /*
		*/ m_cm2_internal_5 /*
		*/ m_cm2_internal_6 /*
		*/ m_cm2_internal_7 /*
		*/ m_cm2_internal_8 /*
		*/ m_cm2_internal_9 /*
		*/ m_cm2_internal_sum
		*/ m_cm2_external_1 /*
		*/ m_cm2_external_2 /*
		*/ m_cm2_external_3 /*
		*/ m_cm2_external_4 /*
		*/ m_cm2_external_5 /*
		*/ m_cm2_external_6 /*
		*/ m_cm2_external_7 /*
		*/ m_cm2_external_8 /*
		*/ m_cm2_external_9 /*	
		*/ m_cm2_external_10 /*
		*/ m_cm2_external_sum
		
	drop m_cm2_F*
						
	save "`temp'\mothers about second child.dta", replace
				
*Mother reporting on third child	

local data "C:\Users\heinh\OneDrive - University of Leeds\Data\UKDA-8156-stata\stata\stata13"
local temp "C:\Users\heinh\OneDrive - University of Leeds\Data\Temp"
	
	*Open parent dataset and add information on relationship to CM

		use13 "`data'\mcs6_parent_interview.dta", clear
		count
		keep MCSID FPNUM00 FPPSEX00 FPLOIL00 FPLOLR0G FPDEAN00 FPSATN00 FPHARE00 FPFORC00
		joinby MCSID FPNUM00 using "`temp'\relationship to CM.dta", _merge(_merge)
		tab _merge
		drop _merge
		
			*Keep only mothers (natural/adoptive/foster/step)
			
				keep if inlist(FHCREL00, 7, 8, 9, 10)
				keep if FPPSEX00==2
							
				rename FHCREL00 m_FHCREL00
				rename FPPSEX00 m_FPPSEX00
				rename FPLOIL00 m_FPLOIL00
				rename FPLOLR0G m_FPLOLR0G
				rename FPDEAN00 m_FPDEAN00
				rename FPSATN00 m_FPSATN00
				rename FPHARE00 m_FPHARE00
				rename FPFORC00 m_FPFORC00
				
				drop m_FPPSEX00 m_FPLOIL00 m_FPLOLR0G m_FPDEAN00 m_FPHARE00 m_FPFORC00 m_FPSATN00 m_FHCREL00
				
				joinby MCSID FPNUM00 using "`data'\mcs6_parent_cm_interview_stata12.dta", _merge(_merge) unmatched(master)
				drop _merge
				
				keep if FCNUM00==3
				count
				
				order MCSID FPNUM00 FCNUM00
		
				keep MCSID FPNUM00 FCNUM00 FPCLSI00 FPCLSM0G FPSCHC00 FPQARP00 FPSDHS00 /*
				*/ FPSDMW00 FPSDUD00 FPSDNC00 FPSDFE00 FPSDSP00 FPSDGF00 FPSDLC00 FPSDPB00 /*
				*/ FPSDTT00 FPSDOR00 FPSDFB00 FPSDCS00 FPSDOA00 FPSDRO00 FPSDFS00 FPSDDC00 /*
				*/ FPSDST00 FPSDTE00
				
				foreach var of varlist FPCLSI00-FPSDTE00 {
				rename `var' m_cm3_`var'
				}
				
*Mother - 3rd - Long standing illness

		gen m_cm3_illness=. 
		replace m_cm3_illness=1 if m_cm3_FPCLSI00==1
		replace m_cm3_illness=0 if m_cm3_FPCLSI00==2		
		
		label variable m_cm3_illness "Mother, 3rd child has longstanding illness"
		label values m_cm3_illness m_cm3_illness
		label define m_cm3_illness /*
		*/ 1 "Yes" 0 "No"
		tab m_cm3_illness m_cm3_FPCLSI00
		
	*Mother - 3rd - Long standing illness mental health
	
		gen m_cm3_illnessMH=. 
		replace m_cm3_illnessMH=1 if m_cm3_FPCLSM0G==1
		replace m_cm3_illnessMH=0 if m_cm3_FPCLSM0G==0	
		replace m_cm3_illnessMH=9 if m_cm3_FPCLSI00==2

		
		label variable m_cm3_illnessMH "Mother, 3rd child has longstanding illness - mental health"
		label values m_cm3_illnessMH m_cm3_illnessMH
		label define m_cm3_illnessMH /*
		*/ 1 "Yes" 0 "No" 9 "No longstanding illness"
		tab m_cm3_illnessMH m_cm3_FPCLSM0G, miss
		tab m_cm3_illnessMH, miss
		
	*Mother - 3rd - How close 
		
		gen m_cm3_close=. 
		replace m_cm3_close=1 if m_cm3_FPSCHC00==1
		replace m_cm3_close=2 if m_cm3_FPSCHC00==2
		replace m_cm3_close=3 if m_cm3_FPSCHC00==3
		replace m_cm3_close=4 if m_cm3_FPSCHC00==4
		
		label variable m_cm3_close "Mother, 3rd child - how close"
		label values m_cm3_close m_cm3_close
		label define m_cm3_close /*
		*/ 1 "Not very close" 2 "Fairly close" 3 "Very close" 4 "Extremely close" 
		tab m_cm3_close m_cm3_FPSCHC00, miss
		tab m_cm3_close, miss
		
	*Mother - 3rd - Arguements 

		gen m_cm3_argue=. 
		replace m_cm3_argue=1 if m_cm3_FPQARP00==1
		replace m_cm3_argue=2 if m_cm3_FPQARP00==2
		replace m_cm3_argue=3 if m_cm3_FPQARP00==3
		replace m_cm3_argue=4 if m_cm3_FPQARP00==4
		
		label variable m_cm3_argue "Mother, 3rd child - how often quarrel"
		label values m_cm3_argue m_cm3_argue
		label define m_cm3_argue /*
		*/ 1 "Most days" 2 ">once/week" 3 "<once/week" 4 "Hardly ever" 
		tab m_cm3_argue m_cm3_FPQARP00, miss
		tab m_cm3_argue, miss
				
	*Mother - 3rd - Internalising behaviour
	
		gen m_cm3_internal_1 = m_cm3_FPSDHS00
		gen m_cm3_internal_2 = m_cm3_FPSDMW00
		gen m_cm3_internal_3 = m_cm3_FPSDUD00
		gen m_cm3_internal_4 = m_cm3_FPSDNC00
		gen m_cm3_internal_5 = m_cm3_FPSDFE00
		gen m_cm3_internal_6 = m_cm3_FPSDSP00
		gen m_cm3_internal_7 = m_cm3_FPSDGF00
		gen m_cm3_internal_8 = m_cm3_FPSDLC00
		gen m_cm3_internal_9 = m_cm3_FPSDPB00
		
		recode m_cm3_internal_7 (3=1) (1=3)
		recode m_cm3_internal_8 (3=1) (1=3)
		
		foreach number of numlist 1/6 9 {
		label values m_cm3_internal_`number' m_cm3_internal_`number'
		label define m_cm3_internal_`number' /*
		*/ 1 "not true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "certainly true"
		}
		
		foreach number of numlist 7/8 {
		label values m_cm3_internal_`number' m_cm3_internal_`number'
		label define m_cm3_internal_`number' /*
		*/ 1 "certainly true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "not true"
		}		
		
		label variable m_cm3_internal_1 "complains of headaches/stomach aches/sickness"
		label variable m_cm3_internal_2 "often seems worried"
		label variable m_cm3_internal_3 "often unhappy"
		label variable m_cm3_internal_4 "nervous or clingy in new situations"
		label variable m_cm3_internal_5 "many fears, easily scared"
		label variable m_cm3_internal_6 "tends to play alone"
		label variable m_cm3_internal_7 "has at least one good friend"
		label variable m_cm3_internal_8 "generally liked by other children"
		label variable m_cm3_internal_9 "picked on or bullied by other children"
		
		foreach number of numlist 1/9 {
			replace m_cm3_internal_`number'=. if m_cm3_internal_`number'<0
		}
		
		tab1 m_cm3_internal_*, miss
		
		egen m_cm3_internal_sum = rowtotal(m_cm3_internal_*)
			
		order MCSID FPNUM00 FCNUM00 /*
		*/ m_cm3_FPCLSI00 m_cm3_FPCLSM0G /*
		*/ m_cm3_FPSCHC00 m_cm3_FPQARP00 /*
		*/ m_cm3_internal_1 /*
		*/ m_cm3_internal_2 /*
		*/ m_cm3_internal_3 /*
		*/ m_cm3_internal_4 /*
		*/ m_cm3_internal_5 /*
		*/ m_cm3_internal_6 /*
		*/ m_cm3_internal_7 /*
		*/ m_cm3_internal_8 /*
		*/ m_cm3_internal_9 

	*Mother - 3rd - Externalising behaviour
	
		gen m_cm3_external_1 = m_cm3_FPSDTT00
		gen m_cm3_external_2 = m_cm3_FPSDOR00
		gen m_cm3_external_3 = m_cm3_FPSDFB00
		gen m_cm3_external_4 = m_cm3_FPSDCS00
		gen m_cm3_external_5 = m_cm3_FPSDOA00
		gen m_cm3_external_6 = m_cm3_FPSDRO00
		gen m_cm3_external_7 = m_cm3_FPSDFS00
		gen m_cm3_external_8 = m_cm3_FPSDDC00
		gen m_cm3_external_9 = m_cm3_FPSDST00		
		gen m_cm3_external_10 = m_cm3_FPSDTE00

		recode m_cm3_external_2 (3=1) (1=3)
		recode m_cm3_external_9 (3=1) (1=3)
		recode m_cm3_external_10 (3=1) (1=3)

		foreach number of numlist 1 3/8 {
		label values m_cm3_external_`number' m_cm3_external_`number'
		label define m_cm3_external_`number' /*
		*/ 1 "not true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "certainly true"
		}
		
		foreach number of numlist 2 9/10 {
		label values m_cm3_external_`number' m_cm3_external_`number'
		label define m_cm3_external_`number' /*
		*/ 1 "certainly true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "not true"
		}		
		
		label variable m_cm3_external_1 "often has temper tantrums"
		label variable m_cm3_external_2 "generally obedient"
		label variable m_cm3_external_3 "fights with or bullies other children"
		label variable m_cm3_external_4 "steals from home, school or elsewhere"
		label variable m_cm3_external_5 "often lies or cheats"
		label variable m_cm3_external_6 "restless, overactive, cannot stay still for long"
		label variable m_cm3_external_7 "constantly fidgeting"
		label variable m_cm3_external_8 "easily distracted"
		label variable m_cm3_external_9 "can stop and think before acting"
		label variable m_cm3_external_10 "sees tasks through to the end"
		
		foreach number of numlist 1/10 {
			replace m_cm3_external_`number'=. if m_cm3_external_`number'<0
		}
		
		tab1 m_cm3_external_*, miss
		
		egen m_cm3_external_sum = rowtotal(m_cm3_external_*)
			
		order MCSID FPNUM00 FCNUM00 /*
		*/ m_cm3_illness m_cm3_illnessMH /*
		*/ m_cm3_close m_cm3_argue /*
		*/ m_cm3_internal_1 /*
		*/ m_cm3_internal_2 /*
		*/ m_cm3_internal_3 /*
		*/ m_cm3_internal_4 /*
		*/ m_cm3_internal_5 /*
		*/ m_cm3_internal_6 /*
		*/ m_cm3_internal_7 /*
		*/ m_cm3_internal_8 /*
		*/ m_cm3_internal_9 /*
		*/ m_cm3_internal_sum
		*/ m_cm3_external_1 /*
		*/ m_cm3_external_2 /*
		*/ m_cm3_external_3 /*
		*/ m_cm3_external_4 /*
		*/ m_cm3_external_5 /*
		*/ m_cm3_external_6 /*
		*/ m_cm3_external_7 /*
		*/ m_cm3_external_8 /*
		*/ m_cm3_external_9 /*	
		*/ m_cm3_external_10 /*
		*/ m_cm3_external_sum
		
	drop m_cm3_F*
						
	save "`temp'\mothers about third child.dta", replace
		
		
**********************************************************************************************************************
*Step 5: Clean and combine father reporting on CM data

local data "C:\Users\heinh\OneDrive - University of Leeds\Data\UKDA-8156-stata\stata\stata13"
local temp "C:\Users\heinh\OneDrive - University of Leeds\Data\Temp"

*Father reporting on first child	
	
	*Obtain relationship to CM from the household grid file

		use13 "`data'\mcs6_hhgrid.dta", clear
		keep MCSID FPNUM00 FHCREL00
		save "`temp'\relationship to CM.dta", replace
		
	*Open parent dataset and add information on relationship to CM

		use13 "`data'\mcs6_parent_interview.dta", clear
		count
		keep MCSID FPNUM00 FPPSEX00 FPLOIL00 FPLOLR0G FPDEAN00 FPSATN00 FPHARE00 FPFORC00
		joinby MCSID FPNUM00 using "`temp'\relationship to CM.dta", _merge(_merge)
		tab _merge
		drop _merge
		
			*Keep only fathers (natural/adoptive/foster/step)
			
				keep if inlist(FHCREL00, 7, 8, 9, 10)
				keep if FPPSEX00==1
							
				rename FHCREL00 f_FHCREL00
				rename FPPSEX00 f_FPPSEX00
				rename FPLOIL00 f_FPLOIL00
				rename FPLOLR0G f_FPLOLR0G
				rename FPDEAN00 f_FPDEAN00
				rename FPSATN00 f_FPSATN00
				rename FPHARE00 f_FPHARE00
				rename FPFORC00 f_FPFORC00
				
				drop f_FPPSEX00 f_FPLOIL00 f_FPLOLR0G f_FPDEAN00 f_FPHARE00 f_FPFORC00 f_FPSATN00 f_FHCREL00
				
				joinby MCSID FPNUM00 using "`data'\mcs6_parent_cm_interview_stata12.dta", _merge(_merge) unmatched(master)
				drop _merge
				
				keep if FCNUM00==1
				count
				
				order MCSID FPNUM00 FCNUM00
				
				keep MCSID FPNUM00 FCNUM00 FPCLSI00 FPCLSM0G FPSCHC00 FPQARP00 FPSDHS00 /*
				*/ FPSDMW00 FPSDUD00 FPSDNC00 FPSDFE00 FPSDSP00 FPSDGF00 FPSDLC00 FPSDPB00 /*
				*/ FPSDTT00 FPSDOR00 FPSDFB00 FPSDCS00 FPSDOA00 FPSDRO00 FPSDFS00 FPSDDC00 /*
				*/ FPSDST00 FPSDTE00
				
				foreach var of varlist FPCLSI00-FPSDTE00 {
				rename `var' f_cm1_`var'
				}
				
	*Father - 1st - Long standing illness
	
		gen f_cm1_illness=. 
		replace f_cm1_illness=1 if f_cm1_FPCLSI00==1
		replace f_cm1_illness=0 if f_cm1_FPCLSI00==2
		replace f_cm1_illness=9 if f_cm1_FPCLSI00==-1
		tab f_cm1_illness f_cm1_FPCLSI00
		
		label variable f_cm1_illness "Father, 1st child has longstanding illness"
		
		label values f_cm1_illness f_cm1_illness
		label define f_cm1_illness /*
		*/ 1 "Yes" 0 "No" 9 "Not applicable"
		tab f_cm1_illness f_cm1_FPCLSI00
		
	*Father - 1st - Long standing illness mental health
		
		gen f_cm1_illnessMH=. 
		replace f_cm1_illnessMH=1 if f_cm1_FPCLSM0G==1
		replace f_cm1_illnessMH=0 if f_cm1_FPCLSM0G==0	
		replace f_cm1_illnessMH=9 if f_cm1_FPCLSI00==2
		
		label variable f_cm1_illnessMH "Father, 1st child has longstanding illness - mental health"
		label values f_cm1_illnessMH f_cm1_illnessMH
		label define f_cm1_illnessMH /*
		*/ 1 "Yes" 0 "No" 9 "No longstanding illness"
		tab f_cm1_illnessMH f_cm1_FPCLSM0G
		
	*Father - 1st - How close 
	
		tab f_cm1_FPSCHC00 
		tab f_cm1_FPSCHC00 , nol
		
		gen f_cm1_close=. 
		replace f_cm1_close=1 if f_cm1_FPSCHC00==1
		replace f_cm1_close=2 if f_cm1_FPSCHC00==2
		replace f_cm1_close=3 if f_cm1_FPSCHC00==3
		replace f_cm1_close=4 if f_cm1_FPSCHC00==4
		
		label variable f_cm1_close "Father, 1st child - how close"
		label values f_cm1_close f_cm1_close
		label define f_cm1_close /*
		*/ 1 "Not very close" 2 "Fairly close" 3 "Very close" 4 "Extremely close" 
		tab f_cm1_close f_cm1_FPSCHC00, miss
		tab f_cm1_close, miss
		
	*Father - 1st - Arguements 

		gen f_cm1_argue=. 
		replace f_cm1_argue=1 if f_cm1_FPQARP00==1
		replace f_cm1_argue=2 if f_cm1_FPQARP00==2
		replace f_cm1_argue=3 if f_cm1_FPQARP00==3
		replace f_cm1_argue=4 if f_cm1_FPQARP00==4
		
		label variable f_cm1_argue "Father, 1st child - how often quarrel"
		label values f_cm1_argue f_cm1_argue
		label define f_cm1_argue /*
		*/ 1 "Most days" 2 ">once/week" 3 "<once/week" 4 "Hardly ever"  
		tab f_cm1_argue f_cm1_FPQARP00, miss
		tab f_cm1_argue, miss
		
	*Father - 1st - Internalising behaviour
	
		gen f_cm1_internal_1 = f_cm1_FPSDHS00
		gen f_cm1_internal_2 = f_cm1_FPSDMW00
		gen f_cm1_internal_3 = f_cm1_FPSDUD00
		gen f_cm1_internal_4 = f_cm1_FPSDNC00
		gen f_cm1_internal_5 = f_cm1_FPSDFE00
		gen f_cm1_internal_6 = f_cm1_FPSDSP00
		gen f_cm1_internal_7 = f_cm1_FPSDGF00
		gen f_cm1_internal_8 = f_cm1_FPSDLC00
		gen f_cm1_internal_9 = f_cm1_FPSDPB00
		
		recode f_cm1_internal_7 (3=1) (1=3)
		recode f_cm1_internal_8 (3=1) (1=3)
		
		foreach number of numlist 1/6 9 {
		label values f_cm1_internal_`number' f_cm1_internal_`number'
		label define f_cm1_internal_`number' /*
		*/ 1 "not true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "certainly true"
		}
		
		foreach number of numlist 7/8 {
		label values f_cm1_internal_`number' f_cm1_internal_`number'
		label define f_cm1_internal_`number' /*
		*/ 1 "certainly true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "not true"
		}		
		
		label variable f_cm1_internal_1 "complains of headaches/stomach aches/sickness"
		label variable f_cm1_internal_2 "often seems worried"
		label variable f_cm1_internal_3 "often unhappy"
		label variable f_cm1_internal_4 "nervous or clingy in new situations"
		label variable f_cm1_internal_5 "many fears, easily scared"
		label variable f_cm1_internal_6 "tends to play alone"
		label variable f_cm1_internal_7 "has at least one good friend"
		label variable f_cm1_internal_8 "generally liked by other children"
		label variable f_cm1_internal_9 "picked on or bullied by other children"
		
		foreach number of numlist 1/9 {
			replace f_cm1_internal_`number'=. if f_cm1_internal_`number'<0
		}
		
		tab1 f_cm1_internal_*, miss
		
		egen f_cm1_internal_sum = rowtotal(f_cm1_internal_*)
			
		order MCSID FPNUM00 FCNUM00 /*
		*/ f_cm1_FPCLSI00 f_cm1_FPCLSM0G /*
		*/ f_cm1_FPSCHC00 f_cm1_FPQARP00 /*
		*/ f_cm1_internal_1 /*
		*/ f_cm1_internal_2 /*
		*/ f_cm1_internal_3 /*
		*/ f_cm1_internal_4 /*
		*/ f_cm1_internal_5 /*
		*/ f_cm1_internal_6 /*
		*/ f_cm1_internal_7 /*
		*/ f_cm1_internal_8 /*
		*/ f_cm1_internal_9 

	*Mother - 1st - Externalising behaviour
	
		gen f_cm1_external_1 = f_cm1_FPSDTT00
		gen f_cm1_external_2 = f_cm1_FPSDOR00
		gen f_cm1_external_3 = f_cm1_FPSDFB00
		gen f_cm1_external_4 = f_cm1_FPSDCS00
		gen f_cm1_external_5 = f_cm1_FPSDOA00
		gen f_cm1_external_6 = f_cm1_FPSDRO00
		gen f_cm1_external_7 = f_cm1_FPSDFS00
		gen f_cm1_external_8 = f_cm1_FPSDDC00
		gen f_cm1_external_9 = f_cm1_FPSDST00		
		gen f_cm1_external_10 = f_cm1_FPSDTE00

		recode f_cm1_external_2 (3=1) (1=3)
		recode f_cm1_external_9 (3=1) (1=3)
		recode f_cm1_external_10 (3=1) (1=3)

		foreach number of numlist 1 3/8 {
		label values f_cm1_external_`number' f_cm1_external_`number'
		label define f_cm1_external_`number' /*
		*/ 1 "not true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "certainly true"
		}
		
		foreach number of numlist 2 9/10 {
		label values f_cm1_external_`number' f_cm1_external_`number'
		label define f_cm1_external_`number' /*
		*/ 1 "certainly true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "not true"
		}		
		
		label variable f_cm1_external_1 "often has temper tantrums"
		label variable f_cm1_external_2 "generally obedient"
		label variable f_cm1_external_3 "fights with or bullies other children"
		label variable f_cm1_external_4 "steals from home, school or elsewhere"
		label variable f_cm1_external_5 "often lies or cheats"
		label variable f_cm1_external_6 "restless, overactive, cannot stay still for long"
		label variable f_cm1_external_7 "constantly fidgeting"
		label variable f_cm1_external_8 "easily distracted"
		label variable f_cm1_external_9 "can stop and think before acting"
		label variable f_cm1_external_10 "sees tasks through to the end"
		
		foreach number of numlist 1/10 {
			replace f_cm1_external_`number'=. if f_cm1_external_`number'<0
		}
		
		tab1 f_cm1_external_*, miss
		
		egen f_cm1_external_sum = rowtotal(f_cm1_external_*)
			
		order MCSID FPNUM00 FCNUM00 /*
		*/ f_cm1_illness f_cm1_illnessMH /*
		*/ f_cm1_close f_cm1_argue /*
		*/ f_cm1_internal_1 /*
		*/ f_cm1_internal_2 /*
		*/ f_cm1_internal_3 /*
		*/ f_cm1_internal_4 /*
		*/ f_cm1_internal_5 /*
		*/ f_cm1_internal_6 /*
		*/ f_cm1_internal_7 /*
		*/ f_cm1_internal_8 /*
		*/ f_cm1_internal_9 /*
		*/ f_cm1_internal_sum
		*/ f_cm1_external_1 /*
		*/ f_cm1_external_2 /*
		*/ f_cm1_external_3 /*
		*/ f_cm1_external_4 /*
		*/ f_cm1_external_5 /*
		*/ f_cm1_external_6 /*
		*/ f_cm1_external_7 /*
		*/ f_cm1_external_8 /*
		*/ f_cm1_external_9 /*	
		*/ f_cm1_external_10 /*
		*/ f_cm1_external_sum
		
	drop f_cm1_F*

	save "`temp'\fathers about first child.dta", replace

*Father reporting on second child

local data "C:\Users\heinh\OneDrive - University of Leeds\Data\UKDA-8156-stata\stata\stata13"
local temp "C:\Users\heinh\OneDrive - University of Leeds\Data\Temp"

	*Obtain relationship to CM from the household grid file

		use13 "`data'\mcs6_hhgrid.dta", clear
		keep MCSID FPNUM00 FHCREL00
		save "`temp'\relationship to CM.dta", replace	
	
	*Open parent dataset and add information on relationship to CM

		use13 "`data'\mcs6_parent_interview.dta", clear
		count
		keep MCSID FPNUM00 FPPSEX00 FPLOIL00 FPLOLR0G FPDEAN00 FPSATN00 FPHARE00 FPFORC00
		joinby MCSID FPNUM00 using "`temp'\relationship to CM.dta", _merge(_merge)
		tab _merge
		drop _merge
		
			*Keep only fathers (natural/adoptive/foster/step)
			
				keep if inlist(FHCREL00, 7, 8, 9, 10)
				keep if FPPSEX00==1
							
				rename FHCREL00 f_FHCREL00
				rename FPPSEX00 f_FPPSEX00
				rename FPLOIL00 f_FPLOIL00
				rename FPLOLR0G f_FPLOLR0G
				rename FPDEAN00 f_FPDEAN00
				rename FPSATN00 f_FPSATN00
				rename FPHARE00 f_FPHARE00
				rename FPFORC00 f_FPFORC00
				
				drop f_FPPSEX00 f_FPLOIL00 f_FPLOLR0G f_FPDEAN00 f_FPHARE00 f_FPFORC00 f_FPSATN00 f_FHCREL00
				
				joinby MCSID FPNUM00 using "`data'\mcs6_parent_cm_interview_stata12.dta", _merge(_merge) unmatched(master)
				drop _merge
				
				keep if FCNUM00==2
				count
				
				order MCSID FPNUM00 FCNUM00
				
				keep MCSID FPNUM00 FCNUM00 FPCLSI00 FPCLSM0G FPSCHC00 FPQARP00 FPSDHS00 /*
				*/ FPSDMW00 FPSDUD00 FPSDNC00 FPSDFE00 FPSDSP00 FPSDGF00 FPSDLC00 FPSDPB00 /*
				*/ FPSDTT00 FPSDOR00 FPSDFB00 FPSDCS00 FPSDOA00 FPSDRO00 FPSDFS00 FPSDDC00 /*
				*/ FPSDST00 FPSDTE00
				
				foreach var of varlist FPCLSI00-FPSDTE00 {
				rename `var' f_cm2_`var'
				}
				
	*Father - 2nd - Long standing illness
		
		gen f_cm2_illness=. 
		replace f_cm2_illness=1 if f_cm2_FPCLSI00==1
		replace f_cm2_illness=0 if f_cm2_FPCLSI00==2
		replace f_cm2_illness=9 if f_cm2_FPCLSI00==-1
		
		label variable f_cm2_illness "Father, 2nd child has longstanding illness"
		label values f_cm2_illness f_cm2_illness
		label define f_cm2_illness /*
		*/ 1 "Yes" 0 "No" 9 "Not applicable"
		tab f_cm2_illness f_cm2_FPCLSI00, miss
		tab f_cm2_illness, miss
		
	*Father - 2nd - Long standing illness mental health
	
		gen f_cm2_illnessMH=. 
		replace f_cm2_illnessMH=1 if f_cm2_FPCLSM0G==1
		replace f_cm2_illnessMH=0 if f_cm2_FPCLSM0G==0
		replace f_cm2_illnessMH=9 if f_cm2_FPCLSI00==2
		
		label variable f_cm2_illnessMH "Father, 2nd child has longstanding illness - mental health"
		label values f_cm2_illnessMH f_cm2_illnessMH
		label define f_cm2_illnessMH /*
		*/ 1 "Yes" 0 "No" 9 "No longstanding illness"
		tab f_cm2_illnessMH f_cm2_FPCLSM0G, miss
		tab f_cm2_illnessMH, miss
		
	*Father - 2nd - How close 
	
		gen f_cm2_close=. 
		replace f_cm2_close=1 if f_cm2_FPSCHC00==1
		replace f_cm2_close=2 if f_cm2_FPSCHC00==2
		replace f_cm2_close=3 if f_cm2_FPSCHC00==3
		replace f_cm2_close=4 if f_cm2_FPSCHC00==4
		
		label variable f_cm2_close "Father, 2nd child - how close"
		label values f_cm2_close f_cm2_close
		label define f_cm2_close /*
		*/ 1 "Not very close" 2 "Fairly close" 3 "Very close" 4 "Extremely close" 
		tab f_cm2_close f_cm2_FPSCHC00
		tab f_cm2_close, miss
		
	*Father - 2nd - Arguements 

		gen f_cm2_argue=. 
		replace f_cm2_argue=1 if f_cm2_FPQARP00==1
		replace f_cm2_argue=2 if f_cm2_FPQARP00==2
		replace f_cm2_argue=3 if f_cm2_FPQARP00==3
		replace f_cm2_argue=4 if f_cm2_FPQARP00==4

		label variable f_cm2_argue "Father, 2nd child - how often quarrel"
		label values f_cm2_argue f_cm2_argue
		label define f_cm2_argue /*
		*/ 1 "Most days" 2 ">once/week" 3 "<once/week" 4 "Hardly ever"  
		tab f_cm2_argue f_cm2_FPQARP00, miss
		tab f_cm2_argue, miss
		
	*Father - 2nd - Internalising behaviour
	
		gen f_cm2_internal_1 = f_cm2_FPSDHS00
		gen f_cm2_internal_2 = f_cm2_FPSDMW00
		gen f_cm2_internal_3 = f_cm2_FPSDUD00
		gen f_cm2_internal_4 = f_cm2_FPSDNC00
		gen f_cm2_internal_5 = f_cm2_FPSDFE00
		gen f_cm2_internal_6 = f_cm2_FPSDSP00
		gen f_cm2_internal_7 = f_cm2_FPSDGF00
		gen f_cm2_internal_8 = f_cm2_FPSDLC00
		gen f_cm2_internal_9 = f_cm2_FPSDPB00
		
		recode f_cm2_internal_7 (3=1) (1=3)
		recode f_cm2_internal_8 (3=1) (1=3)
		
		foreach number of numlist 1/6 9 {
		label values f_cm2_internal_`number' f_cm2_internal_`number'
		label define f_cm2_internal_`number' /*
		*/ 1 "not true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "certainly true"
		}
		
		foreach number of numlist 7/8 {
		label values f_cm2_internal_`number' f_cm2_internal_`number'
		label define f_cm2_internal_`number' /*
		*/ 1 "certainly true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "not true"
		}		
		
		label variable f_cm2_internal_1 "complains of headaches/stomach aches/sickness"
		label variable f_cm2_internal_2 "often seems worried"
		label variable f_cm2_internal_3 "often unhappy"
		label variable f_cm2_internal_4 "nervous or clingy in new situations"
		label variable f_cm2_internal_5 "many fears, easily scared"
		label variable f_cm2_internal_6 "tends to play alone"
		label variable f_cm2_internal_7 "has at least one good friend"
		label variable f_cm2_internal_8 "generally liked by other children"
		label variable f_cm2_internal_9 "picked on or bullied by other children"
		
		foreach number of numlist 1/9 {
			replace f_cm2_internal_`number'=. if f_cm2_internal_`number'<0
		}
		
		tab1 f_cm2_internal_*, miss
		
		egen f_cm2_internal_sum = rowtotal(f_cm2_internal_*)
			
		order MCSID FPNUM00 FCNUM00 /*
		*/ f_cm2_FPCLSI00 f_cm2_FPCLSM0G /*
		*/ f_cm2_FPSCHC00 f_cm2_FPQARP00 /*
		*/ f_cm2_internal_1 /*
		*/ f_cm2_internal_2 /*
		*/ f_cm2_internal_3 /*
		*/ f_cm2_internal_4 /*
		*/ f_cm2_internal_5 /*
		*/ f_cm2_internal_6 /*
		*/ f_cm2_internal_7 /*
		*/ f_cm2_internal_8 /*
		*/ f_cm2_internal_9 

	*Father - 2nd - Externalising behaviour
	
		gen f_cm2_external_1 = f_cm2_FPSDTT00
		gen f_cm2_external_2 = f_cm2_FPSDOR00
		gen f_cm2_external_3 = f_cm2_FPSDFB00
		gen f_cm2_external_4 = f_cm2_FPSDCS00
		gen f_cm2_external_5 = f_cm2_FPSDOA00
		gen f_cm2_external_6 = f_cm2_FPSDRO00
		gen f_cm2_external_7 = f_cm2_FPSDFS00
		gen f_cm2_external_8 = f_cm2_FPSDDC00
		gen f_cm2_external_9 = f_cm2_FPSDST00		
		gen f_cm2_external_10 = f_cm2_FPSDTE00

		recode f_cm2_external_2 (3=1) (1=3)
		recode f_cm2_external_9 (3=1) (1=3)
		recode f_cm2_external_10 (3=1) (1=3)

		foreach number of numlist 1 3/8 {
		label values f_cm2_external_`number' f_cm2_external_`number'
		label define f_cm2_external_`number' /*
		*/ 1 "not true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "certainly true"
		}
		
		foreach number of numlist 2 9/10 {
		label values f_cm2_external_`number' f_cm2_external_`number'
		label define f_cm2_external_`number' /*
		*/ 1 "certainly true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "not true"
		}		
		
		label variable f_cm2_external_1 "often has temper tantrums"
		label variable f_cm2_external_2 "generally obedient"
		label variable f_cm2_external_3 "fights with or bullies other children"
		label variable f_cm2_external_4 "steals from home, school or elsewhere"
		label variable f_cm2_external_5 "often lies or cheats"
		label variable f_cm2_external_6 "restless, overactive, cannot stay still for long"
		label variable f_cm2_external_7 "constantly fidgeting"
		label variable f_cm2_external_8 "easily distracted"
		label variable f_cm2_external_9 "can stop and think before acting"
		label variable f_cm2_external_10 "sees tasks through to the end"
		
		foreach number of numlist 1/10 {
			replace f_cm2_external_`number'=. if f_cm2_external_`number'<0
		}
		
		tab1 f_cm2_external_*, miss
		
		egen f_cm2_external_sum = rowtotal(f_cm2_external_*)
			
		order MCSID FPNUM00 FCNUM00 /*
		*/ f_cm2_illness f_cm2_illnessMH /*
		*/ f_cm2_close f_cm2_argue /*
		*/ f_cm2_internal_1 /*
		*/ f_cm2_internal_2 /*
		*/ f_cm2_internal_3 /*
		*/ f_cm2_internal_4 /*
		*/ f_cm2_internal_5 /*
		*/ f_cm2_internal_6 /*
		*/ f_cm2_internal_7 /*
		*/ f_cm2_internal_8 /*
		*/ f_cm2_internal_9 /*
		*/ f_cm2_internal_sum
		*/ f_cm2_external_1 /*
		*/ f_cm2_external_2 /*
		*/ f_cm2_external_3 /*
		*/ f_cm2_external_4 /*
		*/ f_cm2_external_5 /*
		*/ f_cm2_external_6 /*
		*/ f_cm2_external_7 /*
		*/ f_cm2_external_8 /*
		*/ f_cm2_external_9 /*	
		*/ f_cm2_external_10 /*
		*/ f_cm2_external_sum
		
	drop f_cm2_F*
					
	save "`temp'\fathers about second child.dta", replace
				
*Father reporting on third child

local data "C:\Users\heinh\OneDrive - University of Leeds\Data\UKDA-8156-stata\stata\stata13"
local temp "C:\Users\heinh\OneDrive - University of Leeds\Data\Temp"

	*Obtain relationship to CM from the household grid file

		use13 "`data'\mcs6_hhgrid.dta", clear
		keep MCSID FPNUM00 FHCREL00
		save "`temp'\relationship to CM.dta", replace	
	
	*Open parent dataset and add information on relationship to CM

		use13 "`data'\mcs6_parent_interview.dta", clear
		count
		keep MCSID FPNUM00 FPPSEX00 FPLOIL00 FPLOLR0G FPDEAN00 FPSATN00 FPHARE00 FPFORC00
		joinby MCSID FPNUM00 using "`temp'\relationship to CM.dta", _merge(_merge)
		tab _merge
		drop _merge
		
			*Keep only fathers (natural/adoptive/foster/step)
			
				keep if inlist(FHCREL00, 7, 8, 9, 10)
				keep if FPPSEX00==1
							
				rename FHCREL00 f_FHCREL00
				rename FPPSEX00 f_FPPSEX00
				rename FPLOIL00 f_FPLOIL00
				rename FPLOLR0G f_FPLOLR0G
				rename FPDEAN00 f_FPDEAN00
				rename FPSATN00 f_FPSATN00
				rename FPHARE00 f_FPHARE00
				rename FPFORC00 f_FPFORC00
				
				drop f_FPPSEX00 f_FPLOIL00 f_FPLOLR0G f_FPDEAN00 f_FPHARE00 f_FPFORC00 f_FPSATN00 f_FHCREL00
				
				joinby MCSID FPNUM00 using "`data'\mcs6_parent_cm_interview_stata12.dta", _merge(_merge) unmatched(master)
				drop _merge
				
				keep if FCNUM00==3
				count
				
				order MCSID FPNUM00 FCNUM00
				
				keep MCSID FPNUM00 FCNUM00 FPCLSI00 FPCLSM0G FPSCHC00 FPQARP00 FPSDHS00 /*
				*/ FPSDMW00 FPSDUD00 FPSDNC00 FPSDFE00 FPSDSP00 FPSDGF00 FPSDLC00 FPSDPB00 /*
				*/ FPSDTT00 FPSDOR00 FPSDFB00 FPSDCS00 FPSDOA00 FPSDRO00 FPSDFS00 FPSDDC00 /*
				*/ FPSDST00 FPSDTE00
				
				foreach var of varlist FPCLSI00-FPSDTE00 {
				rename `var' f_cm3_`var'
				}
				
	*Father - 3rd - Long standing illness
	
		gen f_cm3_illness=. 
		replace f_cm3_illness=1 if f_cm3_FPCLSI00==1
		replace f_cm3_illness=0 if f_cm3_FPCLSI00==2
		replace f_cm3_illness=9 if f_cm3_FPCLSI00==-1
		
		label variable f_cm3_illness "Father, 3rd child has longstanding illness"
		label values f_cm3_illness f_cm3_illness
		label define f_cm3_illness /*
		*/ 1 "Yes" 0 "No" 9 "Not applicable"
		tab f_cm3_illness f_cm3_FPCLSI00, miss
		tab f_cm3_illness, miss
		
	*Father - 3rd - Long standing illness mental health

		gen f_cm3_illnessMH=. 
		replace f_cm3_illnessMH=1 if f_cm3_FPCLSM0G==1
		replace f_cm3_illnessMH=0 if f_cm3_FPCLSM0G==0
		replace f_cm3_illnessMH=9 if f_cm3_FPCLSI00==2
		
		label variable f_cm3_illnessMH "Father, 3rd child has longstanding illness - mental health"
		label values f_cm3_illnessMH f_cm3_illnessMH
		label define f_cm3_illnessMH /*
		*/ 1 "Yes" 0 "No" 9 "No longstanding illness"
		tab f_cm3_illnessMH f_cm3_FPCLSM0G, miss
		tab f_cm3_illnessMH, miss
		
	*Father - 3rd - How close 
	
		gen f_cm3_close=. 
		replace f_cm3_close=1 if f_cm3_FPSCHC00==1
		replace f_cm3_close=2 if f_cm3_FPSCHC00==2
		replace f_cm3_close=3 if f_cm3_FPSCHC00==3
		replace f_cm3_close=4 if f_cm3_FPSCHC00==4
	
		label variable f_cm3_close "Mother, 3rd child - how close"
		label values f_cm3_close f_cm3_close
		label define f_cm3_close /*
		*/ 1 "Not very close" 2 "Fairly close" 3 "Very close" 4 "Extremely close" 
		tab f_cm3_close f_cm3_FPSCHC00, miss
		tab f_cm3_close, miss
		
	*Father - 3rd - Arguements 
		
		gen f_cm3_argue=. 
		replace f_cm3_argue=1 if f_cm3_FPQARP00==1
		replace f_cm3_argue=2 if f_cm3_FPQARP00==2
		replace f_cm3_argue=3 if f_cm3_FPQARP00==3
		replace f_cm3_argue=4 if f_cm3_FPQARP00==4
		
		label variable f_cm3_argue "Father, 3rd child - how often quarrel"
		label values f_cm3_argue f_cm3_argue
		label define f_cm3_argue /*
		*/ 1 "Most days" 2 ">once/week" 3 "<once/week" 4 "Hardly ever" 
		tab f_cm3_argue f_cm3_FPQARP00, miss
		tab f_cm3_argue, miss
		
	*Father - 3rd - Internalising behaviour
	
		gen f_cm3_internal_1 = f_cm3_FPSDHS00
		gen f_cm3_internal_2 = f_cm3_FPSDMW00
		gen f_cm3_internal_3 = f_cm3_FPSDUD00
		gen f_cm3_internal_4 = f_cm3_FPSDNC00
		gen f_cm3_internal_5 = f_cm3_FPSDFE00
		gen f_cm3_internal_6 = f_cm3_FPSDSP00
		gen f_cm3_internal_7 = f_cm3_FPSDGF00
		gen f_cm3_internal_8 = f_cm3_FPSDLC00
		gen f_cm3_internal_9 = f_cm3_FPSDPB00
		
		recode f_cm3_internal_7 (3=1) (1=3)
		recode f_cm3_internal_8 (3=1) (1=3)
		
		foreach number of numlist 1/6 9 {
		label values f_cm3_internal_`number' f_cm3_internal_`number'
		label define f_cm3_internal_`number' /*
		*/ 1 "not true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "certainly true"
		}
		
		foreach number of numlist 7/8 {
		label values f_cm3_internal_`number' f_cm3_internal_`number'
		label define f_cm3_internal_`number' /*
		*/ 1 "certainly true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "not true"
		}		
		
		label variable f_cm3_internal_1 "complains of headaches/stomach aches/sickness"
		label variable f_cm3_internal_2 "often seems worried"
		label variable f_cm3_internal_3 "often unhappy"
		label variable f_cm3_internal_4 "nervous or clingy in new situations"
		label variable f_cm3_internal_5 "many fears, easily scared"
		label variable f_cm3_internal_6 "tends to play alone"
		label variable f_cm3_internal_7 "has at least one good friend"
		label variable f_cm3_internal_8 "generally liked by other children"
		label variable f_cm3_internal_9 "picked on or bullied by other children"
		
		foreach number of numlist 1/9 {
			replace f_cm3_internal_`number'=. if f_cm3_internal_`number'<0
		}
		
		tab1 f_cm3_internal_*, miss
		
		egen f_cm3_internal_sum = rowtotal(f_cm3_internal_*)
			
		order MCSID FPNUM00 FCNUM00 /*
		*/ f_cm3_FPCLSI00 f_cm3_FPCLSM0G /*
		*/ f_cm3_FPSCHC00 f_cm3_FPQARP00 /*
		*/ f_cm3_internal_1 /*
		*/ f_cm3_internal_2 /*
		*/ f_cm3_internal_3 /*
		*/ f_cm3_internal_4 /*
		*/ f_cm3_internal_5 /*
		*/ f_cm3_internal_6 /*
		*/ f_cm3_internal_7 /*
		*/ f_cm3_internal_8 /*
		*/ f_cm3_internal_9 

	*Father - 2nd - Externalising behaviour
	
		gen f_cm3_external_1 = f_cm3_FPSDTT00
		gen f_cm3_external_2 = f_cm3_FPSDOR00
		gen f_cm3_external_3 = f_cm3_FPSDFB00
		gen f_cm3_external_4 = f_cm3_FPSDCS00
		gen f_cm3_external_5 = f_cm3_FPSDOA00
		gen f_cm3_external_6 = f_cm3_FPSDRO00
		gen f_cm3_external_7 = f_cm3_FPSDFS00
		gen f_cm3_external_8 = f_cm3_FPSDDC00
		gen f_cm3_external_9 = f_cm3_FPSDST00		
		gen f_cm3_external_10 = f_cm3_FPSDTE00

		recode f_cm3_external_2 (3=1) (1=3)
		recode f_cm3_external_9 (3=1) (1=3)
		recode f_cm3_external_10 (3=1) (1=3)

		foreach number of numlist 1 3/8 {
		label values f_cm3_external_`number' f_cm3_external_`number'
		label define f_cm3_external_`number' /*
		*/ 1 "not true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "certainly true"
		}
		
		foreach number of numlist 2 9/10 {
		label values f_cm3_external_`number' f_cm3_external_`number'
		label define f_cm3_external_`number' /*
		*/ 1 "certainly true" /*
		*/ 2 "somewhat true" /*
		*/ 3 "not true"
		}		
		
		label variable f_cm3_external_1 "often has temper tantrums"
		label variable f_cm3_external_2 "generally obedient"
		label variable f_cm3_external_3 "fights with or bullies other children"
		label variable f_cm3_external_4 "steals from home, school or elsewhere"
		label variable f_cm3_external_5 "often lies or cheats"
		label variable f_cm3_external_6 "restless, overactive, cannot stay still for long"
		label variable f_cm3_external_7 "constantly fidgeting"
		label variable f_cm3_external_8 "easily distracted"
		label variable f_cm3_external_9 "can stop and think before acting"
		label variable f_cm3_external_10 "sees tasks through to the end"
		
		foreach number of numlist 1/10 {
			replace f_cm3_external_`number'=. if f_cm3_external_`number'<0
		}
		
		tab1 f_cm3_external_*, miss
		
		egen f_cm3_external_sum = rowtotal(f_cm3_external_*)
			
		order MCSID FPNUM00 FCNUM00 /*
		*/ f_cm3_illness f_cm3_illnessMH /*
		*/ f_cm3_close f_cm3_argue /*
		*/ f_cm3_internal_1 /*
		*/ f_cm3_internal_2 /*
		*/ f_cm3_internal_3 /*
		*/ f_cm3_internal_4 /*
		*/ f_cm3_internal_5 /*
		*/ f_cm3_internal_6 /*
		*/ f_cm3_internal_7 /*
		*/ f_cm3_internal_8 /*
		*/ f_cm3_internal_9 /*
		*/ f_cm3_internal_sum
		*/ f_cm3_external_1 /*
		*/ f_cm3_external_2 /*
		*/ f_cm3_external_3 /*
		*/ f_cm3_external_4 /*
		*/ f_cm3_external_5 /*
		*/ f_cm3_external_6 /*
		*/ f_cm3_external_7 /*
		*/ f_cm3_external_8 /*
		*/ f_cm3_external_9 /*	
		*/ f_cm3_external_10 /*
		*/ f_cm3_external_sum
		
	drop f_cm3_F*

	save "`temp'\fathers about third child.dta", replace
			
************************************************************************************************************************************
* Step 6: Clean CM_derived data

local data "C:\Users\heinh\OneDrive - University of Leeds\Data\UKDA-8156-stata\stata\stata13"
local temp "C:\Users\heinh\OneDrive - University of Leeds\Data\Temp"

use13 "`data'\mcs6_cm_derived.dta", clear
keep MCSID FCNUM00 FDCE1100 FCUK90O6 FEMOTION FCONDUCT FHYPER FPEER FPROSOC FEBDTOT
	
	*Rename 
	
		foreach var of varlist FDCE1100-FEBDTOT {
		rename `var' cmd_`var'
		}
		
	*Ethnic Group
	
		gen cm_ethnicity = cmd_FDCE1100
		recode cm_ethnicity (9=8) (10=9) (11=10)
		replace cm_ethnicity=. if cm_ethnicity<0
		label variable cm_ethnicity "ethnic group"
		label values cm_ethnicity cm_ethnicity
		label define cm_ethnicity /*
		*/ 1 "white" /*
		*/ 2 "mixed" /*
		*/ 3 "indian" /*
		*/ 4 "pakistani" /*
		*/ 5 "bangladeshi" /*
		*/ 6 "other asian" /*
		*/ 7 "black caribbean" /*
		*/ 8 "black african/other" /*
		*/ 9 "chinese" /*
		*/ 10 "other ethnic group"
		
		tab cm_ethnicity cmd_FDCE1100, miss
		
	*Weight
	
		tab cmd_FCUK90O6
		tab cmd_FCUK90O6, nol
		
		gen cm_weight=. 
		replace cm_weight=1 if cmd_FCUK90O6==2
		replace cm_weight=2 if cmd_FCUK90O6==1		
		replace cm_weight=3 if cmd_FCUK90O6==3	
		replace cm_weight=4 if cmd_FCUK90O6==4
		
		label variable cm_weight "weight category"
		label values cm_weight cm_weight
		label define cm_weight /*
		*/ 1 "Healthy weight" 2 "Underweight" 3 "Over weight" 4 "Obese"
		tab cm_weight cmd_FCUK90O6, miss
		tab cm_weight, miss
		
	*Parent Reported SDQ
	
		foreach domain in EMOTION CONDUCT HYPER PEER PROSOC {
			gen cm_sdq_`domain' = cmd_F`domain'
			replace cm_sdq_`domain' = . if cm_sdq_`domain'<0
			tab cm_sdq_`domain' cmd_F`domain', miss
			tab cm_sdq_`domain', miss
		}
		
		rename cm_sdq_*, lower
		
		gen cm_sdq_total = cmd_FEBDTOT
		replace cm_sdq_total = . if cm_sdq_total < 0
		tab cm_sdq_total cmd_FEBDTOT, miss
		tab cm_sdq_total, miss
		
		recode cm_sdq_prosoc /*
		*/ (0=10) /*
		*/ (1=9) /*
		*/ (2=8) /*
		*/ (3=7) /*
		*/ (4=6) /*
		*/ (5=5) /*
		*/ (6=4) /*
		*/ (7=3) /*
		*/ (8=2) /*
		*/ (9=1) /*
		*/ (10=0) 
		
		label variable cm_sdq_emotion "parent-reported SDQ: emotional symptoms"
		label variable cm_sdq_conduct "parent-reported SDQ: conduct problems"
		label variable cm_sdq_hyper "parent-reported SDQ: hyperactivity/inattention"
		label variable cm_sdq_peer "parent-reported SDQ: peer problems"
		label variable cm_sdq_prosoc "parent-reported SDQ: prosocial"
		label variable cm_sdq_total "parent-reported SDQ: total score"
/*

Note: Check with Emma what these cutoff's are based on. 
	  If they are based on the distribution of the variable in the
	  MCS we should base this on quantiles. 
		
	***
	**SDQ cut-offs 4 categories 
	***
		
		*SDQ-Emotional 4cat
	
		gen cm_sdq_emotion_cat4=. 
		replace cm_sdq_emotion_cat4=0 if cm_sdq_emotion==0
		replace cm_sdq_emotion_cat4=0 if cm_sdq_emotion==1
		replace cm_sdq_emotion_cat4=0 if cm_sdq_emotion==2		
		replace cm_sdq_emotion_cat4=0 if cm_sdq_emotion==3	
		replace cm_sdq_emotion_cat4=1 if cm_sdq_emotion==4
		replace cm_sdq_emotion_cat4=2 if cm_sdq_emotion==5
		replace cm_sdq_emotion_cat4=2 if cm_sdq_emotion==6		
		replace cm_sdq_emotion_cat4=3 if cm_sdq_emotion==7	
		replace cm_sdq_emotion_cat4=3 if cm_sdq_emotion==8
		replace cm_sdq_emotion_cat4=3 if cm_sdq_emotion==9
		replace cm_sdq_emotion_cat4=3 if cm_sdq_emotion==10		
				
		label variable cm_sdq_emotion_cat4 "SDQ Emotion 4cat"
		
		tab cm_sdq_emotion_cat4 cm_sdq_emotion
		
		label values cm_sdq_emotion_cat4 cm_sdq_emotion_cat4
		label define cm_sdq_emotion_cat4 /*
		*/ 0 "Close to average" 1 "slightly raised" 2 "High" 3 "Very high"
		tab cm_sdq_emotion_cat4 cm_sdq_emotion
		
	*SDQ-Conduct 4cat
	
		tab cm_sdq_conduct
		gen cm_sdq_conduct_cat4=. 
		
		replace cm_sdq_conduct_cat4=0 if cm_sdq_conduct==0
		replace cm_sdq_conduct_cat4=0 if cm_sdq_conduct==1
		replace cm_sdq_conduct_cat4=0 if cm_sdq_conduct==2		
		replace cm_sdq_conduct_cat4=1 if cm_sdq_conduct==3	
		replace cm_sdq_conduct_cat4=2 if cm_sdq_conduct==4
		replace cm_sdq_conduct_cat4=2 if cm_sdq_conduct==5
		replace cm_sdq_conduct_cat4=3 if cm_sdq_conduct==6		
		replace cm_sdq_conduct_cat4=3 if cm_sdq_conduct==7	
		replace cm_sdq_conduct_cat4=3 if cm_sdq_conduct==8
		replace cm_sdq_conduct_cat4=3 if cm_sdq_conduct==9
		replace cm_sdq_conduct_cat4=3 if cm_sdq_conduct==10		
				
		label variable cm_sdq_conduct_cat4 "SDQ Conduct 4cat"
		
		tab cm_sdq_conduct_cat4 cm_sdq_conduct
		
		label values cm_sdq_conduct_cat4 cm_sdq_conduct_cat4
		label define cm_sdq_conduct_cat4 /*
		*/ 0 "Close to average" 1 "slightly raised" 2 "High" 3 "Very high"
		tab cm_sdq_conduct_cat4 cm_sdq_conduct
		
			
	*SDQ-Hyperactivity/Inattention 4cat
	
		tab cm_sdq_hyper
		gen cm_sdq_hyper_cat4=.  
		
		replace cm_sdq_hyper_cat4=0 if cm_sdq_hyper==0
		replace cm_sdq_hyper_cat4=0 if cm_sdq_hyper==1
		replace cm_sdq_hyper_cat4=0 if cm_sdq_hyper==2		
		replace cm_sdq_hyper_cat4=0 if cm_sdq_hyper==3	
		replace cm_sdq_hyper_cat4=0 if cm_sdq_hyper==4
		replace cm_sdq_hyper_cat4=0 if cm_sdq_hyper==5
		replace cm_sdq_hyper_cat4=1 if cm_sdq_hyper==6		
		replace cm_sdq_hyper_cat4=1 if cm_sdq_hyper==7	
		replace cm_sdq_hyper_cat4=2 if cm_sdq_hyper==8
		replace cm_sdq_hyper_cat4=3 if cm_sdq_hyper==9
		replace cm_sdq_hyper_cat4=3 if cm_sdq_hyper==10		
				
		label variable cm_sdq_hyper_cat4 "SDQ Hyperactivity 4cat"
		
		tab cm_sdq_hyper_cat4 cm_sdq_hyper
		
		label values cm_sdq_hyper_cat4 cm_sdq_hyper_cat4
		label define cm_sdq_hyper_cat4 /*
		*/ 0 "Close to average" 1 "slightly raised" 2 "High" 3 "Very high"
		tab cm_sdq_hyper_cat4 cm_sdq_hyper
		
	*SDQ-Peer Problems
	
		tab cm_sdq_peer
		gen cm_sdq_peer_cat4=.  
		
		replace cm_sdq_peer_cat4=0 if cm_sdq_peer==0
		replace cm_sdq_peer_cat4=0 if cm_sdq_peer==1
		replace cm_sdq_peer_cat4=0 if cm_sdq_peer==2		
		replace cm_sdq_peer_cat4=1 if cm_sdq_peer==3	
		replace cm_sdq_peer_cat4=2 if cm_sdq_peer==4
		replace cm_sdq_peer_cat4=3 if cm_sdq_peer==5
		replace cm_sdq_peer_cat4=3 if cm_sdq_peer==6		
		replace cm_sdq_peer_cat4=3 if cm_sdq_peer==7	
		replace cm_sdq_peer_cat4=3 if cm_sdq_peer==8
		replace cm_sdq_peer_cat4=3 if cm_sdq_peer==9
		replace cm_sdq_peer_cat4=3 if cm_sdq_peer==10		
				
		label variable cm_sdq_peer_cat4 "SDQ Peer problems 4cat"
		
		tab cm_sdq_peer_cat4 cm_sdq_peer_cat4
		
		label values cm_sdq_peer_cat4 cm_sdq_peer_cat4
		label define cm_sdq_peer_cat4 /*
		*/ 0 "Close to average" 1 "slightly raised" 2 "High" 3 "Very high"
		tab cm_sdq_peer_cat4 cm_sdq_peer
		
	*SDQ-Pro-social
	
		tab cm_sdq_prosoc
		gen cm_sdq_prosoc_cat4=.  
		
		replace cm_sdq_prosoc_cat4=3 if cm_sdq_prosoc==0
		replace cm_sdq_prosoc_cat4=3 if cm_sdq_prosoc==1
		replace cm_sdq_prosoc_cat4=3 if cm_sdq_prosoc==2		
		replace cm_sdq_prosoc_cat4=3 if cm_sdq_prosoc==3	
		replace cm_sdq_prosoc_cat4=3 if cm_sdq_prosoc==4
		replace cm_sdq_prosoc_cat4=3 if cm_sdq_prosoc==5
		replace cm_sdq_prosoc_cat4=2 if cm_sdq_prosoc==6		
		replace cm_sdq_prosoc_cat4=1 if cm_sdq_prosoc==7	
		replace cm_sdq_prosoc_cat4=0 if cm_sdq_prosoc==8
		replace cm_sdq_prosoc_cat4=0 if cm_sdq_prosoc==9
		replace cm_sdq_prosoc_cat4=0 if cm_sdq_prosoc==10		
				
		label variable cm_sdq_prosoc_cat4 "SDQ Pro-social 4cat"
		
		tab cm_sdq_prosoc_cat4 cm_sdq_prosoc
		
		label values cm_sdq_prosoc_cat4 cm_sdq_prosoc_cat4
		label define cm_sdq_prosoc_cat4 /*
		*/ 0 "Close to average" 1 "slightly lowered" 2 "Low" 3 "Very low"
		tab cm_sdq_prosoc_cat4 cm_sdq_prosoc
		
	*SDQ-Total
	
		tab cm_sdq_total
		gen cm_sdq_total_cat4=.  
		
		replace cm_sdq_total_cat4=0 if cm_sdq_total==0
		replace cm_sdq_total_cat4=0 if cm_sdq_total==1
		replace cm_sdq_total_cat4=0 if cm_sdq_total==2		
		replace cm_sdq_total_cat4=0 if cm_sdq_total==3	
		replace cm_sdq_total_cat4=0 if cm_sdq_total==4
		replace cm_sdq_total_cat4=0 if cm_sdq_total==5
		replace cm_sdq_total_cat4=0 if cm_sdq_total==6		
		replace cm_sdq_total_cat4=0 if cm_sdq_total==7	
		replace cm_sdq_total_cat4=0 if cm_sdq_total==8
		replace cm_sdq_total_cat4=0 if cm_sdq_total==9
		replace cm_sdq_total_cat4=0 if cm_sdq_total==10	
		replace cm_sdq_total_cat4=0 if cm_sdq_total==11
		replace cm_sdq_total_cat4=0 if cm_sdq_total==12
		replace cm_sdq_total_cat4=0 if cm_sdq_total==13	
		replace cm_sdq_total_cat4=1 if cm_sdq_total==14
		replace cm_sdq_total_cat4=1 if cm_sdq_total==15
		replace cm_sdq_total_cat4=1 if cm_sdq_total==16
		replace cm_sdq_total_cat4=2 if cm_sdq_total==17	
		replace cm_sdq_total_cat4=2 if cm_sdq_total==18
		replace cm_sdq_total_cat4=2 if cm_sdq_total==19
		replace cm_sdq_total_cat4=3 if cm_sdq_total==20
		replace cm_sdq_total_cat4=3 if cm_sdq_total==21
		replace cm_sdq_total_cat4=3 if cm_sdq_total==22		
		replace cm_sdq_total_cat4=3 if cm_sdq_total==23	
		replace cm_sdq_total_cat4=3 if cm_sdq_total==24
		replace cm_sdq_total_cat4=3 if cm_sdq_total==25
		replace cm_sdq_total_cat4=3 if cm_sdq_total==26		
		replace cm_sdq_total_cat4=3 if cm_sdq_total==27	
		replace cm_sdq_total_cat4=3 if cm_sdq_total==28
		replace cm_sdq_total_cat4=3 if cm_sdq_total==29
		replace cm_sdq_total_cat4=3 if cm_sdq_total==30	
		replace cm_sdq_total_cat4=3 if cm_sdq_total==31
		replace cm_sdq_total_cat4=3 if cm_sdq_total==32
		replace cm_sdq_total_cat4=3 if cm_sdq_total==33	
		replace cm_sdq_total_cat4=3 if cm_sdq_total==34
		replace cm_sdq_total_cat4=3 if cm_sdq_total==35
		replace cm_sdq_total_cat4=3 if cm_sdq_total==36
		replace cm_sdq_total_cat4=3 if cm_sdq_total==37	
		replace cm_sdq_total_cat4=3 if cm_sdq_total==38
		replace cm_sdq_total_cat4=3 if cm_sdq_total==39
		replace cm_sdq_total_cat4=3 if cm_sdq_total==40
			
				
		label variable cm_sdq_total_cat4 "SDQ Total 4cat"
		
	
		label values cm_sdq_total_cat4 cm_sdq_total_cat4
		label define cm_sdq_total_cat4 /*
		*/ 0 "Close to average" 1 "slightly raised" 2 "High" 3 "Very high"
		tab cm_sdq_total_cat4 
		tab cm_sdq_total
	
		***
		**SDQ cut-offs - 2 categories
		***
		
		*SDQ-Emotional 2cat
	
		gen cm_sdq_emotion_cat2=. 
		replace cm_sdq_emotion_cat2=0 if cm_sdq_emotion==0
		replace cm_sdq_emotion_cat2=0 if cm_sdq_emotion==1
		replace cm_sdq_emotion_cat2=0 if cm_sdq_emotion==2		
		replace cm_sdq_emotion_cat2=0 if cm_sdq_emotion==3	
		replace cm_sdq_emotion_cat2=0 if cm_sdq_emotion==4
		replace cm_sdq_emotion_cat2=1 if cm_sdq_emotion==5
		replace cm_sdq_emotion_cat2=1 if cm_sdq_emotion==6		
		replace cm_sdq_emotion_cat2=1 if cm_sdq_emotion==7	
		replace cm_sdq_emotion_cat2=1 if cm_sdq_emotion==8
		replace cm_sdq_emotion_cat2=1 if cm_sdq_emotion==9
		replace cm_sdq_emotion_cat2=1 if cm_sdq_emotion==10		
				
		label variable cm_sdq_emotion_cat2 "SDQ Emotion 2cat"
		
		tab cm_sdq_emotion_cat2 cm_sdq_emotion
		
		label values cm_sdq_emotion_cat2 cm_sdq_emotion_cat2
		label define cm_sdq_emotion_cat2 /*
		*/ 0 "Average/Slightly raised" 1 "High/V.high"
		tab cm_sdq_emotion_cat2 cm_sdq_emotion
		
	*SDQ-Conduct 2cat
	
		tab cm_sdq_conduct
		gen cm_sdq_conduct_cat2=. 
		
		replace cm_sdq_conduct_cat2=0 if cm_sdq_conduct==0
		replace cm_sdq_conduct_cat2=0 if cm_sdq_conduct==1
		replace cm_sdq_conduct_cat2=0 if cm_sdq_conduct==2		
		replace cm_sdq_conduct_cat2=0 if cm_sdq_conduct==3	
		replace cm_sdq_conduct_cat2=1 if cm_sdq_conduct==4
		replace cm_sdq_conduct_cat2=1 if cm_sdq_conduct==5
		replace cm_sdq_conduct_cat2=1 if cm_sdq_conduct==6		
		replace cm_sdq_conduct_cat2=1 if cm_sdq_conduct==7	
		replace cm_sdq_conduct_cat2=1 if cm_sdq_conduct==8
		replace cm_sdq_conduct_cat2=1 if cm_sdq_conduct==9
		replace cm_sdq_conduct_cat2=1 if cm_sdq_conduct==10		
				
		label variable cm_sdq_conduct_cat2 "SDQ Conduct 2cat"
		
		tab cm_sdq_conduct_cat2 cm_sdq_conduct
		
		label values cm_sdq_conduct_cat2 cm_sdq_conduct_cat2
		label define cm_sdq_conduct_cat2 /*
		*/ 0 "Average/Slightly raised" 1 "High/V.high"
		tab cm_sdq_conduct_cat2 cm_sdq_conduct
		
			
	*SDQ-Hyperactivity/Inattention 4cat
	
		tab cm_sdq_hyper
		gen cm_sdq_hyper_cat2=.  
		
		replace cm_sdq_hyper_cat2=0 if cm_sdq_hyper==0
		replace cm_sdq_hyper_cat2=0 if cm_sdq_hyper==1
		replace cm_sdq_hyper_cat2=0 if cm_sdq_hyper==2		
		replace cm_sdq_hyper_cat2=0 if cm_sdq_hyper==3	
		replace cm_sdq_hyper_cat2=0 if cm_sdq_hyper==4
		replace cm_sdq_hyper_cat2=0 if cm_sdq_hyper==5
		replace cm_sdq_hyper_cat2=0 if cm_sdq_hyper==6		
		replace cm_sdq_hyper_cat2=0 if cm_sdq_hyper==7	
		replace cm_sdq_hyper_cat2=1 if cm_sdq_hyper==8
		replace cm_sdq_hyper_cat2=1 if cm_sdq_hyper==9
		replace cm_sdq_hyper_cat2=1 if cm_sdq_hyper==10		
				
		label variable cm_sdq_hyper_cat2 "SDQ Hyperactivity 2cat"
		
		tab cm_sdq_hyper_cat2 cm_sdq_hyper
		
		label values cm_sdq_hyper_cat2 cm_sdq_hyper_cat2
		label define cm_sdq_hyper_cat2 /*
		*/ 0 "Average/Slightly raised" 1 "High/V.high"
		tab cm_sdq_hyper_cat2 cm_sdq_hyper
		
	*SDQ-Peer Problems
	
		tab cm_sdq_peer
		gen cm_sdq_peer_cat2=.  
		
		replace cm_sdq_peer_cat2=0 if cm_sdq_peer==0
		replace cm_sdq_peer_cat2=0 if cm_sdq_peer==1
		replace cm_sdq_peer_cat2=0 if cm_sdq_peer==2		
		replace cm_sdq_peer_cat2=0 if cm_sdq_peer==3	
		replace cm_sdq_peer_cat2=1 if cm_sdq_peer==4
		replace cm_sdq_peer_cat2=1 if cm_sdq_peer==5
		replace cm_sdq_peer_cat2=1 if cm_sdq_peer==6		
		replace cm_sdq_peer_cat2=1 if cm_sdq_peer==7	
		replace cm_sdq_peer_cat2=1 if cm_sdq_peer==8
		replace cm_sdq_peer_cat2=1 if cm_sdq_peer==9
		replace cm_sdq_peer_cat2=1 if cm_sdq_peer==10		
				
		label variable cm_sdq_peer_cat2 "SDQ Peer problems 2cat"
		
		tab cm_sdq_peer_cat2 cm_sdq_peer_cat2
		
		label values cm_sdq_peer_cat2 cm_sdq_peer_cat2
		label define cm_sdq_peer_cat2 /*
		*/ 0 "Average/Slightly raised" 1 "High/V.high"
		tab cm_sdq_peer_cat2 cm_sdq_peer
		
	*SDQ-Pro-social
	
		tab cm_sdq_prosoc
		gen cm_sdq_prosoc_cat2=.  
		
		replace cm_sdq_prosoc_cat2=1 if cm_sdq_prosoc==0
		replace cm_sdq_prosoc_cat2=1 if cm_sdq_prosoc==1
		replace cm_sdq_prosoc_cat2=1 if cm_sdq_prosoc==2		
		replace cm_sdq_prosoc_cat2=1 if cm_sdq_prosoc==3	
		replace cm_sdq_prosoc_cat2=1 if cm_sdq_prosoc==4
		replace cm_sdq_prosoc_cat2=1 if cm_sdq_prosoc==5
		replace cm_sdq_prosoc_cat2=1 if cm_sdq_prosoc==6		
		replace cm_sdq_prosoc_cat2=0 if cm_sdq_prosoc==7	
		replace cm_sdq_prosoc_cat2=0 if cm_sdq_prosoc==8
		replace cm_sdq_prosoc_cat2=0 if cm_sdq_prosoc==9
		replace cm_sdq_prosoc_cat2=0 if cm_sdq_prosoc==10		
				
		label variable cm_sdq_prosoc_cat2 "SDQ Pro-social 2cat"
		
		tab cm_sdq_prosoc_cat2 cm_sdq_prosoc
		
		label values cm_sdq_prosoc_cat2 cm_sdq_prosoc_cat2
		label define cm_sdq_prosoc_cat2 /*
		*/ 0 "Average/Slightly lowered" 1 "Low/V.Low"
		tab cm_sdq_prosoc_cat2 cm_sdq_prosoc
		
	*SDQ-Total
	
		tab cm_sdq_total
		gen cm_sdq_total_cat2=.  
		
		replace cm_sdq_total_cat2=0 if cm_sdq_total==0
		replace cm_sdq_total_cat2=0 if cm_sdq_total==1
		replace cm_sdq_total_cat2=0 if cm_sdq_total==2		
		replace cm_sdq_total_cat2=0 if cm_sdq_total==3	
		replace cm_sdq_total_cat2=0 if cm_sdq_total==4
		replace cm_sdq_total_cat2=0 if cm_sdq_total==5
		replace cm_sdq_total_cat2=0 if cm_sdq_total==6		
		replace cm_sdq_total_cat2=0 if cm_sdq_total==7	
		replace cm_sdq_total_cat2=0 if cm_sdq_total==8
		replace cm_sdq_total_cat2=0 if cm_sdq_total==9
		replace cm_sdq_total_cat2=0 if cm_sdq_total==10	
		replace cm_sdq_total_cat2=0 if cm_sdq_total==11
		replace cm_sdq_total_cat2=0 if cm_sdq_total==12
		replace cm_sdq_total_cat2=0 if cm_sdq_total==13	
		replace cm_sdq_total_cat2=0 if cm_sdq_total==14
		replace cm_sdq_total_cat2=0 if cm_sdq_total==15
		replace cm_sdq_total_cat2=0 if cm_sdq_total==16
		replace cm_sdq_total_cat2=1 if cm_sdq_total==17	
		replace cm_sdq_total_cat2=1 if cm_sdq_total==18
		replace cm_sdq_total_cat2=1 if cm_sdq_total==19
		replace cm_sdq_total_cat2=1 if cm_sdq_total==20
		replace cm_sdq_total_cat2=1 if cm_sdq_total==21
		replace cm_sdq_total_cat2=1 if cm_sdq_total==22		
		replace cm_sdq_total_cat2=1 if cm_sdq_total==23	
		replace cm_sdq_total_cat2=1 if cm_sdq_total==24
		replace cm_sdq_total_cat2=1 if cm_sdq_total==25
		replace cm_sdq_total_cat2=1 if cm_sdq_total==26		
		replace cm_sdq_total_cat2=1 if cm_sdq_total==27	
		replace cm_sdq_total_cat2=1 if cm_sdq_total==28
		replace cm_sdq_total_cat2=1 if cm_sdq_total==29
		replace cm_sdq_total_cat2=1 if cm_sdq_total==30	
		replace cm_sdq_total_cat2=1 if cm_sdq_total==31
		replace cm_sdq_total_cat2=1 if cm_sdq_total==32
		replace cm_sdq_total_cat2=1 if cm_sdq_total==33	
		replace cm_sdq_total_cat2=1 if cm_sdq_total==34
		replace cm_sdq_total_cat2=1 if cm_sdq_total==35
		replace cm_sdq_total_cat2=1 if cm_sdq_total==36
		replace cm_sdq_total_cat2=1 if cm_sdq_total==37	
		replace cm_sdq_total_cat2=1 if cm_sdq_total==38
		replace cm_sdq_total_cat2=1 if cm_sdq_total==39
		replace cm_sdq_total_cat2=1 if cm_sdq_total==40
			
				
		label variable cm_sdq_total_cat2 "SDQ Total 2cat"
		
	
		label values cm_sdq_total_cat2 cm_sdq_total_cat2
		label define cm_sdq_total_cat2 /*
		*/ 0 "Average/Slightly lowered" 1 "Low/V.Low"
		tab cm_sdq_total_cat2 
		tab cm_sdq_total
		
*/
	drop cmd_*
		
	save "`temp'\CM_derived_clean.dta", replace		
				
************************************************************************************************************************************
* Step 7: Combine datasets

local data "C:\Users\heinh\OneDrive - University of Leeds\Data\UKDA-8156-stata\stata\stata13"
local temp "C:\Users\heinh\OneDrive - University of Leeds\Data\Temp"

*Erase unneeded datasets

	erase "`temp'\fathers.dta"
	erase "`temp'\mothers.dta"
	erase "`temp'\relationship to CM.dta"
	erase "`temp'\parent interview and derived.dta"

*Combine all datasets 

local data "C:\Users\heinh\OneDrive - University of Leeds\Data\UKDA-8156-stata\stata\stata13"
local temp "C:\Users\heinh\OneDrive - University of Leeds\Data\Temp"

	use "`temp'\cm_clean.dta", clear
	count
	
	joinby MCSID using "`temp'\mother_clean.dta", _merge(_merge) unmatched(master)
	drop _merge
	count
	
	*Note: 7 same-sex female couples coparenting a study child. Since we don't want more than one row of data per CM, we randomly chose one of these mothers to be included. 
	
	duplicates drop MCSID FCNUM00, force
	count
	
	joinby MCSID using "`temp'\father_clean.dta", _merge(_merge) unmatched(master)
	drop _merge
	count
	
	joinby MCSID using "`temp'\fathers about first child.dta", _merge(_merge) unmatched(master)	
	drop _merge
	count

	joinby MCSID using "`temp'\fathers about second child.dta", _merge(_merge) unmatched(master)	
	drop _merge
	count
	
	joinby MCSID using "`temp'\fathers about third child.dta", _merge(_merge) unmatched(master)	
	drop _merge
	count
	
	joinby MCSID using "`temp'\mothers about first child.dta", _merge(_merge) unmatched(master)	
	drop _merge
	count
	duplicates drop MCSID FCNUM00, force
	count

	joinby MCSID using "`temp'\mothers about second child.dta", _merge(_merge) unmatched(master)	
	drop _merge
	count
	duplicates drop MCSID FCNUM00, force
	count
	
	joinby MCSID using "`temp'\mothers about third child.dta", _merge(_merge) unmatched(master)	
	drop _merge
	count
	duplicates drop MCSID FCNUM00, force
	count
	
	joinby MCSID FCNUM00 using "`temp'\CM_derived_clean.dta", _merge(_merge) unmatched(master)
	drop _merge
	count
	
	drop FPNUM00

************************************************************************************************************************************
* Step 7: Add 2004 IMD data

local data "C:\Users\heinh\OneDrive - University of Leeds\Data\UKDA-8156-stata\stata\stata13"
local temp "C:\Users\heinh\OneDrive - University of Leeds\Data\Temp"

	preserve
		foreach country in e n s w {
			use13 "`data'\mcs_sweep6_imd_`country'_2004.dta", clear
			drop FACTRY00
			save "`temp'\mcs_sweep6_imd_`country'_2004_stata12.dta", replace
		}
	restore
	
	foreach country in e n s w {
		joinby MCSID using "`temp'\mcs_sweep6_imd_`country'_2004_stata12.dta", _merge(_merge) unm(m)
		tab _merge
		drop _merge
		count
	}
	
	count
	
	gen hh_imd2004_overall=.
	replace hh_imd2004_overall = FIMDSCOE if FIMDSCOE != .
	replace hh_imd2004_overall = FIMDSCON if FIMDSCON != .
	replace hh_imd2004_overall = FISIMDSC if FISIMDSC != .
	replace hh_imd2004_overall = FIWIMDSC if FIWIMDSC != .
	recode hh_imd2004_overall /*
	*/ (1=10) (2=9) (3=8) (4=7) (5=6) /*
	*/ (6=5) (7=4) (8=3) (9=2) (10=1) 
	label values hh_imd2004_overall hh_imd2004_overall
	label define hh_imd2004_overall 1 "least deprived" 10 "most deprived"
	label variable hh_imd2004_overall "overall decile"

	tab hh_imd2004_overall, miss
	
	drop FIMDSCOE FIMDSCON FISIMDSC FIWIMDSC
	
	gen hh_imd2004_income=.
	replace hh_imd2004_income = FIMDINCE if FIMDINCE != .
	replace hh_imd2004_income = FIMDINCN if FIMDINCN != .
	replace hh_imd2004_income = FISIMDIN if FISIMDIN != .
	replace hh_imd2004_income = FIWIMDIN if FIWIMDIN != .
	recode hh_imd2004_income /*
	*/ (1=10) (2=9) (3=8) (4=7) (5=6) /*
	*/ (6=5) (7=4) (8=3) (9=2) (10=1) 
	label values hh_imd2004_income hh_imd2004_income
	label define hh_imd2004_income 1 "least deprived" 10 "most deprived"
	label variable hh_imd2004_income "income domain decile"
	tab hh_imd2004_income, miss
	
	drop FIMDINCE FIMDINCN FISIMDIN FIWIMDIN	
	
	gen hh_imd2004_employment=.
	replace hh_imd2004_employment = FIMDEMPE if FIMDEMPE != .
	replace hh_imd2004_employment = FIMDEMPN if FIMDEMPN != .
	replace hh_imd2004_employment = FISIMDEM if FISIMDEM != .
	replace hh_imd2004_employment = FIWIMDEM if FIWIMDEM != .
	recode hh_imd2004_employment /*
	*/ (1=10) (2=9) (3=8) (4=7) (5=6) /*
	*/ (6=5) (7=4) (8=3) (9=2) (10=1) 
	label values hh_imd2004_employment hh_imd2004_employment
	label define hh_imd2004_employment 1 "least deprived" 10 "most deprived"
	label variable hh_imd2004_employment "employment domain decile"
	tab hh_imd2004_employment, miss
	
	drop FIMDEMPE FIMDEMPN FISIMDEM FIWIMDEM	
	
	gen hh_imd2004_health=.
	replace hh_imd2004_health = FIMDHDDE if FIMDHDDE != .
	replace hh_imd2004_health = FIMDHDDN if FIMDHDDN != .
	replace hh_imd2004_health = FISIMDHD if FISIMDHD != .
	replace hh_imd2004_health = FIWIMDHD if FIWIMDHD != .
	recode hh_imd2004_health /*
	*/ (1=10) (2=9) (3=8) (4=7) (5=6) /*
	*/ (6=5) (7=4) (8=3) (9=2) (10=1) 
	label values hh_imd2004_health hh_imd2004_health
	label define hh_imd2004_health 1 "least deprived" 10 "most deprived"
	label variable hh_imd2004_health "health deprivation and disability domain decile"
	tab hh_imd2004_health, miss
	
	drop FIMDHDDE FIMDHDDN FISIMDHD FIWIMDHD		
	
	gen hh_imd2004_education=.
	replace hh_imd2004_education = FIMDHOSE if FIMDHOSE != .
	replace hh_imd2004_education = FIMDESTN if FIMDESTN != .
	replace hh_imd2004_education = FISIMDES if FISIMDES != .
	replace hh_imd2004_education = FIWIMDES if FIWIMDES != .
	recode hh_imd2004_education /*
	*/ (1=10) (2=9) (3=8) (4=7) (5=6) /*
	*/ (6=5) (7=4) (8=3) (9=2) (10=1) 
	label values hh_imd2004_education hh_imd2004_education
	label define hh_imd2004_education 1 "least deprived" 10 "most deprived"
	label variable hh_imd2004_education "education, skills and training domain decile"
	tab hh_imd2004_education, miss
	
	drop FIMDHOSE FIMDESTN FISIMDES FIWIMDES		
	
	* Note: housing measure not available for Northern Ireland
	
	gen hh_imd2004_housing=.
	replace hh_imd2004_housing = FIMDESTE if FIMDESTE != .
	replace hh_imd2004_housing = FISIMDHO if FISIMDHO != .
	replace hh_imd2004_housing = FIWIMDHO if FIWIMDHO != .
	recode hh_imd2004_housing /*
	*/ (1=10) (2=9) (3=8) (4=7) (5=6) /*
	*/ (6=5) (7=4) (8=3) (9=2) (10=1) 
	label values hh_imd2004_housing hh_imd2004_housing
	label define hh_imd2004_housing 1 "least deprived" 10 "most deprived"
	label variable hh_imd2004_housing "barriers to housing $ services domain decile"
	tab hh_imd2004_housing, miss
	
	drop FIMDESTE FISIMDHO FIWIMDHO	
	
	* Note: crime measure not available for Scotland
	
	gen hh_imd2004_crime=.
	replace hh_imd2004_crime = FIMDCRIE if FIMDCRIE != .
	replace hh_imd2004_crime = FIMDCRIN if FIMDCRIN != .
	replace hh_imd2004_crime = FIWIMDCR if FIWIMDCR != .
	recode hh_imd2004_crime /*
	*/ (1=10) (2=9) (3=8) (4=7) (5=6) /*
	*/ (6=5) (7=4) (8=3) (9=2) (10=1) 
	label values hh_imd2004_crime hh_imd2004_crime
	label define hh_imd2004_crime 1 "least deprived" 10 "most deprived"
	label variable hh_imd2004_crime "crime domain decile"
	tab hh_imd2004_crime, miss
	
	drop FIMDCRIE FIMDCRIN FIWIMDCR
	
	* Note: living environment measure not available for Scotland
	
	gen hh_imd2004_environment=.
	replace hh_imd2004_environment = FIMDLEDE if FIMDLEDE != .
	replace hh_imd2004_environment = FIMDLEDN if FIMDLEDN != .
	replace hh_imd2004_environment = FIWIMDLE if FIWIMDLE != .
	recode hh_imd2004_environment /*
	*/ (1=10) (2=9) (3=8) (4=7) (5=6) /*
	*/ (6=5) (7=4) (8=3) (9=2) (10=1) 
	label values hh_imd2004_environment hh_imd2004_environment
	label define hh_imd2004_environment 1 "least deprived" 10 "most deprived"
	label variable hh_imd2004_environment "living environment domain decile"
	tab hh_imd2004_environment, miss
	
	drop FIMDLEDE FIMDLEDN FIWIMDLE	
	
	* Note: geographic access and telecommunication measure only available for Scotland
	
	gen hh_imd2004_access=.
	replace hh_imd2004_access = FISIMDMG if FISIMDMG != .
	recode hh_imd2004_access /*
	*/ (1=10) (2=9) (3=8) (4=7) (5=6) /*
	*/ (6=5) (7=4) (8=3) (9=2) (10=1) 
	label values hh_imd2004_access hh_imd2004_access
	label define hh_imd2004_access 1 "least deprived" 10 "most deprived"
	label variable hh_imd2004_access "gegraphic access and telecom domain decile"
	tab hh_imd2004_access, miss	
	
	drop FISIMDMG
	
	*Urbanicity
	
	gen hh_urbanicity_2004=.
	replace hh_urbanicity_2004 = FIERURUR if FIERURUR != .
	replace hh_urbanicity_2004 = FINRURUR if FINRURUR != .
	replace hh_urbanicity_2004 = FISRURUR if FISRURUR != .
	replace hh_urbanicity_2004 = FIWRURUR if FIWRURUR != .
	label variable hh_urbanicity_2004 "urbanicity"
	label values hh_urbanicity hh_urbanicity
	label define hh_urbanicity /*
	*/ 1 "urban >10k - sparse" /*
	*/ 2 "town and fringe - sparse" /*
	*/ 3 "village, hamlet and isolated dwellings" /*
	*/ 4 "urban >10k - less sparse" /*
	*/ 5 "town and fringe - less sparse" /*
	*/ 6 "village, hamlet and isolated dwellings" 
	tab hh_urbanicity_2004, miss
	
	drop FIERURUR FINRURUR FISRURUR FIWRURUR	
	
************************************************************************************************************************************
* Step 9: Add family-level derived variables

	preserve
		use13 "C:\Users\heinh\OneDrive - University of Leeds\Data\UKDA-8156-stata\stata\stata13\mcs6_family_derived.dta", clear
		keep MCSID FAREGN00 FDROOW00 FDCWRK00 FOEDE000 FOEDP000 FDHTYS00
		saveold "C:\Users\heinh\OneDrive - University of Leeds\Data\Temp\family_derived.dta", replace
	restore
	
	joinby MCSID using "C:\Users\heinh\OneDrive - University of Leeds\Data\Temp\family_derived.dta", _merge(_merge) unm(m)
	tab _merge
	drop _merge
	count	
		
************************************************************************************************************************************
* Step 9: Add design/non-response info
	
	joinby MCSID using "C:\Users\heinh\OneDrive - University of Leeds\Data\MCS longitudinal family file\UKDA-8172-stata11\stata11\mcs_longitudinal_family_file.dta", _merge(_merge) unm(m)
	tab _merge
	drop _merge
	count

************************************************************************************************************************************
* Step 10: Code additional variables

	rename *, lower
	
	* Combine data given by parents about CM1, CM2 and CM3

		foreach variable in /*
		*/ close /*
		*/ argue /*
		*/ internal_1 internal_2 internal_3 internal_4 internal_5 /*
		*/ internal_6 internal_7 internal_8 internal_9 internal_sum /*
		*/ external_1 external_2 external_3 external_4 external_5 /*
		*/ external_6 external_7 external_8 external_9 external_10 external_sum /*
		*/ illness illnessmh {	
					
			foreach letter in m f {
							
				gen `letter'_cm_`variable'=.
								
				bysort mcsid: replace `letter'_cm_`variable'=`letter'_cm1_`variable' if fcnum00==1 
				bysort mcsid: replace `letter'_cm_`variable'=`letter'_cm2_`variable' if fcnum00==2
				bysort mcsid: replace `letter'_cm_`variable'=`letter'_cm3_`variable' if fcnum00==3
				
			}
		}
		
		foreach variable in close argue {	
					
			foreach letter in m f {
							
				recode `letter'_cm_`variable' (1=4) (2=3) (3=2) (4=1)

			}
		}
					
		foreach var in m_cm_close f_cm_close {
		
			label values `var' `var'
			label define `var' /*
			*/ 1 "extremely close" /*
			*/ 2 "very close" /*
			*/ 3 "fairly close" /*
			*/ 4 "not very close" /*
			*/ 5 "don't know/didn't want to answer"
			}
			
		foreach var in m_cm_argue f_cm_argue {
		
			label values `var' `var'
			label define `var' /*
			*/ 1 "hardly ever" /*
			*/ 2 "less than once a week" /*
			*/ 3 "more than once a week" /*
			*/ 4 "most days" /*
			*/ 5 "don't know/didn't want to answer"
			}
			
		label variable m_cm_close "M(nat/step/adopt) how close to CM"
		label variable f_cm_close "F(nat/step/adopt) how close to CM"
		label variable m_cm_argue "M(nat/step/adopt) how often argue with CM"
		label variable f_cm_argue "F(nat/step/adopt) how often argue with CM"	
		
		drop f_cm1_close f_cm1_argue f_cm2_close f_cm2_argue f_cm3_close f_cm3_argue /*
		*/   m_cm1_close m_cm1_argue m_cm2_close m_cm2_argue m_cm3_close m_cm3_argue
		
		foreach letter in m f {
		
			foreach var in illness illnessmh {
			
				label values `letter'_cm_`var' `letter'_cm_`var' 
				label define `letter'_cm_`var' 0 "no" 1 "yes" 9 "child has no longterm `var'"
				
			}
		}
		
		foreach letter in m f {
		
			label variable `letter'_cm_illness "child has longterm illness"
			label variable `letter'_cm_illnessmh "child has longterm illness - mental health"
			
		}
		
		drop /*
		*/ m_cm1_illness m_cm2_illness m_cm3_illness f_cm1_illness f_cm2_illness f_cm3_illness /*
		*/ m_cm1_illnessmh m_cm2_illnessmh m_cm3_illnessmh f_cm1_illnessmh f_cm2_illnessmh f_cm3_illnessmh
		
		foreach letter in m f {
			
			foreach number of numlist 1/6 9 {

		
				label values `letter'_cm_internal_`number' `letter'_cm_internal_`number'
				label define `letter'_cm_internal_`number' /*
				*/ 1 "not true" 2 "somewhat true" 3 "certainly true"
			
			}
		}	
		
		foreach letter in m f {
		
			foreach number in 7 8 {
		
		
				label values `letter'_cm_internal_`number' `letter'_cm_internal_`number'
				label define `letter'_cm_internal_`number' /*
				*/ 1 "certainly true" 2 "somewhat true" 3 "not true"
			
			}
		}
		
		foreach letter in m f {
			
			label variable `letter'_cm_internal_1 "complains of headaches/stomach aches/sickness"
			label variable `letter'_cm_internal_2 "often seems worried"
			label variable `letter'_cm_internal_3 "often unhappy"
			label variable `letter'_cm_internal_4 "nervous or clingy in new situations"
			label variable `letter'_cm_internal_5 "many fears, easily scared"
			label variable `letter'_cm_internal_6 "tends to play alone"
			label variable `letter'_cm_internal_7 "has at least one good friend"
			label variable `letter'_cm_internal_8 "generally liked by other children"
			label variable `letter'_cm_internal_9 "picked on or bullied by other children"
			
		}
					
		drop m_cm1_internal_* m_cm2_internal_* m_cm3_internal_* f_cm1_internal* f_cm2_internal_* f_cm3_internal_*
			
		foreach letter in m f {
		
			foreach number of numlist 1 3/8 {
		
		
				label values `letter'_cm_external_`number' `letter'_cm_external_`number'
				label define `letter'_cm_external_`number' /*
				*/ 1 "not true" 2 "somewhat true" 3 "certainly true"
			
			}
		}	
		
		foreach letter in m f {
		
			foreach number of numlist 2 9/10 {
		
		
				label values `letter'_cm_external_`number' `letter'_cm_external_`number'
				label define `letter'_cm_external_`number' /*
				*/ 1 "certainly true" 2 "somewhat true" 3 "not true"
			
			}
		}			
			
		foreach letter in m f {
			
			label variable `letter'_cm_external_1 "often has temper tantrums"
			label variable `letter'_cm_external_2 "generally obedient"
			label variable `letter'_cm_external_3 "fights with or bullies other children"
			label variable `letter'_cm_external_4 "steals from home, school or elsewhere"
			label variable `letter'_cm_external_5 "often lies or cheats"
			label variable `letter'_cm_external_6 "restless, overactive, cannot stay still for long"
			label variable `letter'_cm_external_7 "constantly fidgeting"
			label variable `letter'_cm_external_8 "easily distracted"
			label variable `letter'_cm_external_9 "can stop and think before acting"
			label variable `letter'_cm_external_10 "sees tasks through to the end"
			
		}
					
		drop m_cm1_external_* m_cm2_external_* m_cm3_external_* f_cm1_external* f_cm2_external_* f_cm3_external_*			
			
	*Create attracted to same sex variable

		gen cm_samesex=.
		replace cm_samesex=1 if (cm_female==0 & cm_attracted_males==1) | (cm_female==1 & cm_attracted_females==1)
		replace cm_samesex=0 if (cm_female==0 & cm_attracted_males==0) | (cm_female==1 & cm_attracted_females==0)
		label variable cm_samesex "CM ever attracted to same sex"
		label values cm_samesex cm_samesex 
		label define cm_samesex 0 "No" 1 "yes" 	
		
	*Shorten IMD variable names and assign string labels
	
		foreach type in overall income employment health education housing crime environment access {
			rename hh_imd2004_`type' imd04_`type'
		}
			
		foreach type in overall income employment health education housing crime environment access {
			label values imd04_`type' imd04_`type'
			label define imd04_`type' /*
			*/ 1 "least deprived" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "most deprived"
		}
		
	*Assign string labels for SDQ items
	
		foreach type in emotion conduct hyper peer prosoc {
			label values cm_sdq_`type' cm_sdq_`type'
			label define cm_sdq_`type' /*
			*/ 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" 6 "6" 7 "7" 8 "8" 9 "9" 10 "10"
		}
			
	*Shorten online bullying variables
	
		rename cm_onlinebully_by_others cm_cbully_by_others
		rename cm_onlinebully_others cm_cbully_others
		
	*Code variable for development of secondary sexual characteristics
	
		gen cm_secondsex=.
		
		replace cm_secondsex=0 if /*
		*/ inlist(cm_pgrowth, 1, 2) & /*
		*/ inlist(cm_pskin, 1, 2) & /*
		*/ inlist(cm_phair, 1, 2)
		
		replace cm_secondsex=1 if /*
		*/ inlist(cm_pgrowth, 3, 4) | /*
		*/ inlist(cm_pskin, 3, 4) | /*
		*/ inlist(cm_phair, 3, 4)
		
		tab cm_secondsex, miss
		
		if cm_female==0 {
		
			replace cm_secondsex=0 if /*
			*/ inlist(cm_pvoice, 1, 2) & /*
			*/ inlist(cm_pfacehair, 1, 2) 
			
			replace cm_secondsex=1 if /*
			*/ inlist(cm_pvoice, 3, 4) | /*
			*/ inlist(cm_pfacehair, 3, 4)
			
		}
		
		if cm_female==1 {
		
			replace cm_secondsex=0 if /*
			*/ inlist(cm_pbreast, 1, 2) & /*
			*/ cm_pmenarche==0
			
			replace cm_secondsex=1 if /*
			*/ inlist(cm_pbreast, 3, 4) | /*
			*/ cm_pmenarche==1
			
		}
		
		label variable cm_secondsex "definite signs of secondary sexual characteristics"
		label values cm_secondsex cm_secondsex
		label define cm_secondsex 0 "no" 1 "yes"
			
		tab cm_secondsex, miss
		
	*Code variable to identify harmful drinking in father/mother
	
		foreach parent in m f {
		
			gen `parent'_alcohol_bin=.
			replace `parent'_alcohol_bin=0 if `parent'_alcohol<=4
			replace `parent'_alcohol_bin=1 if `parent'_alcohol>=5 & `parent'_alcohol!=.
			label variable `parent'_alcohol_bin "AUDIT risk category"
			label values `parent'_alcohol_bin `parent'_alcohol_bin
			label define `parent'_alcohol_bin 0 "low risk" 1 "risky/harmful drinking"
			tab `parent'_alcohol_bin
			
		}
		
	*Note: some implausible values in the contingency table, i.e:

		tab cm_friends_b cm_friends_g
			
	/*		
	
	*Create same sex friendships
	
		gen cm_samesexfriendship=.
		replace cm_samesexfriendship=1 /*
			*/if cm_female==0 & cm_friends_b==1 | cm_female==1 & cm_friends_g==1
		replace cm_samesexfriendship=2 /*	
			*/if cm_female==0 & cm_friends_b==2 | cm_female==1 & cm_friends_g==2
		replace cm_samesexfriendship=3 /*
			*/if cm_female==0 & cm_friends_b==3 | cm_female==1 & cm_friends_g==3
		replace cm_samesexfriendship=4 /*	
			*/if cm_female==0 & cm_friends_b==4 | cm_female==1 & cm_friends_g==4

		label variable cm_samesexfriendship "How many of your friends are the same sex as you?"
		label values cm_samesexfriendship cm_samesexfriendship 
		label define cm_samesexfriendship /*
			*/ 1 "all" 2 "most" 3 "some" 4 "none" 
			
	*/ 	
	
		order f_cm_external_*, last
		order f_cm_internal_*, last
		order m_cm_external_*, last
		order m_cm_internal_*, last	
	
************************************************************************************************************************************
* Step 10: Save finalised data set
	 
	save "C:\Users\heinh\OneDrive - University of Leeds\Work docs\Research\MCS selfharm gender study\MCS analysis data set.dta", replace





