%
% trc_oars.asp
% Texas Rowing Center Oars
%
% This file lists the oars and oar types used by TRC.  By making use
% of the #include directive, this listing can be reused for different
% regattas.
%
% Initial version: Linas Vepstas April 2012
%
% Copyright (c) 2012 Linas Vepstas
% The GNU GPLv3 applies.
%

% -- List of oar types.  Can add new types here, if desired.
scull_oars(OARS, COUNT) :- fatties(OARS, COUNT).
scull_oars(OARS, COUNT) :- big_grip(OARS, COUNT).
scull_oars(OARS, COUNT) :- thin_grip(OARS, COUNT).

% We're going to attempt to race without the clunkers, if we can...
% scull_oars(OARS, COUNT) :- novice(OARS, COUNT).  % the clunky ones.

% --- List of oars.
sweep_oars(purple, 4).
sweep_oars(orange, 4).
sweep_oars(blue, 4).
sweep_oars(wood, 4).
sweep_oars(pair, 1).

% --- Scull oars in order according to rack position.
% -- Private oars half-rack on left.
thin_grip(blue_white, 4).
fatties(blue_blue, 4).
fatties(red_red, 4).

% -- Main competitive crew rack.
fatties(purple_green, 4).
thin_grip(red_blue, 4).
fatties(yellow_purple, 4).
thin_grip(blue_orange, 4).
fatties(orange_orange, 4).
big_grip(orange_blue, 4).
big_grip(red_yellow, 4).
fatties(purple_red, 4).

% -- Novice rack, on right.
novice(blue_purple, 4).
% XX incomplete set...!?? of what color??
big_grip(green_white, 4).
big_grip(purple_white, 4).
novice(blue_yellow, 4).
big_grip(green_blue, 4).
novice(orange_purple, 4).
novice(red_white, 4).

% That's all folks.
