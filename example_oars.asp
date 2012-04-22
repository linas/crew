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
% #include "example.asp".
#include "dbg.asp".

% -- Describe oars
sweep_oars(orange).

scull_oars(purple_yellow).
scull_oars(purple_red).
scull_oars(red_green).
scull_oars(red_yellow).
scull_oars(blue_blue).

% List oars requests.
oar_prefer(201, matt, purple_yellow, 1).

% Every boat reservation must have an oar reservation
oar_request(RACE, CREW, OARS) :- reserve(RACE,CREW,BOAT). 




%%% ========================== %%%
%% The actual scheduling algorithm.
%%% ========================== %%%

#include "oar_solver.asp".
