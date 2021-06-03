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
#
#------------------------------------------------------------------------------
## Local System Packages
#
#------------------------------------------------------------------------------
package require ::tclhdl::definitions
package require ::tclhdl::utils

#------------------------------------------------------------------------------
## Namespace Declaration
#------------------------------------------------------------------------------
namespace eval ::tclhdl::vunit {
 
    #-- Export Procedures
    namespace export get_version
 
    #-- Member Variables 
    variable vunit_repo          "https://github.com/VUnit/vunit"
    variable vunit_branch        ""

    #-- Namespace internal variables
    variable home [file join [pwd] [file dirname [info script]]]
    set version 1.0
}

#------------------------------------------------------------------------------
## Get VUnit VHDL File List
#
#------------------------------------------------------------------------------
proc ::tclhdl::vunit::files_vhdl {} {
    list file_list
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/axi_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/string_ops/src/string_ops.vhd"}
    lappend file_list {"vunit_lib" "vhdl/path/src/path.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/VendorCovApiPkg.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/TranscriptPkg.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/TextUtilPkg.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/NamePkg.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/OsvvmGlobalPkg.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/AlertLogPkg.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/SortListPkg_int.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/ScoreboardGenericPkg.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/ScoreboardPkg_slv.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/ScoreboardPkg_int.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/ResolutionPkg.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/TbUtilPkg.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/RandomBasePkg.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/RandomPkg.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/MessagePkg.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/MemoryPkg.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/CoveragePkg.vhd"}
    lappend file_list {"osvvm"     "vhdl/osvvm/OsvvmContext.vhd"}
    lappend file_list {"vunit_lib" "vhdl/logging/src/print_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/types.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/codec_builder.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/codec_builder-2008p.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/codec.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/codec-2008p.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/api/external_string_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/string_ptr_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/logging/src/ansi_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/logging/src/log_levels_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/string_ptr_pkg-body-2002p.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/byte_vector_ptr_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/api/external_integer_vector_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/integer_vector_ptr_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/logging/src/log_handler_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/logging/src/print_pkg-body.vhd"}
    lappend file_list {"vunit_lib" "vhdl/logging/src/logger_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/memory_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/memory_pkg-body.vhd"}
    lappend file_list {"vunit_lib" "vhdl/dictionary/src/dictionary.vhd"}
    lappend file_list {"vunit_lib" "vhdl/run/src/run_types.vhd"}
    lappend file_list {"vunit_lib" "vhdl/logging/src/file_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/logging/src/log_handler_pkg-body.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/integer_vector_ptr_pkg-body-2002p.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/integer_array_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/memory_utils_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/queue_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/string_ptr_pool_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/queue_pkg-body.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/queue_pkg-2008p.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/integer_vector_ptr_pool_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/axi_statistics_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/run/src/runner_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/run/src/run_api.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/queue_pool_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/integer_array_pkg-body.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/dict_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/data_types/src/data_types_context.vhd"}
    lappend file_list {"vunit_lib" "vhdl/core/src/stop_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/core/src/stop_body_2008p.vhd"}
    lappend file_list {"vunit_lib" "vhdl/core/src/core_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/run/src/run.vhd"}
    lappend file_list {"vunit_lib" "vhdl/logging/src/logger_pkg-body.vhd"}
    lappend file_list {"vunit_lib" "vhdl/logging/src/log_levels_pkg-body.vhd"}
    lappend file_list {"vunit_lib" "vhdl/logging/src/log_deprecated_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/com/src/com_types.vhd"}
    lappend file_list {"vunit_lib" "vhdl/com/src/com_api.vhd"}
    lappend file_list {"vunit_lib" "vhdl/check/src/checker_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/run/src/run_deprecated_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/vunit_run_context.vhd"}
    lappend file_list {"vunit_lib" "vhdl/check/src/checker_pkg-body.vhd"}
    lappend file_list {"vunit_lib" "vhdl/check/src/check_api.vhd"}
    lappend file_list {"vunit_lib" "vhdl/check/src/check_deprecated_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/vunit_context.vhd"}
    lappend file_list {"vunit_lib" "vhdl/com/src/com_support.vhd"}
    lappend file_list {"vunit_lib" "vhdl/com/src/com_messenger.vhd"}
    lappend file_list {"vunit_lib" "vhdl/com/src/com_common.vhd"}
    lappend file_list {"vunit_lib" "vhdl/com/src/com_deprecated.vhd"}
    lappend file_list {"vunit_lib" "vhdl/com/src/com_debug_codec_builder.vhd"}
    lappend file_list {"vunit_lib" "vhdl/com/src/com_string.vhd"}
    lappend file_list {"vunit_lib" "vhdl/com/src/com_context.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/wishbone_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/wishbone_slave.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/sync_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/sync_pkg-body.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/stream_slave_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/stream_slave_pkg-body.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/stream_master_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/uart_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/uart_slave.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/uart_master.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/stream_master_pkg-body.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/signal_checker_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/std_logic_checker.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/bus_master_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/wishbone_master.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/ram_master.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/bus_master_pkg-body.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/bus2memory.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/axi_stream_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/axi_stream_protocol_checker.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/axi_stream_private_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/axi_stream_monitor.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/axi_stream_slave.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/axi_stream_master.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/axi_slave_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/axi_lite_master_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/avalon_stream_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/avalon_source.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/avalon_sink.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/avalon_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/vc_context.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/axi_slave_private_pkg.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/axi_write_slave.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/axi_lite_master.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/axi_read_slave.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/avalon_slave.vhd"}
    lappend file_list {"vunit_lib" "vhdl/verification_components/src/avalon_master.vhd"}
    lappend file_list {"vunit_lib" "vhdl/com/src/com.vhd"}
    lappend file_list {"vunit_lib" "vhdl/check/src/check.vhd"}
    
    return [list $file_list]
}

