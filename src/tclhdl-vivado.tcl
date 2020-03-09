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


package require ::tclhdl::definitions

#------------------------------------------------------------------------------
## Namespace Declaration
#------------------------------------------------------------------------------
namespace eval ::tclhdl::vivado {
 
    #---------------------------------------------------------------------------
    #-- Export Procedures
    #---------------------------------------------------------------------------
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

    #---------------------------------------------------------------------------
    #-- Namespace internal variables
    #---------------------------------------------------------------------------
    variable home [file join [pwd] [file dirname [info script]]]
    set version 1.0
}
 

#------------------------------------------------------------------------------
## Get Version
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::get_version {} {
   puts $tclhdl::vivado::version
}

#------------------------------------------------------------------------------
## Open Project
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::open_project {args} {
    global ::tclhdl::vivado::is_project_closed
    global ::tclhdl::vivado::is_project_assignments
    global ::tclhdl::vivado::project_part
    global ::tclhdl::vivado::project_synth
    global ::tclhdl::vivado::project_synth_flow
    global ::tclhdl::vivado::project_impl
    global ::tclhdl::vivado::project_impl_flow
    global ::tclhdl::vivado::project_fileset_source
    global ::tclhdl::vivado::project_fileset_constraint
    global ::tclhdl::vivado::project_fileset_simulation

    log::log debug "xilinx::open_project: Trying to open project $::tclhdl::vivado::project_name"

    if { [file exists "$::tclhdl::vivado::project_name.xpr"] } {
        set current_dir [pwd]
        log::log debug "xilinx::open_project: We are at $current_dir"
        log::log debug "xilinx::open_project: Open project $::tclhdl::vivado::project_name.xpr"
        ::open_project "$::tclhdl::vivado::project_name.xpr"
        set ::tclhdl::vivado::is_project_closed 1
    } else {
        log::log debug "xilinx::open_project: New project $::tclhdl::vivado::project_name"
        ::create_project $::tclhdl::vivado::project_name .

        log::log debug "xilinx::open_project: Creating Source FileSets"
        if {[string equal [get_filesets -quiet $::tclhdl::vivado::project_fileset_source] ""]} {
          create_fileset -srcset $::tclhdl::vivado::project_fileset_source
        }

        log::log debug "xilinx::open_project: Creating Constraint FileSets"
        if {[string equal [get_filesets -quiet $::tclhdl::vivado::project_fileset_constraint] ""]} {
          create_fileset -constrset $::tclhdl::vivado::project_fileset_constraint
        }

        #log::log debug "xilinx::open_project: Creating Synthesis Run"
        #create_run -name $::tclhdl::vivado::project_synth\
        #         -flow $::tclhdl::vivado::project_synth_flow\
        #         -constrset $::tclhdl::vivado::project_fileset_constraint

        #log::log debug "xilinx::open_project: Creating Implementation Run"
        #create_run -name $::tclhdl::vivado::project_impl\
        #         -flow $::tclhdl::vivado::project_impl_flow\
        #         -constrset $::tclhdl::vivado::project_fileset_constraint\
        #         -parent_run  $::tclhdl::vivado::project_synth

        log::log debug "xilinx::open_project: Set Current Run"
        current_run -synthesis [get_runs $::tclhdl::vivado::project_synth]
        current_run -implementation [get_runs $::tclhdl::vivado::project_synth]

        set obj [get_projects $::tclhdl::vivado::project_name]
        set_property "ip_cache_permissions" "read write" $obj
        set_property "ip_output_repo" "$::tclhdl::vivado::project_name.cache/ip" $obj

        #-- Set Project to Close
        set ::tclhdl::vivado::is_project_closed 1
    }
}

#------------------------------------------------------------------------------
## Close Project
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::close_project {} {
    global ::tclhdl::vivado::is_project_closed
    global ::tclhdl::vivado::is_project_assignments

    log::log debug "xilinx::project_close:: Closing project $::tclhdl::vivado::project_name"

    if {$::tclhdl::vivado::is_project_closed} {
        log::log debug "xilinx::project_close:: Project Closed"
        ::close_project
    }
}

#------------------------------------------------------------------------------
## 
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::set_project_name {name} {
    global ::tclhdl::vivado::project_name
    set ::tclhdl::vivado::project_name $name
}

proc ::tclhdl::vivado::set_project_revision {rev} {
    global ::tclhdl::vivado::project_revision
    set ::tclhdl::vivado::project_revision $rev
}

proc ::tclhdl::vivado::set_project_part {part} {
    global ::tclhdl::vivado::project_part
    set ::tclhdl::vivado::project_part $part
}

proc ::tclhdl::vivado::set_project_build_dir {dir} {
    global ::tclhdl::vivado::project_build_dir
    set ::tclhdl::vivado::project_build_dir $dir
}

proc ::tclhdl::vivado::set_project_settings {settings} {
    global ::tclhdl::vivado::project_settings
    set ::tclhdl::vivado::project_settings $settings
}

