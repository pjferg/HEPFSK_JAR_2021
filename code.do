********************************************************************************************************************************************
*
*  Less Information, More Comparison, and Better Performance: Evidence from a Field Experiment
*
*  Henry Eyring, Patrick Ferguson, and Sebastian Koppers
*
*  Steps and program for main empirical analyses
*  Data are confidential and provided by skills.lab as described in the attached datasheet
*
********************************************************************************************************************************************


********************************************************************************************************************************************


******************

use "/Users/eyring/Documents/LIMC Code and Data Sharing Components/LIMC Data.dta", replace


*generate var in round 2 for performance from round 1

gen r1_dist_inr1 = distance if round==1

egen r1_dist = mode(r1_dist_inr1), by(id)

gen r1_hit_inr1 = hitrate if round==1

egen r1_hit = mode(r1_hit_inr1), by(id)

gen r1_avg_inr1 = avg_time if round==1

egen r1_avg = mode(r1_avg_inr1), by(id)

gen r1_fast_inr1 = fast_time if round==1

egen r1_fast = mode(r1_fast_inr1), by(id)


*generate var in round 2 for square of performance from round 1

gen r1_dist_square = r1_dist^2

gen r1_avg_square = r1_avg^2

gen r1_hit_square = r1_hit^2

gen r1_fast_square = r1_fast^2



******************


** Table 2 **

est clear 

*

eststo: reg hitrate rel both det age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position r1_hit r1_hit_square if (round==2), robust

eststo: reg hitrate rel both det int_rel_det int_both_det age gender heig weig leaguelevel pctgames tenurew  i.skills_cat i.firstlanguage i.training i.position r1_hit r1_hit_square if (round==2), robust


eststo: reg distance rel both det age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position r1_dist r1_dist_square if (round==2), robust

eststo: reg distance rel both det int_rel_det int_both_det age gender heig weig leaguelevel pctgames tenurew  i.skills_cat i.firstlanguage i.training i.position r1_dist r1_dist_square if (round==2), robust


eststo: reg avg_time rel both det age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position r1_avg r1_avg_square if (round==2), robust

eststo: reg avg_time rel both det int_rel_det int_both_det age gender heig weig leaguelevel pctgames tenurew  i.skills_cat i.firstlanguage i.training i.position r1_avg r1_avg_square if (round==2), robust


eststo: reg fast_time rel both det age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position r1_fast r1_fast_square if (round==2), robust

eststo: reg fast_time rel both det int_rel_det int_both_det age gender heig weig leaguelevel pctgames tenurew  i.skills_cat i.firstlanguage i.training i.position r1_fast r1_fast_square if (round==2), robust


*tabulate 

esttab using "/Users/eyring/Documents/LIMC Tables/table2.csv", replace b(2) nogaps star(* 0.10 ** 0.05 *** 0.01)

********

 
** Table 3 **

est clear 

*

eststo: reg toomanymeasures both age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position if (round==2), robust

eststo: reg toomanymeasures both age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position if (round==2) & aggregate==0, robust

eststo: reg toomanymeasures both age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position if (round==2) & aggregate==1, robust


*tabulate

esttab using "/Users/eyring/Documents/LIMC Tables/table3.csv", replace b(2) nogaps star(* 0.10 ** 0.05 *** 0.01)

********


** Table 4 **

est clear

*generate comparison

factor comparison1 comparison2 if round==2

predict comparison

*

eststo: reg comparison rel both age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position if (round==2), robust


*tabulate

esttab using "/Users/eyring/Documents/LIMC Tables/table4.csv", replace b(2) nogaps star(* 0.10 ** 0.05 *** 0.01)

********

 
** Table 5 **

est clear 

*

eststo: reg hitrate comparison age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position if (round ==1 | round==2), cluster(id)

eststo: reg distance comparison age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position if (round ==1 | round==2), cluster(id)

eststo: reg avg_time comparison age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position if (round ==1 | round==2), cluster(id)

eststo: reg fast_time comparison age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position if (round ==1 | round==2), cluster(id)


*tabulate

esttab using "/Users/eyring/Documents/LIMC Tables/table5.csv", replace b(2) nogaps star(* 0.10 ** 0.05 *** 0.01)
 
********
 
 
** Table 6 **

est clear 


*generate indicator for round 2 of the drill

gen aft = round == 2


*generate term for interaction between measures of time and indicator for round 2 of the drill

gen fast_aft = fast_time*aft

gen avg_aft = avg_time*aft


*

eststo: reg hitrate fast_time aft fast_aft if (round==1 | round==2) & abs==0, cluster(id)

eststo: reg hitrate fast_time aft fast_aft if (round==1 | round==2) & abs==1, cluster(id)

eststo: reg hitrate avg_time aft avg_aft if (round==1 | round==2) & abs==0, cluster(id)

eststo: reg hitrate avg_time aft avg_aft if (round==1 | round==2) & abs==1, cluster(id)


*tabulate

esttab using "/Users/eyring/Documents/LIMC Tables/table6.csv", replace b(2) nogaps star(* 0.10 ** 0.05 *** 0.01)

********
 
 
** Table 7 **

est clear


*generate terms for interaction between depth at position and feedback type

