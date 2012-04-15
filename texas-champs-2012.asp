%
% regatta team equipment scheduling
% Texas Rowing Center Boats
% Texas Rowing Championsips 2012
%
% The problem of scheduling equipment for a regatta is a constraint
% problem -- two crews cannot use the same boat at the same time,
% and, indeed, there must be enough time between crews to rig the boat,
% launch it, warmp up, race, and return to the dock, before the next
% crew can use it.  Because this is a classic constraint problem,
% implementing this via answer-set programming seems like the easiest,
% most direct way to accomplish this.
%
% Initial version: Linas Vepstas April 2012 
%
% Copyright (c) 2012 Linas Vepstas
% The GNU GPLv3 applies.
%

% -- List of boat classes.  Can add new boat classes here, if desired.
boat(BOAT) :- eight(BOAT).
boat(BOAT) :- fourplus(BOAT).
boat(BOAT) :- fourminus(BOAT).

boat(BOAT) :- heavy_quad(BOAT).
boat(BOAT) :- midheavy_quad(BOAT).
boat(BOAT) :- midweight_quad(BOAT).
boat(BOAT) :- midlight_quad(BOAT).
boat(BOAT) :- lightweight_quad(BOAT).

boat(BOAT) :- heavy_double(BOAT).
boat(BOAT) :- midweight_double(BOAT).
boat(BOAT) :- lightweight_double(BOAT).
boat(BOAT) :- pair(BOAT).

boat(BOAT) :- heavy_single(BOAT).
boat(BOAT) :- midweight_single(BOAT).
boat(BOAT) :- lightweight_single(BOAT).
boat(BOAT) :- flyweight_single(BOAT).
boat(BOAT) :- adaptive_single(BOAT).

% --- Generic boat classes.
hv_or_mid_quad(BOAT) :- heavy_quad(BOAT).
hv_or_mid_quad(BOAT) :- midheavy_quad(BOAT).
hv_or_mid_quad(BOAT) :- midweight_quad(BOAT).
lt_or_mid_quad(BOAT) :- midweight_quad(BOAT).
lt_or_mid_quad(BOAT) :- midlight_quad(BOAT).
lt_or_mid_quad(BOAT) :- lightweight_quad(BOAT).
any_quad(BOAT) :- lightweight_quad(BOAT).


% --- Describe the boats, according to boat class.
% Kaitlin is a heavy 8, Sophie a mid-weight.
eight(kaitlin).
eight(sophie).

% Judie is a midweight, Berverly a heavy
% Marty's 4- is a midweight
fourplus(judie).
fourplus(beverly).
fourminus(martys_4minus).

% Quads
heavy_quad(orange).
heavy_quad(black).
midheavy_quad(parents).
midheavy_quad(masters).
midheavy_quad(mcdarmid).

midweight_quad(yellow).
midlight_quad(green).
midlight_quad(blue).
lightweight_quad(red).

% Doubles
heavy_double(maas).
heavy_double(kaschper).
heavy_double(barksdale).

midweight_double(swinford).
midweight_double(bass).
lightweight_double(thrash).

% Pairs -- 41 is heavyweight, 30 is midweight.
pair(41).
pair(30).

% Singles. 
heavy_single(dunya).  % Actually its a superheavy.
heavy_single(knifty).
heavy_single(director).
heavy_single(cantu).
midweight_single(somers).
midweight_single(marty_n_saloni).
midweight_single(blair).
lightweight_single(pete).
lightweight_single(veronica).
lightweight_single(unnamed).
flyweight_single(fly).
adaptive_single(intrepid).

% --- Describe crew types.
crew(juniors).
crew(advanced).
crew(advanced_a).
crew(advanced_b).
crew(advanced_c).
crew(advanced_d).
crew(intermediate).
crew(intermediate_a).
crew(intermediate_b).
crew(intermediate_c).
crew(intermediate_d).
crew(connie).
crew(jeff).
crew(ken).
crew(mari).
crew(matt).
crew(sarah).
crew(sue).
crew(wade).

% --- List the races
racenum(NUM) :- NUM=101..116.   % Saturday.
racenum(NUM) :- NUM=201..231.   % Sunday.

% --- Specify minimum number of races between equipment reuse.
center(4).

% --- Restrictions.
% Juniors are never allowed to take out the black quad.
:- request(RACE, juniors, black), racenum(RACE).

% --- List boat requests.
%- Saturday, Apr 28
%- 101	  	Womens Jr JV 4x
%- 102	  	Womens Jr. Novice 2x
%- 103	  	Mens Jr JV 4x
%- 104	  	Mens Jr Novice 2x
%- 105	  	Womens Jr Varsity 4x
%- 106	  	Womens Jr JV 2x
%- 107	  	Mens Jr Varsity 4x
%- 108	  	Mens Jr JV 2x
%- 109	  	Womens Jr Varsity 2x
%- 110	  	Womens Jr Novice 4x
%- 111	  	Mens Jr Varsity 2x
%- 112	  	Mens Jr Novice 4x
%- 113	  	Womens Jr 1x
%- 114	  	Womens Jr Ltwt 2x
%- 115	  	Mens Jr 1x
%- 116	  	Mens Jr Ltwt 2x
%- Sunday, Apr 29
%- 201	  	Womens Masters 2-
%- 202	  	Mens Masters 4+
2{ request(202, intermediate, BOAT) : fourplus(BOAT) }2.

