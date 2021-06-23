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
## \file tclhdl-vivado.tcl
#
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
## Local System Packages
#
#------------------------------------------------------------------------------
package require ::tclhdl::definitions
package require ::tclhdl::utils
package require ::tclhdl::vunit

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
    namespace export get_project_tool_version

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

    namespace export hw_programming

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
    variable project_jobs                   "6"
    variable project_threads                "6"
    variable project_tool_version

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
## Open Project
#
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
    get_project_tool_version

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
        if { [expr $::tclhdl::vivado::project_tool_version > 2018.0] } {
            log::log debug "xilinx::open_project: Setting ip output - version $::tclhdl::vivado::project_tool_version"
            set_property "ip_cache_permissions" "read write" $obj
            set_property "ip_output_repo" "$::tclhdl::vivado::project_name.cache/ip" $obj
            set_param general.maxThreads $::tclhdl::vivado::project_threads
        }

        #-- Set Project to Close
        set ::tclhdl::vivado::is_project_closed 1
    }
}

#------------------------------------------------------------------------------
## Close Project
#
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
#
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::get_project_tool_version {} {
    global ::tclhdl::vivado::project_tool_version
    set version_list [split [::version -short] .]

    #-- If a patch version is installed then the version for major.minor only
    #-- does not work.
    set ::tclhdl::vivado::project_tool_version "[lindex $version_list 0].[lindex $version_list 1]"
}

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
## Run Ip Build
#
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::build_ip {} {
}

#------------------------------------------------------------------------------
## Run Synthesis
#
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::build_synthesis {} {
    log::log debug "xilinx::build_synthesis : launch synthesis"
    if { [get_property needs_refresh [get_runs $::tclhdl::vivado::project_synth]] } {
        reset_run $::tclhdl::vivado::project_synth
        launch_runs $::tclhdl::vivado::project_synth -jobs $::tclhdl::vivado::project_jobs
    } else {
        reset_run $::tclhdl::vivado::project_synth
        launch_runs $::tclhdl::vivado::project_synth -jobs $::tclhdl::vivado::project_jobs
    }
    wait_on_run $::tclhdl::vivado::project_synth

    set error_code ""
    regexp {ERROR} [get_property status [get_runs $::tclhdl::vivado::project_synth]] error_code
    if { "$error_code" == "ERROR" } {
        log::log error "xilinx::build_synthesis : synthesis failed"
        exit 1
    }
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
        reset_run $::tclhdl::vivado::project_impl
        launch_runs $::tclhdl::vivado::project_impl -to_step write_bitstream -jobs $::tclhdl::vivado::project_jobs
    }
    wait_on_run $::tclhdl::vivado::project_impl

    set error_code ""
    regexp {ERROR} [get_property status [get_runs $::tclhdl::vivado::project_impl]] error_code
    if { "$error_code" == "ERROR" } {
        log::log error "xilinx::build_fitting : implementation  failed"
        exit 1
    }
}

#------------------------------------------------------------------------------
## Run Timing Analysis
#
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::build_timing {} {
    log::log debug "xilinx::build_timing: launch timing analysis"

    #open_run $::tclhdl::vivado::project_impl 
    #set wns [get_property status.wns [get_runs $::tclhdl::vivado::project_impl]]
    #set whs [get_property status.whs [get_runs $::tclhdl::vivado::project_impl]]
    #if { [expr $wns <= 0.0] || [expr $whs <= 0.0] } {
    #    log::log error "xilinx::build_timing : Timing not met with WNS=$wns and WHS=$whs"
    #    exit 1
    #}
    
    open_run $::tclhdl::vivado::project_impl
    set error_code [get_property SLACK [get_timing_paths]]
    if { [expr $error_code < 0] } {
        log::log error "xilinx::build_fitting : Timing not met with Slack = $error_code"
        exit 1
    }
}

#------------------------------------------------------------------------------
## Run Generate Bitstream
#
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::build_bitstream {} {
    file mkdir "$::tclhdl::vivado::project_name.out"
    foreach fileIdx [glob -nocomplain "$::tclhdl::vivado::project_name.out/*"] {
        eval file delete -force $fileIdx
    }

    log::log debug "xilinx::build_bitstream : launch bitstream"
    open_impl_design $::tclhdl::vivado::project_impl
    write_bitstream -force -raw_bitfile -bin_file "$::tclhdl::vivado::project_name.out/$::tclhdl::vivado::project_name"
    close_design

    log::log debug "xilinx::build_bitstream : add bitstream version"
    set fileId [open "$::tclhdl::vivado::project_name.out/$::tclhdl::vivado::project_name.semver" "w"]
    puts -nonewline $fileId $::tclhdl::project_semver
    close $fileId

    log::log debug "xilinx::build_bitstream : compute checksums"
    set file_list [glob "$::tclhdl::vivado::project_name.out/$::tclhdl::vivado::project_name*"]
    foreach fileIdx $file_list {
        ::tclhdl::utils::checksum $fileIdx
    }
}

