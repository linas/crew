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
oars(OARS, sweep, COUNT) :- sweep_oars(OARS, COUNT).
oars(OARS, scull, COUNT) :- scull_oars(OARS, COUNT).

oar_type(OARS, TYPE) :- oars(OARS, TYPE, COUNT).

% Enumerate all possible pairs of oars, given the declaration,
% and the count of how many pairs there are.
oarpair(OARS, TYPE, PAIR) :- oars(OARS, TYPE, COUNT), PAIR=1..COUNT.

% The number of oars needed, for a given boat type.
oarpairs_needed(BOAT, sweep, 4) :- eight(BOAT).
oarpairs_needed(BOAT, sweep, 2) :- fourplus(BOAT).
oarpairs_needed(BOAT, sweep, 2) :- fourminus(BOAT).
oarpairs_needed(BOAT, sweep, 1) :- pair(BOAT).

oarpairs_needed(BOAT, scull, 4) :- quad(BOAT).
oarpairs_needed(BOAT, scull, 2) :- double(BOAT).
oarpairs_needed(BOAT, scull, 1) :- single(BOAT).

%%% ========================================================== %%%
%% The actual scheduling algorithm.
%% DO NOT MODIFY ANYTHING BELOW THIS LINE!
%% (Unless you really, really know what you're doing, and
%% you probably don't.)  Just write me with questions, requests.
%%% ========================================================== %%%
% Below follows the core oar available/request/reserve logic.
% Most of the below is similar to the boat reservation logic,
% except that its considerably more complex, because we have to deal
% with the problem of differing numbers of oars and oar types for
% different boat types.

% Oars are available if not in use by any crew.
oarpair_available(RACE, OARS, TYPE, PAIR) :-
           racenum(RACE), crew(CREW),
           oarpair(OARS, TYPE, PAIR),
           not oarpair_inuse(RACE, CREW, OARS, TYPE, PAIR).

% Reserve oar pairs if they are requested and available.
% OK, the section commented out below works, but won't split up oar
% sets for doubles and singles.  So we replace it by a more complex 
% system for doubles, singles.
%
% oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR) :-
%            oarpair_available(RACE, OARS, TYPE, PAIR),
%            oar_request(RACE, CREW, OARS), 
%            reserve(RACE, CREW, BOAT),
%            oarpairs_needed(BOAT, TYPE, COUNT),
%            PAIR = 1..COUNT.

% XXX This is broken right now, because oar requests for singles fail 
% to realize the sets can be split up, and so the requests never get made.
% and so oar reservation failures happen. Yikes!  Fixme later.

% When there's a set of 4 needed, grab them all.
oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR) :-
           oarpair_available(RACE, OARS, TYPE, PAIR),
           oar_request(RACE, CREW, OARS), 
           reserve(RACE, CREW, BOAT),
           oarpairs_needed(BOAT, TYPE, 4),
           PAIR = 1..4.

% When there's a set of 2 needed, and the first two are available,
% grab them.
oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR) :-
           oarpair_available(RACE, OARS, TYPE, PAIR),
           oar_request(RACE, CREW, OARS), 
           reserve(RACE, CREW, BOAT),
           oarpairs_needed(BOAT, TYPE, 2),
           PAIR = 1..2.

% When the first 2 pairs of oars are taken, then grab the other two
% out of the set.
oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR) :-
           not oarpair_available(RACE, OARS, TYPE, 1),
           not oarpair_available(RACE, OARS, TYPE, 2),
           oarpair_available(RACE, OARS, TYPE, PAIR),
           oar_request(RACE, CREW, OARS), 
           reserve(RACE, CREW, BOAT),
           oarpairs_needed(BOAT, TYPE, 2),
           PAIR = 3..4.

% singles
oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR) :-
           oarpair_available(RACE, OARS, TYPE, PAIR),
           oar_request(RACE, CREW, OARS), 
           reserve(RACE, CREW, BOAT),
           oarpairs_needed(BOAT, TYPE, 1),
           PAIR = 1.

oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR) :-
           not oarpair_available(RACE, OARS, TYPE, 1),
           oarpair_available(RACE, OARS, TYPE, PAIR),
           oar_request(RACE, CREW, OARS), 
           reserve(RACE, CREW, BOAT),
           oarpairs_needed(BOAT, TYPE, 1),
           PAIR = 2.

oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR) :-
           not oarpair_available(RACE, OARS, TYPE, 1),
           not oarpair_available(RACE, OARS, TYPE, 2),
           oarpair_available(RACE, OARS, TYPE, PAIR),
           oar_request(RACE, CREW, OARS), 
           reserve(RACE, CREW, BOAT),
           oarpairs_needed(BOAT, TYPE, 1),
           PAIR = 3.

oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR) :-
           not oarpair_available(RACE, OARS, TYPE, 1),
           not oarpair_available(RACE, OARS, TYPE, 2),
           not oarpair_available(RACE, OARS, TYPE, 3),
           oarpair_available(RACE, OARS, TYPE, PAIR),
           oar_request(RACE, CREW, OARS), 
           reserve(RACE, CREW, BOAT),
           oarpairs_needed(BOAT, TYPE, 1),
           PAIR = 4.


% Make sure that quads and eights get four pairs of oars, and not less.
% Start by counting how many oarparis we actually got.
got_four_oarpairs(RACE, CREW, OARS, TYPE) :- 
           oarpair_reserve(RACE, CREW, OARS, TYPE, PA), 
           oarpair_reserve(RACE, CREW, OARS, TYPE, PB), 
           oarpair_reserve(RACE, CREW, OARS, TYPE, PC), 
           oarpair_reserve(RACE, CREW, OARS, TYPE, PD), 
           PA != PB, PA != PC, PA != PD,
           PB != PC, PB != PD, PC != PD.

% Doubles, fours need only two pairs of oars.
got_two_oarpairs(RACE, CREW, OARS, TYPE) :- 
           oarpair_reserve(RACE, CREW, OARS, TYPE, PA), 
           oarpair_reserve(RACE, CREW, OARS, TYPE, PB), 
           PA != PB.

% We got enough oar pairs if ... etc, depending on boat type.
got_enough_oarpairs(RACE, CREW, OARS, TYPE) :-
           got_four_oarpairs(RACE, CREW, OARS, TYPE),
           oarpairs_needed(BOAT, TYPE, 4),
           reserve(RACE, CREW, BOAT).

got_enough_oarpairs(RACE, CREW, OARS, TYPE) :-
           got_two_oarpairs(RACE, CREW, OARS, TYPE),
           oarpairs_needed(BOAT, TYPE, 2),
           reserve(RACE, CREW, BOAT).

got_enough_oarpairs(RACE, CREW, OARS, TYPE) :-
           oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR), 
           oarpairs_needed(BOAT, TYPE, 1),
           reserve(RACE, CREW, BOAT).

% Whoops, this is true if we got something, but did NOT get enough.
not_got_enough_oarpairs(RACE, CREW, OARS, TYPE) :-
           not got_enough_oarpairs(RACE, CREW, OARS, TYPE),
           oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR). 

% Double-negative: must get enough.
:- not_got_enough_oarpairs(RACE, CREW, OARS, TYPE).

% If oarpair are reserved, then they will be in use at least CENTER races
% beforehand. That is, the crew needs CENTER races to launch and
% warmup before the race.
oarpair_inuse(ONWATER, CREW, OARS, TYPE, PAIR) :-
           racenum(RACE), crew(CREW),
           oarpair(OARS, TYPE, PAIR),
           oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR), 
           ONWATER = RACE - N,
           N = 1..CENTER,
           center(CENTER).

% Cannot reserve oars that are in use.
:- oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR),
   oarpair_inuse(RACE, OTHER_CREW, OARS, TYPE, PAIR),
   racenum(RACE), crew(CREW), crew(OTHER_CREW), oarpair(OARS, TYPE, PAIR). 

% Cannot request oars if they're in use.
% This rule isn't needed right now, comment it out. 
% :- oar_request(RACE, CREW, OARS), oar_inuse(RACE, OTHER_CREW, OARS, PAIR).

% Two different crews cannot reserve same oars for the same race.
:- oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR), 
   oarpair_reserve(RACE, OTHER_CREW, OARS, TYPE, PAIR),
   CREW != OTHER_CREW,
   racenum(RACE), crew(CREW), crew(OTHER_CREW), oarpair(OARS, TYPE, PAIR). 

% ----------------------
% Preference indication.

% choice must be a number, 1 to 4.
oar_choice(CHOICE) :- CHOICE=1..4.

% The total universe of all possible oar-set assignments, to a given
% crew and race.  This does not count how many, or the types.
1 { oar_universe(RACE, CREW, OARS) : oars(OARS, TYPE, COUNT) } 1 :-
   crew(CREW), racenum(RACE).

