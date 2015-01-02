# -*-tcl-*- \
	exec tclsh "$0" "$@"
#
# make-plan.tcl - a very simple TCL based template
#   program based on substify from wiki.tcl.tk. 
#
# The basic idea is break the input into lines where:
#
# *... is TCL code and is just added to the program
# ...  is anything else that is some TCL code to append this line
# 
# Then finally we eval the generated program.
#
# For example:
#
# *foreach a {1 2 3} {
#   hello ${a}
# *}
#
# generates
#
#  hello 1
#  hello 2
#  hello 3
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

proc substify {in var} {
  set script ""
  set pos 0
  foreach pair [regexp -line -all -inline -indices {^[*].*$} $in] {
    foreach {from to} $pair break
    set s [string range $in $pos [expr {$from - 2}]]
    if {[string length $s] > 0} {
      append script "append $var \[" [list subst $s] "]\n" 
      append script "append $var \\n\n"
    }
    append script "[string range $in [expr {$from+1}] $to]\n" 
    set pos [expr {$to+2}]
  }
  set s [string range $in $pos end]
  if {[string length $s] > 0} {
    append script "append $var \[" [list subst "$s\n" ] "]\n"
  }
  return $script
}

proc main {} {
  set output ""
  set prog [substify [read stdin] output]
  if {$::options(-show_prog)} {
    puts $prog
  }
  if {[catch [list eval $prog] r]} {
    puts "failed with $r $::errorInfo"
  } else {
    puts $output
  }
}

main




