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

% -- List of fundamental boat classes.  We must distinguish sweeps
% from sculls, and quads, doubles, singles, etc.  in order to be
% able to count the number of oars needed, for oar reservations.
% That's why these are the "fundamental" types.
boat(BOAT) :- sweep_boat(BOAT).
boat(BOAT) :- scull_boat(BOAT).

sweep_boat(BOAT) :- eight(BOAT).
sweep_boat(BOAT) :- fourplus(BOAT).
sweep_boat(BOAT) :- fourminus(BOAT).
sweep_boat(BOAT) :- pair(BOAT).

scull_boat(BOAT) :- quad(BOAT).
scull_boat(BOAT) :- double(BOAT).
scull_boat(BOAT) :- single(BOAT).

%%% ========================================================== %%%
%% The actual scheduling algorithm. Short and simple, huh?
%% DO NOT MODIFY ANYTHING BELOW THIS LINE!
%% (Unless you really, really know what you're doing, and
%% you probably don't.)  Just write me with questions, requests.
%%% ========================================================== %%%

% Some priority assignments:
boat_reserve_priority(12). % top priority
oar_reserve_priority(11).  % 2nd highest priority
boat_hotseat_priority(10). % 3rd priority
oar_hotseat_priority(9).   % 4th priority
boat_choice_priority(8).
oar_choice_priority(7).
num_boats_priority(6).
num_oars_priority(5).

% Below follows the core available/request/reserve logic.

% A boat is available if its not in use by any crew.
available(RACE, BOAT) :- racenum(RACE), crew(CREW), boat(BOAT),
                         not inuse(RACE, CREW, BOAT).

% Reserve the boat if it is requested and available.
reserve(RACE, CREW, BOAT) :- racenum(RACE), crew(CREW), boat(BOAT),
                             request(RACE, CREW, BOAT), 
                             available(RACE, BOAT).

% If a boat is reserved, then it will be in use at least CENTER races
% beforehand. That is, the crew needs CENTER-1 races to launch and
% warmup before the race.
inuse(ONWATER, CREW, BOAT) :- reserve(RACE, CREW, BOAT), 
                              heat(SCH, RACE),
                              SCHMN = SCH - N,
                              heat(SCHMN, ONWATER),
                              N = 1..CENTER-1,
                              center(CENTER).

% Its on the water for the next race, too.
inuse(ONWATER, CREW, BOAT) :- reserve(RACE, CREW, BOAT), 
                              heat(SCH, RACE),
                              heat(SCH+1, ONWATER).

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
% Preference indication.

% choice must be a number, 1 to 4.
choice(CHOICE) :- CHOICE=1..4.

% The total universe of all possible boat assignments, to a given
% crew and race.  In this universe, only one boat is ever assigned.
1 { boat_universe(RACE, CREW, BOAT) : boat(BOAT) } 1 :-
   crew(CREW), racenum(RACE).

% Out of a list of desired boats, choose only one boat.
request(RACE, CREW, BOAT) :- prefer(RACE, CREW, BOAT, CHOICE),
                             boat_universe(RACE, CREW, BOAT).

% A crew wants to race in a race if they've expressed a boat preference.
% or if they've requested a specific boat.
want_to_race(RACE, CREW) :- prefer(RACE, CREW, BOAT, CHOICE).
want_to_race(RACE, CREW) :- request(RACE, CREW, BOAT).

% A crew got a boat if it has a reservation.
got_a_boat(RACE, CREW) :- reserve(RACE, CREW, BOAT).

% We sure want every boat request to be granted. Must flag any crews
% that want to race a race, but we can't find them a boat.
% This flag must be highly visible.
boat_reservation_failure(RACE, CREW) :- want_to_race(RACE, CREW),
                                        not got_a_boat(RACE, CREW).

% The above rules do allow a situation where some crews can't get
% a boat.  Thus, we have to maximize for number of reservations
% granted.  This must be at the highest priority, higher than the
% hot-seat avoidance priority.
#minimize [boat_reservation_failure(RACE, CREW)
                   : boat_reserve_priority(BRP)
                   : racenum(RACE)
                   : crew(CREW) @BRP ].

% We're going to try to honour everyone's top preferences.
% So CHOICE=1 is first choice, CHOICE=2 is second choice, etc.
#minimize [request(RACE, CREW, BOAT)
                : boat_choice_priority(BCP)
                : prefer(RACE, CREW, BOAT, CHOICE) = CHOICE@BCP ].

% ----------------------
% Hotseat notifications and minimization.
% Basically, we try to find assignments with the fewest hot-seats.

% True if boat will be hotseated at the dock.
hotseat(RACE, BOAT) :- reserve(RACE, CREW, BOAT), 
                       reserve(OTHER_RACE, OTHER_CREW, BOAT),
                       heat(SCH, RACE),
                       heat(SCH-CENTER-M, OTHER_RACE),
                       center(CENTER),
                       M=0..HOTS, hotseat_warn(HOTS).

% True if crew should hurry back because boat is needed.
% Currently, not used for anything, except as a printout for the
% convenience of the crews.
hurry_back(RACE, CREW, BOAT) :-
                       reserve(RACE, CREW, BOAT), 
                       reserve(OTHER_RACE, OTHER_CREW, BOAT),
                       heat(SCH, RACE),
                       heat(SCH+CENTER+M, OTHER_RACE),
                       center(CENTER),
                       M=0..HOTS, hotseat_warn(HOTS).

% Minimize the number of boats that are hot-seated.
% The @10 just means that minimizing the number of hot-seats is
% top priority -- higher priority than honoring desired boats.
#minimize [hotseat(RACE, BOAT) @BHP : boat_hotseat_priority(BHP)].


% ----------------------
% Equipment list.  Stuff to take to the venue.
take_to_venue(BOAT) :- reserve(RACE, CREW, BOAT).

% This seems to make things run a bit slower... and yeilds nothing
% noteworthy, since specific boats are being asked for in almost
% all cases, and so the below can't cut down on anything.
% It seems to add 5% or so total run time ...
#minimize [take_to_venue(BOAT)
                   : num_boats_priority(NBP) @NBP ].

% ----------------------
% Look for a typo in the name of the boat, crew or race.
% Typos can screw everything up, so flag these.
bad_boat_name(BOAT) :- request(RACE,CREW,BOAT), not boat(BOAT).
bad_crew_name(CREW) :- request(RACE,CREW,BOAT), not crew(CREW).
bad_race_num(RACE)  :- request(RACE,CREW,BOAT), not racenum(RACE).

bad_boat_name(BOAT) :- prefer(RACE,CREW,BOAT,CHOICE), not boat(BOAT).
bad_crew_name(CREW) :- prefer(RACE,CREW,BOAT,CHOICE), not crew(CREW).
bad_race_num(RACE)  :- prefer(RACE,CREW,BOAT,CHOICE), not racenum(RACE).
bad_preference(CHOICE) :- prefer(RACE,CREW,BOAT,CHOICE), not choice(CHOICE).

#hide.
#show boat_reservation_failure/2.
#show bad_boat_name/1.
#show bad_crew_name/1.
#show bad_race_num/1.
#show bad_preference/1.
#show reserve/3.
#show hotseat/2.
#show hurry_back/3.
#show take_to_venue/1.
% #show request/2.
% #show inuse/2.
% #show available/2.
