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
rower(carter).    % Sue Carter
rower(crawford).  % Jeff Crawford
rower(cullicott). % John Collicott
rower(daniels).   % Sarah Daniels
rower(ellis).     % Phil Ellis
rower(feicht).    % Doug Feicht
rower(gates).     % Ken Gates
rower(hicks).     % Connie Hicks
rower(knifton).   % Matt Knifton
rower(lynch).     % Robb Lynch
rower(mari).
rower(mast).      % Steve Mast  (Intermediate crew)
rower(morey).     % Justin Morey
rower(nicot).     % JP Nicot
rower(oppliger).  % Wade Oppliger
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
% racenum(NUM) :- NUM=101..116.   % Saturday.
% racenum(NUM) :- NUM=201..231.   % Sunday.

% Wow. Yuck. There's gotta be an easier way!
racenum(NUM) :- sched(CENTER, NUM).

sched(501, 201).
sched(502, 202).
sched(503, 203.1).
sched(504, 203.2).
sched(505, 203.3).
sched(506, 204).
sched(507, 205).
sched(508, 206.1).
sched(509, 206.2).
sched(510, 207).
sched(511, 208).
sched(512, 209).
sched(513, 210.1).
sched(514, 210.2).
sched(515, 212).
sched(516, 213).
sched(517, 214).
sched(518, 215).
sched(519, 216).
sched(520, 217.1).
sched(521, 217.2).
sched(522, 219).
sched(523, 220.1).
sched(524, 220.2).
sched(525, 221.1).
sched(526, 221.2).
sched(527, 222).
sched(528, 224.1).
sched(529, 224.2).
sched(530, 225).
sched(531, 228).
sched(532, 229).
sched(533, 230.1).
sched(534, 230.2).
sched(535, 231).

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
request(203.1, bolton, private_bolton).
request(203.2, cullicott, private_cullicott).
1{ request(203.2, mast, BOAT) : midweight_single(BOAT) }1.
1{ request(203.2, smith, BOAT) : any_single(BOAT) }1.

request(203.3, ellis, private_ellis).
request(203.3, lynch, private_lynch).

1{ request(203.3, brennan, BOAT) : any_single(BOAT) }1.

1{ request(203.3, feicht, BOAT) : heavy_single(BOAT) }1.
oar_prefer(203.3, feicht, yellow_purple, 1).

prefer(203.3, gates, dunya, 1).
oar_prefer(203.3, gates, blue_blue, 1).

1{ request(203.3, nicot, BOAT) : any_single(BOAT) }1.

1{ request(203.3, oppliger, BOAT) : heavy_single(BOAT) }1.
oar_prefer(203.3, oppliger, yellow_purple, 1).

% XXX did jeff scratch?
1{ request(203.3, crawford, BOAT) : lightweight_single(BOAT) }1.
oar_prefer(203.3, crawford, yellow_purple, 1).


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
1{ request(206.1, daniels, BOAT) : lt_or_mid_quad(BOAT) }1.

% racenum(206.2).
% 1{ request(206.2, intermediate, BOAT) : lt_or_mid_quad(BOAT) }1.
request(206.2, intermediate, green).

1{ request(206.2, wolf, BOAT) : lt_or_mid_quad(BOAT) }1.  % 206.2
oar_prefer(206.2, wolf, purple_red, 1).

% greyhounds
prefer(206.2, hicks, blue, 1).
oar_prefer(206.2, hicks, yellow_purple, 1).

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

% 3{ request(210, intermediate, BOAT) : any_quad(BOAT) }3.
request(210.1, morey, orange).
request(210.1, nicot, mcdarmid).
request(210.1, intermediate_c, green).

request(210.2, vepstas, masters).  % connie, sue, jeff, linas
oar_prefer(210.2, vepstas, yellow_purple, 1).

request(210.2, novice, blue).

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
1{ request(217.1, intermediate, BOAT) : lightweight_single(BOAT) }1.

prefer(217.2, carter, somers, 1).
oar_prefer(217.2, carter, private_oars_sue, 1).

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
request(220.1, advanced, sophie).
oar_prefer(220.1, advanced, purple, 1).

%- 221	  	Mens Masters 2x
request(221.1, knifton, empacher). % ken and matt
oar_prefer(221.1, knifton, blue_blue, 1).

request(221.2, vepstas, private_double). % linas and phil
request(221.2, lynch, bass).  % robb and phil

% XXX I guess this is scratched!?
% 1{ request(221.2, advanced_b, BOAT) : hv_or_mid_double(BOAT) }1. % ted

request(221.2, feicht, jakob). % saloni

%- 222	  	Womens Jr 4+
% XXXX this is a hotseat problem!!
request(222, juniors_a, judie).
oar_prefer(222, juniors_a, blue, 1).

request(222, juniors_b, borrowed_four).
oar_prefer(222, juniors_b, blue, 1).

%- 223	  	Mens Jr Ltwt 8+
%- 224	  	Womens Masters 2x

request(224.1, daniels, swinford).  % & veronica
oar_prefer(224.1, daniels, red_red, 1).

request(224.1, intermediate_a, bass).

request(224.1, scheer, thrash). % & mari (folco??)
oar_prefer(224.1, scheer, red_red, 1).

% the other double will be the 41 re-rigged
1{ request(224.2, intermediate, BOAT) : any_double(BOAT) }1.

%- 225	  	Mixed Adaptive 2x
%- 226	  	Mens Jr 4+
%- 227	  	Womens Jr Ltwt 8+
%- 228	  	Mens Masters 8+
%- 229	  	Mixed Masters 2x
prefer(229, crawford, thrash, 1).   % connie_h
prefer(229, crawford, swinford, 2).
oar_prefer(229, crawford, yellow_purple, 1).

% 1{ request(229, gates, BOAT) : heavy_double(BOAT) }1.  % & connie a
request(229, gates, barksdale).  % with adams
oar_prefer(229, gates, blue_blue, 1).

%- 230	  	Womens Masters 4+
request(230.1, intermediate_c, borrowed_four).
oar_prefer(230.1, intermediate_c, wood, 1).

request(230.2, intermediate_a, beverly).
oar_prefer(230.2, intermediate_a, blue, 1).

request(230.2, intermediate_b, judie).
oar_prefer(230.2, intermediate_b, blue, 1).

%- 231	  	Womens Jr 8+
request(231, juniors, sophie).
oar_prefer(231, juniors, purple, 1).


%%% ========================== %%%
%% The actual scheduling algorithm.
%%% ========================== %%%

#include "solver.asp".
#include "oar_solver.asp" .

