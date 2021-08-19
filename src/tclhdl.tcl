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
## \file tclhdl.tcl
# TCLHDL intends to be
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
#-- Tcl System Packages
#------------------------------------------------------------------------------

package require Tcl
package require log

#------------------------------------------------------------------------------
## Local System Packages
#
#------------------------------------------------------------------------------
package require ::tclhdl::definitions
package require ::tclhdl::utils

if { $runtime_prog == "quartus" } {
    package require ::tclhdl::quartus
} elseif { $runtime_prog == "vivado" } {
    package require ::tclhdl::vivado
} elseif { $runtime_prog == "ise" } {
    package require ::tclhdl::ise
} elseif { $runtime_prog == "diamond" } {
    package require ::tclhdl::diamond
} elseif { $runtime_prog == "libero" } {
    package require ::tclhdl::libero
} elseif { $runtime_prog == "modelsim" } {
    package require ::tclhdl::modelsim
} elseif { $runtime_prog == "ghdl" } {
    package require ::tclhdl::ghdl
} elseif { $runtime_prog == "icarus" } {
    package require ::tclhdl::icarus
} else {
    puts "No Runtime Program Available"
}

#---------------------------------------------------------------------------
#-- Alias definitions
#---------------------------------------------------------------------------
interp alias {} check_quartus  {} if { $::runtime_prog != "quartus"  } { return 0 }
interp alias {} check_vivado   {} if { $::runtime_prog != "vivado"   } { return 0 }
interp alias {} check_ise      {} if { $::runtime_prog != "ise"      } { return 0 }
interp alias {} check_diamond  {} if { $::runtime_prog != "diamond"  } { return 0 }
interp alias {} check_libero   {} if { $::runtime_prog != "libero"  } { return 0 }
interp alias {} check_modelsim {} if { $::runtime_prog != "modelsim" } { return 0 }

interp alias {} check_project_created {} if { $::tclhdl::flag_project_create == 0} { return 0 }
interp alias {} check_simulation {} if { $::tclhdl::flag_is_simulation == 1} { return 0 }

#------------------------------------------------------------------------------
## Namespace Declaration
#
#------------------------------------------------------------------------------
namespace eval ::tclhdl {

    #-- Export Procedures
    namespace export get_version
    namespace export get_project_info
    namespace export get_project_list

    namespace export add_project
    namespace export add_source
    namespace export add_ip
    namespace export add_constraint
    namespace export add_settings
    namespace export add_tcl
    namespace export add_pre
    namespace export add_post

    namespace export project_create
    namespace export project_build
    namespace export project_info
    namespace export project_verify
    namespace export project_clean
    namespace export project_open
    namespace export project_close
    namespace export project_simulation

    namespace export fetch_pre
    namespace export fetch_ips
    namespace export fetch_sources
    namespace export fetch_constraints
    namespace export fetch_simulations
    namespace export fetch_settings
    namespace export fetch_post

    namespace export set_project_root
    namespace export set_project_name
    namespace export set_project_dir
    namespace export set_project_type
    namespace export set_project_target_dir
    namespace export set_project_build_number
    namespace export set_project_version
    namespace export set_project_version_major
    namespace export set_project_version_minor
    namespace export set_project_version_patch
    namespace export set_project_revision
    namespace export set_project_semver
    namespace export set_project_simulation
    namespace export set_source_dir
    namespace export set_ip_dir
    namespace export set_ip_output_dir
    namespace export set_constraint_dir
    namespace export set_simulation_dir
    namespace export set_settings_dir
    namespace export set_scripts_dir

    namespace export is_project_created

    namespace export build_pre
    namespace export build_ip
    namespace export build_synthesis
    namespace export build_fitting
    namespace export build_timing
    namespace export build_simulation
    namespace export build_bitstream
    namespace export build_report
    namespace export build_post
    namespace export build_custom

    #-- Member Variables
    variable project_root
    variable project_name
    variable project_dir
    variable project_type
    variable project_tool
    variable project_part
    variable project_jobs
    variable project_target_dir
    variable project_source_dir
    variable project_ip_dir
    variable project_constraint_dir
    variable project_simulation_dir
    variable project_settings_dir
    variable project_scripts_dir
    variable project_build_dir
    variable project_build_ip_dir
    variable project_build_full     1
    variable project_build_step     "full"
    variable project_build_number
    variable project_version        ""
    variable project_version_major  ""
    variable project_version_minor  ""
    variable project_version_patch  ""
    variable project_revision       ""
    variable project_semver         ""

    variable list_projects ""
    variable list_source ""
    variable list_ip ""
    variable list_constraint ""
    variable list_settings ""
    variable list_target_dir ""
    variable list_pre_scripts ""
    variable list_post_scripts ""
    variable list_simulations ""
    variable list_simulations_tools
    variable list_simulations_tools

    variable flag_project_create
    variable flag_is_simulation     0

    #-- Namespace internal variables
    variable home [file join [pwd] [file dirname [info script]]]
    set version 1.0

}

#------------------------------------------------------------------------------
## Get Library Version
#
#
#------------------------------------------------------------------------------
proc ::tclhdl::get_version {} {
    puts $tclhdl::version
    puts $tclhdl::definitions::version
}

#------------------------------------------------------------------------------
## Set Project Root
#
# \param[in] root  Location of your project
#------------------------------------------------------------------------------
proc ::tclhdl::set_project_root {root} {
    log::log debug "set_project_root: Setting project_root to $root"
    global ::tclhdl::project_root
    set ::tclhdl::project_root $root 
    log::log debug "set_project_root: Setting project_root to $::tclhdl::project_root"
}

