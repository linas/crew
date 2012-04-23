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
sweep_oars(orange).

scull_oars(purple_yellow).
scull_oars(purple_red).
scull_oars(red_green).
scull_oars(red_yellow).
scull_oars(blue_blue).

% List oars requests.
oar_prefer(201, matt, purple_yellow, 1).
oar_prefer(202, intermediate, red_yellow, 1).
oar_prefer(206, juniors, red_green, 1).
oar_prefer(206, juniors, blue_blue, 1).

%%% ========================== %%%
%% The actual scheduling algorithm.
%%% ========================== %%%

#include "oar_solver.asp".
