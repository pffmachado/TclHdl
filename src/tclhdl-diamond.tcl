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
namespace eval ::tclhdl::diamond {
 
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
proc ::tclhdl::diamond::open_project {args} {
    global ::tclhdl::diamond::is_project_closed
    global ::tclhdl::diamond::is_project_assignments
    global ::tclhdl::diamond::project_part
    global ::tclhdl::diamond::project_synth
    global ::tclhdl::diamond::project_synth_flow
    global ::tclhdl::diamond::project_impl
    global ::tclhdl::diamond::project_impl_flow
    global ::tclhdl::diamond::project_fileset_source
    global ::tclhdl::diamond::project_fileset_constraint
    global ::tclhdl::diamond::project_fileset_simulation
    set current_dir [pwd]

    log::log debug "diamond::open_project: Trying to open project $::tclhdl::diamond::project_name"

    if { [file exists "$::tclhdl::diamond::project_name.ldf"] } {
        log::log debug "diamond::open_project: We are at $current_dir"
        log::log debug "diamond::open_project: Open project $::tclhdl::diamond::project_name.ldf"
        prj_project open "$::tclhdl::diamond::project_name.ldf"
        set ::tclhdl::diamond::is_project_closed 1
    } else {
        log::log debug "diamond::open_project: New project $::tclhdl::diamond::project_name"
        prj_project new -name "$::tclhdl::diamond::project_name"\
            -impl "$::tclhdl::diamond::project_impl"\
            -synthesis "$::tclhdl::diamond::project_synth"
        #-- Set Project to Close
        set ::tclhdl::diamond::is_project_closed 1
    }
}

#------------------------------------------------------------------------------
## Close Project
#
#------------------------------------------------------------------------------
proc ::tclhdl::diamond::close_project {} {
    global ::tclhdl::diamond::is_project_closed
    global ::tclhdl::diamond::is_project_assignments

    log::log debug "diamond::project_close:: Closing project $::tclhdl::diamond::project_name"

    if {$::tclhdl::diamond::is_project_closed} {
        log::log debug "diamond::project_close:: Project Closed"
        prj_project save
        prj_project close
    }
}

#------------------------------------------------------------------------------
## 
#------------------------------------------------------------------------------
proc ::tclhdl::diamond::set_project_name {name} {
    global ::tclhdl::diamond::project_name
    set ::tclhdl::diamond::project_name $name
}

proc ::tclhdl::diamond::set_project_revision {rev} {
    global ::tclhdl::diamond::project_revision
    set ::tclhdl::diamond::project_revision $rev
}

proc ::tclhdl::diamond::set_project_part {part} {
    global ::tclhdl::diamond::project_part
    set ::tclhdl::diamond::project_part $part
}

proc ::tclhdl::diamond::set_project_build_dir {dir} {
    global ::tclhdl::diamond::project_build_dir
    set ::tclhdl::diamond::project_build_dir $dir
}

proc ::tclhdl::diamond::set_project_settings {settings} {
    global ::tclhdl::diamond::project_settings
    set ::tclhdl::diamond::project_settings $settings
}

proc ::tclhdl::diamond::set_project_synth {synth} {
    global ::tclhdl::diamond::project_synth
    set ::tclhdl::diamond::project_synth $synth
}

proc ::tclhdl::diamond::set_project_impl {impl} {
    global ::tclhdl::diamond::project_impl
    set ::tclhdl::diamond::project_impl $impl
}

proc ::tclhdl::diamond::set_project_constr {constr} {
    global ::tclhdl::diamond::project_constr
    set ::tclhdl::diamond::project_constr $constr
}

proc ::tclhdl::diamond::set_project_sim {sim} {
    global ::tclhdl::diamond::project_sim
    set ::tclhdl::diamond::project_sim $sim
}

proc ::tclhdl::diamond::set_project_flow_synth {flow} {
    global ::tclhdl::diamond::project_flow_synth
    set ::tclhdl::diamond::project_flow_synth $flow
}

proc ::tclhdl::diamond::set_project_flow_impl {flow} {
    global ::tclhdl::diamond::project_flow_impl
    set ::tclhdl::diamond::project_flow_impl $flow
}

#------------------------------------------------------------------------------
## Run Ip Build
#
#------------------------------------------------------------------------------
proc ::tclhdl::diamond::build_ip {} {
    log::log debug "diamond::build_ip : launch coregen"
}

#------------------------------------------------------------------------------
## Run Synthesis
#
#------------------------------------------------------------------------------
proc ::tclhdl::diamond::build_synthesis {} {
    log::log debug "diamond::build_synthesis : launch synthesis - $::tclhdl::diamond::project_impl"
    #TODO: Very ugly hook! It happens on diamond the synthesis it seams be 
    #spawn in other process which exits from tclhdl once finished.
    set hook [open "hook.tcl" "w"]
    puts $hook "prj_project open $::tclhdl::diamond::project_name.ldf"
    puts $hook "prj_run Synthesis -impl $::tclhdl::diamond::project_impl -forceAll"
    puts $hook "prj_project close"
    close $hook
    if { $::runtime_system == "Linux" } {
        exec diamondc hook.tcl
    } elseif { $::runtime_system == "Windows NT" } {
        exec pnmainc hook.tcl
    } else {
        log::log debug "diamond::build_synthesis : Platform not identified"
    }
}

#------------------------------------------------------------------------------
## Run Fitting/Implementation
#
#------------------------------------------------------------------------------
proc ::tclhdl::diamond::build_fitting {} {
    log::log debug "diamond::build_fitting : launch implementation"
    prj_run Translate -impl "$::tclhdl::diamond::project_impl"
    prj_run Map -impl "$::tclhdl::diamond::project_impl"
    prj_run PAR -impl "$::tclhdl::diamond::project_impl"
}

#------------------------------------------------------------------------------
## Run Timing Analysis
#
#------------------------------------------------------------------------------
proc ::tclhdl::diamond::build_timing {} {
    log::log debug "diamond::build_timing : launch timing analysis"
    prj_run Map -impl "$::tclhdl::diamond::project_impl" -task MapTrace
    prj_run PAR -impl "$::tclhdl::diamond::project_impl" -task PARTrace
    prj_run PAR -impl "$::tclhdl::diamond::project_impl" -task IOTiming
}

#------------------------------------------------------------------------------
## Run Generate Bitstream
#
#------------------------------------------------------------------------------
proc ::tclhdl::diamond::build_bitstream {} {
    set project_top $::tclhdl::diamond::project_name
    set project_output "output"
    set project_report "report"
    set artifact_name $project_top
    set artifact_dir $project_output

    file mkdir "$project_output"
    foreach fileIdx [glob -nocomplain "$project_output/*"] {
        eval file delete -force $fileIdx
    }

    log::log debug "diamond::build_bitstream : launch bitstream"
    prj_run Export -impl "$::tclhdl::diamond::project_impl" -task Bitgen
    prj_run Export -impl "$::tclhdl::diamond::project_impl" -task Jedecgen

    set fileId [open $artifact_name.semver "w"]
    puts -nonewline $fileId $::tclhdl::project_version
    close $fileId

    log::log debug "diamond::build_bitstream : copy artifacts to output dir"
    file copy -force "$::tclhdl::diamond::project_impl/${artifact_name}_${::tclhdl::diamond::project_impl}.bit"\
        "$artifact_dir/$artifact_name.bit"
    file copy -force "$::tclhdl::diamond::project_impl/${artifact_name}_${::tclhdl::diamond::project_impl}.jed"\
        "$artifact_dir/$artifact_name.jed"
    file copy -force "$artifact_name.semver"      "$artifact_dir"

    log::log debug "diamond::build_bitstream : adding checksum to artifacts"
    set file_list [glob "$artifact_dir/$artifact_name*"]
    foreach fileIdx $file_list {
        ::tclhdl::utils::checksum $fileIdx
    }
}

#------------------------------------------------------------------------------
## Run Report Generation
#
#------------------------------------------------------------------------------
proc ::tclhdl::diamond::build_report {} {
    set project_top "$::tclhdl::diamond::project_impl/$::tclhdl::diamond::project_name"
    set report_dir "report"

    log::log debug "lattice::build_report: launch report generation"

    log::log debug "lattice::build_report: synthesis copy reports to output folder"
    file mkdir "$report_dir"
    file copy -force "$::tclhdl::diamond::project_impl/stdout.log" "$report_dir"
    file copy -force "$::tclhdl::diamond::project_impl/automake.log" "$report_dir"
    file copy -force "${project_top}_${::tclhdl::diamond::project_impl}.twr" "$report_dir"
    file copy -force "${project_top}_${::tclhdl::diamond::project_impl}.par" "$report_dir"
    file copy -force "${project_top}_${::tclhdl::diamond::project_impl}.pad" "$report_dir"
    file copy -force "${project_top}_${::tclhdl::diamond::project_impl}.mrp" "$report_dir"
    file copy -force "${project_top}_${::tclhdl::diamond::project_impl}.bgn" "$report_dir"
    file copy -force "${project_top}_${::tclhdl::diamond::project_impl}.srf" "$report_dir"
    file copy -force "${project_top}_${::tclhdl::diamond::project_impl}.srr" "$report_dir"
    file copy -force "${project_top}_${::tclhdl::diamond::project_impl}_map.hrr" "$report_dir"
}

#------------------------------------------------------------------------------
## IP Generate
#
#------------------------------------------------------------------------------
proc ::tclhdl::diamond::ip_generate {} {
    log::log debug "ip_generate: Generate $::tclhdl::diamond::ip_type for $::tclhdl::diamond::ip_name"
}

proc ::tclhdl::diamond::set_project_top {value} {
}

#-------------------------------------------------------------------------------
## Adding Source Files
#
#-------------------------------------------------------------------------------
proc ::tclhdl::diamond::source_add {type src} {
    log::log debug "diamond::source_add: Add $type - $src"
    prj_src add -format $type $src
}

#-------------------------------------------------------------------------------
## Adding IP Files
#
#-------------------------------------------------------------------------------
proc ::tclhdl::diamond::ip_add {type src} {
    log::log debug "diamond::ip_add: Add $type $src"
    if { $type == "IPX" } {
        prj_src add $src
    } else {
        log::log debug "diamond::ip_add: IP type ($type) not recognized"
    }
}

#-------------------------------------------------------------------------------
## Adding Constraint Files
#
#-------------------------------------------------------------------------------
proc ::tclhdl::diamond::constraint_add {type src} {
    log::log debug "diamond::constraint_add: Add $type $src"
     if { $type == "LPF" } {
        prj_src add -format $type $src
        prj_src enable $src
    } else {
        log::log debug "diamond::constraint_add: Constraint type ($type) not recognized"
    }
}

#------------------------------------------------------------------------------
## Get Version
#
#------------------------------------------------------------------------------
proc ::tclhdl::diamond::get_version {} {
   puts $tclhdl::diamond::version
}

#------------------------------------------------------------------------------
## Package Declaration
#
#------------------------------------------------------------------------------
package provide ::tclhdl::diamond $tclhdl::diamond::version

