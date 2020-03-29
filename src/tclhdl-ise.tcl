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
#-- Project  :  
#-- Filename :  
#-- Author   :  
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

package require ::tclhdl::definitions

#------------------------------------------------------------------------------
## Namespace Declaration
#------------------------------------------------------------------------------
namespace eval ::tclhdl::ise {
 
    #--------------------------------------------------------------------------
    #-- Export Procedures
    #--------------------------------------------------------------------------
    namespace export get_version

    namespace export open_project
    namespace export close_project

    namespace export set_project_name
    namespace export set_project_revision
    namespace export set_project_settings
    namespace export set_project_part
    namespace export set_project_build_dir
    namespace export set_project_settings
    namespace export set_project_synth
    namespace export set_project_impl
    namespace export set_project_constr
    namespace export set_project_sim
    namespace export set_project_flow_synth
    namespace export set_project_flow_impl

    namespace export build_synthesis
    namespace export build_fitting
    namespace export build_timing
    namespace export build_bitstream
    namespace export build_report

    namespace export ip_set_name
    namespace export ip_set_type
    namespace export ip_set_output_root
    namespace export ip_set_output_dir
    namespace export ip_set_output_type
    namespace export ip_set_component_name
    namespace export ip_set_component_param
    namespace export ip_set_system_info
    namespace export ip_set_report_file
    namespace export ip_set_synthesis
    namespace export ip_set_language
    namespace export ip_get_info 
    namespace export ip_generate 
    namespace export ip_add

    #---------------------------------------------------------------------------
    #-- Member Variables 
    #---------------------------------------------------------------------------
    variable is_project_closed 0
    variable project_name
    variable project_revision
    variable project_part
    variable project_build_dir
    variable project_settings
    variable project_synth                  "synth_1"
    variable project_synth_flow             "Vivado Synthesis Defaults"
    variable project_impl                   "impl_1"
    variable project_impl_flow              "Vivado Implementation Defaults"
    variable project_constr
    variable project_sim
    variable project_flow_synth
    variable project_flow_impl              
    variable project_fileset_source         "sources_1"
    variable project_fileset_constraint     "constrs_1"
    variable project_fileset_simulation     "sim_1"
    variable project_jobs                   "4"

    variable ip_name          ""
    variable ip_type          INTEL_IP
    variable ip_coregen_project ""
    variable output_root       ""
    variable output_dir       ""
    variable output_type      ""
    variable component_name   ""
    variable component_value  ""
    variable component_param  ""
    variable report_file      ""
    variable system_info      ""
    variable language         "VERILOG"
    variable synthesis        "--synthesis=VERILOG"

    #--------------------------------------------------------------------------
    #-- Namespace internal variables
    #--------------------------------------------------------------------------
    variable home [file join [pwd] [file dirname [info script]]]
    set version 1.0
}
 
#------------------------------------------------------------------------------
## Open Project
#
#------------------------------------------------------------------------------
proc ::tclhdl::ise::open_project {args} {
    global ::tclhdl::ise::is_project_closed
    global ::tclhdl::ise::is_project_assignments
    global ::tclhdl::ise::project_part
    global ::tclhdl::ise::project_synth
    global ::tclhdl::ise::project_synth_flow
    global ::tclhdl::ise::project_impl
    global ::tclhdl::ise::project_impl_flow
    global ::tclhdl::ise::project_fileset_source
    global ::tclhdl::ise::project_fileset_constraint
    global ::tclhdl::ise::project_fileset_simulation
    set current_dir [pwd]

    log::log debug "ise::open_project: Trying to open project $::tclhdl::ise::project_name"

    if { [file exists "$::tclhdl::ise::project_name.xise"] } {
        log::log debug "ise::open_project: We are at $current_dir"
        log::log debug "ise::open_project: Open project $::tclhdl::ise::project_name.xise"
        project open "$::tclhdl::ise::project_name.xise"
        set ::tclhdl::ise::is_project_closed 1
    } else {
        log::log debug "ise::open_project: New project $::tclhdl::ise::project_name"
        project new $::tclhdl::ise::project_name
        project set "Cores Search Directories" "$::tclhdl::project_build_ip_dir" -process "Synthesize - XST"
        project set "Work Directory" "$current_dir/xst" -process "Synthesize - XST"

        #-- Set Project to Close
        set ::tclhdl::ise::is_project_closed 1
    }
}

#------------------------------------------------------------------------------
## Close Project
#
#------------------------------------------------------------------------------
proc ::tclhdl::ise::close_project {} {
    global ::tclhdl::ise::is_project_closed
    global ::tclhdl::ise::is_project_assignments

    log::log debug "ise::project_close:: Closing project $::tclhdl::ise::project_name"

    if {$::tclhdl::ise::is_project_closed} {
        log::log debug "ise::project_close:: Project Closed"
        project save
        project close
    }
}

#------------------------------------------------------------------------------
## 
#------------------------------------------------------------------------------
proc ::tclhdl::ise::set_project_name {name} {
    global ::tclhdl::ise::project_name
    set ::tclhdl::ise::project_name $name
}

proc ::tclhdl::ise::set_project_revision {rev} {
    global ::tclhdl::ise::project_revision
    set ::tclhdl::ise::project_revision $rev
}

proc ::tclhdl::ise::set_project_part {part} {
    global ::tclhdl::ise::project_part
    set ::tclhdl::ise::project_part $part
}

