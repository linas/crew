%
% crew equipment scheduling
%
% The problem of scheduling equipment for a regatta is a constraint
% problem -- ttwo crews canot use the same boat at the same time,
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

% List the races
racenum(NUM) :- NUM=201..229.

% Specify minimum number of races between equipment reuse.
center(4).

% List boat classes.  Can add new boat classes here, if needed.
boat(BOAT) :- quad(BOAT).
boat(BOAT) :- lightweight_quad(BOAT).
boat(BOAT) :- double(BOAT).
boat(BOAT) :- single(BOAT).

% Describe the boats, according to boat class.
quad(orange).
quad(black).
quad(red).
lightweight_quad(green).

% Generic boat classes.
any_quad(BOAT) :- quad(BOAT).
any_quad(BOAT) :- lightweight_quad(BOAT).

double(barks).
double(gluten).
single(director).
single(cantu).

% Describe crew types.
crew(juniors).
crew(advanced).
crew(intermediate).
crew(matt).

% Restrictions. Juniors are never allowed to take out the black quad.
:- request(RACE, juniors, black), racenum(RACE).

% List boat requests.
% advanced crew wants one quad, any quad, for race 201
1{ request(201, advanced, BOAT) : quad(BOAT) }1.

% matt must have his black boat for this race.
request(201, matt, black).

% intermediate crew wants one quad, any quad, for race 201
1{ request(202, intermediate, BOAT) : quad(BOAT) }1.

% Juniors want 2 quads for race 206
2{ request(206, juniors, BOAT) : any_quad(BOAT) }2.


%%% ========================================================== %%%
%% The actual scheduling algorithm. Short and simple, huh?

% A boat is available if its not inuse.
available(RACE, BOAT) :- boat(BOAT), racenum(RACE), 
                         not inuse(RACE, BOAT).

% Reserve the boat if it is available.
reserve(RACE, CREW, BOAT) :- request(RACE, CREW, BOAT), 
                     available(RACE, BOAT).

% A boat will be in use if its reserved, and for the next CENTER races.
inuse(ONWATER, BOAT) :- reserve(RACE, CREW, BOAT), 
                        crew(CREW),
                        boat(BOAT),
                        racenum(RACE),
                        ONWATER = RACE + N,
                        N = 1..CENTER,
                        center(CENTER).

% Cannot reserve a boat that is in use.
:- reserve(RACE, CREW, BOAT), inuse(RACE, BOAT). 

% Cannot request a boat if its in use.
:- request(RACE, CREW, BOAT), inuse(RACE, BOAT), racenum(RACE), boat(BOAT).

% Two different crews cannot use the same boat in the same race
XXXX borken....
req(RACE, BOAT) :- request(RACE, CREW, BOAT).
:- req(RACE, BOAT), inuse(RACE, BOAT), racenum(RACE), boat(BOAT).


#hide.
#show reserve/3.
% #show request/2.
% #show inuse/2.
% #show available/2.
