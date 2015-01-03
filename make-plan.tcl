# -*-tcl-*- \
	exec tclsh "$0" "$@"
#
# make-plan.tcl - a very simple TCL based template suitable
#   for making TaskJuggler plans
#
#
# Copyright (c) 2015, Phil Maker
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

array set options {
  -show_prog 1
}
array set options $argv


proc process {s} {
  set prog {}
  set out {}
  foreach line [split $s \n] {
    if {[regexp {^[ \t]*[*](.*)} $line -> rest]} {
      append prog $rest \n
    } elseif {[regexp {^[ \t]*[$](.*)} $line -> rest]} {
      append prog \
	  "append out \[subst -nocommands -nobackslashes [list $rest]\] \\n" \n

    } elseif {[regexp {^[ \t]*[!](.*)} $line -> rest]} {
      append prog \
	  "append out \[subst -nobackslashes [list $rest]\] \\n" \n
    } else {
      append prog "append out [list $line] \\n" \n
    }
  }
  if {[catch $prog r]} {
    puts "$prog failed $r $::errorInfo"
    return ""
  } else {
    puts "$prog ->"
    return $out
  }
}

proc indent {s} {
  set level 0

  foreach line [split $s \n] {
    regexp {^[ \t]*(.*$)} $line -> rest
    set indentby 0
    for {set i 0} {$i < [string length $rest]} {incr i} {
      set c [string index $rest $i]
      if {$c == "\{"} {
	incr indentby
      } elseif {$c == "\}"} {
	incr indentby -1
      } else {
	 # ignore it
      }
    }
    set tab "  "
    if {$indentby > 0} {
      puts "[string repeat $tab $level]$rest"
      incr level $indentby
    } elseif {$indentby < 0} {
      incr level $indentby
      puts "[string repeat $tab $level]$rest"
    } else {
      puts "[string repeat $tab $level]$rest"
    }
  }
}

# some semi useful library procedures
proc between {min max} { # between 7 10 return 7 or 8 or 9 or 10
  return [expr int($min + rand() * ($max - $min))]
}

proc main {} {
  indent [process [read stdin]]
}

main




