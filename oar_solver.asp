%
% regatta team oara scheduling
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

% Two fundamental oar classes; we need this for consistent reservations.
oars(OARS) :- sweep_oars(OARS).
oars(OARS) :- scull_oars(OARS).

%%% ========================================================== %%%
%% The actual scheduling algorithm. Short and simple, huh?
%% DO NOT MODIFY ANYTHING BELOW THIS LINE!
%% (Unless you really, really know what you're doing, and
%% you probably don't.)  Just write me with questions, requests.
%%% ========================================================== %%%
% Below follows the core oar available/request/reserve logic.
% Everything below is almost identical to the boat reservation logic,
% except that we renamed boats->oars everywhere, and an oar reservation
% failure is only declared when a boat has been assigned (but not oars).

% Oars are available if not in use by any crew.
oar_available(RACE, OARS) :- racenum(RACE), crew(CREW), oars(OARS),
                         not oar_inuse(RACE, CREW, OARS).

% Reserve the oars if they are requested and available.
oar_reserve(RACE, CREW, OARS) :- racenum(RACE), crew(CREW), oars(OARS),
                             oar_request(RACE, CREW, OARS), 
                             oar_available(RACE, OARS).

% If oars are reserved, then they will be in use at least CENTER races
% beforehand. That is, the crew needs CENTER races to launch and
% warmup before the race.
oar_inuse(ONWATER, CREW, OARS) :- racenum(RACE), crew(CREW), oars(OARS),
                              oar_reserve(RACE, CREW, OARS), 
                              ONWATER = RACE - N,
                              N = 1..CENTER,
                              center(CENTER).

% Cannot reserve oars that are in use.
:- oar_reserve(RACE, CREW, OARS), oar_inuse(RACE, OTHER_CREW, OARS),
   racenum(RACE), crew(CREW), crew(OTHER_CREW), oars(OARS). 

% Cannot request oars if they're in use.
% This rule isn't needed right now, comment it out. 
% :- oar_request(RACE, CREW, OARS), oar_inuse(RACE, OTHER_CREW, OARS).

% Two different crews cannot reserve same oars for the same race.
:- oar_reserve(RACE, CREW, OARS), oar_reserve(RACE, OTHER_CREW, OARS),
   CREW != OTHER_CREW,
   racenum(RACE), crew(CREW), crew(OTHER_CREW), oars(OARS). 

% ----------------------
% Preference indication.

% choice must be a number, 1 to 4.
oar_choice(CHOICE) :- CHOICE=1..4.

% The total universe of all possible oar assignments, to a given
% crew and race.  In this universe, only one oar is ever assigned.
1 { oar_universe(RACE, CREW, OARS) : oars(OARS) } 1 :-
   crew(CREW), racenum(RACE).

% Out of a list of desired oars, choose only one set of oars.
oar_request(RACE, CREW, OARS) :- oar_prefer(RACE, CREW, OARS, CHOICE),
                                 oar_universe(RACE, CREW, OARS).

% A crew got oars if it has a reservation.
got_oars(RACE, CREW) :- oar_reserve(RACE, CREW, OARS).

% We sure want every oar request to be granted. Must flag any crews
% that got boats, but we can't find them oars.
% This flag must be highly visible.
oar_reservation_failure(RACE, CREW) :- got_a_boat(RACE, CREW),
                                       not got_oars(RACE, CREW).

% The above rules do allow a situation where some crews can't get
% a oar.  Thus, we have to maximize for number of reservations
% granted.  This must be at the highest priority, higher than the
% hot-seat avoidance priority.
#minimize [oar_reservation_failure(RACE, CREW)
                   : oar_reserve_priority(ORP)
                   : racenum(RACE)
                   : crew(CREW) @ORP ].

% We're going to try to honour everyone's top preferences.
% So CHOICE=1 is first choice, CHOICE=2 is second choice, etc.
#minimize [oar_request(RACE, CREW, OARS)
                : oar_choice_priority(OCP)
                : oar_prefer(RACE, CREW, OARS, CHOICE) = CHOICE@OCP ].

% ----------------------
% Useful info.

% True if oars will be hotseated at the dock.
oar_hotseat(RACE, OARS) :- oar_reserve(RACE, CREW, OARS), 
                       oar_reserve(RACE-CENTER-M, OTHER_CREW, OARS),
                       center(CENTER),
                       M=1..HOTS, hotseat_warn(HOTS).

% True if crew should hurry back because oars are needed.
% Currently, not used for anything, except as a printout for the
% convenience of the crews.
oar_hurry_back(RACE, CREW, OARS) :- oar_reserve(RACE, CREW, OARS), 
                       oar_reserve(RACE+CENTER+M, OTHER_CREW, OARS),
                       center(CENTER),
                       M=1..HOTS, hotseat_warn(HOTS).

% Minimize the number of oars that are hot-seated.
% The @10 just means that minimizing the number of hot-seats is
% 10 times more important than honoring desired oars.
#minimize [oar_hotseat(RACE, OARS) @OHP : oar_hotseat_priority(OHP)].


% Look for a typo in the name of the oars, crew or race.
% Typos can screw everything up, so flag these.
bad_oars_name(OARS) :- oar_request(RACE,CREW,OARS), not oars(OARS).
bad_crew_name(CREW) :- oar_request(RACE,CREW,OARS), not crew(CREW).
bad_race_num(RACE) :- oar_request(RACE,CREW,OARS), not racenum(RACE).
bad_oar_preference(CHOICE) :- oar_prefer(RACE,CREW,OARS,CHOICE), not choice(CHOICE).

#show oar_reservation_failure/2.
#show bad_oars_name/1.
#show bad_oar_preference/1.
#show oar_reserve/3.
#show oar_hotseat/2.
#show oar_hurry_back/3.
% #show oar_request/2.
% #show oar_inuse/2.
% #show oar_available/2.
