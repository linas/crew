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
% quad(black).
% doubles(barks; gluten).
% singles(director; cantu).

boat(BOAT) :- quad(BOAT).
% boat(BOAT) :- doubles(BOAT).
% boat(BOAT) :- singles(BOAT).

race(201, BOAT) :- quad(BOAT).
race(202, BOAT) :- quad(BOAT).
race(206, BOAT) :- quad(BOAT).

racenum(NUM) :- NUM=201..229.

inuse(RACE, BOAT) :- equip(ONWATER, BOAT), boat(BOAT), 
                     racenum(RACE), ONWATER=RACE-1.

equip(RACENUM, BOAT) :- boat(BOAT), race(RACENUM, BOAT).
unavailable(RACE, BOAT) :- equip(RACE, BOAT), inuse(RACE, BOAT). 

:- unavailable(RACE, BOAT).

#hide.
#show equip/2.
#show inuse/2.
#show unavailable/2.
