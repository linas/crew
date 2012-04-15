%
% regatta team equipment scheduling
% Texas Rowing Center Boats
%
% The problem of scheduling equipment for a regatta is a constraint
% problem -- two crews cannot use the same boat at the same time,
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

% -- List of boat classes.  Can add new boat classes here, if desired.
boat(BOAT) :- eight(BOAT).
boat(BOAT) :- fourplus(BOAT).
boat(BOAT) :- fourminus(BOAT).

boat(BOAT) :- heavy_quad(BOAT).
boat(BOAT) :- midheavy_quad(BOAT).
boat(BOAT) :- midweight_quad(BOAT).
boat(BOAT) :- midlight_quad(BOAT).
boat(BOAT) :- lightweight_quad(BOAT).

boat(BOAT) :- heavy_double(BOAT).
boat(BOAT) :- midweight_double(BOAT).
boat(BOAT) :- lightweight_double(BOAT).
boat(BOAT) :- pair(BOAT).

boat(BOAT) :- heavy_single(BOAT).
boat(BOAT) :- midweight_single(BOAT).
boat(BOAT) :- lightweight_single(BOAT).
boat(BOAT) :- flyweight_single(BOAT).
boat(BOAT) :- adaptive_single(BOAT).

% --- Generic boat classes.
hv_or_mid_quad(BOAT) :- heavy_quad(BOAT).
hv_or_mid_quad(BOAT) :- midheavy_quad(BOAT).
hv_or_mid_quad(BOAT) :- midweight_quad(BOAT).
lt_or_mid_quad(BOAT) :- midweight_quad(BOAT).
lt_or_mid_quad(BOAT) :- midlight_quad(BOAT).
lt_or_mid_quad(BOAT) :- lightweight_quad(BOAT).
any_quad(BOAT) :- lightweight_quad(BOAT).


% --- Describe the boats, according to boat class.
% Kaitlin is a heavy 8, Sophie a mid-weight.
eight(kaitlin).
eight(sophie).

% Judie is a midweight, Berverly a heavy
% Marty's 4- is a midweight
fourplus(judie).
fourplus(beverly).
fourminus(martys_4minus).

% Quads
heavy_quad(orange).
heavy_quad(black).
midheavy_quad(parents).
midheavy_quad(masters).
midheavy_quad(mcdarmid).

midweight_quad(yellow).
midlight_quad(green).
midlight_quad(blue).
lightweight_quad(red).

% Doubles
heavy_double(maas).
heavy_double(kaschper).
heavy_double(barksdale).

midweight_double(swinford).
midweight_double(bass).
lightweight_double(thrash).

% Pairs -- 41 is heavyweight, 30 is midweight.
pair(41).
pair(30).

% Singles. 
heavy_single(dunya).  % Actually its a superheavy.
heavy_single(knifty).
heavy_single(director).
heavy_single(cantu).
midweight_single(somers).
midweight_single(marty_n_saloni).
midweight_single(blair).
lightweight_single(pete).
lightweight_single(veronica).
lightweight_single(unnamed).
flyweight_single(fly).
adaptive_single(intrepid).

% --- Describe crew types.
crew(juniors).
crew(advanced).
crew(intermediate).
crew(matt).

% --- List the races
racenum(NUM) :- NUM=101..140.   % Saturday.
racenum(NUM) :- NUM=201..229.   % Sunday.

% --- Specify minimum number of races between equipment reuse.
center(4).

% --- Restrictions.
% Juniors are never allowed to take out the black quad.
:- request(RACE, juniors, black), racenum(RACE).

% --- List boat requests.
% XXX totally bogus data, ignore..... XXX
% Advanced crew wants one quad, any quad, for race 201
1{ request(201, advanced, BOAT) : heavy_quad(BOAT) }1.

% Matt must have his black boat for this race.
request(201, matt, black).

% Intermediate crew wants one quad, mid or heavyweight quad, for race 201
1{ request(202, intermediate, BOAT) : hv_or_mid_quad(BOAT) }1.

% Juniors want 2 mid or lightweight quads for race 206
2{ request(206, juniors, BOAT) : lt_or_mid_quad(BOAT) }2.


%%% ========================================================== %%%
%% The actual scheduling algorithm. Short and simple, huh?
%% DO NOT MODIFY ANYTHING BELOW THIS LINE!
%% (unless you really, really know what you're doing, and
%% you probably don't.  Just write me with questions, requests.
%%% ========================================================== %%%

% A boat is available if its not in use by any crew.
available(RACE, BOAT) :- racenum(RACE), crew(CREW), boat(BOAT),
                         not inuse(RACE, CREW, BOAT).

% Reserve the boat if it is requested and available.
reserve(RACE, CREW, BOAT) :- racenum(RACE), crew(CREW), boat(BOAT),
                             request(RACE, CREW, BOAT), 
                             available(RACE, BOAT).

% A boat will be in use for the next CENTER races if it is reserved.
inuse(ONWATER, CREW, BOAT) :- racenum(RACE), crew(CREW), boat(BOAT),
                              reserve(RACE, CREW, BOAT), 
                              ONWATER = RACE + N,
                              N = 1..CENTER,
                              center(CENTER).

% Cannot reserve a boat that is in use.
:- reserve(RACE, CREW, BOAT), inuse(RACE, OTHER_CREW, BOAT),
   racenum(RACE), crew(CREW), crew(OTHER_CREW), boat(BOAT). 

% Cannot request a boat if its in use.
% This rule isn't needed right now, comment it out. 
% :- request(RACE, CREW, BOAT), inuse(RACE, OTHER_CREW, BOAT).

% Two different crews cannot reserve same boat for teh same race.
:- reserve(RACE, CREW, BOAT), reserve(RACE, OTHER_CREW, BOAT),
   CREW != OTHER_CREW,
   racenum(RACE), crew(CREW), crew(OTHER_CREW), boat(BOAT). 

% ----------------------
% Useful info.

% True is boat will be hotseated at the dock.
hotseat(RACE, BOAT) :- reserve(RACE, CREW, BOAT), 
                       reserve(RACE-CENTER-1, OTHER_CREW, BOAT),
                       center(CENTER).

% True if crew should hurry back because boat is needed.
hurry_back(RACE, CREW, BOAT) :- reserve(RACE, CREW, BOAT), 
                       reserve(RACE+CENTER+1, OTHER_CREW, BOAT),
                       center(CENTER).

% Minimize the number of boats that are hot-seated.
#minimize [hotseat(RACE, BOAT)].


#hide.
#show reserve/3.
#show hotseat/2.
#show hurry_back/3.
% #show request/2.
% #show inuse/2.
% #show available/2.