% XXX This is broken right now, because oar requests for singles fail 
% to realize the sets can be split up, and so the requests never get made.
% and so oar reservation failures happen. Yikes! Fixme later.

% Out of a list of desired oars, choose only one set of oars.
oar_request(RACE, CREW, OARS) :-
             oar_prefer(RACE, CREW, OARS, CHOICE),
             oar_universe(RACE, CREW, OARS).

% A crew has a reservation if it has one or more oar pairs.
oar_reserve(RACE, CREW, OARS, TYPE) :-
             oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR).

% A crew got oars if it has a reservation.
got_oars(RACE, CREW) :- oar_reserve(RACE, CREW, OARS, TYPE).

% We sure want every oar request to be granted. Must flag any crews
% that got boats, but we can't find them oarpair.
% This flag must be highly visible.
oar_reservation_failure(RACE, CREW) :- got_a_boat(RACE, CREW),
                                       not got_oars(RACE, CREW).

% The above rules do allow a situation where some crews can't get
% oars.  Thus, we have to maximize for number of reservations
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
% Every boat reservation must have an oar reservation
% If a crew did not express an oar choice, make a request for them,
% ask for something, anything.
expressed_oar_pref(RACE, CREW) :- oar_prefer(RACE, CREW, OARS, CHOICE).
oar_request(RACE, CREW, OARS) :- got_a_boat(RACE, CREW),
                                 not expressed_oar_pref(RACE, CREW),
                                 oar_universe(RACE, CREW, OARS).

% ----------------------
% Hotseat notifications and minimization.
% Basically, we try to find assignments with the fewest hot-seats.

% True if oars will be hotseated at the dock.
oar_hotseat(RACE, OARS) :-
          oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR), 
          oarpair_reserve(RACE-CENTER-M, OTHER_CREW, OARS, TYPE, PAIR),
          center(CENTER),
          M=1..HOTS, hotseat_warn(HOTS).

% True if crew should hurry back because oarpair are needed.
% Currently, not used for anything, except as a printout for the
% convenience of the crews.
oar_hurry_back(RACE, CREW, OARS) :-
          oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR), 
          oarpair_reserve(RACE+CENTER+M, OTHER_CREW, OARS, TYPE, PAIR),
          center(CENTER),
          M=1..HOTS, hotseat_warn(HOTS).

% Minimize the number of oars that are hot-seated.
#minimize [oar_hotseat(RACE, OARS) @OHP : oar_hotseat_priority(OHP)].


% ----------------------
% Equipment list.  Stuff to take to the venue.
take_oars_to_venue(OARS, TYPE) :- oar_reserve(RACE, CREW, OARS, TYPE).

% XXX Caution: enabling this can chew up huge amounts of CPU time!
% #minimize [take_oars_to_venue(OARS, TYPE)
%                   : num_oars_priority(NOP) @NOP ].

% ----------------------
% Look for a typo in the name of the oarpair, crew or race.
% Typos can screw everything up, so flag these.
% fixme, use some kind of aggregate.
% bad_oar_count(OARS) :- oars(OARS,TYPE,COUNT), not COUNT=1..8.

oarname(OARS) :- oars(OARS, TYPE, COUNT).
bad_oar_name(OARS) :- oar_request(RACE,CREW,OARS), not oarname(OARS).
bad_crew_name(CREW) :- oar_request(RACE,CREW,OARS), not crew(CREW).
bad_race_num(RACE) :- oar_request(RACE,CREW,OARS), not racenum(RACE).

bad_oar_name(OARS) :- oar_prefer(RACE,CREW,OARS,CHOICE), not oarname(OARS).
bad_crew_name(CREW) :- oar_prefer(RACE,CREW,OARS,CHOICE), not crew(CREW).
bad_race_num(RACE) :- oar_prefer(RACE,CREW,OARS,CHOICE), not racenum(RACE).
bad_oar_preference(CHOICE) :- oar_prefer(RACE,CREW,OARS,CHOICE), not choice(CHOICE).

#show oar_reservation_failure/2.
#show bad_oar_count/1.
#show bad_oar_name/1.
#show bad_oar_preference/1.
% #show oarpair_reserve/5.
% #show got_four_oarpairs/4.
% #show got_enough_oarpairs/4.
% #show not_got_enough_oarpairs/4.
#show oar_reserve/4.
#show oar_hotseat/2.
#show oar_hurry_back/3.
#show take_oars_to_venue/2.
% #show oar_request/3.
% #show oarpair_inuse/5.
% #show oarpair_available/4.
% #show oarpairs_needed/3.