%- 203	  	Mens Masters 1x
request(203, wade, dunya).
1{ request(203, jeff, BOAT) : lightweight_single(BOAT) }1.

%- 204	  	Mens Jr 8+
%- 205	  	Womens Jr 2-
%- 206	  	Womens Masters 4x
%- 207	  	Mens Jr Novice 4+
%- 208	  	Womens Jr Novice 8+
%- 209	  	Mens Masters 2-
%- 210	  	Mixed Masters 4x
1{ request(210, advanced_a, BOAT) : hv_or_mid_quad(BOAT) }1.
%- 211	  	Mens Jr Ltwt 4+
%- 212	  	Womens Masters 8+
%- 213	  	Mens Jr 2-
%- 214	  	Mens Masters 4x
1{ request(214, advanced_a, BOAT) : hv_or_mid_quad(BOAT) }1.
1{ request(214, intermediate_a, BOAT) : hv_or_mid_quad(BOAT) }1.
%- 215	  	Womens Jr Ltwt 4+
%- 216	  	Mens Jr Novice 8+
%- 217	  	Womens Masters 1x
1{ request(217, connie, BOAT) : lightweight_single(BOAT) }1.
1{ request(217, sue, BOAT) : lightweight_single(BOAT) }1.
%- 218	  	Mixed Adaptive 4x
%- 219	  	Womens Jr Novice 4+
%- 220	  	Mixed Masters 8+
1{ request(220, advanced, BOAT) : eight(BOAT) }1.
%- 221	  	Mens Masters 2x
%- 222	  	Womens Jr 4+
%- 223	  	Mens Jr Ltwt 8+
%- 224	  	Womens Masters 2x
1{ request(224, sarah, BOAT) : midweight_double(BOAT) }1.  % & veronica
1{ request(224, mari, BOAT) : lightweight_double(BOAT) }1. % & feesh

%- 225	  	Mixed Adaptive 2x
%- 226	  	Mens Jr 4+
%- 227	  	Womens Jr Ltwt 8+
%- 228	  	Mens Masters 8+
%- 229	  	Mixed Masters 2x
1{ request(229, jeff, BOAT) : midweight_double(BOAT) }1.  % & connie_h
1{ request(229, ken, BOAT) : heavy_double(BOAT) }1.  % & connie_a
:- reserve(229, ken, maas).  % No way that Ken gets the maas.
%- 230	  	Womens Masters 4+
%- 231	  	Womens Jr 8+


%%% ========================================================== %%%
%% The actual scheduling algorithm. Short and simple, huh?
%% DO NOT MODIFY ANYTHING BELOW THIS LINE!
%% (unless you really, really know what you're doing, and
%% you probably don't.  Just write me with questions, requests.
%%% ========================================================== %%%

% A boat is available if its not in use by any crew.
available(RACE, BOAT) :- racenum(RACE), crew(CREW), boat(BOAT),
                         not inuse(RACE, CREW, BOAT).

% Reserve the boat if it is requested and available.
reserve(RACE, CREW, BOAT) :- racenum(RACE), crew(CREW), boat(BOAT),
                             request(RACE, CREW, BOAT), 
                             available(RACE, BOAT).

% A boat will be in use for the next CENTER races if it is reserved.
inuse(ONWATER, CREW, BOAT) :- racenum(RACE), crew(CREW), boat(BOAT),
                              reserve(RACE, CREW, BOAT), 
                              ONWATER = RACE + N,
                              N = 1..CENTER,
                              center(CENTER).

% Cannot reserve a boat that is in use.
:- reserve(RACE, CREW, BOAT), inuse(RACE, OTHER_CREW, BOAT),
   racenum(RACE), crew(CREW), crew(OTHER_CREW), boat(BOAT). 

% Cannot request a boat if its in use.
% This rule isn't needed right now, comment it out. 
% :- request(RACE, CREW, BOAT), inuse(RACE, OTHER_CREW, BOAT).

% Two different crews cannot reserve same boat for the same race.
:- reserve(RACE, CREW, BOAT), reserve(RACE, OTHER_CREW, BOAT),
   CREW != OTHER_CREW,
   racenum(RACE), crew(CREW), crew(OTHER_CREW), boat(BOAT). 

% ----------------------
% Useful info.

% True is boat will be hotseated at the dock.
hotseat(RACE, BOAT) :- reserve(RACE, CREW, BOAT), 
                       reserve(RACE-CENTER-1, OTHER_CREW, BOAT),
                       center(CENTER).

% True if crew should hurry back because boat is needed.
hurry_back(RACE, CREW, BOAT) :- reserve(RACE, CREW, BOAT), 
                       reserve(RACE+CENTER+1, OTHER_CREW, BOAT),
                       center(CENTER).

% Minimize the number of boats that are hot-seated.
#minimize [hotseat(RACE, BOAT)].


#hide.
#show reserve/3.
#show hotseat/2.
#show hurry_back/3.
% #show request/2.
% #show inuse/2.
% #show available/2.
