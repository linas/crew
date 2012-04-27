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
quad(BOAT) :- heavy_quad(BOAT).
quad(BOAT) :- midweight_quad(BOAT).
quad(BOAT) :- lightweight_quad(BOAT).

% --- Generic boat classes. Can add new classes here, as desired.
% For example, a "mid or light" class might be useful.
mid_or_hv_quad(BOAT) :- midweight_quad(BOAT).
mid_or_hv_quad(BOAT) :- heavy_quad(BOAT).

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

pair(thrash).
fourplus(beverley).
fourminus(marty).
eight(sophie).

% --- Describe crew types.
crew(juniors_a).
crew(juniors_b).
crew(advanced).
crew(intermediate).
crew(matt).

% -- List the races
racenum(NUM) :- NUM=101..140.   % Saturday.
racenum(NUM) :- NUM=201..229.   % Sunday.

% -- used for inserting heats into events.  See other examples
% for details.
heat(NUM, NUM) :- racenum(NUM).

% --- Specify minimum number of races between equipment reuse.
% In this case, the boat cannot be reserved for the previous 4 races.
center(4).
% Print a hotseat warning if there is just 1 center to get the boat
% back to the dock.  Change to 2 if you want more hotseat warnings
% printed.
hotseat_warn(1).

% --- Restrictions.
% Juniors are never allowed to take out the black quad.
:- request(RACE, juniors_a, black).
:- request(RACE, juniors_b, black).

% List boat requests.
% For race 201, advanced crew wants one quad, any heavy-weight quad.
1{ request(201, advanced, BOAT) : heavy_quad(BOAT) }1.

% Matt must have his black boat for the same race. 
% This is not a request, this is a reservation. No if's, and's or but's.
reserve(201, matt, black).

% For race 202, the intermediate crew is going to be picky: they 
% want the black quad, and if they can't get it, then they want
% the green, and if they can't get that, they want the orange.
% Of course, they won't get it (because matt's got it, above),
% but they can certainly ask for it... they'll get their second
% choice.
prefer(202, intermediate, black, 1).
prefer(202, intermediate, green, 2).
prefer(202, intermediate, orange, 3).

% For race 203, the intermediate crew wants the black boat. But of course
% they can't have it, since matt is using it (see above). So, the request
% below will result in a reservation failure.  This will be printed in
% the output.  The would get a boat, if they made a second & third choice,
% but they didn't, so they won't.
prefer(203, intermediate, black, 1).

% For race 206, juniors want 2 quads, any two mid or heavyweights will do.
1{ request(206, juniors_a, BOAT) : mid_or_hv_quad(BOAT) }1.
1{ request(206, juniors_b, BOAT) : mid_or_hv_quad(BOAT) }1.


%%% ========================== %%%
%% The actual scheduling algorithm.
%%% ========================== %%%

#include "solver.asp".
