%
% regatta team equipment scheduling
%
% The problem of scheduling equipment for a regatta is a constraint
% problem -- two crews cannot use the same boat at the same time,
% and, indeed, there must be enough time between crews to rig the boat,
% launch it, warm up, race, and return to the dock, before the next
% crew can use it.  Because this is a classic constraint problem,
% implementing this via answer-set programming seems like the easiest,
% most direct way to accomplish this.
%
% Initial version: Linas Vepstas April 2012 
%
% Copyright (c) 2012 Linas Vepstas
% The GNU GPLv3 applies.
%

% -- List of boat classes.  Can add new boat classes here, as desired.
boat(BOAT) :- heavy_quad(BOAT).
boat(BOAT) :- midweight_quad(BOAT).
boat(BOAT) :- lightweight_quad(BOAT).
boat(BOAT) :- double(BOAT).
boat(BOAT) :- single(BOAT).

% --- Generic boat classes. Can add new classes here, as desired.
% For example, a "mid or heavy" class might be useful.
any_quad(BOAT) :- heavy_quad(BOAT).
any_quad(BOAT) :- midweight_quad(BOAT).
any_quad(BOAT) :- lightweight_quad(BOAT).

% --- Describe the boats, according to boat class.
heavy_quad(orange).
heavy_quad(black).
heavy_quad(revere).
midweight_quad(green).
lightweight_quad(red).

double(barks).
double(gluten).
single(director).
single(cantu).

% --- Describe crew types.
crew(juniors).
crew(advanced).
crew(intermediate).
crew(matt).

% -- List the races
racenum(NUM) :- NUM=101..140.   % Saturday.
racenum(NUM) :- NUM=201..229.   % Sunday.

% --- Specify minimum number of races between equipment reuse.
% In this case, the boat cannot be reserved for the next 4 races.
center(4).
% Print a hotseat warning if there is just 1 center to get the boat
% back to the dock.  Change to 2 if you want more hotseat warning
% printed.
hotseat_warn(1).

% --- Restrictions.
% Juniors are never allowed to take out the black quad.
:- request(RACE, juniors, black).

% List boat requests.
% Advanced crew wants one quad, any heavy-weight quad, for race 201
1{ request(201, advanced, BOAT) : heavy_quad(BOAT) }1.

% Matt must have his black boat for the same race.
request(201, matt, black).

% Intermediate crew wants one quad, any quad, for race 201
1{ request(202, intermediate, BOAT) : any_quad(BOAT) }1.

% Juniors want 2 quads for race 206
2{ request(206, juniors, BOAT) : any_quad(BOAT) }2.


%%% ========================== %%%
%% The actual scheduling algorithm.
%%% ========================== %%%

#include " solver.asp ".