proc ::tclhdl::vivado::set_project_synth {synth} {
    global ::tclhdl::vivado::project_synth
    set ::tclhdl::vivado::project_synth $synth
}

proc ::tclhdl::vivado::set_project_impl {impl} {
    global ::tclhdl::vivado::project_impl
    set ::tclhdl::vivado::project_impl $impl
}

proc ::tclhdl::vivado::set_project_constr {constr} {
    global ::tclhdl::vivado::project_constr
    set ::tclhdl::vivado::project_constr $constr
}

proc ::tclhdl::vivado::set_project_sim {sim} {
    global ::tclhdl::vivado::project_sim
    set ::tclhdl::vivado::project_sim $sim
}

proc ::tclhdl::vivado::set_project_flow_synth {flow} {
    global ::tclhdl::vivado::project_flow_synth
    set ::tclhdl::vivado::project_flow_synth $flow
}

proc ::tclhdl::vivado::set_project_flow_impl {flow} {
    global ::tclhdl::vivado::project_flow_impl
    set ::tclhdl::vivado::project_flow_impl $flow
}

#------------------------------------------------------------------------------
## 
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
#--
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::build_ip {} {
}

#------------------------------------------------------------------------------
## Run Synthesis
#
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::build_synthesis {} {
    if { [get_property needs_refresh [get_runs $::tclhdl::vivado::project_synth]] } {
        synth_design
    } else {
        reset_run $::tclhdl::vivado::project_synth
        launch_runs $::tclhdl::vivado::project_synth -jobs $::tclhdl::vivado::project_jobs
    }
    wait_on_run $::tclhdl::vivado::project_synth
}

#------------------------------------------------------------------------------
## Run Fitting/Implementation
#
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::build_fitting {} {
    log::log debug "xilinx::build_fitting : launch implementation"
    if { [get_property needs_refresh [get_runs $::tclhdl::vivado::project_impl]] } {
        launch_runs $::tclhdl::vivado::project_impl -to_step write_bitstream -jobs $::tclhdl::vivado::project_jobs
    } else {
        reset_runs $::tclhdl::vivado::project_impl
        launch_runs $::tclhdl::vivado::project_impl -to_step write_bitstream -jobs $::tclhdl::vivado::project_jobs
    }
    wait_on_run $::tclhdl::vivado::project_impl
}

#------------------------------------------------------------------------------
## Run Timing Analysis
#
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::build_timing {} {
}

#------------------------------------------------------------------------------
## Run Generate Bitstream
#
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::build_bitstream {} {
    log::log debug "xilinx::build_bitstream : launch bitstream"
    file mkdir "$::tclhdl::vivado::project_name.out"
    open_impl_design $::tclhdl::vivado::project_impl
    write_bitstream -force -raw_bitfile -bin_file "$::tclhdl::vivado::project_name.out/$::tclhdl::vivado::project_name"
    close_design
}

#------------------------------------------------------------------------------
## Run Report Generation
#
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::build_report {} {
    #report_drc
    #report_timming
    #report_power
}

#------------------------------------------------------------------------------
#--
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::ip_reset {} {
    global ::tclhdl::vivado::ip_name         
    global ::tclhdl::vivado::ip_type         
    global ::tclhdl::vivado::output_dir      
    global ::tclhdl::vivado::output_type     
    global ::tclhdl::vivado::component_name  
    global ::tclhdl::vivado::component_value 
    global ::tclhdl::vivado::component_param 
    global ::tclhdl::vivado::report_file     
    global ::tclhdl::vivado::system_info     
    global ::tclhdl::vivado::language        
    global ::tclhdl::vivado::synthesis       

    set ::tclhdl::vivado::ip_name          ""
    set ::tclhdl::vivado::ip_type          INTEL_IP
    set ::tclhdl::vivado::output_dir       ""
    set ::tclhdl::vivado::output_type      ""
    set ::tclhdl::vivado::component_name   ""
    set ::tclhdl::vivado::component_value  ""
    set ::tclhdl::vivado::component_param  ""
    set ::tclhdl::vivado::report_file      ""
    set ::tclhdl::vivado::system_info      ""
    set ::tclhdl::vivado::language         "VERILOG"
    set ::tclhdl::vivado::synthesis        "--synthesis=VERILOG"
}

#------------------------------------------------------------------------------
#--
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::ip_set_name {name} {
    global ::tclhdl::vivado::ip_name
    set ::tclhdl::vivado::ip_name $name
}

proc ::tclhdl::vivado::ip_set_type {type} {
    global ::tclhdl::vivado::ip_type
    set ::tclhdl::vivado::ip_type $type
}

proc ::tclhdl::vivado::ip_set_output_root {dir} {
    global ::tclhdl::vivado::output_root
    set ::tclhdl::vivado::output_root $dir
}
proc ::tclhdl::vivado::ip_set_output_dir {dir} {
    global ::tclhdl::vivado::output_dir
    set ::tclhdl::vivado::output_dir "--output-directory=$dir"
}

