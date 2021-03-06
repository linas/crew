
Regatta Equipment Scheduling
============================
Version 0.03 -- Linas Vepstas -- April 2012


Pre-requisites
--------------
To use this code, must have clingo, from the potassco project, installed.
In principle, any other answer-set programming system should work,
although only clingo has been tested.

See:  http://potassco.sourceforge.net/


Look at the Example
-------------------
The file 'example.asp' contains a hand-written example showing boats,
races, and crews, and boat requests for certain boats and certain races.
Look at it.  Its supposed to be simple enough that you can understand it.
Its supposed to be "realistic" enough to give you the idea on how to set
up a real club, with real equipment.

The file 'example_oars.asp' adds oar reservations to the basic example
above.

The files 'trc_boats.asp' and 'trc_oars.asp' are the real-life equipment
lists for a real-life club.  The file 'texas-champs-2012.asp' is a
real-life regatta, making use of the trc equipment.  It works (more or
less, we're still debugging).


Testing the Example
-------------------
Validate your clingo installation by running the following at the
command line:

   clingo example.asp

The output should resemble the following:
   Answer: 1
   reserve(201,matt,black)
   reserve(206,juniors,green) reserve(206,juniors,orange)
   reserve(201,advanced,revere)
   boat_reservation_failure(202,intermediate)
   boat_reservation_failure(203,intermediate)
   Optimization: 2 0 0

   Answer: 2
   reserve(201,matt,black)
   reserve(206,juniors,revere) reserve(206,juniors,orange)
   reserve(201,advanced,orange)
   reserve(202,intermediate,green)
   boat_reservation_failure(203,intermediate)
   hotseat(206,orange) hurry_back(201,advanced,orange)
   Optimization: 1 1 1
   OPTIMUM FOUND


The above states that two different reservations were found, labelled
"Answer: 1" and "Answer: 2".  In both cases, the intermediate crew
cannot get a boat for race 203, there are simply not enough boats.
In the first answer, the intermediate crew can't get a boat for race
202 also, whereas in the 2nd answer, there is a solution with a hot-seat
of the orange quad; the second requires no hot-seating.  Lets review
these in detail:

In the first answer, the juniors get two quads for race 206: the
heavyweight orange and the midweight green. Matt gets the black boat
for race 201, and the advanced crew gets the revere, also for race 201.
The line "Optimization 2 0 0" states that there were 2 boat request
failures (intermediate crew didn't get boats for races 202 and 203).
The next 0 means there were no hot-seats in this solution, and the
last 0 means all boat-choice requests were honored (i.e. everyone got
their 1st choice of boating, except the crews that got none.)

In the second answer, the intermediate crew finally does get a boat
for race 202, but still looses in race 203.  The trick here is that
"revere" will have to be hot-seated.  The "hurry_back" note is printed
for convenience: it reminds the crew in race 201 that they need to
hurry back to the hotseat dock.  The "hotseat" note reminds that
race 206 will be hot-seating the boat that hurried back.

The line "Optimization: 1 1 1" states that, this time, there was only
1 reservation failure. It also states that there is 1 hot-seat required.
Finally, it states that there is 1 crew that did not get their top
choice of boat picks. Too bad.

The system will *always* try to seat as many crews as possible, even
if this requires lots of hotseats, and if some crews don't get the
boats they wanted.  The "best" answer is always printed last.

There may be thousands of different possible seatings.  These can be
narrowed down by letting the crews get picky with what boats they want.
One can also disallow certain crews from using certain boats, etc.
Doing so may result in more and more hotseats being required.
It is also possible to make firm reservations that are always granted,
no matter what enyone else wants.  However, doing this may result in
some crews not getting to race.


Example with oar assignments
----------------------------
The file 'example_oars.asp' adds oar assignments to the basic example.
To try it, run this command line:

   clingo example_oars.asp


Running
-------
 * Make a copy of the 'trc_boats.asp' file, giving it some other name,
   say, for example, 'club_boats.asp'.  Edit, as desired, describing
   the various boats owned by the club.  New boat classes and boat
   types may be added (or removed) as desired; the 'trc_boats.asp' is
   merely a more refined example of what one can do.

 * Make a copy of the 'texas-champs-2012.asp' file, calling it, say,
   'head2012.asp'.  Edit this file, and describe the crews and the
   equipment requests.

 * Run the software.  To list one possible set of boat assignments:

       clingo  head2102.asp

 * Typically, ther may be thousands of different boat assignments.  In
   this case, it is probably worth the effort to tighten up boat
   requests, to give certain crews priority for certain boats; this way,
   one can work towards getting everybody what they want.

Errors
------
There shouldn't be any :-)

If the program prints "UNSATISFIABLE", this is probably because no
boat choice preferences were indicated.  The keyword "prefer" must be
used at least once, somewhere, in the list of boat requests.

Other reasons for getting "UNSATISFIABLE" are typos in the list of
boats or oars.  Typos will confuse the program.  Review the data,
pay close attention to the spelling.

The program does try to find typos, it will print "bad_boat_name" or
"bad_crew_name", etc. if it found some.

That's all for now, folks!
