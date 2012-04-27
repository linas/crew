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
racenum(NUM) :- heat(CENTER, NUM).

% Number on the left is just a linear ordering of the events,
% including heats.  The numbers on the left must increase by one
% (they indicate time; leave gaps for breaks!)  The numbers on
% the right are race numbers, e.g. 202.1  unfortuantely, we can't
% write it like that, so instead we write r202h1. Yuck.
% unfortunately, there is no easy way of managine this list, yet.
% Maybe we'll fix this someday...
heat(501, r201).
heat(502, r202).
heat(503, "102.2").
heat(504, r203h1).
heat(505, r203h2).
heat(506, r203h3).
heat(507, r204).
heat(508, r205).
heat(509, gap).
heat(510, r206h1).
heat(511, r206h2).
heat(512, r207).
heat(513, r208).
heat(514, r209).
heat(515, gap).
heat(516, r210h1).
heat(517, r210h2).
heat(518, r212).
heat(519, r213).
heat(520, r214).
heat(521, r215).
heat(522, r216).
heat(523, r217h1).
heat(524, r217h2).
heat(525, gap).
heat(526, r219).
heat(527, r220h1).
heat(528, r220h2).
heat(529, r221h1).
heat(530, r221h2).
heat(531, r222).
heat(532, gap).
heat(533, r224h1).
heat(534, r224h2).
heat(535, r225).
heat(536, r228).
heat(537, r229).
heat(538, r230h1).
heat(539, r230h2).
heat(540, r231).

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
%- r201	  	Womens Masters 2-
%- r202	  	Mens Masters 4+
% 1{ request(r202, intermediate, BOAT) : fourplus(BOAT) }1.
request(r202, intermediate, beverly).

%- r203	  	Mens Masters 1x
request(r203h1, bolton, private_bolton).
request(r203h2, cullicott, private_cullicott).
1{ request(r203h2, mast, BOAT) : midweight_single(BOAT) }1.
1{ request(r203h2, smith, BOAT) : any_single(BOAT) }1.

request(r203h3, ellis, private_ellis).
request(r203h3, lynch, private_lynch).

1{ request(r203h3, brennan, BOAT) : any_single(BOAT) }1.

1{ request(r203h3, feicht, BOAT) : heavy_single(BOAT) }1.
oar_prefer(r203h3, feicht, yellow_purple, 1).

prefer(r203h3, gates, dunya, 1).
oar_prefer(r203h3, gates, blue_blue, 1).

1{ request(r203h3, nicot, BOAT) : any_single(BOAT) }1.

1{ request(r203h3, oppliger, BOAT) : heavy_single(BOAT) }1.
oar_prefer(r203h3, oppliger, yellow_purple, 1).

% XXX did jeff scratch?
1{ request(r203h3, crawford, BOAT) : lightweight_single(BOAT) }1.
oar_prefer(r203h3, crawford, yellow_purple, 1).


%- r204	  	Mens Jr 8+
request(r204, juniors, sophie).
oar_prefer(r204, juniors, purple, 1).

%- r205	  	Womens Jr 2-
request(r205, juniors_a, thrash).
oar_prefer(r205, juniors_a, pair, 1).

request(r205, juniors_b, 30).
oar_prefer(r205, juniors_b, blue, 1).

request(r205, juniors_c, borrowed_pair).
oar_prefer(r205, juniors_c, blue, 1).

%- r206	  	Womens Masters 4x
1{ request(r206h1, daniels, BOAT) : lt_or_mid_quad(BOAT) }1.

% racenum(r206h2).
% 1{ request(r206h2, intermediate, BOAT) : lt_or_mid_quad(BOAT) }1.
request(r206h2, intermediate, green).

1{ request(r206h2, wolf, BOAT) : lt_or_mid_quad(BOAT) }1.  % r206.2
oar_prefer(r206h2, wolf, purple_red, 1).

% greyhounds
prefer(r206h2, hicks, blue, 1).
oar_prefer(r206h2, hicks, yellow_purple, 1).

%- r207	  	Mens Jr Novice 4+
% XXX got an oar hotseating problem here.
request(r207, juniors_a, judie).
oar_prefer(r207, juniors_a, wood, 1).

request(r207, juniors_b, borrowed_four).
oar_prefer(r207, juniors_b, orange, 1).

%- r208	  	Womens Jr Novice 8+
request(r208, juniors, sophie).
oar_prefer(r208, juniors, purple, 1).

%- r209	  	Mens Masters 2-
%- r210	  	Mixed Masters 4x

% 3{ request(r210, intermediate, BOAT) : any_quad(BOAT) }3.
request(r210h1, morey, orange).
request(r210h1, nicot, mcdarmid).
request(r210h1, intermediate_c, green).

