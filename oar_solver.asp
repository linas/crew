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

% ----------------------
% Preference indication.

% choice must be a number, 1 to 4.
oar_choice(CHOICE) :- CHOICE=1..4.

%%% ========================================================== %%%
%% The actual scheduling algorithm.
%% DO NOT MODIFY ANYTHING BELOW THIS LINE!
%% (Unless you really, really know what you're doing, and
%% you probably don't.)  Just write me with questions, requests.
%%% ========================================================== %%%
% ----------------------
% oarset logic
%
% The total possible number of matchings of sets of oars to boats.
% The division is done so that out of a set of 4 pairs of oars, a
% quad gets just one set, a double gets set 1 or 2, while singles
% get set 1,2,3 or 4.  By contrast, if there are only three pairs of
% oars, then the quads get zero, while doubles and singles can still
% get a set.
oarsets_possible(BOAT, OARS, NSETS) :-
          oarpairs_needed(BOAT, TYPE, COUNT),
          oars(OARS, TYPE, SETCOUNT),
          NSETS = SETCOUNT/COUNT,
          NSETS != 0.

% The total universe of oar-set assignments. Any boat will only ever 
% get one set of oars.  Out of a set of 4 pairs of oars, a quad will
% get the whole set, a double can get set 1 or set 2, while singles
% can get one and only one of the sets 1,2,3 or 4.
% crew and racenum are "free variables", so an orset is generated for
% every possible crew+race combination.
1 { set_universe(RACE, CREW, BOAT, OARS, SET) :
      SET=1..NSETS :
      oars(OARS, TYPE, COUNT) :
      oarsets_possible(BOAT, OARS, NSETS)
 } 1 :-
          crew(CREW), racenum(RACE).

% Out of a list of desired oars, choose only one set of oars.
oarset_request(RACE, CREW, OARS, SET) :-
             oar_prefer(RACE, CREW, OARS, CHOICE),
             set_universe(RACE, CREW, BOAT, OARS, SET).

% Two different crews cannot make a request for the same oarset
% for the same race.
:- oarset_request(RACE, CREW, OARS, SET),
   oarset_request(RACE, OTHER_CREW, OARS, SET),
   CREW != OTHER_CREW.

% ----------------------
% Every boat reservation must have an oar reservation.
% If a crew did not express an oar choice, make a request for them,
% ask for something, anything.
expressed_oar_pref(RACE, CREW) :- oar_prefer(RACE, CREW, OARS, CHOICE).

auto_oar_req(RACE, CREW) :-
           got_a_boat(RACE, CREW),
           not expressed_oar_pref(RACE, CREW).

oarset_request(RACE, CREW, OARS, SET) :-
           auto_oar_req(RACE, CREW),
           set_universe(RACE, CREW, BOAT, OARS, SET).

% ----------------------
% Convert oarset requests into oarpair requests.  Basically, just take
% the oarset, and multiply by the number of oarpairs needed for a given
% boat class.  This is the magic where sets of oars can be split up
% between doubles, singles.

% Note also: a request is not made unless a boat is reserved.

oarpair_request(RACE, CREW, OARS, TYPE, PAIR) :-
           reserve(RACE, CREW, BOAT),
           oarset_request(RACE, CREW, OARS, SET),
           oarpairs_needed(BOAT, TYPE, COUNT),
           N = 1..COUNT,
           PAIR = N + (SET-1)* COUNT. 

% ----------------------
% The core reservation/inuse logic. Vaguely resembles that used for the
% boats, but has more arguments.

% Oars are available if not in use by any crew.
oarpair_available(RACE, OARS, TYPE, PAIR) :-
           racenum(RACE), crew(CREW),
           oarpair(OARS, TYPE, PAIR),
           not oarpair_inuse(RACE, CREW, OARS, TYPE, PAIR).

% Reserve oar pairs if they are requested and available.
oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR) :-
            oarpair_available(RACE, OARS, TYPE, PAIR),
            oarpair_request(RACE, CREW, OARS, TYPE, PAIR).

% If oarpair is reserved, then it will be in use at least CENTER races
% beforehand. That is, the crew needs CENTER-1 races to launch and
% warmup before the race.
oarpair_inuse(ONWATER, CREW, OARS, TYPE, PAIR) :-
           oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR), 
           sched(SCH, RACE),
           SCHMN = SCH - N,
           sched(SCHMN, ONWATER),
           N = 1..CENTER-1,
           center(CENTER).

% Oars are on the water for race immediately after, too.
oarpair_inuse(ONWATER, CREW, OARS, TYPE, PAIR) :-
           oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR), 
           sched(SCH, RACE),
           sched(SCH+1, ONWATER).

% Cannot reserve oars that are in use.
:- oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR),
   oarpair_inuse(RACE, OTHER_CREW, OARS, TYPE, PAIR),
   racenum(RACE), crew(CREW), crew(OTHER_CREW), oarpair(OARS, TYPE, PAIR). 

% Cannot request oars if they're in use.
% This rule isn't needed right now, comment it out. 
% :- oar_request(RACE, CREW, OARS), oar_inuse(RACE, OTHER_CREW, OARS, PAIR).

% Two different crews cannot reserve same oars for the same race.
% I think this may be a redundant constraint, not sure.  I think an 
% earlier constraint on oarpair_request by different crews already
% guarantees this.
:- oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR), 
   oarpair_reserve(RACE, OTHER_CREW, OARS, TYPE, PAIR),
   CREW != OTHER_CREW,
   racenum(RACE), crew(CREW), crew(OTHER_CREW), oarpair(OARS, TYPE, PAIR). 

% ---------------------------------
% Second guess everything.  The above should be enough, I think, to
% properly reserve oars. But, just in case ...

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

% --------------------
% minimize oar reservation conflicts.

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
% XXX  disabled right now, enable later.
% #minimize [oar_request(RACE, CREW, OARS)
%                : oar_choice_priority(OCP)
%                : oar_prefer(RACE, CREW, OARS, CHOICE) = CHOICE@OCP ].

% ----------------------
% Hotseat notifications and minimization.
% Basically, we try to find assignments with the fewest hot-seats.

% True if oars will be hotseated at the dock.
% XXX M should be M=0..HOTS but this spews cpu time right now
% and is borken.  fixme later.
oar_hotseat(RACE, OARS) :-
          oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR), 
          oarpair_reserve(OTHER_RACE, OTHER_CREW, OARS, TYPE, PAIR),
          sched(SCH, RACE),
          sched(SCH-CENTER-M, OTHER_RACE),
          center(CENTER),
          M=1..HOTS, hotseat_warn(HOTS).

% True if crew should hurry back because oarpair are needed.
% Currently, not used for anything, except as a printout for the
% convenience of the crews.
oar_hurry_back(RACE, CREW, OARS) :-
          oarpair_reserve(RACE, CREW, OARS, TYPE, PAIR), 
          oarpair_reserve(OTHER_RACE, OTHER_CREW, OARS, TYPE, PAIR),
          sched(SCH, RACE),
          sched(SCH+CENTER+M, OTHER_RACE),
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
bad_oar_name(OARS) :- oar_prefer(RACE,CREW,OARS,CH), not oarname(OARS).
bad_crew_name(CREW) :- oar_prefer(RACE,CREW,OARS,CH), not crew(CREW).
bad_race_num(RACE) :- oar_prefer(RACE,CREW,OARS,CH), not racenum(RACE).

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
% #show set_universe/5.
#show oarset_request/4.
% #show oarsets_possible/3.
#show oarpair_request/5.
