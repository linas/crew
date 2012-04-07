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

boats(quads; doubles; eights).
race(201).

equip(RACENUM, BOAT) :- boats(BOAT), race(RACENUM).

#hide.
#show equip/2.
