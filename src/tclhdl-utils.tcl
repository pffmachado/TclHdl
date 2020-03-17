#------------------------------------------------------------------------------
#-- Copyright (c) 2020 TCLHDL
#-- 
#-- Permission is hereby granted, free of charge, to any person obtaining a copy
#-- of this software and associated documentation files (the "Software"), to deal
#-- in the Software without restriction, including without limitation the rights
#-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#-- copies of the Software, and to permit persons to whom the Software is
#-- furnished to do so, subject to the following conditions:
#-- 
#-- The above copyright notice and this permission notice shall be included in all
#-- copies or substantial portions of the Software.
#-- 
#-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#-- SOFTWARE.
#------------------------------------------------------------------------------
#-- Project  : TCLHDL
#-- Author   : Paulo Machado <pffmachado@yahoo.com> 
#-- Filename : tclhdl.tcl 
#------------------------------------------------------------------------------
#-- File Description:
#--
#--
#--
#--
#------------------------------------------------------------------------------
#-- ChangeLog:
#--
#--
#--
#--
#------------------------------------------------------------------------------
## \file tclhdl-utils.tcl
# 
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
#-- Tcl System Packages
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
## Namespace Declaration
#------------------------------------------------------------------------------
namespace eval ::tclhdl::utils {
 
    #--------------------------------------------------------------------------
    #-- Export Procedures
    #--------------------------------------------------------------------------
    namespace export get_version

    namespace export sed
    namespace export grep
    namespace export diff
    namespace export patch
    namespace export git

    #--------------------------------------------------------------------------
    #-- Namespace internal variables
    #--------------------------------------------------------------------------
    variable home [file join [pwd] [file dirname [info script]]]
    set version 1.0
}

#------------------------------------------------------------------------------
## Sed like
#
#------------------------------------------------------------------------------
proc ::tclhdl::utils::sed {script input} {
    set sep [string index $script 1]
    foreach {cmd from to flag} [split $script $sep] break
    switch -- $cmd {
        "s" {
            set cmd regsub
            if {[string first "g" $flag]>=0} {
                lappend cmd -all
            }
            if {[string first "i" [string tolower $flag]]>=0} {
                lappend cmd -nocase
            }
            set idx [regsub -all -- {[a-zA-Z]} $flag ""]
            if { [string is integer -strict $idx] } {
                set cmd [lreplace $cmd 0 0 regexp]
                lappend cmd -inline -indices -all -- $from $input
                set res [eval $cmd]
                set which [lindex $res $idx]
                return [string replace $input [lindex $which 0] [lindex $which 1] $to]
            }
            # Most generic case
            lappend cmd -- $from $input $to
            return [eval $cmd]
        }
        "e" {
            set cmd regexp
            if { $to eq "" } { set to 0 }
            if {![string is integer -strict $to]} {
                return -error code "No proper group identifier specified for extraction"
            }
            lappend cmd -inline -- $from $input
            return [lindex [eval $cmd] $to]
        }
        "y" {
            return [string map [list $from $to] $input]
        }
    }
    return -code error "not yet implemented"
}

#------------------------------------------------------------------------------
## Grep like
#
#------------------------------------------------------------------------------
proc ::tclhdl::utils::grep {REset fp} {
    while {[gets $fp line] >= 0} {
        foreach RE $REset {
            if {[regexp $RE $line]} {
                puts $line
                break
            }
        }
    }
}
#------------------------------------------------------------------------------
## Get Version
#
#------------------------------------------------------------------------------
proc ::tclhdl::utils::get_version {} {
   puts $tclhdl::utils::version
}

#------------------------------------------------------------------------------
## Package Declaration
#
#------------------------------------------------------------------------------
package provide ::tclhdl::utils $tclhdl::utils::version

