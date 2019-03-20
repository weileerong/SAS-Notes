/******************************************************
*	Cracker example from the book
*******************************************************/

option nodate nocenter;
data crackers;
input sales previous promotion id;
datalines;
 38  21  1  1
  39  26  1  2
  36  22  1  3
  45  28  1  4
  33  19  1  5
  43  34  2  1
  38  26  2  2
  38  29  2  3
  27  18  2  4
  34  25  2  5
  24  23  3  1
  32  29  3  2
  31  30  3  3
  21  16  3  4
  28  29  3  5
;
run;

proc means data = crackers mean;
var previous;
run;

data crackersc;
set crackers;
previousc = previous-25;
run;

/************************************/
/* Inital investigation of the data*/

/* Is there an interaction*/

proc sort data=crackers;
by previous;
run;

proc glm data=crackers;
class promotion;
model sales = promotion previous promotion*previous;
run;
quit;

/* Fit the additive model */
proc glm data=crackers;
class promotion;
model sales = promotion previous;
output out=CrackOut r=r p=p;
run;

/*Normal QQ-Plot*/
proc univariate data=CrackOut noprint;
qqplot r;
run;


/************************************/
/* Factor means */
proc glm data=crackers;
class promotion;
model sales = promotion previous;
means promotion / clm;
lsmeans promotion /  pdiff adjust=tukey cl;
run;
quit;


/* LSMEANS without pervious in the model
gives the same solutions as MEANS */
proc glm data=crackers;
class promotion;
model sales = promotion;
lsmeans promotion / pdiff adjust=tukey;
run;
quit;




/**********************************************
	Hormone Study
************************************************/
data hormone;
input growth sex depression id;
datalines;
  1.4  1  1  1
  2.4  1  1  2
  2.2  1  1  3
  2.1  1  2  1
  1.7  1  2  2
  0.7  1  3  1
  1.1  1  3  2
  2.4  2  1  1
  2.5  2  2  1
  1.8  2  2  2
  2.0  2  2  3
  0.5  2  3  1
  0.9  2  3  2
  1.3  2  3  3
  ;
run;


PROC FORMAT;
  VALUE  forsex 1="Male"
                2="Female";
  Value fordep 1="Severe"
  					2="Mod"
					3="Mild";
run;

/*****************************************
A quick look at the data
*******************************************/
proc freq data=hormone;
format sex forsex. depression fordep.;
table sex*depression;
run;


/*****************************************
The model with interaction 
*******************************************/
proc glm data=hormone;
format sex forsex. depression fordep.;
class sex depression;
model growth = sex depression sex*depression;
means sex*depression;
lsmeans sex*depression / cl;
means sex;
lsmeans sex;
run; quit;


/*****************************************
analyzing cell means without interaction
*******************************************/
proc glm data=hormone;
format sex forsex. depression fordep.;
class sex depression;
model growth = sex depression / solution;
lsmeans depression / adjust=tukey;
estimate 'Mild Male' intercept 1 sex 0 1 depression 1 0 0 /e;
estimate 'Mod Male' intercept 1 sex 0 1 depression 0 1 0 /e;
estimate 'Mod Female' intercept 1 sex 1 0 depression 0 1 0 /e;
estimate 'Mod Mean - same as lsmeans' intercept 1 sex 0.5 0.5 depression 0 1 0 /e;
run; quit;




/**********************************************
	Hormone Study With an Empty Cell
************************************************/
data hormone2;
input growth sex depression id;
datalines;
 1.4  1  1  1
  2.4  1  1  2
  2.2  1  1  3
  2.1  1  2  1
  1.7  1  2  2
  0.7  1  3  1
  1.1  1  3  2
  2.5  2  2  1
  1.8  2  2  2
  2.0  2  2  3
  0.5  2  3  1
  0.9  2  3  2
  1.3  2  3  3
  ;
run;

proc freq data=hormone2;
format sex forsex. depression fordep.;
table sex*depression;
run;

proc glm data=hormone2;
format sex forsex. depression fordep.;
class sex depression;
model growth = sex depression sex*depression /solution;
lsmeans sex*depression;
run; quit;


proc glm data=hormone2;
format sex forsex. depression fordep.;
class sex depression;
model growth = sex depression / solution;
lsmeans depression / adjust=tukey;
estimate 'Mod Female' intercept 1 sex 1 0 depression 0 1 0;
estimate 'Mod Male' intercept 1 sex 1 0 depression 0 1 0;
estimate 'Mod mean' intercept 1 sex 0.5 0.5 depression 0 1 0;
estimate 'Sev Female' intercept 1 sex 1 0 depression  0 0 1;
run; quit;





