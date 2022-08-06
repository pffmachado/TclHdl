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
package require ::tclhdl::utils

#------------------------------------------------------------------------------
## Namespace Declaration
#------------------------------------------------------------------------------
namespace eval ::tclhdl::libero {
 
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
    namespace export set_project_top

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
    variable project_top

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
proc ::tclhdl::libero::open_project {args} {
    global ::tclhdl::libero::is_project_closed
    global ::tclhdl::libero::is_project_assignments
    global ::tclhdl::libero::project_name
    global ::tclhdl::libero::project_part
    global ::tclhdl::libero::project_synth
    global ::tclhdl::libero::project_synth_flow
    global ::tclhdl::libero::project_impl
    global ::tclhdl::libero::project_impl_flow
    global ::tclhdl::libero::project_fileset_source
    global ::tclhdl::libero::project_fileset_constraint
    global ::tclhdl::libero::project_fileset_simulation
    set current_dir [pwd]

    log::log debug "libero::open_project: Trying to open project $::tclhdl::libero::project_name"

    if { [file exists "$::tclhdl::libero::project_name.prjx"] } {
        log::log debug "libero::open_project: We are at $current_dir"
        log::log debug "libero::open_project: Open project $::tclhdl::libero::project_name.prjx"
        #-- Confliting proc name! Namespace needs to be forced.
        namespace eval :: {
            open_project "$::tclhdl::libero::project_name.prjx"
            }
        set ::tclhdl::libero::is_project_closed 1
    } else {
        log::log debug "libero::open_project: New project $::tclhdl::libero::project_name"
        file delete -force "$::tclhdl::project_build_dir"
        new_project -name "$::tclhdl::libero::project_name" \
                      -location "$::tclhdl::project_build_dir" \
                      -hdl "VHDL" \
                      -family "PolarFire" \
                      -die "MPF100T"

        #-- Set Project to Close
        set ::tclhdl::libero::is_project_closed 1

        #-- Vault Specification
        log::log debug "libero::open_project: Force Vault at $current_dir/vault"
        file delete -force "$::env(HOME)/.config/Actel"
        file delete -force {*}[glob $::env(HOME)/.actel*]
        file mkdir "$current_dir/vault"
        change_vault_location -location "$current_dir/vault"
    }

}

#------------------------------------------------------------------------------
## Close Project
#
#------------------------------------------------------------------------------
proc ::tclhdl::libero::close_project {} {
    global ::tclhdl::libero::is_project_closed
    global ::tclhdl::libero::is_project_assignments

    log::log debug "libero::project_close:: Closing project $::tclhdl::libero::project_name"

    if {$::tclhdl::libero::is_project_closed} {
        log::log debug "libero::project_close:: Project Closed"
        namespace eval :: {
            save_project
            close_project
        }
    }
}

#------------------------------------------------------------------------------
## 
#------------------------------------------------------------------------------
proc ::tclhdl::libero::set_project_name {name} {
    global ::tclhdl::libero::project_name
    set ::tclhdl::libero::project_name $name
}

proc ::tclhdl::libero::set_project_revision {rev} {
    global ::tclhdl::libero::project_revision
    set ::tclhdl::libero::project_revision $rev
}

proc ::tclhdl::libero::set_project_part {part} {
    global ::tclhdl::libero::project_part
    set ::tclhdl::libero::project_part $part
}

proc ::tclhdl::libero::set_project_build_dir {dir} {
    global ::tclhdl::libero::project_build_dir
    set ::tclhdl::libero::project_build_dir $dir
}

proc ::tclhdl::libero::set_project_settings {settings} {
    global ::tclhdl::libero::project_settings
    set ::tclhdl::libero::project_settings $settings
}

proc ::tclhdl::libero::set_project_synth {synth} {
    global ::tclhdl::libero::project_synth
    set ::tclhdl::libero::project_synth $synth
}

proc ::tclhdl::libero::set_project_impl {impl} {
    global ::tclhdl::libero::project_impl
    set ::tclhdl::libero::project_impl $impl
}

proc ::tclhdl::libero::set_project_constr {constr} {
    global ::tclhdl::libero::project_constr
    set ::tclhdl::libero::project_constr $constr
}

proc ::tclhdl::libero::set_project_sim {sim} {
    global ::tclhdl::libero::project_sim
    set ::tclhdl::libero::project_sim $sim
}

proc ::tclhdl::libero::set_project_flow_synth {flow} {
    global ::tclhdl::libero::project_flow_synth
    set ::tclhdl::libero::project_flow_synth $flow
}

proc ::tclhdl::libero::set_project_flow_impl {flow} {
    global ::tclhdl::libero::project_flow_impl
    set ::tclhdl::libero::project_flow_impl $flow
}

#-- NOTE: Apparently there is no call for getting the toplevel name.
proc ::tclhdl::libero::set_project_top {top} {
    global ::tclhdl::libero::project_top
    set ::tclhdl::libero::project_top $top
}

#------------------------------------------------------------------------------
## Run Ip Build
#
#------------------------------------------------------------------------------
proc ::tclhdl::libero::build_ip {} {
    log::log debug "libero::build_ip : launch coregen"
}

#------------------------------------------------------------------------------
## Run Synthesis
#
#------------------------------------------------------------------------------
proc ::tclhdl::libero::build_synthesis {} {
    log::log debug "libero::build_synthesis : launch synthesis - $::tclhdl::libero::project_impl"
    cleanall_tool -name {SYNTHESIZE}
    run_tool -name {SYNTHESIZE}
}

#------------------------------------------------------------------------------
## Run Fitting/Implementation
#
#------------------------------------------------------------------------------
proc ::tclhdl::libero::build_fitting {} {
    log::log debug "libero::build_fitting : launch implementation"
    run_tool -name {PLACEROUTE}
}

#------------------------------------------------------------------------------
## Run Timing Analysis
#
#------------------------------------------------------------------------------
proc ::tclhdl::libero::build_timing {} {
    log::log debug "libero::build_timing : launch timing analysis"
    run_tool -name {VERIFYTIMING}
}

#------------------------------------------------------------------------------
## Run Generate Bitstream
#
#------------------------------------------------------------------------------
proc ::tclhdl::libero::build_bitstream {} {
    log::log debug "libero::build_bitstream : launch bitstream"
    run_tool -name {GENERATEPROGRAMMINGFILE}
}

#------------------------------------------------------------------------------
## Run Report Generation
#
#------------------------------------------------------------------------------
proc ::tclhdl::libero::build_report {} {
    global ::tclhdl::libero::project_top
    set project_top $::tclhdl::libero::project_top
    set project_report "report"
    set project_design "designer/${project_top}"
    set artifact_name $project_top

    log::log debug "libero::build_report: create report"
    file mkdir "$project_report"

    log::log debug "libero::build_report: copy log files"
    foreach fileIdx [glob -nocomplain "${project_design}/${project_top}_*.log"] {
        eval file copy -force $fileIdx $project_report
    }

    log::log debug "libero::build_report: copy rpt files"
    foreach fileIdx [glob -nocomplain "${project_design}/${project_top}_*.rpt"] {
        eval file copy -force $fileIdx $project_report
    }
}

#------------------------------------------------------------------------------
## IP Generate
#
#------------------------------------------------------------------------------
proc ::tclhdl::libero::ip_generate {} {
    log::log debug "ip_generate: Generate $::tclhdl::libero::ip_type for $::tclhdl::libero::ip_name"
}

#-------------------------------------------------------------------------------
## Adding Source Files
#
#-------------------------------------------------------------------------------
proc ::tclhdl::libero::source_add {type src} {
    log::log debug "libero::source_add: Add $type - $src"
    create_links -hdl_source $src
}

#-------------------------------------------------------------------------------
## Adding IP Files
#
#-------------------------------------------------------------------------------
proc ::tclhdl::libero::ip_add {type src} {
    log::log debug "libero::ip_add: Add $type $src"
    if { $type == "CXF" } {
        import_component -file $src
    } elseif { $type == "IPTCL" } {
        source $src
    } else {
        log::log debug "libero::ip_add: IP type ($type) not recognized"
    }
}

#-------------------------------------------------------------------------------
## Adding Constraint Files
#
#-------------------------------------------------------------------------------
proc ::tclhdl::libero::constraint_add {type src} {
    log::log debug "libero::constraint_add: Add $type $src"
     if { $type == "SDC" } {
        create_links -sdc $src
    } elseif { $type == "DCF" } {
        create_links -dcf $src
    } elseif { $type == "PDC_FP" } {
        create_links -fp_pdc $src
    } elseif { $type == "PDC_IO" } {
        create_links -io_pdc $src
    } else {
        log::log debug "libero::constraint_add: Constraint type ($type) not recognized"
    }
}

#------------------------------------------------------------------------------
## Get Version
#
#------------------------------------------------------------------------------
proc ::tclhdl::libero::get_version {} {
   puts $tclhdl::libero::version
}

#------------------------------------------------------------------------------
## Package Declaration
#
#------------------------------------------------------------------------------
package provide ::tclhdl::libero $tclhdl::libero::version

