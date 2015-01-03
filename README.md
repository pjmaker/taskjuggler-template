== taskjuggler-template

Task Juggler http://www.taskjuggler.org is a wonderful plain text
based project management tool which can be used for:

* Scheduling tasks and people (ah sorry resources).
* Costing
* Timesheets

This project adds a small preprocessor in TCL http://wiki.tcl.tk which
can be used for automatically generating complicated plans. As an
example you might want to have 37 sites installed each of which look 
roughly alike but have special properties, e.g. 

1. Every site requires land
1. Every site has a name and an installed size in kW.
1. Every site is connected by low voltage (lv) or high voltage (hv)

> task land {
> *foreach s ... {
>   task fred

.
 
