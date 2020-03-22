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

#------------------------------------------------------------------------------
## Namespace Declaration
#------------------------------------------------------------------------------
namespace eval ::tclhdl::definitions {
 
    #-- Export Procedures
    namespace export get_version
 
    #-- Member Variables 
    set VENDOR                           {XILINX INTEL LATTICE MICROSEMI}
    set IP_TYPE_INTEL                    {INTEL_IP INTEL_QSYS}
    set IP_TYPE_XILINX                   {XILINX_IP}
    set IP_TYPE_LATTICE                  {LATTICE_IP}
    set IP_GENERATOR_INTEL               "ip-generate"
    set IP_GENERATOR_INTEL_QSYS_SCRIPT   "qsys-script"
    set IP_GENERATOR_INTEL_QSYS_GENERATE "qsys-generate"
    set TOOL_XILINX                      "vivado"
    set TOOL_XILINX_ISE                  "xtclsh"
    set TOOL_INTEL                       "quartus_sh"
    set TOOL_LATTICE                     "diamondc"

    #-- Namespace internal variables
    variable home [file join [pwd] [file dirname [info script]]]
    set version 1.0
}
 
#------------------------------------------------------------------------------
## Get Version
#------------------------------------------------------------------------------
proc ::tclhdl::definitions::get_version {} {
   puts $tclhdl::definitions::version
}

#------------------------------------------------------------------------------
## Package Declaration
#------------------------------------------------------------------------------
package provide ::tclhdl::definitions $tclhdl::definitions::version