gen rel_depth = rel*depth_at_position

gen both_depth = both*depth_at_position


* 

eststo: reg hitrate rel both depth_at_position age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position r1_hit r1_hit_square if (round==2), robust

eststo: reg hitrate rel both depth_at_position rel_depth both_depth  age gender heig weig leaguelevel pctgames tenurew  i.skills_cat i.firstlanguage i.training i.position r1_hit r1_hit_square if (round==2), robust


eststo: reg distance rel both depth_at_position age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position r1_dist r1_dist_square  if (round==2), robust

eststo: reg distance rel both depth_at_position rel_depth both_depth age gender heig weig leaguelevel pctgames  tenurew i.skills_cat i.firstlanguage i.training i.position r1_dist r1_dist_square if (round==2), robust


eststo: reg avg_time rel both depth_at_position age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position r1_avg r1_avg_square if (round==2), robust

eststo: reg avg_time rel both depth_at_position rel_depth both_depth age gender heig weig leaguelevel pctgames tenurew  i.skills_cat i.firstlanguage i.training i.position r1_avg r1_avg_square if (round==2), robust


eststo: reg fast_time rel both depth_at_position age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position r1_fast r1_fast_square if (round==2), robust

eststo: reg fast_time rel both depth_at_position age rel_depth both_depth gender heig weig leaguelevel pctgames tenurew  i.skills_cat i.firstlanguage i.training i.position r1_fast r1_fast_square if (round==2), robust


* tabulate 

esttab using "/Users/eyring/Documents/LIMC Tables/table7.csv", replace b(2) nogaps star(* 0.10 ** 0.05 *** 0.01)
 
********

 
** Table 8 **

est clear 


*generate high frequency training as proxy for task commitment

gen high_train = training>=6


*

eststo: reg hitrate rel both det age gender heig weig leaguelevel pctgames tenurew  i.skills_cat i.firstlanguage i.training i.position r1_hit r1_hit_square if (round==2) & high_train==0, robust

eststo: reg hitrate rel both det age gender heig weig leaguelevel pctgames tenurew  i.skills_cat i.firstlanguage i.training i.position r1_hit r1_hit_square if (round==2) & high_train==1, robust


eststo: reg distance rel both det age gender heig weig leaguelevel pctgames tenurew  i.training i.firstlanguage i.skills_cat i.position r1_dist r1_dist_square if (round==2) & high_train==0, robust

eststo: reg distance rel both det age gender heig weig leaguelevel pctgames tenurew  i.training i.firstlanguage i.skills_cat i.position r1_dist r1_dist_square if (round==2) & high_train==1, robust


eststo: reg avg_time rel both det age gender heig weig leaguelevel pctgames tenurew  i.skills_cat i.firstlanguage i.training i.position r1_avg r1_avg_square if (round==2) & high_train==0, robust

eststo: reg avg_time rel both det age gender heig weig leaguelevel pctgames tenurew  i.skills_cat i.firstlanguage i.training i.position r1_avg r1_avg_square if (round==2) & high_train==1, robust


eststo: reg fast_time rel both det age gender heig weig leaguelevel pctgames tenurew  i.skills_cat i.firstlanguage i.training i.position r1_fast r1_fast_square if (round==2) & high_train==0, robust

eststo: reg fast_time rel both det age gender heig weig leaguelevel pctgames tenurew  i.skills_cat i.firstlanguage i.training i.position r1_fast r1_fast_square if (round==2) & high_train==1, robust


*tabulate 

esttab using "/Users/eyring/Documents/LIMC Tables/table8.csv", replace b(2) nogaps star(* 0.10 ** 0.05 *** 0.01)

********


** Table 9 **

est clear


*

eststo: reg hitrate rel both det age gender heig weig leaguelevel pctgames tenurew  i.skills_cat i.firstlanguage i.training i.position r1_hit r1_hit_square  if (round==2) & trainee==0, robust

eststo: reg hitrate rel both det age gender heig weig leaguelevel pctgames tenurew  i.skills_cat i.firstlanguage i.training i.position r1_hit r1_hit_square if (round==2) &  trainee==1, robust

 

eststo: reg distance rel both det age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position r1_dist r1_dist_square if (round==2) & trainee==0, robust

eststo: reg distance rel both det age gender heig weig leaguelevel pctgames tenurew  i.skills_cat i.firstlanguage i.training i.position r1_dist r1_dist_square if (round==2) & trainee==1, robust



eststo: reg avg_time rel both det age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position r1_avg r1_avg_square if (round==2) &  trainee==0, robust

eststo: reg avg_time rel both det age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position r1_avg r1_avg_square if (round==2) &  trainee==1, robust



eststo: reg fast_time rel both det age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position r1_fast r1_fast_square if (round==2) & trainee==0, robust

eststo: reg fast_time rel both det age gender heig weig leaguelevel pctgames tenurew i.skills_cat i.firstlanguage i.training i.position r1_fast r1_fast_square if (round==2) & trainee==1, robust


* tabulate

esttab using "/Users/eyring/Documents/LIMC Tables/table9.csv", replace b(2) nogaps star(* 0.10 ** 0.05 *** 0.01)

******************
