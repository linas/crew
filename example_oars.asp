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

% List oars requests.

% Every boat reservation must have an oar reservation
oar_request(RACE, CREW, OARS) :- reserve(RACE,CREW,BOAT), oars(OARS).



%%% ========================== %%%
%% The actual scheduling algorithm.
%%% ========================== %%%

#include "oar_solver.asp".
