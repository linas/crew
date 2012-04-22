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

% -- List of boat classes.
#include "trc_boats.asp".
#include "trc_oars.asp".

% -- Special boats for this race.
pair(borrowed_pair).
fourplus(borrowed_four).

boat(BOAT) :- double(BOAT).
double(private_double).

% No one is going to race the maas.
:- request(RACE, CREW, maas), racenum(RACE), crew(CREW).

% --- Name the rowers.
rower(bolton).
rower(connie_a).
rower(connie_h).
rower(cullicott).
rower(ellis).
rower(feicht).
rower(gates).
rower(jeff).
rower(linas).
rower(lynch).
rower(mari).
rower(matt).
rower(oppliger).
rower(sarah).
rower(sue).

% --- Describe crew types.
crew(PERSON) :- rower(PERSON).
crew(juniors).
crew(juniors_a).
crew(juniors_b).
crew(juniors_c).
crew(juniors_d).
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
crew(novice).

% --- List the races
racenum(NUM) :- NUM=101..116.   % Saturday.
racenum(NUM) :- NUM=201..231.   % Sunday.

% --- Specify minimum number of races between equipment reuse.
% In this case, the boat cannot be reserved for the previous 2 races.
center(2).
% Print a hotseat warning if there is just 1 center to get the boat
% back to the dock.  Change to 2 if you want more hotseat warning 
% printed.
hotseat_warn(2).

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
% 1{ request(202, intermediate, BOAT) : fourplus(BOAT) }1.
request(202, intermediate, beverly).

%- 203	  	Mens Masters 1x
% 1{ request(203, bolton, BOAT) : any_single(BOAT) }1.
% Ellis has own, private boat, not assigning.
% 1{ request(203, ellis, BOAT) : any_single(BOAT) }1.
1{ request(203, feicht, BOAT) : any_single(BOAT) }1.
1{ request(203, gates, BOAT) : heavy_single(BOAT) }1.
1{ request(203, jeff, BOAT) : lightweight_single(BOAT) }1.
% Lynch has own private boat, we're not assigning...
% 1{ request(203, lynch, BOAT) : any_single(BOAT) }1.
prefer(203, oppliger, dunya, 1).

%- 204	  	Mens Jr 8+
request(204, juniors, sophie).
oar_prefer(204, juniors, purple, 1).

%- 205	  	Womens Jr 2-
request(205, juniors_a, thrash).
request(205, juniors_b, 30).
request(205, juniors_c, borrowed_pair).
%- 206	  	Womens Masters 4x
1{ request(206, advanced_a, BOAT) : lt_or_mid_quad(BOAT) }1.
1{ request(206, advanced_b, BOAT) : lt_or_mid_quad(BOAT) }1.
1{ request(206, advanced_c, BOAT) : lt_or_mid_quad(BOAT) }1.
1{ request(206, intermediate, BOAT) : lt_or_mid_quad(BOAT) }1.
%- 207	  	Mens Jr Novice 4+
request(207, juniors, judie).
%- 208	  	Womens Jr Novice 8+
request(208, juniors, sophie).
%- 209	  	Mens Masters 2-
%- 210	  	Mixed Masters 4x
% 1{ request(210, advanced_a, BOAT) : heavy_quad(BOAT) }1.
request(210, connie_h, masters).  % connie, sue, jeff, linas
3{ request(210, intermediate, BOAT) : any_quad(BOAT) }3.
request(210, novice, blue).
%- 211	  	Mens Jr Ltwt 4+
%- 212	  	Womens Masters 8+
1{request(212, intermediate, BOAT) : eight(BOAT) }1.
%- 213	  	Mens Jr 2-
request(213, juniors, 30).
%- 214	  	Mens Masters 4x
% 1{ request(214, advanced_a, BOAT) : hv_or_mid_quad(BOAT) }1.
% 1{ request(214, intermediate_a, BOAT) : hv_or_mid_quad(BOAT) }1.
request(214, matt, black).
request(214, advanced, orange).
%- 215	  	Womens Jr Ltwt 4+
request(215, juniors_a, judie).
request(215, juniors_b, borrowed_four).
%- 216	  	Mens Jr Novice 8+
request(216, juniors, sophie).
%- 217	  	Womens Masters 1x
1{ request(217, connie_h, BOAT) : lightweight_single(BOAT) }1.
1{ request(217, sue, BOAT) : lightweight_single(BOAT) }1.
%- 218	  	Mixed Adaptive 4x
%- 219	  	Womens Jr Novice 4+
3{ request(219, juniors, BOAT) : fourplus(BOAT) }3.
%- 220	  	Mixed Masters 8+
% 1{ request(220, advanced, BOAT) : eight(BOAT) }1.
request(220, advanced, sophie).
%- 221	  	Mens Masters 2x
request(221, linas, private_double). % linas and phil
1{ request(221, advanced_a, BOAT) : hv_or_mid_double(BOAT) }1. % ted
1{ request(221, advanced_b, BOAT) : hv_or_mid_double(BOAT) }1. % ted
% 1{ request(221, novice, BOAT) : any_double(BOAT) }1. % saloni
request(221, novice, jakob). % saloni

%- 222	  	Womens Jr 4+
% XXXX this is a hotseat problem!!
2{ request(222, juniors, BOAT) : fourplus(BOAT) }2.
%- 223	  	Mens Jr Ltwt 8+
%- 224	  	Womens Masters 2x
% 1{ request(224, sarah, BOAT) : midweight_double(BOAT) }1.  % & veronica
% 1{ request(224, mari, BOAT) : lightweight_double(BOAT) }1. % & feesh

request(224, sarah, swinford).  % & veronica
request(224, mari, thrash). % & feesh
2{ request(224, intermediate, BOAT) : any_double(BOAT) }2.

%- 225	  	Mixed Adaptive 2x
%- 226	  	Mens Jr 4+
%- 227	  	Womens Jr Ltwt 8+
%- 228	  	Mens Masters 8+
%- 229	  	Mixed Masters 2x
1{ request(229, jeff, BOAT) : midweight_double(BOAT) }1.  % & connie_h
1{ request(229, gates, BOAT) : heavy_double(BOAT) }1.  % & connie_a
:- reserve(229, gates, maas).  % No way that Ken gets the maas.
%- 230	  	Womens Masters 4+
2{ request(230, intermediate, BOAT) : fourplus(BOAT) }2.
%- 231	  	Womens Jr 8+


%%% ========================== %%%
%% The actual scheduling algorithm.
%%% ========================== %%%

#include "solver.asp".
#include "oar_solver.asp" .

% Every boat reservation must have an oar reservation
oar_request(RACE, CREW, OARS) :- reserve(RACE,CREW,BOAT), oars(OARS).