#------------------------------------------------------------------------------
## Run Report Generation
#
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::build_report {} {
    set obj [get_filesets $::tclhdl::vivado::project_fileset_source]
    set project_top [get_property "top" $obj]
    set impl_dir "$::tclhdl::vivado::project_name.runs/$::tclhdl::vivado::project_impl"
    set synth_dir "$::tclhdl::vivado::project_name.runs/$::tclhdl::vivado::project_synth"

    log::log debug "xilinx::build_report: launch report generation"
    #report_drc
    #report_timming
    #report_power

    file mkdir "$::tclhdl::vivado::project_name.rpt"

    log::log debug "xilinx::build_report: synthesis copy reports to output folder"
    set file_list [glob "$synth_dir/*.rpt"]
    file copy -force "$synth_dir/runme.log" "$::tclhdl::vivado::project_name.rpt/${project_top}_synth.log"
    foreach fileIdx $file_list {
        eval file copy -force $fileIdx "$::tclhdl::vivado::project_name.rpt"
    }

    log::log debug "xilinx::build_report: implementation copy reports to output folder"
    set file_list [glob "$impl_dir/*.rpt"]
    file copy -force "$impl_dir/runme.log" "$::tclhdl::vivado::project_name.rpt/${project_top}_impl.log"
    foreach fileIdx $file_list {
        eval file copy -force $fileIdx "$::tclhdl::vivado::project_name.rpt"
    }

    log::log debug "xilinx::build_report: implementation parse critical warnings"
    set critical_warnings [::tclhdl::utils::grep "CRITICAL" "$::tclhdl::vivado::project_name.rpt/${project_top}_impl.log"]
    set fileId [open "$::tclhdl::vivado::project_name.rpt/${project_top}_impl.critical" "w"]
    foreach warning $critical_warnings {
        puts $fileId $warning
    }
    close $fileId
}

#------------------------------------------------------------------------------
## IP Generate
#
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::ip_generate {} {
    log::log debug "ip_generate: Generate $::tclhdl::vivado::ip_type for $::tclhdl::vivado::ip_name"
}

#-------------------------------------------------------------------------------
## Adding Source Files
#
#-------------------------------------------------------------------------------
proc ::tclhdl::vivado::source_add {type src} {
    log::log debug "source_add: Add $type - $src"

    set obj [get_filesets sources_1]

    if { $type != "COEFF" } {
        add_files -norecurse -scan_for_includes -fileset $obj $src
        set file [file normalize $src]
        set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
        set_property "file_type" $type $file_obj
        set_property "is_enabled" "1" $file_obj
        set_property "is_global_include" "0" $file_obj
        set_property "library" "xil_defaultlib" $file_obj
        set_property "path_mode" "RelativeFirst" $file_obj
        set_property "used_in_synthesis" "1" $file_obj
        set_property "used_in_simulation" "0" $file_obj
    } else {
        #set coefname [file tail $src]
        #set coefname_dir [lindex [split $coefname .] 0]
        #set fileset_dir "$::tclhdl::vivado::project_name.srcs/sources_1/source"
        #set coef  [file normalize "$fileset_dir/$coefname"]
        #file mkdir $fileset_dir
        #file copy $src $coef
    }
}

