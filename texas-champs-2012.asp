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
double(private_double).  % Phil's from Dallas
double(empacher).  % private
single(private_bolton).
single(private_cullicott).
single(private_ellis).
single(private_lynch).
scull_oars(private_oars_sue, 1).

% No one is going to race the maas.
:- request(RACE, CREW, maas), racenum(RACE), crew(CREW).

% --- Name the rowers.
rower(adams).     % Connie Adams
rower(bolton).    % Scott Bolton
rower(brennan).   % Rober Brennan
rower(cullicott). % John Collicott
rower(ellis).     % Phil Ellis
rower(feicht).    % Doug Feicht
rower(gates).     % Ken Gates
rower(hicks).     % Connie Hicks
rower(jeff).
rower(knifton).   % Matt Knifton
rower(lynch).     % Robb Lynch
rower(mari).
rower(mast).      % Steve Mast  (Intermediate crew)
rower(nicot).     % JP Nicot
rower(oppliger).  % Wade Oppliger
rower(sarah).
rower(sue).
rower(scheer).    % Veronica Scheer
rower(smith).     % Bill Smith  (Saloni's Crew).
rower(vepstas).   % Linas Vepstas
rower(wolf).      % Bettina Wolf

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
center(3).
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
request(203, bolton, private_bolton).
request(203, cullicott, private_cullicott).
request(203, ellis, private_ellis).
request(203, lynch, private_lynch).

1{ request(203, brennan, BOAT) : any_single(BOAT) }1.

1{ request(203, feicht, BOAT) : heavy_single(BOAT) }1.
oar_prefer(203, feicht, yellow_purple, 1).

prefer(203, gates, dunya, 1).
oar_prefer(203, gates, blue_blue, 1).

1{ request(203, jeff, BOAT) : lightweight_single(BOAT) }1.
oar_prefer(203, jeff, yellow_purple, 1).

1{ request(203, mast, BOAT) : midweight_single(BOAT) }1.
1{ request(203, nicot, BOAT) : any_single(BOAT) }1.

1{ request(203, oppliger, BOAT) : heavy_single(BOAT) }1.
oar_prefer(203, oppliger, yellow_purple, 1).

1{ request(203, smith, BOAT) : any_single(BOAT) }1.

%- 204	  	Mens Jr 8+
request(204, juniors, sophie).
oar_prefer(204, juniors, purple, 1).

%- 205	  	Womens Jr 2-
request(205, juniors_a, thrash).
oar_prefer(205, juniors_a, pair, 1).

request(205, juniors_b, 30).
oar_prefer(205, juniors_b, blue, 1).

request(205, juniors_c, borrowed_pair).
oar_prefer(205, juniors_c, blue, 1).

%- 206	  	Womens Masters 4x
1{ request(206, advanced_a, BOAT) : lt_or_mid_quad(BOAT) }1.
1{ request(206, intermediate, BOAT) : lt_or_mid_quad(BOAT) }1.

% racenum(206.2).
1{ request(206, wolf, BOAT) : lt_or_mid_quad(BOAT) }1.  % 206.2
oar_prefer(206, wolf, purple_red, 1).

% greyhounds
prefer(206, hicks, blue, 1).
oar_prefer(206, hicks, yellow_purple, 1).

%- 207	  	Mens Jr Novice 4+
% XXX got an oar hotseating problem here.
request(207, juniors_a, judie).
oar_prefer(207, juniors_a, wood, 1).

request(207, juniors_b, borrowed_four).
oar_prefer(207, juniors_b, orange, 1).

%- 208	  	Womens Jr Novice 8+
request(208, juniors, sophie).
oar_prefer(208, juniors, purple, 1).

%- 209	  	Mens Masters 2-
%- 210	  	Mixed Masters 4x
request(210, hicks, masters).  % connie, sue, jeff, linas
oar_prefer(210, hicks, yellow_purple, 1).

% 3{ request(210, intermediate, BOAT) : any_quad(BOAT) }3.
request(210, intermediate_a, orange).
request(210, intermediate_b, mcdarmid).
request(210, intermediate_c, green).

request(210, novice, blue).

%- 211	  	Mens Jr Ltwt 4+
%- 212	  	Womens Masters 8+
1{request(212, intermediate, BOAT) : eight(BOAT) }1.

%- 213	  	Mens Jr 2-
request(213, juniors, 30).
oar_prefer(213, juniors, pair, 1).

%- 214	  	Mens Masters 4x
% 1{ request(214, advanced_a, BOAT) : hv_or_mid_quad(BOAT) }1.
% 1{ request(214, intermediate_a, BOAT) : hv_or_mid_quad(BOAT) }1.
request(214, knifton, black).
oar_prefer(214, knifton, blue_blue, 1).

request(214, advanced, orange).
oar_prefer(214, advanced, purple_green, 1).

%- 215	  	Womens Jr Ltwt 4+
request(215, juniors_a, judie).
oar_prefer(215, juniors_a, blue, 1).

request(215, juniors_b, borrowed_four).
oar_prefer(215, juniors_b, blue, 1).

%- 216	  	Mens Jr Novice 8+
request(216, juniors, sophie).
oar_prefer(216, juniors, purple, 1).

%- 217	  	Womens Masters 1x
1{ request(217, hicks, BOAT) : lightweight_single(BOAT) }1.

% 1{ request(217, sue, BOAT) : lightweight_single(BOAT) }1.
prefer(217, sue, somers, 1).
oar_prefer(217, sue, private_oars_sue, 1).

%- 218	  	Mixed Adaptive 4x
%- 219	  	Womens Jr Novice 4+
% 3{ request(219, juniors, BOAT) : fourplus(BOAT) }3.
request(219, juniors_a, judie).
oar_prefer(219, juniors_a, blue, 1).

request(219, juniors_b, borrowed_four).
oar_prefer(219, juniors_b, blue, 1).

request(219, juniors_c, beverly).
oar_prefer(219, juniors_c, orange, 1).

%- 220	  	Mixed Masters 8+
% 1{ request(220, advanced, BOAT) : eight(BOAT) }1.
request(220, advanced, sophie).
oar_prefer(220, advanced, purple, 1).

%- 221	  	Mens Masters 2x
request(221, vepstas, private_double). % linas and phil

request(221, knifton, empacher). % ken and matt
oar_prefer(221, knifton, blue_blue, 1).

request(221, lynch, bass).  % robb and phil

1{ request(221, advanced_a, BOAT) : hv_or_mid_double(BOAT) }1. % ted

% 1{ request(221, novice, BOAT) : any_double(BOAT) }1. % saloni
request(221, novice, jakob). % saloni

%- 222	  	Womens Jr 4+
% XXXX this is a hotseat problem!!
% 2{ request(222, juniors, BOAT) : fourplus(BOAT) }2.

request(222, juniors_a, judie).
oar_prefer(222, juniors_a, blue, 1).

request(222, juniors_b, borrowed_four).
oar_prefer(222, juniors_b, blue, 1).

%- 223	  	Mens Jr Ltwt 8+
%- 224	  	Womens Masters 2x

request(224, sarah, swinford).  % & veronica
oar_prefer(224, sarah, red_red, 1).

request(224, scheer, thrash). % & feesh
oar_prefer(224, scheer, red_red, 1).

% the other double will be the 41 re-rigged
% 2{ request(224, intermediate, BOAT) : any_double(BOAT) }2.
1{ request(224, intermediate, BOAT) : any_double(BOAT) }1.
request(224, intermediate_a, bass).

%- 225	  	Mixed Adaptive 2x
%- 226	  	Mens Jr 4+
%- 227	  	Womens Jr Ltwt 8+
%- 228	  	Mens Masters 8+
%- 229	  	Mixed Masters 2x
% 1{ request(229, jeff, BOAT) : midweight_double(BOAT) }1.  % & connie h
prefer(229, hicks, thrash, 1).
prefer(229, hicks, swinford, 2).
oar_prefer(229, hicks, yellow_purple, 1).

% 1{ request(229, gates, BOAT) : heavy_double(BOAT) }1.  % & connie a
request(229, gates, barksdale).  % with adams
oar_prefer(229, gates, blue_blue, 1).

%- 230	  	Womens Masters 4+
% 2{ request(230, intermediate, BOAT) : fourplus(BOAT) }2.
request(230, intermediate_a, beverly).
oar_prefer(230, intermediate_a, blue, 1).

request(230, intermediate_b, borrowed_four).
oar_prefer(230, intermediate_b, wood, 1).

%- 231	  	Womens Jr 8+
request(231, juniors, sophie).
oar_prefer(231, juniors, purple, 1).


%%% ========================== %%%
%% The actual scheduling algorithm.
%%% ========================== %%%

#include "solver.asp".
#include "oar_solver.asp" .