#------------------------------------------------------------------------------
## Get VUnit Verilog File List
#
#------------------------------------------------------------------------------
proc ::tclhdl::vunit::files_verilog {} {
    list file_list
    return file_list
}

#------------------------------------------------------------------------------
## Clone
#
#------------------------------------------------------------------------------
proc ::tclhdl::vunit::clone {dir branch} {
   global ::tclhdl::vunit::vunit_repo
   set current_dir [pwd]
   cd $dir

   file delete -force vunit

   # Clone Repository
   if { [catch {exec git clone $::tclhdl::vunit::vunit_repo --branch=$branch}] } {
    log::log debug "vunit::clone: check cloned repo at $dir"
   }

   # Udpate Subumodules
   cd vunit
   if { [catch {exec git submodule update --init --recursive}] } {
    log::log debug "vunit::clone: Submodules Updated"
   }

   cd $current_dir
}

#------------------------------------------------------------------------------
## Generate ModelSim Library
#------------------------------------------------------------------------------
proc ::tclhdl::vunit::modelsim {root vdir} {

    set file_list [lindex [files_vhdl] 0]
    set current_dir [pwd]
    set vunit_dir "$vdir/vunit"

    # Change to root dir
    cd $root

    # Setup vunit libraries
    exec vlib vunit_lib
    exec vlib osvvm
    exec vmap vunit_lib "$root/vunit_lib"
    exec vmap osvvm "$root/osvvm"

    # Compile VHDL
    foreach file_map $file_list {
        set file_path [lindex $file_map 1]
        exec vcom -64 -2008 -work [lindex $file_map 0] "$vunit_dir/$file_path"
    }

    # Compile Verilog
    # TODO
    
    # Back to original directory
    cd $current_dir
}


#------------------------------------------------------------------------------
## Get Version
#------------------------------------------------------------------------------
proc ::tclhdl::vunit::get_version {} {
   puts $tclhdl::vunit::version
}

#------------------------------------------------------------------------------
## Package Declaration
#------------------------------------------------------------------------------
package provide ::tclhdl::vunit $tclhdl::vunit::version