request(r210h2, vepstas, masters).  % connie, sue, jeff, linas
oar_prefer(r210h2, vepstas, yellow_purple, 1).

request(r210h2, novice, blue).

%- r211	  	Mens Jr Ltwt 4+
%- r212	  	Womens Masters 8+
1{request(r212, intermediate, BOAT) : eight(BOAT) }1.

%- r213	  	Mens Jr 2-
request(r213, juniors, 30).
oar_prefer(r213, juniors, pair, 1).

%- r214	  	Mens Masters 4x
% 1{ request(r214, advanced_a, BOAT) : hv_or_mid_quad(BOAT) }1.
% 1{ request(r214, intermediate_a, BOAT) : hv_or_mid_quad(BOAT) }1.
request(r214, knifton, black).
oar_prefer(r214, knifton, blue_blue, 1).

request(r214, advanced, orange).
oar_prefer(r214, advanced, purple_green, 1).

%- r215	  	Womens Jr Ltwt 4+
request(r215, juniors_a, judie).
oar_prefer(r215, juniors_a, blue, 1).

request(r215, juniors_b, borrowed_four).
oar_prefer(r215, juniors_b, blue, 1).

%- r216	  	Mens Jr Novice 8+
request(r216, juniors, sophie).
oar_prefer(r216, juniors, purple, 1).

%- r217	  	Womens Masters 1x
1{ request(r217h1, intermediate, BOAT) : lightweight_single(BOAT) }1.

prefer(r217h2, carter, somers, 1).
oar_prefer(r217h2, carter, private_oars_sue, 1).

%- r218	  	Mixed Adaptive 4x
%- r219	  	Womens Jr Novice 4+
% 3{ request(r219, juniors, BOAT) : fourplus(BOAT) }3.
request(r219, juniors_a, judie).
oar_prefer(r219, juniors_a, blue, 1).

request(r219, juniors_b, borrowed_four).
oar_prefer(r219, juniors_b, blue, 1).

request(r219, juniors_c, beverly).
oar_prefer(r219, juniors_c, orange, 1).

%- r220	  	Mixed Masters 8+
request(r220h1, advanced, sophie).
oar_prefer(r220h1, advanced, purple, 1).

%- r221	  	Mens Masters 2x
request(r221h1, knifton, empacher). % ken and matt
oar_prefer(r221h1, knifton, blue_blue, 1).

request(r221h2, vepstas, private_double). % linas and phil
request(r221h2, lynch, bass).  % robb and phil

% XXX I guess this is scratched!?
% 1{ request(r221h2, advanced_b, BOAT) : hv_or_mid_double(BOAT) }1. % ted

request(r221h2, feicht, jakob). % saloni

%- r222	  	Womens Jr 4+
% XXXX this is a hotseat problem!!
request(r222, juniors_a, judie).
oar_prefer(r222, juniors_a, blue, 1).

request(r222, juniors_b, borrowed_four).
oar_prefer(r222, juniors_b, blue, 1).

%- r223	  	Mens Jr Ltwt 8+
%- r224	  	Womens Masters 2x

request(r224h1, daniels, swinford).  % & veronica
oar_prefer(r224h1, daniels, red_red, 1).

request(r224h1, intermediate_a, bass).

request(r224h1, scheer, thrash). % & mari (folco??)
oar_prefer(r224h1, scheer, red_red, 1).

% the other double will be the 41 re-rigged
1{ request(r224h2, intermediate, BOAT) : any_double(BOAT) }1.

%- r225	  	Mixed Adaptive 2x
%- r226	  	Mens Jr 4+
%- r227	  	Womens Jr Ltwt 8+
%- r228	  	Mens Masters 8+
%- r229	  	Mixed Masters 2x
prefer(r229, crawford, thrash, 1).   % connie_h
prefer(r229, crawford, swinford, 2).
oar_prefer(r229, crawford, yellow_purple, 1).

% 1{ request(r229, gates, BOAT) : heavy_double(BOAT) }1.  % & connie a
request(r229, gates, barksdale).  % with adams
oar_prefer(r229, gates, blue_blue, 1).

%- r230	  	Womens Masters 4+
request(r230h1, intermediate_c, borrowed_four).
oar_prefer(r230h1, intermediate_c, wood, 1).

request(r230h2, intermediate_a, beverly).
oar_prefer(r230h2, intermediate_a, blue, 1).

request(r230h2, intermediate_b, judie).
oar_prefer(r230h2, intermediate_b, blue, 1).

%- r231	  	Womens Jr 8+
request(r231, juniors, sophie).
oar_prefer(r231, juniors, purple, 1).


%%% ========================== %%%
%% The actual scheduling algorithm.
%%% ========================== %%%

#include "solver.asp".
#include "oar_solver.asp" .

