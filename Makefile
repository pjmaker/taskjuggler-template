#
# Makefile - for the taskjuggler-template
#

all::
	./make-plan.tcl <plan.tjt >auto-plan.tjp
	rm -rf HTML
	mkdir HTML
	tj3 -c 8 --no-color --silent -o HTML auto-plan.tjp

