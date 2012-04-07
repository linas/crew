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

double(barks).
double(gluten).
single(director).
single(cantu).

crew(juniors).

% Generate possibilities
1{ request(201, CREW, BOAT) : quad(BOAT): crew(CREW) }1.
1{ request(202, CREW, BOAT) : quad(BOAT): crew(CREW) }1.
1{ request(206, CREW, BOAT) : quad(BOAT): crew(CREW) }1.

racenum(NUM) :- NUM=201..229.

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

#hide.
#show reserve/3.
% #show request/2.
% #show inuse/2.
% #show available/2.