proc ::tclhdl::vivado::ip_set_output_type {type} {
    global ::tclhdl::vivado::output_type
    set ::tclhdl::vivado::output_type "--file-set=$type"
}

proc ::tclhdl::vivado::ip_set_component_name {name} {
    global ::tclhdl::vivado::component_name
    set ::tclhdl::vivado::component_name "--component-name=$name"
}

proc ::tclhdl::vivado::ip_set_component_param {param} {
    global ::tclhdl::vivado::component_param
    lappend component_param "--component-param=$param"
}

proc ::tclhdl::vivado::ip_set_system_info {sys_info} {
    global ::tclhdl::vivado::system_info
    lappend system_info "--system-info=$sys_info"
}

proc ::tclhdl::vivado::ip_set_report_file {rpt} {
    global ::tclhdl::vivado::report_file
    set ::tclhdl::vivado::report_file "--report-file=$rpt"
}

proc ::tclhdl::vivado::ip_set_synthesis {synth} {
    global ::tclhdl::vivado::synthesis
    set ::tclhdl::vivado::synthesis "--synthesis-file=$synth"
}

proc ::tclhdl::vivado::ip_set_language {lang} {
    global ::tclhdl::vivado::language
    set ::tclhdl::vivado::language "--language=$lang"
}

proc ::tclhdl::vivado::ip_get_info {} {
    puts "The info are $system_info"
}

proc ::tclhdl::vivado::ip_generate {} {
    log::log debug "ip_generate: Generate $::tclhdl::vivado::ip_type for $::tclhdl::vivado::ip_name"
}

proc ::tclhdl::vivado::set_project_top {value} {
    set obj [get_filesets sources_1]
    set_property "top" $value $obj
}

proc ::tclhdl::vivado::source_add {type src} {
    log::log debug "source_add: Add $type - $src"

    set obj [get_filesets sources_1]
    add_files -norecurse -scan_for_includes -fileset $obj $src

    if { $type != "COEFF" } {
        set file [file normalize $src]
        set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
        set_property "file_type" $type $file_obj
        set_property "is_enabled" "1" $file_obj
        set_property "is_global_include" "0" $file_obj
        set_property "library" "xil_defaultlib" $file_obj
        set_property "path_mode" "RelativeFirst" $file_obj
        #set_property "used_in_implementation" "1" $file_obj
        set_property "used_in_synthesis" "1" $file_obj
        set_property "used_in_simulation" "1" $file_obj
    }
}

proc ::tclhdl::vivado::ip_add {type src} {
    log::log debug "xilinx::ip_add: Add $type $src"
    set ipname [file tail $src]
    set ipname_dir [lindex [split $ipname .] 0]
    set fileset_dir "$::tclhdl::vivado::project_name.srcs/sources_1/ip"
    set ip  [file normalize "$fileset_dir/$ipname_dir/$ipname"]

    log::log debug "xilinx::ip_add: name $ipname_dir"
    import_ip $src -name $ipname_dir

    log::log debug "xilinx::ip_add: ip $ip"
    set file_obj [get_files -of_objects [get_filesets $::tclhdl::vivado::project_fileset_source] [list "*$ipname"]]

    log::log debug "xilinx::ip_add: check if is locked"
    if { [get_property "is_locked" $file_obj] } {
        log::log debug "xilinx::ip_add: locked ip needs to be upgrade $ipname_dir"
        upgrade_ip [get_ips $ipname_dir]
    }

    log::log debug "xilinx::ip_add: set properties  $file_obj"
    set_property "is_enabled" "1" $file_obj
    set_property "is_global_include" "0" $file_obj
    set_property "library" "xil_defaultlib" $file_obj
    set_property "path_mode" "RelativeFirst" $file_obj
    set_property "used_in_synthesis" "1" $file_obj
    set_property "used_in_implementation" "1" $file_obj
    set_property "used_in_simulation" "1" $file_obj

    log::log debug "xilinx::ip_add: create runs  $file_obj"
    generate_target all [get_ips $ipname_dir]
    create_ip_run [get_ips $ipname_dir]
    log::log debug "xilinx::ip_add: Done"
}

proc ::tclhdl::vivado::constraint_add {type src} {
    set obj [get_filesets $::tclhdl::vivado::project_fileset_constraint]
    set fd "[file normalize "$src"]"
    add_files -norecurse -fileset $obj $fd
    set fd $src
    set file_obj [get_files -of_objects [get_filesets $::tclhdl::vivado::project_fileset_constraint] [list "*$fd"]]
    set_property "file_type" $type $file_obj
    set_property "used_in_synthesis" "0" $file_obj
    set_property "used_in_implementation" "1" $file_obj
}
#------------------------------------------------------------------------------
## Package Declaration
#------------------------------------------------------------------------------
package provide ::tclhdl::vivado $tclhdl::vivado::version

