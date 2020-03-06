#------------------------------------------------------------------------------
#-- Copyright (c) 2019 OpenHh
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


package require ::quartus::project
package require ::quartus::flow
package require ::quartus::report
package require ::quartus::design

package require ::tclhdl::definitions

#------------------------------------------------------------------------------
## Namespace Declaration
#------------------------------------------------------------------------------
namespace eval ::tclhdl::quartus {
 
    #---------------------------------------------------------------------------
    #-- Export Procedures
    #---------------------------------------------------------------------------
    namespace export get_version

    namespace export open_project
    namespace export close_project

    namespace export set_project_name
    namespace export set_project_revision
    namespace export set_project_settings

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
    namespace export ip_set_qsys_script
    namespace export ip_set_qsys_file
    namespace export ip_set_synthesis
    namespace export ip_set_language
    namespace export ip_get_info 
    namespace export ip_generate 
    namespace export ip_add_qsys_component
    namespace export ip_add_qsys_hw

    #---------------------------------------------------------------------------
    #-- Member Variables 
    #---------------------------------------------------------------------------
    variable is_project_closed 0
    variable is_project_assignments 1
    variable project_name
    variable project_revision
    variable project_settings

    variable ip_name          ""
    variable ip_type          INTEL_IP
    variable output_root       ""
    variable output_dir       ""
    variable output_type      ""
    variable component_name   ""
    variable component_value  ""
    variable component_param  ""
    variable report_file      ""
    variable system_info      ""
    variable qsys_file        ""
    variable qsys_script      ""
    variable qsys_component   ""
    variable qsys_hw          ""
    variable language         "VERILOG"
    variable synthesis        "--synthesis=VERILOG"

    #---------------------------------------------------------------------------
    #-- Namespace internal variables
    #---------------------------------------------------------------------------
    variable home [file join [pwd] [file dirname [info script]]]
    set version 1.0
}
 

#------------------------------------------------------------------------------
## Get Version
#------------------------------------------------------------------------------
proc ::tclhdl::quartus::get_version {} {
   puts $tclhdl::quartus::version
}

#------------------------------------------------------------------------------
## Open Project
#------------------------------------------------------------------------------
proc ::tclhdl::quartus::open_project {args} {
    global ::tclhdl::quartus::is_project_closed
    global ::tclhdl::quartus::is_project_assignments

    log::log debug "intel::project_open:: Trying to open project $::tclhdl::quartus::project_name"
    if {[is_project_open]} {
        if {[string compare $quartus(project) "$::tclhdl::quartus::project_name"]} {
            set ::tclhdl::quartus::is_project_assignments 0
        }
    } else {
        if {[project_exists $::tclhdl::quartus::project_name]} {
            log::log debug "intel::project_open:: Open project $::tclhdl::quartus::project_name"
            project_open -revision $::tclhdl::quartus::project_revision $::tclhdl::quartus::project_name
        } else {
            log::log debug "intel::project_open:: New project $::tclhdl::quartus::project_name"
            project_new -revision $::tclhdl::quartus::project_revision $::tclhdl::quartus::project_name
        }
        set ::tclhdl::quartus::is_project_closed 1
    }
}

#------------------------------------------------------------------------------
## Close Project
#------------------------------------------------------------------------------
proc ::tclhdl::quartus::close_project {} {
    global ::tclhdl::quartus::is_project_closed
    global ::tclhdl::quartus::is_project_assignments

    log::log debug "intel::project_close:: Closing project $::tclhdl::quartus::project_name"
    if {$::tclhdl::quartus::is_project_assignments} {
        # Commit assignments
        log::log debug "intel::project_close:: Exporting Assignments"
        export_assignments

        # Close project
        if {$::tclhdl::quartus::is_project_closed} {
            log::log debug "intel::project_close:: Close Project"
            project_close
        }
    }
}

#------------------------------------------------------------------------------
## 
#------------------------------------------------------------------------------
proc ::tclhdl::quartus::set_project_name {name} {
    global ::tclhdl::quartus::project_name
    set ::tclhdl::quartus::project_name $name
}

#------------------------------------------------------------------------------
## 
#------------------------------------------------------------------------------
proc ::tclhdl::quartus::set_project_revision {rev} {
    global ::tclhdl::quartus::project_revision
    set ::tclhdl::quartus::project_revision $rev
}

