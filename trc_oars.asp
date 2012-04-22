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
oars(OARS) :- fatties(OARS).
oars(OARS) :- black_grip(OARS).
oars(OARS) :- fat_grip(OARS).
oars(OARS) :- thin_grip(OARS).


% --- List of oars.
fatties(purple_yellow).

