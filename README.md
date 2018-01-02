
Regatta Equipment Scheduling
============================
Version 0.03 -- Linas Vepstas -- April 2012

Scheduling boats and oars for a rowing regatta is hard.  The goal of
this project is to (eventually) simplify this.  Right now, this is just
an experimental begining.  We've scheduled equipment for one regatta,
using this code, but not without a lot of pain.

What it currently does:
-----------------------
The directory "solver" contains code to automate equipment scheduling.
Rowers and/or coaches can specify desired equipment; the solver will try
to give everybody what they want. It will print hotseat warnings. It
will print lists of equipment to be taken to the venue.

The directory contains several examples, and one real regatta.  It works
(i.e. doesn't make mistakes) but, ahem, needs tuning. It uses the latest
in high-tech to do the scheuling: Answer-Set Programming using recent
advances in Boolean Satisfiability Solving algorithms, such as the
Davis-Putnam algorithm.  In other words, its state of the art for
scheduling problems.

The directory "scripts" contains a perl script to take the above output,
and convert to CSV, suitable for import into a spreadsheet.


What is planned:
----------------
-- Import of race and entry info from regattacentral.
-- Import of race and entry info from spreadsheets
-- Web interface for entering this info.

and etc. -- kind of what you'd want and expect from something usable.

This is why we're on version 0.03 right now :-)

To help, contact linasvepstas@gmail.com