proc ::tclhdl::ise::set_project_build_dir {dir} {
    global ::tclhdl::ise::project_build_dir
    set ::tclhdl::ise::project_build_dir $dir
}

proc ::tclhdl::ise::set_project_settings {settings} {
    global ::tclhdl::ise::project_settings
    set ::tclhdl::ise::project_settings $settings
}

proc ::tclhdl::ise::set_project_synth {synth} {
    global ::tclhdl::ise::project_synth
    set ::tclhdl::ise::project_synth $synth
}

proc ::tclhdl::ise::set_project_impl {impl} {
    global ::tclhdl::ise::project_impl
    set ::tclhdl::ise::project_impl $impl
}

proc ::tclhdl::ise::set_project_constr {constr} {
    global ::tclhdl::ise::project_constr
    set ::tclhdl::ise::project_constr $constr
}

proc ::tclhdl::ise::set_project_sim {sim} {
    global ::tclhdl::ise::project_sim
    set ::tclhdl::ise::project_sim $sim
}

proc ::tclhdl::ise::set_project_flow_synth {flow} {
    global ::tclhdl::ise::project_flow_synth
    set ::tclhdl::ise::project_flow_synth $flow
}

proc ::tclhdl::ise::set_project_flow_impl {flow} {
    global ::tclhdl::ise::project_flow_impl
    set ::tclhdl::ise::project_flow_impl $flow
}

#------------------------------------------------------------------------------
## Run Ip Build
#
#------------------------------------------------------------------------------
proc ::tclhdl::ise::build_ip {} {
    log::log debug "ise::build_ip : launch coregen"
    process run "Regenerate All Cores"
}

#------------------------------------------------------------------------------
## Run Synthesis
#
#------------------------------------------------------------------------------
proc ::tclhdl::ise::build_synthesis {} {
    log::log debug "ise::build_synthesis : launch synthesis"
    process run "Synthesize - XST"
}

#------------------------------------------------------------------------------
## Run Fitting/Implementation
#
#------------------------------------------------------------------------------
proc ::tclhdl::ise::build_fitting {} {
    log::log debug "ise::build_fitting : launch implementation"
    process run "Implement Design"
}

#------------------------------------------------------------------------------
## Run Timing Analysis
#
#------------------------------------------------------------------------------
proc ::tclhdl::ise::build_timing {} {
    log::log debug "ise::build_timing : launch timing analysis"
}

#------------------------------------------------------------------------------
## Run Generate Bitstream
#
#------------------------------------------------------------------------------
proc ::tclhdl::ise::build_bitstream {} {
    log::log debug "ise::build_bitstream : launch bitstream"
    process run "Generate Programming File"
}

#------------------------------------------------------------------------------
## Run Report Generation
#
#------------------------------------------------------------------------------
proc ::tclhdl::ise::build_report {} {
    log::log debug "ise::build_report : launch report generation"
}

#------------------------------------------------------------------------------
## IP Generate
#
#------------------------------------------------------------------------------
proc ::tclhdl::ise::ip_generate {} {
    log::log debug "ip_generate: Generate $::tclhdl::ise::ip_type for $::tclhdl::ise::ip_name"
}

proc ::tclhdl::ise::set_project_top {value} {
    set obj [get_filesets sources_1]
    set_property "top" $value $obj
}

#-------------------------------------------------------------------------------
## Adding Source Files
#
#-------------------------------------------------------------------------------
proc ::tclhdl::ise::source_add {type src} {
    log::log debug "ise::source_add: Add $type - $src"
    if { $type != "TCL" } {
        xfile add $src
    } else {
        log::log debug "ise::source_add: source tcl"
        source $src
    }

}

#-------------------------------------------------------------------------------
## Adding IP Files
#
#-------------------------------------------------------------------------------
proc ::tclhdl::ise::ip_add {type src} {
    global ::tclhdl::ise::ip_coregen_project

    set ip_dir $::tclhdl::project_build_ip_dir
    set filename [file tail $src]
    set filext [file extension $src]
    set src_new $ip_dir/$filename
    file copy -force $src $src_new

    log::log debug "ise::ip_add: Add $type $src $filext"
    if { $type == "XCO" && $filext == ".xco" } {
        log::log debug "ise::ip_add: run coregen - $::tclhdl::ise::ip_coregen_project"
        xfile add $src_new
        #if { $upgrade == "UPGRADE" } {
            if { [catch { eval exec coregen -p $::tclhdl::ise::ip_coregen_project -b $src -intstyle ise -u }] } {
                log::log debug "ise::ip_add: done"
            }
        #}
    } elseif { $type == "COREGEN" } {
        log::log debug "ise::ip_add: add coregen"
        set ::tclhdl::ise::ip_coregen_project "$src_new"

    } else {
        log::log debug "ise::ip_add: add $filext"
    }
}

#-------------------------------------------------------------------------------
## Adding Constraint Files
#
#-------------------------------------------------------------------------------
proc ::tclhdl::ise::constraint_add {type src} {
    log::log debug "ise::constraint_add: Add $type $src"
    xfile add $src
}

#------------------------------------------------------------------------------
## Get Version
#
#------------------------------------------------------------------------------
proc ::tclhdl::ise::get_version {} {
   puts $tclhdl::ise::version
}

#------------------------------------------------------------------------------
## Package Declaration
#
#------------------------------------------------------------------------------
package provide ::tclhdl::ise $tclhdl::ise::version

