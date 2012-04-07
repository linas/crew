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

quads(orange; black).
doubles(barks; gluten).
singles(director; cantu).

boats(BOAT) :- quads(BOAT).
boats(BOAT) :- doubles(BOAT).
boats(BOAT) :- singles(BOAT).

race(201, BOAT) :- quads(BOAT).
race(202, BOAT) :- quads(BOAT).
race(206, BOAT) :- quads(BOAT).

racenum(NUM) :- NUM=201..229.

inuse(RACE, BOAT) :- equip(ONWAT, BOAT), boats(BOAT), racenum(RACE), ONWAT=RACE-1.

equip(RACENUM, BOAT) :- boats(BOAT), race(RACENUM, BOAT).
:- equip(RACE, BOAT), inuse(RACE, BOAT). 

#hide.
#show equip/2.