#------------------------------------------------------------------------------
## 
#------------------------------------------------------------------------------
proc ::tclhdl::quartus::set_project_settings {settings} {
    global ::tclhdl::quartus::project_settings
    set ::tclhdl::quartus::project_settings $settings
}

#------------------------------------------------------------------------------
#--
#------------------------------------------------------------------------------
proc ::tclhdl::quartus::build_ip {} {
}

#------------------------------------------------------------------------------
#--
#------------------------------------------------------------------------------
proc ::tclhdl::quartus::build_all {} {
    execute_flow -compile
}

#------------------------------------------------------------------------------
#--
#------------------------------------------------------------------------------
proc ::tclhdl::quartus::build_synthesis {} {
    execute_module -tool map
}

#------------------------------------------------------------------------------
#--
#------------------------------------------------------------------------------
proc ::tclhdl::quartus::build_fitting {} {
    execute_module -tool fit
}

#------------------------------------------------------------------------------
#--
#------------------------------------------------------------------------------
proc ::tclhdl::quartus::build_timing {} {
    execute_module -tool sta
}

#------------------------------------------------------------------------------
#--
#------------------------------------------------------------------------------
proc ::tclhdl::quartus::build_bitstream {} {
    execute_module -tool asm
}

#------------------------------------------------------------------------------
#--
#------------------------------------------------------------------------------
proc ::tclhdl::quartus::build_report {} {

}

#------------------------------------------------------------------------------
#--
#------------------------------------------------------------------------------
proc ::tclhdl::quartus::ip_reset {} {
    global ::tclhdl::quartus::ip_name         
    global ::tclhdl::quartus::ip_type         
    global ::tclhdl::quartus::output_dir      
    global ::tclhdl::quartus::output_type     
    global ::tclhdl::quartus::component_name  
    global ::tclhdl::quartus::component_value 
    global ::tclhdl::quartus::component_param 
    global ::tclhdl::quartus::report_file     
    global ::tclhdl::quartus::system_info     
    global ::tclhdl::quartus::qsys_file       
    global ::tclhdl::quartus::qsys_script     
    global ::tclhdl::quartus::qsys_hw
    global ::tclhdl::quartus::qsys_component
    global ::tclhdl::quartus::language        
    global ::tclhdl::quartus::synthesis       

    set ::tclhdl::quartus::ip_name          ""
    set ::tclhdl::quartus::ip_type          INTEL_IP
    set ::tclhdl::quartus::output_dir       ""
    set ::tclhdl::quartus::output_type      ""
    set ::tclhdl::quartus::component_name   ""
    set ::tclhdl::quartus::component_value  ""
    set ::tclhdl::quartus::component_param  ""
    set ::tclhdl::quartus::report_file      ""
    set ::tclhdl::quartus::system_info      ""
    set ::tclhdl::quartus::qsys_file        ""
    set ::tclhdl::quartus::qsys_script      ""
    set ::tclhdl::quartus::qsys_hw          ""
    set ::tclhdl::quartus::qsys_component   ""
    set ::tclhdl::quartus::language         "VERILOG"
    set ::tclhdl::quartus::synthesis        "--synthesis=VERILOG"
}

#------------------------------------------------------------------------------
#--
#------------------------------------------------------------------------------
proc ::tclhdl::quartus::ip_set_name {name} {
    global ::tclhdl::quartus::ip_name
    set ::tclhdl::quartus::ip_name $name
}

proc ::tclhdl::quartus::ip_set_type {type} {
    global ::tclhdl::quartus::ip_type
    set ::tclhdl::quartus::ip_type $type
}

proc ::tclhdl::quartus::ip_set_output_root {dir} {
    global ::tclhdl::quartus::output_root
    set ::tclhdl::quartus::output_root $dir
}
proc ::tclhdl::quartus::ip_set_output_dir {dir} {
    global ::tclhdl::quartus::output_dir
    set ::tclhdl::quartus::output_dir "--output-directory=$dir"
}

proc ::tclhdl::quartus::ip_set_output_type {type} {
    global ::tclhdl::quartus::output_type
    set ::tclhdl::quartus::output_type "--file-set=$type"
}

