%
% regatta team equipment scheduling
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

% List the races
racenum(NUM) :- NUM=201..229.

% Specify minimum number of races between equipment reuse.
center(4).

% List boat classes.  Can add new boat classes here, if needed.
boat(BOAT) :- heavy_quad(BOAT).
boat(BOAT) :- midweight_quad(BOAT).
boat(BOAT) :- lightweight_quad(BOAT).
boat(BOAT) :- double(BOAT).
boat(BOAT) :- single(BOAT).

% Describe the boats, according to boat class.
heavy_quad(orange).
heavy_quad(black).
midweight_quad(green).
lightweight_quad(red).

% Generic boat classes.
any_quad(BOAT) :- heavy_quad(BOAT).
any_quad(BOAT) :- midweight_quad(BOAT).
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
1{ request(201, advanced, BOAT) : heavy_quad(BOAT) }1.

% matt must have his black boat for this race.
request(201, matt, black).

% intermediate crew wants one quad, any quad, for race 201
1{ request(202, intermediate, BOAT) : any_quad(BOAT) }1.

% Juniors want 2 quads for race 206
2{ request(206, juniors, BOAT) : any_quad(BOAT) }2.


%%% ========================================================== %%%
%% The actual scheduling algorithm. Short and simple, huh?
%% DO NOT MODIFY ANYTHING BELOW THIS LINE!
%% (unless you really, really know what you're doing, and
%% you probably don't.  Just write me with questions, requests.
%%% ========================================================== %%%

% A boat is available if its not in use by any crew.
available(RACE, BOAT) :- boat(BOAT), racenum(RACE), crew(CREW),
                         not inuse(RACE, CREW, BOAT).

% Reserve the boat if it is requested and available.
reserve(RACE, CREW, BOAT) :- request(RACE, CREW, BOAT), 
                             available(RACE, BOAT).

% A boat will be in use for the next CENTER races if it is reserved.
inuse(ONWATER, CREW, BOAT) :- reserve(RACE, CREW, BOAT), 
                              crew(CREW),
                              boat(BOAT),
                              racenum(RACE),
                              ONWATER = RACE + N,
                              N = 1..CENTER,
                              center(CENTER).

% Cannot reserve a boat that is in use.
:- reserve(RACE, CREW, BOAT), inuse(RACE, OTHER_CREW, BOAT). 

% Cannot request a boat if its in use.
% This rule isn't needed right now, comment it out. 
% :- request(RACE, CREW, BOAT), inuse(RACE, OTHER_CREW, BOAT).

% Two different crews cannot reserve same boat.
:- reserve(RACE, CREW, BOAT), reserve(RACE, OTHER_CREW, BOAT),
   CREW != OTHER_CREW.

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

#hide.
#show reserve/3.
#show hotseat/2.
#show hurry_back/3.
% #show request/2.
% #show inuse/2.
% #show available/2.
