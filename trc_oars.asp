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
scull_oars(OARS) :- fatties(OARS).
scull_oars(OARS) :- fat_grip(OARS).
scull_oars(OARS) :- thin_grip(OARS).

% --- List of oars.
sweep_oars(purple).
sweep_oars(orange).
sweep_oars(blue).
sweep_oars(wood).
sweep_oars(pair).

% --- Scull oars
fatties(purple_yellow).
fatties(purple_green).
fat_grip(red_yellow).
fat_grip(red_green).
thin_grip(red_blue).

scull_oars(a).
scull_oars(b).
scull_oars(c).
scull_oars(d).
scull_oars(e).
scull_oars(f).
scull_oars(g).
scull_oars(h).
scull_oars(i).
scull_oars(j).
scull_oars(k).