proc ::tclhdl::quartus::ip_set_component_name {name} {
    global ::tclhdl::quartus::component_name
    set ::tclhdl::quartus::component_name "--component-name=$name"
}

proc ::tclhdl::quartus::ip_set_component_param {param} {
    global ::tclhdl::quartus::component_param
    lappend component_param "--component-param=$param"
}

proc ::tclhdl::quartus::ip_set_system_info {sys_info} {
    global ::tclhdl::quartus::system_info
    lappend system_info "--system-info=$sys_info"
}

proc ::tclhdl::quartus::ip_set_report_file {rpt} {
    global ::tclhdl::quartus::report_file
    set ::tclhdl::quartus::report_file "--report-file=$rpt"
}

proc ::tclhdl::quartus::ip_set_qsys_script {script} {
    global ::tclhdl::quartus::qsys_script
    set ::tclhdl::quartus::qsys_script "--script=$script"
}

proc ::tclhdl::quartus::ip_set_qsys_file {script} {
    global ::tclhdl::quartus::qsys_file
    set ::tclhdl::quartus::qsys_file "$script"
}

proc ::tclhdl::quartus::ip_add_qsys_component {dir} {
    global ::tclhdl::quartus::qsys_component
    lappend ::tclhdl::quartus::qsys_component $dir
}

proc ::tclhdl::quartus::ip_add_qsys_hw {hw_file} {
    global ::tclhdl::quartus::qsys_hw
    lappend ::tclhdl::quartus::qsys_hw $hw_file
}

proc ::tclhdl::quartus::ip_set_synthesis {synth} {
    global ::tclhdl::quartus::synthesis
    set ::tclhdl::quartus::synthesis "--synthesis-file=$synth"
}

proc ::tclhdl::quartus::ip_set_language {lang} {
    global ::tclhdl::quartus::language
    set ::tclhdl::quartus::language "--language=$lang"
}

proc ::tclhdl::quartus::ip_get_info {} {
    puts "The info are $system_info"
}

proc ::tclhdl::quartus::ip_generate {} {
    log::log debug "ip_generate: Generate $::tclhdl::quartus::ip_type for $::tclhdl::quartus::ip_name"
    if {$::tclhdl::quartus::ip_type == "INTEL_IP"} {
        lappend args "$::tclhdl::quartus::output_dir"
        lappend args "$::tclhdl::quartus::output_type"
        lappend args "$::tclhdl::quartus::component_name"
        foreach arg $::tclhdl::quartus::component_param {
            lappend args "$arg"
        }
        foreach arg $::tclhdl::quartus::system_info {
            lappend args "$arg"
        }
        lappend args "$::tclhdl::quartus::report_file"

        if { [catch { eval exec "$::tclhdl::definitions::IP_GENERATOR_INTEL $args" }] } {
            log::log debug "ip_generate: Generated INTEL_IP $::tclhdl::quartus::ip_name"
        }
    } elseif {$::tclhdl::quartus::ip_type == "INTEL_QSYS"} {
        lappend args "$::tclhdl::quartus::synthesis"
        lappend args "$::tclhdl::quartus::output_dir"
        lappend args "$::tclhdl::quartus::qsys_file"

        #-- Run QSYS Scipt
        puts "$::tclhdl::definitions::IP_GENERATOR_INTEL_QSYS_SCRIPT $::tclhdl::quartus::qsys_script"
        if { [catch { eval exec "$::tclhdl::definitions::IP_GENERATOR_INTEL_QSYS_SCRIPT $::tclhdl::quartus::qsys_script" }] } {
            log::log debug "ip_generate: QSYS Run Script $::tclhdl::quartus::qsys_script"
        }

        #-- Generate QSYS
        puts "$::tclhdl::definitions::IP_GENERATOR_INTEL_QSYS_GENERATE $args"
        if { [catch { eval exec "$::tclhdl::definitions::IP_GENERATOR_INTEL_QSYS_GENERATE $args" }] } {
            log::log debug "ip_generate: Generate QSYS $::tclhdl::quartus::qsys_file"
        }

    } else {
        puts "Debug: No IP to Generate"
    }
}

#------------------------------------------------------------------------------
## Package Declaration
#------------------------------------------------------------------------------
package provide ::tclhdl::quartus $tclhdl::quartus::version

