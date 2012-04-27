%
% trc_boats.asp
% Texas Rowing Center Boats
%
% This file lists the boats and boat classes used by TRC.  By making use
% of the #include directive, this listing can be reused for different
% regattas.
%
% Initial version: Linas Vepstas April 2012 
%
% Copyright (c) 2012 Linas Vepstas
% The GNU GPLv3 applies.
%

% -- List of boat classes.  Can add new boat classes here, if desired.
quad(BOAT) :- heavy_quad(BOAT).
quad(BOAT) :- midheavy_quad(BOAT).
quad(BOAT) :- midweight_quad(BOAT).
quad(BOAT) :- midlight_quad(BOAT).
quad(BOAT) :- lightweight_quad(BOAT).

double(BOAT) :- heavy_double(BOAT).
double(BOAT) :- midweight_double(BOAT).
double(BOAT) :- lightweight_double(BOAT).

single(BOAT) :- heavy_single(BOAT).
single(BOAT) :- midweight_single(BOAT).
single(BOAT) :- lightweight_single(BOAT).
single(BOAT) :- flyweight_single(BOAT).
single(BOAT) :- adaptive_single(BOAT).
single(BOAT) :- club_racer(BOAT).

% --- Generic boat classes.
hv_or_mid_quad(BOAT) :- heavy_quad(BOAT).
hv_or_mid_quad(BOAT) :- midheavy_quad(BOAT).
hv_or_mid_quad(BOAT) :- midweight_quad(BOAT).
lt_or_mid_quad(BOAT) :- midweight_quad(BOAT).
lt_or_mid_quad(BOAT) :- midlight_quad(BOAT).
lt_or_mid_quad(BOAT) :- lightweight_quad(BOAT).

any_quad(BOAT) :- hv_or_mid_quad(BOAT).
any_quad(BOAT) :- lt_or_mid_quad(BOAT).

% --------
hv_or_mid_double(BOAT) :- heavy_double(BOAT).
hv_or_mid_double(BOAT) :- midweight_double(BOAT).

lt_or_mid_double(BOAT) :- lightweight_double(BOAT).
lt_or_mid_double(BOAT) :- midweight_double(BOAT).

any_double(BOAT) :- hv_or_mid_double(BOAT).
any_double(BOAT) :- lt_or_mid_double(BOAT).

% --------
hv_or_mid_single(BOAT) :- heavy_single(BOAT).
hv_or_mid_single(BOAT) :- midweight_single(BOAT).

lt_or_mid_single(BOAT) :- lightweight_single(BOAT).
lt_or_mid_single(BOAT) :- midweight_single(BOAT).

any_single(BOAT) :- hv_or_mid_single(BOAT).
any_single(BOAT) :- lt_or_mid_single(BOAT).
any_single(BOAT) :- flyweight_single(BOAT).

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
midheavy_quad(mcdiarmid).

midweight_quad(yellow).
midlight_quad(green).
midlight_quad(blue).
lightweight_quad(red).

% Doubles
heavy_double(maas).
heavy_double(jakob).
heavy_double(barksdales).

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

% Club racers.
club_racer(rogers).
club_racer(kryzinski).
club_racer(hamilton).

