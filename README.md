Task Juggler http://www.taskjuggler.org is a wonderful plain text
based project management tool which can be used for:

* Scheduling tasks and people (ah sorry resources).
* Costing
* Timesheets
* Many more things

This project adds a small preprocessor in TCL (see http://wiki.tcl.tk)
which can be used for automatically generating complicated plans. As
an example you might want to have 37 sites installed each of which
look roughly alike but have special properties, e.g.

1. Every site requires land which takes between 6 and 12 months 
   to acquire (randomly).
1. Every site has a name and an installed size in kW. The installed
   size also effects the time to construct and the cost is a function
   of the size (not necessarily linear).
1. Every site is connected by low voltage (lv) or high voltage (hv) 
   which require different teams and have different plans.

So the main itch that is being scratched is how to automagically
generate a taskjuggler via a templating system which only makes
sense for projects with lots of repeating varying tasks (otherwise
TaskJuggler macros etc will do the job).

As a small example consider this fragment:
```` 
*set sites {
  *  {name A connect hv size 500}
  *  {name B connect lv size 1200}
  *  {name C connect hv size 100}
*}

resource hvt "HVT" { } 
resource lvt "LVT" { }

task land "Land Procurement" {
  chargeset land
  *foreach site $sites {
    *foreach {v k} $site {set $v $k} 
    $task land_$name "Land $name" { 
      !duration [between 6 12]m ;# 6..12 months
      allocate batman {alternative robin}
      !charge [expr 200*$size] onstart
    }
  *}
}

task mp_rollout "MP Rollout" {
  chargeset mprollout
  *foreach site $sites {
    *foreach {v k} $site {set $v $k}
    $ task site_$name "$name $connect $size" {
      depends land_$name

      *if {$connect eq "hv"} {
	task HV {
	  effort 3d
	  allocate hvt
	}
      *} elseif {$connect eq "lv"} {
	task LV {
	  effort 10d
	  allocate lvt
	}
      *} else {
	error "connect must be hv|lv for $name" }
      *}
    }
  *}
}
````
