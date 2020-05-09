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
namespace eval ::tclhdl::modelsim {
 
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
    variable project_synth                  "lse"
    variable project_impl                   "impl1"
    variable project_constr
    variable project_sim
    variable project_flow_synth
    variable project_flow_impl              
    variable project_jobs                   "4"

    variable output_root       ""
    variable output_dir       ""
    variable output_type      ""
    variable component_name   ""
    variable component_value  ""
    variable component_param  ""
    variable report_file      ""
    variable system_info      ""

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
proc ::tclhdl::modelsim::open_project {args} {
    global ::tclhdl::modelsim::is_project_closed
    global ::tclhdl::modelsim::is_project_assignments
    global ::tclhdl::modelsim::project_part
    global ::tclhdl::modelsim::project_synth
    global ::tclhdl::modelsim::project_synth_flow
    global ::tclhdl::modelsim::project_impl
    global ::tclhdl::modelsim::project_impl_flow
    global ::tclhdl::modelsim::project_fileset_source
    global ::tclhdl::modelsim::project_fileset_constraint
    global ::tclhdl::modelsim::project_fileset_simulation
    set current_dir [pwd]

    log::log debug "modelsim::open_project: Trying to open project $::tclhdl::modelsim::project_name"

    if { [file exists "$::tclhdl::modelsim::project_name.ldf"] } {
        log::log debug "modelsim::open_project: We are at $current_dir"
        log::log debug "modelsim::open_project: Open project $::tclhdl::modelsim::project_name.ldf"
        prj_project open "$::tclhdl::modelsim::project_name.ldf"
        set ::tclhdl::modelsim::is_project_closed 1
    } else {
        log::log debug "modelsim::open_project: New project $::tclhdl::modelsim::project_name"
        prj_project new -name "$::tclhdl::modelsim::project_name"\
            -impl "$::tclhdl::modelsim::project_impl"\
            -synthesis "$::tclhdl::modelsim::project_synth"
        #-- Set Project to Close
        set ::tclhdl::modelsim::is_project_closed 1
    }
}

#------------------------------------------------------------------------------
## Close Project
#
#------------------------------------------------------------------------------
proc ::tclhdl::modelsim::close_project {} {
    global ::tclhdl::modelsim::is_project_closed
    global ::tclhdl::modelsim::is_project_assignments

    log::log debug "modelsim::project_close:: Closing project $::tclhdl::modelsim::project_name"

    if {$::tclhdl::modelsim::is_project_closed} {
        log::log debug "modelsim::project_close:: Project Closed"
        prj_project save
        prj_project close
    }
}

#------------------------------------------------------------------------------
## 
#------------------------------------------------------------------------------
proc ::tclhdl::modelsim::set_project_name {name} {
    global ::tclhdl::modelsim::project_name
    set ::tclhdl::modelsim::project_name $name
}

proc ::tclhdl::modelsim::set_project_revision {rev} {
    global ::tclhdl::modelsim::project_revision
    set ::tclhdl::modelsim::project_revision $rev
}

proc ::tclhdl::modelsim::set_project_part {part} {
    global ::tclhdl::modelsim::project_part
    set ::tclhdl::modelsim::project_part $part
}

proc ::tclhdl::modelsim::set_project_build_dir {dir} {
    global ::tclhdl::modelsim::project_build_dir
    set ::tclhdl::modelsim::project_build_dir $dir
}

proc ::tclhdl::modelsim::set_project_settings {settings} {
    global ::tclhdl::modelsim::project_settings
    set ::tclhdl::modelsim::project_settings $settings
}

proc ::tclhdl::modelsim::set_project_synth {synth} {
    global ::tclhdl::modelsim::project_synth
    set ::tclhdl::modelsim::project_synth $synth
}

proc ::tclhdl::modelsim::set_project_impl {impl} {
    global ::tclhdl::modelsim::project_impl
    set ::tclhdl::modelsim::project_impl $impl
}

proc ::tclhdl::modelsim::set_project_constr {constr} {
    global ::tclhdl::modelsim::project_constr
    set ::tclhdl::modelsim::project_constr $constr
}

proc ::tclhdl::modelsim::set_project_sim {sim} {
    global ::tclhdl::modelsim::project_sim
    set ::tclhdl::modelsim::project_sim $sim
}

proc ::tclhdl::modelsim::set_project_flow_synth {flow} {
    global ::tclhdl::modelsim::project_flow_synth
    set ::tclhdl::modelsim::project_flow_synth $flow
}

proc ::tclhdl::modelsim::set_project_flow_impl {flow} {
    global ::tclhdl::modelsim::project_flow_impl
    set ::tclhdl::modelsim::project_flow_impl $flow
}

#------------------------------------------------------------------------------
## Run Ip Build
#
#------------------------------------------------------------------------------
proc ::tclhdl::modelsim::build_ip {} {
    log::log debug "modelsim::build_ip : launch coregen"
}

#-------------------------------------------------------------------------------
## Adding Source Files
#
#-------------------------------------------------------------------------------
proc ::tclhdl::modelsim::source_add {type src} {
    log::log debug "modelsim::source_add: Add $type - $src"
    prj_src add -format $type $src
}

#------------------------------------------------------------------------------
## Get Version
#
#------------------------------------------------------------------------------
proc ::tclhdl::modelsim::get_version {} {
   puts $tclhdl::modelsim::version
}

#------------------------------------------------------------------------------
## Package Declaration
#
#------------------------------------------------------------------------------
package provide ::tclhdl::modelsim $tclhdl::modelsim::version