#-------------------------------------------------------------------------------
## Adding IP Files
#
#-------------------------------------------------------------------------------
proc ::tclhdl::vivado::ip_add {type src} {
    log::log debug "xilinx::ip_add: Add $type $src"
    set ipname [file tail $src]
    set ipname_dir [lindex [split $ipname .] 0]
    set fileset_dir "$::tclhdl::vivado::project_name.srcs/sources_1/ip"
    set ip  [file normalize "$fileset_dir/$ipname_dir/$ipname"]

    log::log debug "xilinx::ip_add: name $ipname_dir"
    read_ip $src

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

#-------------------------------------------------------------------------------
## Adding Constraint Files
#
#-------------------------------------------------------------------------------
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

#-------------------------------------------------------------------------------
## Adding Simulation Settings Files
#
#-------------------------------------------------------------------------------
proc ::tclhdl::vivado::simulation_settings {name top settings} {
    if {[string equal [get_filesets -quiet $name] ""]} {
      create_fileset -simset $name
    }
    
    set obj [get_filesets $name]
    set_property -name "top" -value "$top" -objects $obj
    set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

    if { [string trim $settings] ne "" } {
        source $settings
    }
}

#-------------------------------------------------------------------------------
## Adding Simulation Files
#
#-------------------------------------------------------------------------------
proc ::tclhdl::vivado::simulation_add {name type src} {
    if {[string equal [get_filesets -quiet $name] ""]} {
      create_fileset -simset $name
    }
    
    set obj [get_filesets $name]
    set fd "[file normalize "$src"]"
    add_files -norecurse -fileset $obj $fd
    set fd $src
    set file_obj [get_files -of_objects [get_filesets $name] [list "*$fd"]]
    set_property "file_type" $type $file_obj
}

#-------------------------------------------------------------------------------
## Running Simulation
#
#-------------------------------------------------------------------------------
proc ::tclhdl::vivado::build_simulation {name settings} {

    log::log debug "xilinx::build_simulation: $settings"
    if { [string trim $settings] ne "" } {
        source $settings
    }

    launch_simulation -simset "$name" -scripts_only

    set obj [get_projects  $::tclhdl::vivado::project_name]
    set simulator [get_property "target_simulator" $obj]
    set current_dir [pwd]
    log::log debug "xilinx::build_simulation: $simulator"
    if {[string equal $simulator "ModelSim"]} {
        cd ${::tclhdl::vivado::project_name}.sim/$name/behav/modelsim

        if { [catch {exec >&@stdout $::tclhdl::definitions::TOOL_MODELSIM -batch -do "${name}_compile.do" -do "quit"}] } {
            log::log debug "xilinx::build_simulation: compilation error"
            exit 1
        }
        if { [catch {exec >&@stdout $::tclhdl::definitions::TOOL_MODELSIM -batch -do "${name}_simulate.do" -do "quit" -l simulate.log}] } {
            log::log debug "xilinx::build_simulation: simulation error"
            exit 1
        }

        cd $current_dir
    }
}

#-------------------------------------------------------------------------------
## Compile Simulation Libraries
#
#-------------------------------------------------------------------------------
proc ::tclhdl::vivado::compile_simlib {simulator} {
    set target_dir "$::env(XILINX_VIVADO)/compile_simlib/$simulator"
    set_param general.maxThreads 8

    log::log debug "xilinx::compile_simlib: $simulator - $target_dir"
    if { [catch {eval ::compile_simlib -simulator "$simulator" -family all -language all -library all -directory "$target_dir" -verbose}] } {
        log::log debug "xilinx::compile_simlib: there are some issues. However perhaps not import for your case!"
    }

    log::log debug "xilinx::compile_simlib: compile vunit"
    ::tclhdl::vunit::clone "$target_dir/.."  "v4.5.0"
    if {[string equal $simulator "modelsim"]} {
        ::tclhdl::vunit::modelsim "$target_dir" "$target_dir/../vunit"
    }
}


#-------------------------------------------------------------------------------
## Adding Constraint Files
#
#-------------------------------------------------------------------------------
#TODO: This is very incomplete!
proc ::tclhdl::vivado::hw_programming {} {
    set obj [get_filesets $::tclhdl::vivado::project_fileset_source]
    set artifact_name [get_property "top" $obj]

    log::log debug "xilinx::hw_programming: Start"
    open_hw
    connect_hw_server
    open_hw_target

    log::log debug "xilinx::hw_programming: Get Hardware Device"
    set hw_device [get_hw_devices]
    current_hw_device $hw_device
    refresh_hw_device -update_hw_probes false [lindex [get_hw_devices $hw_device] 0]

    log::log debug "xilinx::hw_programming: Programming File $::tclhdl::vivado::project_name.out/$artifact_name.bin"
    set_property PROBES.FILE {} [get_hw_devices $hw_device]
    set_property FULL_PROBES.FILE {} [get_hw_devices $hw_device]
    set_property PROGRAM.FILE "$::tclhdl::vivado::project_name.out/$artifact_name.bin" [get_hw_devices $hw_device]

    log::log debug "xilinx::hw_programming: Program"
    program_hw_devices [get_hw_devices $hw_device]
    refresh_hw_device [lindex [get_hw_devices $hw_device] 0]

    disconnect_hw_server
}

#------------------------------------------------------------------------------
## Get Version
#
#------------------------------------------------------------------------------
proc ::tclhdl::vivado::get_version {} {
   puts $tclhdl::vivado::version
}

#------------------------------------------------------------------------------
## Package Declaration
#
#------------------------------------------------------------------------------
package provide ::tclhdl::vivado $tclhdl::vivado::version

