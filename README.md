Task Juggler http://www.taskjuggler.org is a wonderful plain text
based project management tool which can be used for:

* Scheduling tasks and people (ah sorry resources).
* Costing
* Timesheets

This project adds a small preprocessor in TCL (see http://wiki.tcl.tk)
which can be used for automatically generating complicated plans. As
an example you might want to have 37 sites installed each of which
look roughly alike but have special properties, e.g.

1. Every site requires land which takes between 6 and 12 months 
   to acquire (randomly).
1. Every site has a name and an installed size in kW. The installed
   size also effects the time to construct and the cost.is a function
   of the size (not necessarily linear).
1. Every site is connected by low voltage (lv) or high voltage (hv) 
   which require different teams and have different plans.

So the main itch that is being scratched is how to automagically
generate a taskjuggler via a templating system which only makes
sense for projects with lots of repeating varying tasks (otherwise
TaskJuggler macros etc will do the job).

. 



.
 
