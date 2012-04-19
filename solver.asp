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

%%% ========================================================== %%%
%% The actual scheduling algorithm. Short and simple, huh?
%% DO NOT MODIFY ANYTHING BELOW THIS LINE!
%% (Unless you really, really know what you're doing, and
%% you probably don't.)  Just write me with questions, requests.
%%% ========================================================== %%%

% A boat is available if its not in use by any crew.
available(RACE, BOAT) :- racenum(RACE), crew(CREW), boat(BOAT),
                         not inuse(RACE, CREW, BOAT).

% Reserve the boat if it is requested and available.
reserve(RACE, CREW, BOAT) :- racenum(RACE), crew(CREW), boat(BOAT),
                             request(RACE, CREW, BOAT), 
                             available(RACE, BOAT).

% If a boat is reserved, then it will be in use at least CENTER races
% beforehand. That is, the crew needs CENTER races to launch and
% warmup before the race.
inuse(ONWATER, CREW, BOAT) :- racenum(RACE), crew(CREW), boat(BOAT),
                              reserve(RACE, CREW, BOAT), 
                              ONWATER = RACE - N,
                              N = 1..CENTER,
                              center(CENTER).

% Cannot reserve a boat that is in use.
:- reserve(RACE, CREW, BOAT), inuse(RACE, OTHER_CREW, BOAT),
   racenum(RACE), crew(CREW), crew(OTHER_CREW), boat(BOAT). 

% Cannot request a boat if its in use.
% This rule isn't needed right now, comment it out. 
% :- request(RACE, CREW, BOAT), inuse(RACE, OTHER_CREW, BOAT).

% Two different crews cannot reserve same boat for the same race.
:- reserve(RACE, CREW, BOAT), reserve(RACE, OTHER_CREW, BOAT),
   CREW != OTHER_CREW,
   racenum(RACE), crew(CREW), crew(OTHER_CREW), boat(BOAT). 

% ----------------------
% Useful info.

% True if boat will be hotseated at the dock.
hotseat(RACE, BOAT) :- reserve(RACE, CREW, BOAT), 
                       reserve(RACE-CENTER-M, OTHER_CREW, BOAT),
                       center(CENTER),
                       M=1..HOTS, hotseat_warn(HOTS).

% True if crew should hurry back because boat is needed.
% Currently, not used for anything, except as a printout for the
% convenience of the crews.
hurry_back(RACE, CREW, BOAT) :- reserve(RACE, CREW, BOAT), 
                       reserve(RACE+CENTER+M, OTHER_CREW, BOAT),
                       center(CENTER),
                       M=1..HOTS, hotseat_warn(HOTS).

% Minimize the number of boats that are hot-seated.
#minimize [hotseat(RACE, BOAT)].

% Look for a typo in the name of the boat, crew or race.
% typos can screw everything up, so flag these.
bad_boat_name(BOAT) :- request(RACE,CREW,BOAT), not boat(BOAT).
bad_crew_name(CREW) :- request(RACE,CREW,BOAT), not crew(CREW).
bad_race_num(RACE) :- request(RACE,CREW,BOAT), not racenum(RACE).

#hide.
#show bad_boat_name/1.
#show bad_crew_name/1.
#show bad_race_num/1.
#show reserve/3.
#show hotseat/2.
#show hurry_back/3.
% #show request/2.
% #show inuse/2.
% #show available/2.
