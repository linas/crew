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

% min number of racees betwen equipment reuse.
center(4).

quad(orange).
quad(black).
% doubles(barks; gluten).
% singles(director; cantu).

boat(BOAT) :- quad(BOAT).
% boat(BOAT) :- doubles(BOAT).
% boat(BOAT) :- singles(BOAT).

% Generate possibilities
1{ request(201, BOAT) : quad(BOAT) }1.
1{ request(202, BOAT) : quad(BOAT) }1.
1{ request(206, BOAT) : quad(BOAT) }1.

racenum(NUM) :- NUM=201..229.

% A boat is available if its not inuse.
available(RACE, BOAT) :- boat(BOAT), racenum(RACE), 
                         not inuse(RACE, BOAT).

% Reserve the boat if it is available.
reserve(RACE, BOAT) :- request(RACE, BOAT), 
                     available(RACE, BOAT).

% A boat will be in use if its reserved, and for the next CENTER races.
inuse(ONWATER, BOAT) :- reserve(RACE, BOAT), 
                        boat(BOAT),
                        racenum(RACE),
                        ONWATER = RACE + N,
                        N = 1..CENTER,
                        center(CENTER).

% Cannot reserve a boat that is in use.
:- reserve(RACE, BOAT), inuse(RACE, BOAT). 

% Cannot request a boat if its in use.
:- request(RACE,BOAT), inuse(RACE, BOAT), racenum(RACE), boat(BOAT).

#hide.
#show reserve/2.
% #show request/2.
% #show inuse/2.
% #show available/2.