#------------------------------------------------------------------------------
## Get Project List
#
#------------------------------------------------------------------------------
proc ::tclhdl::get_project_list {tclhdl_dir} {
    log::log debug "get_project_list: Fetching Project at $tclhdl_dir"
    global ::tclhdl::list_target_dir
    foreach dir [glob $tclhdl_dir/*] {
        if {![file exist $dir/build]} {continue}
        if {![file exist $dir/project]} {continue}
        if {![file exist $dir/sources]} {continue}
        if {![file exist $dir/ip]} {continue}
        lappend ::tclhdl::list_target_dir [file tail $dir]
        log::log debug "get_project_list: Fetching inside $dir"
    }
}

#-------------------------------------------------------------------------------
## Add Source File To The Project Structure
#
#-------------------------------------------------------------------------------
proc ::tclhdl::add_source {type src} {
    check_simulation
    check_project_created
    switch $::tclhdl::project_tool {
        INTEL_QUARTUS {
            check_quartus
            log::log debug "add_source: Intel - Adding file type $type - $src"
            set_global_assignment -name "${type}_FILE" $src
        }
        XILINX_VIVADO {
            check_vivado
            log::log debug "add_source: Xilinx Vivado - Adding file type $type - $src"
            ::tclhdl::vivado::source_add $type $src
        }
        XILINX_ISE {
            check_ise
            log::log debug "add_source: Xilinx ISE - Adding file type $type - $src"
            ::tclhdl::ise::source_add $type $src
        }
        LATTICE_DIAMOND {
            check_diamond
            log::log debug "add_source: Lattice Diamond - Adding file type $type - $src"
            ::tclhdl::diamond::source_add $type $src
        }
        MICROSEMI_LIBERO {
            check_libero
            log::log debug "add_source: Microsemi Libero - Adding file type $type - $src"
            ::tclhdl::libero::source_add $type $src
        }
        default {
            log::logMsg "add_source: No supported tool define for the current project"
        }
    }
}

#-------------------------------------------------------------------------------
## Add Tcl File To Project
#
#-------------------------------------------------------------------------------
proc ::tclhdl::add_tcl {src} {
    log::log debug "add_tcl: Add TCL File to Project $src"
    source $src
}

#-------------------------------------------------------------------------------
## Add IP To The Project Structure
#
#-------------------------------------------------------------------------------
proc ::tclhdl::add_ip {type src} {
    check_simulation
    check_project_created
    switch $::tclhdl::project_tool {
        INTEL_QUARTUS {
            check_quartus
            switch $type {
                INTEL_QUARTUS_IP {
                    log::log debug "add_ip: Adding ip type $type - $src"
                    cd $::tclhdl::quartus::output_root
                    ::tclhdl::quartus::ip_reset
                    ::tclhdl::quartus::ip_set_type $type
                    source $src
                    ::tclhdl::quartus::ip_generate
                }
                INTEL_QUARTUS_QSYS {
                    log::log debug "add_ip: Adding QSYS ip type $type - $src"
                    ::tclhdl::quartus::ip_reset
                    ::tclhdl::quartus::ip_set_type $type
                    source $src

                    log::log debug "add_ip: Adding QSYS ip $::tclhdl::quartus::output_root"
                    set ip_name "$::tclhdl::quartus::output_root/$::tclhdl::quartus::ip_name"
                    file mkdir $ip_name
                    cd $ip_name

                    foreach dir $::tclhdl::quartus::qsys_component {
                        log::log debug "add_ip: Adding QSYS component - $dir"
                        set name [file tail $dir]
                        file link -symbolic $name $dir
                    }

                    foreach hw $::tclhdl::quartus::qsys_hw {
                        log::log debug "add_ip: Adding QSYS hw - $hw"
                        set name [file tail $hw]
                        file copy -force  $hw "$ip_name/$name"
                    }

                    ::tclhdl::quartus::ip_generate
                }
                default {
                    log::logMsg "add_ip: No IP type defined for $ip_file"
                }
            }
        }
        XILINX_VIVADO {
            check_vivado
            switch $type {
                XCI {
                    log::log debug "add_ip: Adding ip type $type - $src"
                    ::tclhdl::vivado::ip_add $type $src
                }
                default {
                    log::logMsg "add_ip: No IP type defined for $ip_file"
                }
            }
        }
        XILINX_ISE {
            check_ise
            switch $type {
                COREGEN {
                    log::log debug "add_ip: Adding ip type $type - $src"
                    ::tclhdl::ise::ip_add $type $src
                }
                XCO {
                    log::log debug "add_ip: Adding ip type $type - $src"
                    ::tclhdl::ise::ip_add $type $src
                }
                default {
                    log::logMsg "add_ip: No IP type defined for $ip_file"
                }
            }
        }
        LATTICE_DIAMOND {
            check_diamond
            switch $type {
                IPX {
                    log::log debug "add_ip: Adding ip type $type - $src"
                    ::tclhdl::diamond::ip_add $type $src
                }
                default {
                    log::logMsg "add_ip: No IP type defined for $ip_file"
                }
            }
        }
        MICROSEMI_LIBERO {
            check_libero
            switch $type {
                IPX {
                    log::log debug "add_ip: Adding ip type $type - $src"
                    ::tclhdl::libero::ip_add $type $src
                }
                default {
                    log::logMsg "add_ip: No IP type defined for $ip_file"
                }
            }
        }
        default {
            log::logMsg "add_source: No supported tool define for the current project"
        }
    }
    #-- Make sure we are always at project build dir
    cd $::tclhdl::project_build_dir
}

#-------------------------------------------------------------------------------
## Add Constraint To The Project Structure
#
#-------------------------------------------------------------------------------
proc ::tclhdl::add_constraint {type src} {
    check_simulation
    check_project_created
    switch $::tclhdl::project_tool {
        INTEL_QUARTUS {
            check_quartus
            log::log debug "add_constraint: Intel - Adding file tyepe $type -$src"
            source $src
        }
        XILINX_VIVADO {
            check_vivado
            log::log debug "add_constraint: Vivado - Adding file type $type - $src"
            ::tclhdl::vivado::constraint_add $type $src
        }
        XILINX_ISE {
            check_ise
            log::log debug "add_constraint: ISE - Adding file type $type - $src"
            ::tclhdl::ise::constraint_add $type $src
        }
        LATTICE_DIAMOND {
            check_diamond
            log::log debug "add_constraint: Diamond - Adding file type $type - $src"
            ::tclhdl::diamond::constraint_add $type $src
        }
        MICROSEMI_LIBERO {
            check_libero
            log::log debug "add_constraint: Libero - Adding file type $type - $src"
            ::tclhdl::libero::constraint_add $type $src
        }
        default {
            log::logMsg "add_constraint: No supported tool define for the current project"
        }
    }
}

#-------------------------------------------------------------------------------
## Add Simulation File To The Project Structure
#
#-------------------------------------------------------------------------------
proc ::tclhdl::add_simulation {name type src} {
    switch $::tclhdl::list_simulations_tools($name) {
        INTEL_QUARTUS {
            check_quartus
            ::tclhdl::quartus::simulation_add $name $type $src
        }
        XILINX_VIVADO {
            check_vivado
            ::tclhdl::vivado::simulation_add $name $type $src
        }
        XILINX_ISE {
            check_ise
            ::tclhdl::ise::simulation_add $name $type $src
        }
        LATTICE_DIAMOND {
            check_diamond
            ::tclhdl::diamond::simulation_add $name $type $src
        }
        MICROSEMI_LIBERO {
            check_libero
            ::tclhdl::libero::simulation_add $name $type $src
        }
        MENTOR_MODELSIM {
            check_modelsim
            ::tclhdl::modelsim::simulation_add $name $type $src
        }
        default {
            log::logMsg "add_simulation: No supported tool define for the current project"
        }
    }
}

#-------------------------------------------------------------------------------
## Add Simulation Settings
#
#-------------------------------------------------------------------------------
proc ::tclhdl::add_simulation_settings {name top settings} {
    switch $::tclhdl::list_simulations_tools($name) {
        INTEL_QUARTUS {
            check_quartus
            ::tclhdl::quartus::simulation_settings $name $top $settings
        }
        XILINX_VIVADO {
            check_vivado
            ::tclhdl::vivado::simulation_settings $name $top $settings
        }
        XILINX_ISE {
            check_ise
            ::tclhdl::ise::simulation_settings $name $top $settings
        }
        LATTICE_DIAMOND {
            check_diamond
            ::tclhdl::diamond::simulation_settings $name $top $settings
        }
        MICROSEMI_LIBERO {
            check_libero
            ::tclhdl::libero::simulation_settings $name $top $settings
        }
        MENTOR_MODELSIM {
            check_modelsim
            ::tclhdl::modelsim::simulation_settings $name $top $settings
        }
        default {
            log::logMsg "add_simulation_settings: No supported tool define for the current project"
        }
    }
}



#-------------------------------------------------------------------------------
## Add Settings To The Project Structure
#
#-------------------------------------------------------------------------------
proc ::tclhdl::add_settings {settings src} {
    check_simulation
    switch $::tclhdl::project_tool {
        INTEL_QUARTUS {
            check_quartus
            log::log debug "add_settings: Quartus - Adding file settings $settings - $src"
            if { $::tclhdl::quartus::project_settings == $settings } {
                source $src
            }
        }
        XILINX_VIVADO {
            check_vivado
            log::log debug "add_settings: Vivado - Adding file settings $settings - $src"
            if { $::tclhdl::vivado::project_settings == $settings } {
                source $src
            }
        }
        XILINX_ISE {
            check_ise
            log::log debug "add_settings: ISE - Adding file settings $settings - $src"
            if { $::tclhdl::ise::project_settings == $settings } {
                source $src
            }
        }
        LATTICE_DIAMOND {
            check_diamond
            log::log debug "add_settings: Diamond - Adding file settings $settings - $src"
            if { $::tclhdl::diamond::project_settings == $settings } {
                source $src
            }
        }
        MICROSEMI_LIBERO {
            check_libero
            log::log debug "add_settings: Libero - Adding file settings $settings - $src"
            if { $::tclhdl::libero::project_settings == $settings } {
                source $src
            }
        }
        default {
            log::logMsg "add_source: No supported tool define for the current project"
        }
    }
}
#-------------------------------------------------------------------------------
## Add Project
#
#-------------------------------------------------------------------------------
proc ::tclhdl::add_project {prj settings rev} {
    check_simulation
    log::log debug "add_project: Adding Project $prj with revision $rev and settings $settings"
    global ::tclhdl::list_projects
    if { $::tclhdl::flag_project_create == 1 } { return 0 }
    switch $::tclhdl::project_tool {
        INTEL_QUARTUS {
            check_quartus
            lappend ::tclhdl::list_projects [list $prj $settings $rev]
        }
        XILINX_VIVADO {
            check_vivado
            lappend ::tclhdl::list_projects [list $prj $settings $rev]
        }
        XILINX_ISE {
            check_ise
            lappend ::tclhdl::list_projects [list $prj $settings $rev]
        }
        LATTICE_DIAMOND {
            check_diamond
            lappend ::tclhdl::list_projects [list $prj $settings $rev]
        }
        MICROSEMI_LIBERO {
            check_libero
            lappend ::tclhdl::list_projects [list $prj $settings $rev]
        }
        default {
            log::logMsg "add_project: No supported tool define for the current project"
        }
    }
}
#-------------------------------------------------------------------------------
## Add Pre Script
#
#-------------------------------------------------------------------------------
proc ::tclhdl::add_pre {src} {
    check_simulation
    global ::tclhdl::list_pre_scripts
    log::log debug "add_pre: Add Pre File to Project $src"

    lappend ::tclhdl::list_pre_scripts $src
}

#-------------------------------------------------------------------------------
## Add Post Script
#
#-------------------------------------------------------------------------------
proc ::tclhdl::add_post {src} {
    check_simulation
    global ::tclhdl::list_post_scripts
    log::log debug "add_post: Add Post File to Project $src"

    lappend ::tclhdl::list_post_scripts $src
}

#------------------------------------------------------------------------------
## Verify if Project is compliant with TCLHDL
#
#------------------------------------------------------------------------------
proc ::tclhdl::project_verify {prj} {
    global ::tclhdl::project_dir
    global ::tclhdl::project_target_dir

    log::log debug "project_verify: Verify project $prj at root $tclhdl::project_root"
    set project_dir $::tclhdl::project_root
    set target_dir $project_dir

    log::log debug "project_verify: Check if exists $target_dir"
    if { ![file exist $target_dir] } {
        log::logMsg "project_verify: Project $target_dir does not exist"
        exit 1
    }

    log::log debug "project_verify: Check if structure exists at $target_dir/project"
    if {![file exist $target_dir/project] && ![file exist $target_dir/sources] && ![file exist $target_dir/build] && ![file exist $target_dir/ip] } {
        log::logMsg "project_verify: Project $prj is not compliant with TCLHDL"
        exit 1
    }

    set ::tclhdl::project_dir [file normalize $project_dir]
    set ::tclhdl::project_target_dir [file normalize $target_dir]
}

#-------------------------------------------------------------------------------
## Create/Generate Project
#
#-------------------------------------------------------------------------------
proc ::tclhdl::project_create {prj} {
    global ::tclhdl::flag_project_create
    global ::tclhdl::project_build_dir
    global ::tclhdl::project_build_ip_dir

    #-- Verify Project
    log::log debug "project_create: Verifying if project exists"
    ::tclhdl::project_verify $prj

    #-- Get Environment Variables
    log::log debug "project_create: Setting environment"
    set ::tclhdl::flag_project_create 0
    source $::tclhdl::project_target_dir/project
    set ::tclhdl::flag_project_create 1

    #-- Create Project
    log::log debug "project_create: Creating project"

    foreach lst $::tclhdl::list_projects {
        set project [lindex $lst 0]
        set settings [lindex $lst 1]
        set current_dir [pwd]

        #-- Create necessary directories
        file delete -force "$::tclhdl::project_target_dir/$project-$settings"
        file mkdir "$::tclhdl::project_target_dir/$project-$settings"
        file mkdir "$::tclhdl::project_target_dir/$project-$settings/ip"

        set ::tclhdl::project_build_dir [file normalize "$::tclhdl::project_target_dir/$project-$settings"]
        set ::tclhdl::project_build_ip_dir [file normalize "$::tclhdl::project_build_dir/ip"]

        #-- Creating Projects on the proper right folder
        log::log debug "project_create: Opening Project with $settings"
        cd "$::tclhdl::project_target_dir/$project-$settings"
        ::tclhdl::project_open [lindex $lst 0] [lindex $lst 1] [lindex $lst 2]

        log::log debug "project_create: Reload Project with $settings"
        cd $current_dir
        source $::tclhdl::project_target_dir/settings
        source $::tclhdl::project_target_dir/project

        log::log debug "project_create: Close Project with $settings"
        ::tclhdl::project_close [lindex $lst 0]
    }
}

#-------------------------------------------------------------------------------
##  Build Project
#
#-------------------------------------------------------------------------------
proc ::tclhdl::project_build {prj step} {
    global ::tclhdl::project_build_full
    global ::tclhdl::project_build_step
    
    log::log debug "project_build: Building $prj with Flow $step"
    #-- Get build step
    set ::tclhdl::project_build_full 0
    set ::tclhdl::project_build_step $step
    if { $step == "full" } {
        set ::tclhdl::project_build_full 1
    }

    #-- Verify Project
    ::tclhdl::project_verify $prj

    #-- Get Environment Variables
    log::log debug "project_build: Setting enviornment"
    set ::tclhdl::flag_project_create 0
    source $::tclhdl::project_target_dir/project

    #-- Build Project
    log::log debug "project_build: Build Project"
    foreach lst $::tclhdl::list_projects {
        set project [lindex $lst 0]
        set settings [lindex $lst 1]

        #-- Move to build directory
        log::log debug "project_build: Change Dir to $::tclhdl::project_target_dir/$project-$settings"
        cd "$::tclhdl::project_target_dir/$project-$settings"

        #-- Opennning the existent Project
        log::log debug "project_build: Build Execute"
        ::tclhdl::project_open [lindex $lst 0] [lindex $lst 1] [lindex $lst 2]
        source $::tclhdl::project_target_dir/build
        ::tclhdl::project_close [lindex $lst 0]
    }
}

#-------------------------------------------------------------------------------
##  Get Project Information
#
#-------------------------------------------------------------------------------
proc ::tclhdl::project_info {prj} {
    #-- Verify Project
    ::tclhdl::project_verify $prj

    #-- Get Environment Variables
    log::log debug "project_info: Setting enviornment"
    set ::tclhdl::flag_project_create 0
    source $::tclhdl::project_target_dir/project
}

#-------------------------------------------------------------------------------
## Open Existent Project
#
#-------------------------------------------------------------------------------
proc ::tclhdl::project_open {args} {
    switch $::tclhdl::project_tool {
        INTEL_QUARTUS {
            check_quartus
            if { [llength $args] == 3 } {
                set prj [lindex $args 0]
                set settings [lindex $args 1]
                set rev [lindex $args 2]
                log::log debug "project_open: Adding Project $prj with revision $rev"
                ::tclhdl::quartus::set_project_name $prj
                ::tclhdl::quartus::set_project_settings $settings
                ::tclhdl::quartus::set_project_revision $rev
                ::tclhdl::quartus::open_project
            } else {
                log::Msg "project_open: Adding Project not correct"
            }
        }
        XILINX_VIVADO {
            check_vivado
            if { [llength $args] == 3 } {
                set prj [lindex $args 0]
                set settings [lindex $args 1]
                set rev [lindex $args 2]
                log::log debug "project_open: Adding Project $prj with settings $settings"
                ::tclhdl::vivado::set_project_name $prj
                ::tclhdl::vivado::set_project_settings $settings
                ::tclhdl::vivado::set_project_revision $rev
                ::tclhdl::vivado::open_project
            } else {
                log::Msg "project_open: Adding Project not correct"
            }
        }
        XILINX_ISE {
            check_ise
            if { [llength $args] == 3 } {
                set prj [lindex $args 0]
                set settings [lindex $args 1]
                set rev [lindex $args 2]
                log::log debug "project_open: Adding Project $prj with settings $settings"
                ::tclhdl::ise::set_project_name $prj
                ::tclhdl::ise::set_project_settings $settings
                ::tclhdl::ise::set_project_revision $rev
                ::tclhdl::ise::open_project
            } else {
                log::Msg "project_open: Adding Project not correct"
            }
        }
        LATTICE_DIAMOND {
            check_diamond
            if { [llength $args] == 3 } {
                set prj [lindex $args 0]
                set settings [lindex $args 1]
                set rev [lindex $args 2]
                log::log debug "project_open: Adding Project $prj with settings $settings"
                ::tclhdl::diamond::set_project_name $prj
                ::tclhdl::diamond::set_project_settings $settings
                ::tclhdl::diamond::set_project_revision $rev
                ::tclhdl::diamond::open_project
            } else {
                log::Msg "project_open: Adding Project not correct"
            }
        }
        MICROSEMI_LIBERO {
            check_libero
            if { [llength $args] == 3 } {
                set prj [lindex $args 0]
                set settings [lindex $args 1]
                set rev [lindex $args 2]
                log::log debug "project_open: Adding Project $prj with settings $settings"
                ::tclhdl::libero::set_project_name $prj
                ::tclhdl::libero::set_project_settings $settings
                ::tclhdl::libero::set_project_revision $rev
                ::tclhdl::libero::open_project
            } else {
                log::Msg "project_open: Adding Project not correct"
            }
        }
        default {
            log::logMsg "project_open: No supported tool define for the current project"
        }
    }
}

#-------------------------------------------------------------------------------
## Close Project
#
#-------------------------------------------------------------------------------
proc ::tclhdl::project_close {prj} {
    log::log debug "project_close: Closing project $prj"
    switch $::tclhdl::project_tool {
        INTEL_QUARTUS {
            check_quartus
            ::tclhdl::quartus::close_project
        }
        XILINX_VIVADO {
            check_vivado
            ::tclhdl::vivado::close_project
        }
        XILINX_ISE {
            check_ise
            ::tclhdl::ise::close_project
        }
        LATTICE_DIAMOND {
            check_diamond
            ::tclhdl::diamond::close_project
        }
        MICROSEMI_LIBERO {
            check_libero
            ::tclhdl::libero::close_project
        }
        default {
            log::logMsg "project_close: No supported tool define for the current project"
        }
    }
}

#-------------------------------------------------------------------------------
## Simulation  Project
#
#-------------------------------------------------------------------------------
proc ::tclhdl::project_simulation {prj step simulation simulation_settings} {
    global ::tclhdl::project_build_full
    global ::tclhdl::project_build_step
    
    log::log debug "project_build: Building Simulation $simulation for Project $prj with Flow $step"
    #-- Get build step
    set ::tclhdl::project_build_full 0
    set ::tclhdl::project_build_step $step
    if { $step == "full" } {
        set ::tclhdl::project_build_full 1
    }

    #-- Verify Project
    ::tclhdl::project_verify $prj

    #-- Get Environment Variables
    log::log debug "project_build: Setting enviornment"
    set ::tclhdl::flag_project_create 0
    source $::tclhdl::project_target_dir/project

    #-- Build Project
    log::log debug "project_build: Build Project"
    foreach lst $::tclhdl::list_projects {
        set project [lindex $lst 0]
        set settings [lindex $lst 1]

        #-- Move to build directory
        log::log debug "project_build: Change Dir to $::tclhdl::project_target_dir/$project-$settings"
        cd "$::tclhdl::project_target_dir/$project-$settings"

        #-- Opennning the existent Project
        log::log debug "project_build: Build Execute"
        ::tclhdl::project_open [lindex $lst 0] [lindex $lst 1] [lindex $lst 2]
        ::tclhdl::build_simulation $simulation $simulation_settings
        ::tclhdl::project_close [lindex $lst 0]
    }
}

#-------------------------------------------------------------------------------
## Clean Project
#
#-------------------------------------------------------------------------------
proc ::tclhdl::project_clean {prj} {
    set path [pwd]
    log::log debug "project_clean: Cleaning project $path/$prj"
    file delete -force [glob -type d $path/$prj/$prj-*]
}

#-------------------------------------------------------------------------------
## Verify If Create Project is Set
#
#-------------------------------------------------------------------------------
proc ::tclhdl::is_project_created {} {
    log::log debug "is_project_created: Check if project is already created - $::tclhdl::flag_project_create"
    if { $::tclhdl::flag_project_create == 0 } {
        return 1
    }
    return 0
}

#-------------------------------------------------------------------------------
## Shell Project
#
#-------------------------------------------------------------------------------
proc ::tclhdl::project_shell {prj} {
    #-- Verify Project
    ::tclhdl::project_verify $prj

    #-- Get Environment Variables
    log::log debug "project_build: Setting enviornment"
    set ::tclhdl::flag_project_create 0
    source $::tclhdl::project_target_dir/project

    #-- Build Project
    log::log debug "project_build: Build Project"
    foreach lst $::tclhdl::list_projects {
        set project [lindex $lst 0]
        set settings [lindex $lst 1]

        #-- Move to build directory
        log::log debug "project_build: Change Dir to $::tclhdl::project_target_dir/$project-$settings"
        cd "$::tclhdl::project_target_dir/$project-$settings"

        #-- Opennning the existent Project
        log::log debug "project_build: Build Execute"
        ::tclhdl::project_open [lindex $lst 0] [lindex $lst 1] [lindex $lst 2]
    }
}


#-------------------------------------------------------------------------------
## Project Hardware Programming
#
#-------------------------------------------------------------------------------
proc ::tclhdl::project_program {prj} {
    #-- Verify Project
    ::tclhdl::project_verify $prj

    #-- Get Environment Variables
    log::log debug "project_build: Setting enviornment"
    set ::tclhdl::flag_project_create 0
    source $::tclhdl::project_target_dir/project

    #-- Build Project
    log::log debug "project_build: Build Project"
    foreach lst $::tclhdl::list_projects {
        set project [lindex $lst 0]
        set settings [lindex $lst 1]

        #-- Move to build directory
        log::log debug "project_build: Change Dir to $::tclhdl::project_target_dir/$project-$settings"
        cd "$::tclhdl::project_target_dir/$project-$settings"

        #-- Opennning the existent Project
        log::log debug "project_build: Build Execute"
        ::tclhdl::project_open [lindex $lst 0] [lindex $lst 1] [lindex $lst 2]
         switch $::tclhdl::project_tool {
            INTEL_QUARTUS {
            }
            XILINX_VIVADO {
                check_vivado
                log::log debug "project_program: Start Hardware Programming"
                ::tclhdl::vivado::hw_programming
            }
            XILINX_ISE {
            }
            LATTICE_DIAMOND {
            }
            default {
                log::logMsg "project_program: No supported tool define for the current project"
            }
        }
        ::tclhdl::project_close [lindex $lst 0]
    }
}

#-------------------------------------------------------------------------------
## Project Simulation Library Compile
#
#-------------------------------------------------------------------------------
proc ::tclhdl::project_simlib {prj simulator} {
    #-- Verify Project
    ::tclhdl::project_verify $prj

    #-- Get Environment Variables
    log::log debug "project_simlib: Setting enviornment"
    set ::tclhdl::flag_project_create 0
    source $::tclhdl::project_target_dir/project

    log::log debug "project_simlib: Generate Simulation Libraries for $simulator"
    switch $::tclhdl::project_tool {
        INTEL_QUARTUS {
            check_quartus
        }
        XILINX_VIVADO {
            ::tclhdl::vivado::compile_simlib $simulator
        }
        XILINX_ISE {
            check_ise
        }
        LATTICE_DIAMOND {
            check_diamond
        }
        MICROSEMI_LIBERO {
            check_libero
        }
        default {
            log::logMsg "add_project: No supported tool define for the current project"
        }
    }

}


#-------------------------------------------------------------------------------
## Fetch Post Scripts
#
#-------------------------------------------------------------------------------
proc ::tclhdl::fetch_pre {} {
    check_simulation
    log::log debug "fetch_pre: Fetching Pre build"
    source $::tclhdl::project_target_dir/pre
}

#-------------------------------------------------------------------------------
## Fetch IP sources
#
#-------------------------------------------------------------------------------
proc ::tclhdl::fetch_ips {} {
    check_simulation
    if { [::tclhdl::is_project_created] } {
        return 0
    }

    log::log debug "fetch_ips: Fetching for IP file"
    source $::tclhdl::project_target_dir/ip
}

#-------------------------------------------------------------------------------
## Fetch Sources
#
#-------------------------------------------------------------------------------
proc ::tclhdl::fetch_sources {} {
    check_simulation
    if { [::tclhdl::is_project_created] } {
        return 0
    }

    log::log debug "fetch_sources: Fetching for Source file"
    source $::tclhdl::project_target_dir/sources
}

#-------------------------------------------------------------------------------
## Fetch Constraints
#
#-------------------------------------------------------------------------------
proc ::tclhdl::fetch_constraints {} {
    check_simulation
    if { [::tclhdl::is_project_created] } {
        return 0
    }

    log::log debug "fetch_constraints: Fetching for Constraint file"
    source $::tclhdl::project_target_dir/constraints
}

#-------------------------------------------------------------------------------
## Fetch Simulations
#
#-------------------------------------------------------------------------------
proc ::tclhdl::fetch_simulations {} {
    if { [::tclhdl::is_project_created] } {
        return 0
    }

    log::log debug "fetch_simulations: Fetching for Simulations file"
    source $::tclhdl::project_target_dir/simulation
}

#-------------------------------------------------------------------------------
## Fetch Settings
#
#-------------------------------------------------------------------------------
proc ::tclhdl::fetch_settings {src} {
    check_simulation
    if { [::tclhdl::is_project_created] } {
        return 0
    }

    log::log debug "fetch_settings: Fetching for Settings file"
    source $src
}

#-------------------------------------------------------------------------------
## Fetch Post Scripts
#
#-------------------------------------------------------------------------------
proc ::tclhdl::fetch_post {} {
    check_simulation
    log::log debug "fetch_post: Fetching Post Buiding"
    source $::tclhdl::project_target_dir/post
}

#-------------------------------------------------------------------------------
## Set Project Name
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_project_name {name} {
    global ::tclhdl::project_name
    set ::tclhdl::project_name $name
    log::log debug "set_project_name: Set Project name to $::tclhdl::project_name"
}

#-------------------------------------------------------------------------------
## Set Project Directory
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_project_dir {dir} {
    global ::tclhdl::project_dir
    set ::tclhdl::project_dir $dir
    log::log debug "set_project_dir: Set Project dir to $::tclhdl::project_dir"
}

#-------------------------------------------------------------------------------
## Set Project Type
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_project_type {type} {
    global ::tclhdl::project_type
    global ::tclhdl::project_tool
    set ::tclhdl::project_type $type
    set ::tclhdl::project_tool $type
    log::log debug "set_project_type: Set Project type to $::tclhdl::project_type"
}

#-------------------------------------------------------------------------------
## Set Project Part
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_project_part {part} {
    global ::tclhdl::project_part
    set ::tclhdl::project_part $part
    log::log debug "set_project_part: Set Project part to $::tclhdl::project_part"
}

#-------------------------------------------------------------------------------
## Set Project Jobs
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_project_jobs {jobs} {
    global ::tclhdl::project_jobs
    set ::tclhdl::project_jobs $jobs
    log::log debug "set_project_jobs: Set Project jobs to $::tclhdl::project_jobs"
}

#-------------------------------------------------------------------------------
## Set Project Target Directory
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_project_target_dir {dir} {
    global ::tclhdl::project_target_dir
    set ::tclhdl::project_target_dir $dir
    log::log debug "set_project_type: Set Project target dir to $::tclhdl::project_target_dir"
}

#-------------------------------------------------------------------------------
## Set Project Build Number
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_project_build_number {number} {
    global ::tclhdl::project_build_number
    set ::tclhdl::project_build_number $number
    log::log debug "set_project_build_number: Set Project build number to $::tclhdl::project_build_number"
}

#-------------------------------------------------------------------------------
## Set Project Version
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_project_version {version} {
    global ::tclhdl::project_version
    global ::tclhdl::project_version_major
    global ::tclhdl::project_version_minor
    global ::tclhdl::project_version_patch
    set ::tclhdl::project_version $version
    log::log debug "set_project_version: Set Project Version to $::tclhdl::project_version"

    set version_fields [split $version "."]
    set length [llength $version_fields]

    set ::tclhdl::project_version_major "0"
    if { $length > 0 } {
        set ::tclhdl::project_version_major [lindex $version_fields 0]
    }

    set ::tclhdl::project_version_minor "0"
    if { $length > 1 } {
        set ::tclhdl::project_version_minor [lindex $version_fields 1]
    }

    set ::tclhdl::project_version_patch "0"
    if { $length > 2 } {
        set ::tclhdl::project_version_patch [lindex $version_fields 2]
    }

}

#-------------------------------------------------------------------------------
## Set Project Major Version
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_project_version_major {number} {
    global ::tclhdl::project_version_major
    set ::tclhdl::project_version_major $number
    log::log debug "set_project_version_major: Set Project Major Version to $::tclhdl::project_version_major"
}

#-------------------------------------------------------------------------------
## Set Project Minor Version
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_project_version_minor {number} {
    global ::tclhdl::project_version_minor
    set ::tclhdl::project_version_minor $number
    log::log debug "set_project_version_minor: Set Project Minor Version to $::tclhdl::project_version_minor"
}

#-------------------------------------------------------------------------------
## Set Project Patch Version
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_project_version_patch {number} {
    global ::tclhdl::project_version_patch
    set ::tclhdl::project_version_patch $number
    log::log debug "set_project_version_patch: Set Project Patch Version to $::tclhdl::project_version_patch"
}

#-------------------------------------------------------------------------------
## Set Project Revision
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_project_revision {number} {
    global ::tclhdl::project_revision
    set ::tclhdl::project_revision $number
    log::log debug "set_project_revision: Set Project Revision to $::tclhdl::project_revision"
}

#-------------------------------------------------------------------------------
## Set Project Semantic Version
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_project_semver {semver} {
    global ::tclhdl::project_semver
    set ::tclhdl::project_semver $semver
    log::log debug "set_project_semver: Set Project semver to $::tclhdl::project_semver"
}

#-------------------------------------------------------------------------------
## Set Project Source Directory
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_source_dir {dir} {
    global ::tclhdl::project_source_dir
    set ::tclhdl::project_source_dir $dir
    log::log debug "set_source_dir: Set Project source dir to $::tclhdl::project_source_dir"
}

#-------------------------------------------------------------------------------
## Set Project IP Directory
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_ip_dir {dir} {
    global ::tclhdl::project_ip_dir
    set ::tclhdl::project_ip_dir $dir
    log::log debug "set_ip_dir: Set Project ip dir to $::tclhdl::project_ip_dir"
}

#-------------------------------------------------------------------------------
## Set Porject IP Output Directory
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_ip_output_dir {dir} {
    global ::tclhdl::ip_output_dir
    set ::tclhdl::ip_output_dir $dir
    log::log debug "set_ip_dir: Set ip output dir $::tclhdl::ip_output_dir"

    switch $::tclhdl::project_tool {
        INTEL_QUARTUS {
            $::tclhdl::quartus::set_ip_output_dir $dir
        }
        XILINX_VIVADO {
            check_vivado
        }
        XILINX_ISE {
        }
        LATTICE_DIAMOND {
        }
        default {
            log::logMsg "set_ip_output_dir: No supported tool define for the current project"
        }
    }

}
#-------------------------------------------------------------------------------
## Set Project Constraint Directory
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_constraint_dir {dir} {
    global ::tclhdl::project_constraint_dir
    set ::tclhdl::project_constraint_dir $dir
    log::log debug "set_constraint_dir: Set Project constraint dir to $::tclhdl::project_constraint_dir"
}

#-------------------------------------------------------------------------------
## Set Project Simulation Directory
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_simulation_dir {dir} {
    global ::tclhdl::project_simulation_dir
    set ::tclhdl::project_simulation_dir $dir
    log::log debug "set_simulation_dir: Set Project simulation dir to $::tclhdl::project_simulation_dir"
}

#-------------------------------------------------------------------------------
## Set Project Settings Directory
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_settings_dir {dir} {
    global ::tclhdl::project_settings_dir
    set ::tclhdl::project_settings_dir $dir
    log::log debug "set_settings_dir: Set Project settings dir to $::tclhdl::project_settings_dir"
}

#-------------------------------------------------------------------------------
## Set Project Scripts Directory
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_scripts_dir {dir} {
    global ::tclhdl::project_scripts_dir
    set ::tclhdl::project_scripts_dir $dir
    log::log debug "set_scripts_dir: Set Project scripts dir to $::tclhdl::project_scripts_dir"
}

#-------------------------------------------------------------------------------
## Set Project Simulation Type
#
#-------------------------------------------------------------------------------
proc ::tclhdl::set_project_simulation {name type} {
    global ::tclhdl::list_simulations
    global ::tclhdl::list_simulations_tools
    lappend ::tclhdl::list_simulations $name
    set ::tclhdl::list_simulations_tools($name) $type
    log::log debug "set_project_simulation_type: Set Project Simulation $name type to $type"
}

#-------------------------------------------------------------------------------
## Build Pre
#
#-------------------------------------------------------------------------------
proc ::tclhdl::build_pre {} {
    log::log debug "build_pre: Pre Script build"
    foreach lst $::tclhdl::list_pre_scripts {
        source $lst
    }
}

#-------------------------------------------------------------------------------
## Build IP
#
#-------------------------------------------------------------------------------
proc ::tclhdl::build_ip {} {
    if { $::tclhdl::project_build_full == 0 && $::tclhdl::project_build_step != "ip" } {
        return 0
    }

    log::log debug "build_ip: Build Ip Cores"
    switch $::tclhdl::project_tool {
        INTEL_QUARTUS {
            check_quartus
        }
        XILINX_VIVADO {
            check_vivado
            ::tclhdl::vivado::build_ip
        }
        XILINX_ISE {
            check_ise
            ::tclhdl::ise::build_ip
        }
        LATTICE_DIAMOND {
            check_diamond
            ::tclhdl::diamond::build_ip
        }
        MICROSEMI_LIBERO {
            check_libero
            ::tclhdl::libero::build_ip
        }
        default {
            log::logMsg "build_ip: No supported tool define for the current project"
        }
    }
}

#-------------------------------------------------------------------------------
## Build Synthesis
#
#-------------------------------------------------------------------------------
proc ::tclhdl::build_synthesis {} {
    if { $::tclhdl::project_build_full == 0 && $::tclhdl::project_build_step != "synthesis" } {
        return 0
    }

    log::log debug "build_synthesis: Synthesis"
    switch $::tclhdl::project_tool {
        INTEL_QUARTUS {
            check_quartus
            ::tclhdl::quartus::build_synthesis
        }
        XILINX_VIVADO {
            check_vivado
            ::tclhdl::vivado::build_synthesis
        }
        XILINX_ISE {
            check_ise
            ::tclhdl::ise::build_synthesis
        }
        LATTICE_DIAMOND {
            check_diamond
            ::tclhdl::diamond::build_synthesis
        }
        MICROSEMI_LIBERO {
            check_libero
            ::tclhdl::libero::build_synthesis
        }
        default {
            log::logMsg "build_synthesis: No supported tool define for the current project"
        }
    }
}

#-------------------------------------------------------------------------------
## Build Fitting
#
#-------------------------------------------------------------------------------
proc ::tclhdl::build_fitting {} {
    if { $::tclhdl::project_build_full == 0 && $::tclhdl::project_build_step != "fitting" } {
        return 0
    }

    log::log debug "build_fitting: Place and Route"
    switch $::tclhdl::project_tool {
        INTEL_QUARTUS {
            check_quartus
            ::tclhdl::quartus::build_fitting
        }
        XILINX_VIVADO {
            check_vivado
            ::tclhdl::vivado::build_fitting
        }
        XILINX_ISE {
            check_ise
            ::tclhdl::ise::build_fitting
        }
        LATTICE_DIAMOND {
            check_diamond
            ::tclhdl::diamond::build_fitting
        }
        MICROSEMI_LIBERO {
            check_libero
            ::tclhdl::libero::build_fitting
        }
        default {
            log::logMsg "build_fitting: No supported tool define for the current project"
        }
    }
}

#-------------------------------------------------------------------------------
## Build Timing
#
#-------------------------------------------------------------------------------
proc ::tclhdl::build_timing {} {
    if { $::tclhdl::project_build_full == 0 && $::tclhdl::project_build_step != "timing" } {
        return 0
    }

    log::log debug "build_timing: Timming Analysis"
    switch $::tclhdl::project_tool {
        INTEL_QUARTUS {
            check_quartus
            ::tclhdl::quartus::build_timing
        }
        XILINX_VIVADO {
            check_vivado
            ::tclhdl::vivado::build_timing
        }
        XILINX_ISE {
            check_ise
            ::tclhdl::ise::build_timing
        }
        LATTICE_DIAMOND {
            check_diamond
        }
        MICROSEMI_LIBERO {
            check_libero
        }
        default {
            log::logMsg "build_timing: No supported tool define for the current project"
        }
    }
}

#-------------------------------------------------------------------------------
## Build Simulation
#
#-------------------------------------------------------------------------------
proc ::tclhdl::build_simulation {name settings} {
    if { $::tclhdl::project_build_full == 0 && $::tclhdl::project_build_step != "simulation" } {
        return 0
    }

    log::log debug "build_simulation: Run Simulation $name"
    switch $::tclhdl::project_tool {
        INTEL_QUARTUS {
            check_quartus
            ::tclhdl::quartus::build_simulation $name $settings
        }
        XILINX_VIVADO {
            check_vivado
            ::tclhdl::vivado::build_simulation $name $settings
        }
        XILINX_ISE {
            check_ise
            ::tclhdl::ise::build_simulation $name $settings
        }
        LATTICE_DIAMOND {
            check_diamond
        }
        MICROSEMI_LIBERO {
            check_libero
        }
        default {
            log::logMsg "build_simulation: No supported tool define for the current project"
        }
    }
}

#-------------------------------------------------------------------------------
## Build Post
#
#-------------------------------------------------------------------------------
proc ::tclhdl::build_post {} {
    log::log debug "build_post: Post Script build"
    foreach lst $::tclhdl::list_post_scripts {
        source $lst
    }
}

#-------------------------------------------------------------------------------
## Build Bitstream
#
#-------------------------------------------------------------------------------
proc ::tclhdl::build_bitstream {} {
    if { $::tclhdl::project_build_full == 0 && $::tclhdl::project_build_step != "bitstream" } {
        return 0
    }

    log::log debug "build_bitstream: Generate Bitstream"
    switch $::tclhdl::project_tool {
        INTEL_QUARTUS {
            check_quartus
            ::tclhdl::quartus::build_bitstream
        }
        XILINX_VIVADO {
            check_vivado
            ::tclhdl::vivado::build_bitstream
        }
        XILINX_ISE {
            check_ise
            ::tclhdl::ise::build_bitstream
        }
        LATTICE_DIAMOND {
            check_diamond
            ::tclhdl::diamond::build_bitstream
        }
        MICROSEMI_LIBERO {
            check_libero
            ::tclhdl::libero::build_bitstream
        }
        default {
            log::logMsg "build_bitstream: No supported tool define for the current project"
        }
    }
}

#-------------------------------------------------------------------------------
## Build Report
#
#-------------------------------------------------------------------------------
proc ::tclhdl::build_report {} {
    if { $::tclhdl::project_build_full == 0 && $::tclhdl::project_build_step != "report" } {
        return 0
    }

    log::log debug "build_report: Generate Report"
    switch $::tclhdl::project_tool {
        INTEL_QUARTUS {
            check_quartus
            ::tclhdl::quartus::build_report
        }
        XILINX_VIVADO {
            check_vivado
            ::tclhdl::vivado::build_report
        }
        XILINX_ISE {
            check_ise
            ::tclhdl::ise::build_report
        }
        LATTICE_DIAMOND {
            check_diamond
            ::tclhdl::diamond::build_report
        }
        MICROSEMI_LIBERO {
            check_libero
            ::tclhdl::libero::build_report
        }
        default {
            log::logMsg "build_report: No supported tool define for the current project"
        }
    }
}

#-------------------------------------------------------------------------------
## Build Custom
#
#-------------------------------------------------------------------------------
proc ::tclhdl::build_custom {src} {
    if { $::tclhdl::project_build_full == 0 && $::tclhdl::project_build_step != "custom" } {
        return 0
    }

    log::log debug "build_custom: Custom Build Flow"
    source $src
}

#------------------------------------------------------------------------------
## Package Declaration
#
#------------------------------------------------------------------------------
package provide ::tclhdl $tclhdl::version

