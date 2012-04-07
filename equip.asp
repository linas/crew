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

1{ needed_for_race(201, BOAT) : quad(BOAT) }1.
1{ needed_for_race(202, BOAT) : quad(BOAT) }1.
1{ needed_for_race(206, BOAT) : quad(BOAT) }1.

racenum(NUM) :- NUM=201..229.

available(RACE, BOAT) :- boat(BOAT), racenum(RACE), 
                         not inuse(RACE, BOAT).

reserve(RACE, BOAT) :- needed_for_race(RACE, BOAT), 
                     available(RACE, BOAT).

inuse(RACE, BOAT) :- reserve(ONWATER, BOAT), boat(BOAT), 
                     racenum(RACE), ONWATER=RACE-1.


unavailable(RACE, BOAT) :- reserve(RACE, BOAT), inuse(RACE, BOAT). 

:- unavailable(RACE, BOAT).

:- needed_for_race(RACE,BOAT), racenum(RACE), boat(BOAT), inuse(RACE, BOAT).

#hide.
#show reserve/2.
#show needed_for_race/2.
#show inuse/2.
% #show available/2.
