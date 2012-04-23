%
% example_oars.asp
% regatta oar and equipment scheduling
%
% This example is the similar to the simpler "example.asp" file, but
% includes a demo of oar reservations as well. This makes things more
% complex all-around, but is a necessary evil.
%
% Initial version: Linas Vepstas April 2012 
%
% Copyright (c) 2012 Linas Vepstas
% The GNU GPLv3 applies.
%

% First, we're going to run the boat reservations.
#include "example.asp".

% -- Describe oars
% There are 4 pairs of orange oars
sweep_oars(orange, 4).

% And 4 pairs of all the other oars, except blue_blue, of which we
% have just 3 pairs (one pair is broken).
scull_oars(purple_yellow, 4).
scull_oars(purple_red, 4).
scull_oars(red_green, 4).
scull_oars(red_yellow, 4).
scull_oars(blue_blue, 3).

% List oars requests.
oar_prefer(201, matt, purple_yellow, 1).
oar_prefer(202, intermediate, red_yellow, 1).
oar_prefer(206, juniors, red_green, 1).
oar_prefer(206, juniors, blue_blue, 1).

%%% ========================== %%%
%% The actual scheduling algorithm.
%%% ========================== %%%

#include "oar_solver.asp".
