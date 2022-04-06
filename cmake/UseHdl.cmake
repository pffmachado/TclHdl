# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
UseHdl
-------

Use Module for HDL

This file provides functions for TclHdl.  It is assumed that
:module:`FindHdl` has already been loaded.  See :module:`FindHdl` for
information on how to load Hdl into your CMake project.

Creating And Installing HDL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: cmake

add_hdl(<target_name>
    [VENDOR <vendor>]
    [TOOL <tool>]
    [SETTINGS <name> [FILES <file>]]
    [VERSION <major.minor.patch>]
    [REVISION <rev>]
    [OUTPUT_DIR <dir>]
    [OUTPUT_NAME <name>]
    [SOURCES] <source1> [<source2>...]
    [VHDL] <source1> [<source2>...]
    [VHDL_2008] <source1> [<source2>...]
    [VERILOG] <source1> [<source2>...]
    [SYSTEMVERILOG] <source1> [<source2>...]
    [COEFF] <source1> [<source2>...]
    [TCL] <source1> [<source2>...]
    [TCLHDL] <source1> [<source2>...]
    [PRE] <source1> [<source2>...]
    [POST] <source1> [<source2>...]
    [COREGEN] <source1> [<source2>...]
    [XCI] <source1> [<source2>...]
    [XCO] <source1> [<source2>...]
    [XCO_UPGRADE] <source1> [<source2>...]
    [QSYS] <source1> [<source2>...]
    [IPX] <source1> [<source2>...]
    [COREGEN] <source1> [<source2>...]
    [XCI] <source1> [<source2>...]
    [XCO] <source1> [<source2>...]
    [XCO_UPGRADE] <source1> [<source2>...]
    [QSYS] <source1> [<source2>...]
    [CXF] <source1> [<source2>...]
    [FLOW] <flow>
    [SOURCE_DIR] <dir>
    [IP_DIR] <dir>
    [CONSTRAINT_DIR] <dir>
    [SETTING_DIR] <dir>
    [SCRIPT_DIR] <dir>
    )


Examples
""""""""

To add compile flags to the target you can set these flags with the following
variable:

.. code-block:: cmake

Finding Tools
^^^^^^^^^^^^^

.. code-block:: cmake

find_hdl(<VAR>
    <name> | NAMES <name1> [<name2>...]
    [PATHS <path1> [<path2>... ENV <var>]]
    [VERSIONS <version1> [<version2>]]
    [DOC "cache documentation string"]
    )


#]=======================================================================]

#------------------------------------------------------------------------------
#-- Helper function: Add tclhdl file
#------------------------------------------------------------------------------
function(_tclhdl_add_file)
    cmake_parse_arguments(_tclhdl_add_file "" "FUNCTION;NAME;TYPE;OUTPUT" "FILES" ${ARGN})
    set(_type "${_tclhdl_add_file_TYPE}")
    set(_name "${_tclhdl_add_file_NAME}")
    set(_output "${_tclhdl_add_file_OUTPUT}")
    foreach(_file IN LISTS _tclhdl_add_file_FILES)
        set(_function "::tclhdl::${_tclhdl_add_file_FUNCTION} ")
        if (_name)
            string (CONCAT _function ${_function} "\"${_name}\" ")
        endif()
        if (_type)
            string (CONCAT _function ${_function} "\"${_type}\" ")
        endif()
        string (CONCAT _function ${_function} "\"${_file}\"")
        string (CONCAT _function ${_function} "\n")
        file (APPEND ${_output} ${_function})
        #message (STATUS "${_function}")
    endforeach()
endfunction()

#------------------------------------------------------------------------------
#-- TCLHDL Project Setup
#------------------------------------------------------------------------------
function(add_hdl _TARGET_NAME)

    cmake_parse_arguments(_add_hdl
        ""
        "VENDOR;TOOL;SIMULATOR;VERSION;REVISION;OUTPUT_DIR;OUTPUT_NAME"
        "VHDL;VHDL_2008;VERILOG;SYSTEMVERILOG;COEFF;TCL;TCLHDL;SOURCES;PRE;POST;SETTINGS;TCL_SETTINGS;FLOW;SOURCEDIR;IPDIR;CONSTRAINTDIR;SETTINGDIR;SCRIPTDIR;COREGEN;XCI;XCO;XCO_UPGRADE;QSYS;IPTCL;CXF;IPX;UCF;XDC;SDC;SDF;LPF;PDC_FP;PDC_IO"
        ${ARGN}
        )

    if (NOT DEFINED _add_hdl_SIMULATOR)
        set(_add_hdl_SIMULATOR "none")
    endif()
    if(NOT DEFINED _add_hdl_OUTPUT_DIR AND DEFINED CMAKE_HDL_TARGET_OUTPUT_DIR)
        set(_add_hdl_OUTPUT_DIR "${CMAKE_HDL_TARGET_OUTPUT_DIR}")
    endif()
    if(NOT DEFINED _add_hdl_OUTPUT_NAME AND DEFINED CMAKE_HDL_TARGET_OUTPUT_NAME)
        set(_add_hdl_OUTPUT_NAME "${CMAKE_HDL_TARGET_OUTPUT_NAME}")
        set(CMAKE_HDL_TARGET_OUTPUT_NAME)
    endif()
    if (NOT DEFINED _add_hdl_OUTPUT_DIR)
        set(_add_hdl_OUTPUT_DIR ${CMAKE_BINARY_DIR})
    else()
        get_filename_component(_add_hdl_OUTPUT_DIR ${_add_hdl_OUTPUT_DIR} ABSOLUTE)
    endif()
    if (_add_hdl_SETTINGS)
        list (GET _add_hdl_SETTINGS 0 _add_hdl_SETTINGS_NAME)
        cmake_parse_arguments (_add_hdl_SETTINGS "" "" "FILES" ${_add_hdl_SETTINGS})
    endif()

    string(TOUPPER ${_add_hdl_VENDOR} _vendor)
    string(TOUPPER ${_add_hdl_TOOL} _tool)
    string(CONCAT  _vendor_tool ${_vendor} "_" ${_tool})
    string(TOLOWER ${_add_hdl_SIMULATOR} _TARGET_SIMULATOR)

    set (_HDL_VERSION 	                ${_add_hdl_VERSION})
    set (_HDL_REVISION 	                ${_add_hdl_REVISION})
    set (_HDL_VHDL_FILES 	            ${_add_hdl_VHDL})
    set (_HDL_VHDL2008_FILES 	        ${_add_hdl_VHDL_2008})
    set (_HDL_VERILOG_FILES	            ${_add_hdl_VERILOG})
    set (_HDL_SYSTEMVERILOG_FILES	    ${_add_hdl_SYSTEMVERILOG})
    set (_HDL_COEFF_FILES	            ${_add_hdl_COEFF})
    set (_HDL_TCL_FILES 	            ${_add_hdl_TCL})
    set (_HDL_TCLHDL_FILES 	            ${_add_hdl_TCLHDL})
    set (_HDL_PRE_FILES 	            ${_add_hdl_PRE})
    set (_HDL_POST_FILES 	            ${_add_hdl_POST})
    set (_HDL_SOURCEDIR 	            ${_add_hdl_SOURCEDIR})
    set (_HDL_IPDIR 	                ${_add_hdl_IPDIR})
    set (_HDL_CONSTRAINTDIR 	        ${_add_hdl_CONSTRAINTDIR})
    set (_HDL_SETTINGDIR 	            ${_add_hdl_SETTINGDIR})
    set (_HDL_SCRIPTDIR 	            ${_add_hdl_SCRIPTDIR})
    set (_HDL_FLOW_FILES 	            ${_add_hdl_FLOW})
    set (_HDL_SETTINGS_NAME 	        ${_add_hdl_SETTINGS_NAME})
    set (_HDL_SETTINGS_FILES 	        ${_add_hdl_SETTINGS_FILES})
    set (_HDL_TCL_SETTINGS 	            ${_add_hdl_TCL_SETTINGS})
    set (_HDL_COREGEN_FILES 	        ${_add_hdl_COREGEN})
    set (_HDL_XCI_FILES 	            ${_add_hdl_XCI})
    set (_HDL_XCO_FILES 	            ${_add_hdl_XCO})
    set (_HDL_XCO_UPGRADE_FILES         ${_add_hdl_XCO_UPGRADE})
    set (_HDL_IPX_FILES 	            ${_add_hdl_IPX})
    set (_HDL_UCF_FILES 	            ${_add_hdl_UCF})
    set (_HDL_XDC_FILES 	            ${_add_hdl_XDC})
    set (_HDL_SDC_FILES 	            ${_add_hdl_SDC})
    set (_HDL_LPF_FILES 	            ${_add_hdl_LPF})
    set (_HDL_CXF_FILES 	            ${_add_hdl_CXF})
    set (_HDL_PDC_FP_FILES 	            ${_add_hdl_PDC_FP})
    set (_HDL_PDC_IO_FILES 	            ${_add_hdl_PDC_IO})
    set (_HDL_IPTCL_FILES 	            ${_add_hdl_IPTCL})
    set (_HDL_SOURCE_FILES 	            ${_add_hdl_SOURCES} ${_add_hdl_UNPARSED_ARGUMENTS})

    set (_HDL_PROJECT_DIR "${CMAKE_BINARY_DIR}/${_TARGET_NAME}")
    set (_HDL_PROJECT_TYPE 	${_vendor_tool})

    set (CMAKE_HDL_TCLHDL_FILE_PROJECT      "${_HDL_PROJECT_DIR}/project")
    set (CMAKE_HDL_TCLHDL_FILE_SOURCE       "${_HDL_PROJECT_DIR}/sources")
    set (CMAKE_HDL_TCLHDL_FILE_IP           "${_HDL_PROJECT_DIR}/ip")
    set (CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS  "${_HDL_PROJECT_DIR}/constraints")
    set (CMAKE_HDL_TCLHDL_FILE_SIMULATION   "${_HDL_PROJECT_DIR}/simulation")
    set (CMAKE_HDL_TCLHDL_FILE_PRE          "${_HDL_PROJECT_DIR}/pre")
    set (CMAKE_HDL_TCLHDL_FILE_POST         "${_HDL_PROJECT_DIR}/post")
    set (CMAKE_HDL_TCLHDL_FILE_BUILD        "${_HDL_PROJECT_DIR}/build")
    set (CMAKE_HDL_TCLHDL_FILE_SETTINGS     "${_HDL_PROJECT_DIR}/settings")

    #-- Create Project Directory
    file (MAKE_DIRECTORY "${_HDL_PROJECT_DIR}")

    #-- Create TclHdl file structure
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_PROJECT})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_IP})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_SIMULATION})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_PRE})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_POST})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_BUILD})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_SETTINGS})

    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_PROJECT} "")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_SOURCE} "")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_IP} "")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS} "")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_SIMULATION} "")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_PRE} "")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_POST} "")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_BUILD} "")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_SETTINGS} "")

    #-- Set project file environment
    set (_name "::tclhdl::set_project_name \"${_TARGET_NAME}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_project_type \"${_HDL_PROJECT_TYPE}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_project_version \"${_HDL_VERSION}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_source_dir \"${_HDL_SOURCEDIR}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_ip_dir \"${_HDL_IPDIR}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_constraint_dir \"${_HDL_CONSTRAINTDIR}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_settings_dir \"${_HDL_SETTINGDIR}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_scripts_dir \"${_HDL_SCRIPTDIR}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})

    #-- Add project tclhdl project
    set (_name "::tclhdl::add_project \"${_TARGET_NAME}\" \"${_HDL_SETTINGS_NAME}\" \"${_HDL_REVISION}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})

    #-- Add project fetch procedures
    set (_name "::tclhdl::fetch_pre\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::fetch_ips\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::fetch_sources\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::fetch_constraints\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::fetch_simulations\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::fetch_post\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})

    #-- Add sources
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "VHDL"                FILES ${_HDL_VHDL_FILES}               OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "VHDL 2008"           FILES ${_HDL_VHDL2008_FILES}           OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "VERILOG"             FILES ${_HDL_VERILOG_FILES}            OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "SYSTEMVERILOG"       FILES ${_HDL_SYSTEMVERILOG_FILES}      OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "COEFF"               FILES ${_HDL_COEFF_FILES}              OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "TCL"                 FILES ${_HDL_TCL_FILES}                OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_source"     TYPE "TCLHDL"              FILES ${_HDL_TCLHDL_FILES}             OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    _tclhdl_add_file (FUNCTION "add_pre"        TYPE ""                    FILES ${_HDL_PRE_FILES}                OUTPUT ${CMAKE_HDL_TCLHDL_FILE_PRE})
    _tclhdl_add_file (FUNCTION "add_post"       TYPE ""                    FILES ${_HDL_POST_FILES}               OUTPUT ${CMAKE_HDL_TCLHDL_FILE_POST})
    _tclhdl_add_file (FUNCTION "add_ip"         TYPE "COREGEN"             FILES ${_HDL_COREGEN_FILES}            OUTPUT ${CMAKE_HDL_TCLHDL_FILE_IP})
    _tclhdl_add_file (FUNCTION "add_ip"         TYPE "XCI"                 FILES ${_HDL_XCI_FILES}                OUTPUT ${CMAKE_HDL_TCLHDL_FILE_IP})
    _tclhdl_add_file (FUNCTION "add_ip"         TYPE "XCO"                 FILES ${_HDL_XCO_FILES}                OUTPUT ${CMAKE_HDL_TCLHDL_FILE_IP})
    _tclhdl_add_file (FUNCTION "add_ip"         TYPE "XCO_UPGRADE"         FILES ${_HDL_XCO_UPGRADE_FILES}        OUTPUT ${CMAKE_HDL_TCLHDL_FILE_IP})
    _tclhdl_add_file (FUNCTION "add_ip"         TYPE "QSYS"                FILES ${_HDL_QSYS_FILES}               OUTPUT ${CMAKE_HDL_TCLHDL_FILE_IP})
    _tclhdl_add_file (FUNCTION "add_ip"         TYPE "IPX"                 FILES ${_HDL_IPX_FILES}                OUTPUT ${CMAKE_HDL_TCLHDL_FILE_IP})
    _tclhdl_add_file (FUNCTION "add_ip"         TYPE "CXF"                 FILES ${_HDL_CXF_FILES}                OUTPUT ${CMAKE_HDL_TCLHDL_FILE_IP})
    _tclhdl_add_file (FUNCTION "add_ip"         TYPE "IPTCL"               FILES ${_HDL_IPTCL_FILES}              OUTPUT ${CMAKE_HDL_TCLHDL_FILE_IP})
    _tclhdl_add_file (FUNCTION "add_constraint" TYPE "UCF"                 FILES ${_HDL_UCF_FILES}                OUTPUT ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS})
    _tclhdl_add_file (FUNCTION "add_constraint" TYPE "XDC"                 FILES ${_HDL_XDC_FILES}                OUTPUT ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS})
    _tclhdl_add_file (FUNCTION "add_constraint" TYPE "SDC"                 FILES ${_HDL_SDC_FILES}                OUTPUT ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS})
    _tclhdl_add_file (FUNCTION "add_constraint" TYPE "LPF"                 FILES ${_HDL_LPF_FILES}                OUTPUT ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS})
    _tclhdl_add_file (FUNCTION "add_constraint" TYPE "PDC_FP"              FILES ${_HDL_PDC_FP_FILES}             OUTPUT ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS})
    _tclhdl_add_file (FUNCTION "add_constraint" TYPE "PDC_IO"              FILES ${_HDL_PDC_IO_FILES}             OUTPUT ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS})
    _tclhdl_add_file (FUNCTION "add_settings"   TYPE ${_HDL_SETTINGS_NAME} FILES ${_HDL_SETTINGS_FILES}           OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SETTINGS})
    _tclhdl_add_file (FUNCTION "fetch_settings" TYPE ""                    FILES ${_HDL_TCL_SETTINGS}             OUTPUT ${CMAKE_HDL_TCLHDL_FILE_PROJECT})

    #-- Add build flow
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_FLOW_FILES)
        set(_name "::tclhdl::build_")
        string (CONCAT _name ${_name} "${_HDL_SOURCE_FILE}")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_BUILD} ${_name})
    endforeach()

    #-- Set different tools invoke depending upon OS
    set (CMAKE_HDL_SYSTEM_SOURCE "")
    if (UNIX)
        set (CMAKE_HDL_SYSTEM_SOURCE "source")
    endif ()

    #set (TCLHDL_TOOL ${CMAKE_HDL_TCLHDL})
    file (TO_NATIVE_PATH ${CMAKE_HDL_TCLHDL} TCLHDL_TOOL)
    #if ( ${HAS_TCLHDL} )
    set (_TCLHDL_TOOL       "${TCLHDL_TOOL}")
    set (_TCLHDL_IP         "-generateip")
    set (_TCLHDL_DEBUG      "-debug")
    set (_TCLHDL_PROJECT    "-project")
    set (_TCLHDL_GENERATE   "-generate")
    set (_TCLHDL_BUILD      "-build")
    set (_TCLHDL_REPORT     "-report")
    set (_TCLHDL_BITSTREAM  "-bitstream")
    set (_TCLHDL_PROGRAM    "-program")
    set (_TCLHDL_SHELL      "-shell")
    set (_TCLHDL_CLEAN      "-clean")
    set (_TCLHDL_SIMLIB     "-simlib")
    #endif ()

    set (CMAKE_HDL_COMMAND_END "")
    #-- Set the different vendor specific calls
    if ( ${_vendor} STREQUAL "XILINX" )
        #set (XILINX_SOURCE_SETTINGS ${CMAKE_HDL_TOOL_SETTINGS})
        file (TO_NATIVE_PATH ${CMAKE_HDL_TOOL_SETTINGS} XILINX_SOURCE_SETTINGS)
        if ( ${_tool} STREQUAL "VIVADO" )
            set (_VENDOR_TOOL "vivado" "-mode" "tcl" "-notrace" "-source")
            set (_VENDOR_ARGS "-tclargs")
        elseif ( ${_tool} STREQUAL "ISE" )
            set (_VENDOR_TOOL "xtclsh")
            set (_VENDOR_ARGS "")
        endif ()
        set (_VENDOR_TOOL_VERSION "")
        set (_VENDOR_SOURCE "${XILINX_SOURCE_SETTINGS}")
        set (CMAKE_HDL_COMMAND ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_PROJECT} ${_TARGET_NAME})
    elseif ( ${_vendor} MATCHES "Altera|Intel" )
        if ( ${_tool} EQUAL "Quartus" )
            set (_VENDOR_TOOL "quartus_sh")
        endif ()
        set (_VENDOR_TOOL_VERSION "")
        set (_VENDOR_SOURCE "${INTEL_SOURCE_SETTINGS}")
        set (CMAKE_HDL_COMMAND ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_PROJECT} ${_TARGET_NAME})
    elseif ( ${_vendor} STREQUAL "LATTICE" )
        file (TO_NATIVE_PATH ${CMAKE_HDL_TOOL_SETTINGS} LATTICE_SOURCE_SETTINGS)
        if ( ${_tool} STREQUAL "DIAMOND" )
            set (_VENDOR_TOOL "pnmainc")
            if (UNIX)
                set (_VENDOR_TOOL "diamondc")
            endif ()
            set (_VENDOR_ARGS "")
        endif ()
        set (_VENDOR_TOOL_VERSION "")
        set (_VENDOR_SOURCE "${LATTICE_SOURCE_SETTINGS}")
        set (CMAKE_HDL_COMMAND ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_PROJECT} ${_TARGET_NAME})
    elseif ( ${_vendor} STREQUAL "MICROSEMI" )
        file (TO_NATIVE_PATH ${CMAKE_HDL_TOOL_SETTINGS} MICROSEMI_SOURCE_SETTINGS)
        if ( ${_tool} STREQUAL "LIBERO" )
            set (_VENDOR_TOOL "libero" "script:")
            set (_VENDOR_ARGS "script_args:")
        endif ()
        set (_VENDOR_TOOL_VERSION "")
        set (_VENDOR_SOURCE "${MICROSEMI_SOURCE_SETTINGS}")
        set (CMAKE_HDL_COMMAND ${_VENDOR_TOOL}${_TCLHDL_TOOL} ${_VENDOR_ARGS}\"${_TCLHDL_DEBUG} ${_TCLHDL_PROJECT} ${_TARGET_NAME})
        set (CMAKE_HDL_COMMAND_END "\"")
    endif ()

    set (CMAKE_HDL_SIMULATION_SETTINGS "")
    if (UNIX)
        set (CMAKE_HDL_SIMULATION_SETTINGS ${_VENDOR_SOURCE})
    endif ()

    #set (TCLHDL_TOOL ${CMAKE_HDL_TCLHDL})
    file (TO_NATIVE_PATH ${CMAKE_HDL_TCLHDL} TCLHDL_TOOL)
    #if ( ${HAS_TCLHDL} )
    set (_TCLHDL_TOOL       "${TCLHDL_TOOL}")
    set (_TCLHDL_IP         "-generateip")
    set (_TCLHDL_DEBUG      "-debug")
    set (_TCLHDL_PROJECT    "-project")
    set (_TCLHDL_GENERATE   "-generate")
    set (_TCLHDL_BUILD      "-build")
    set (_TCLHDL_REPORT     "-report")
    set (_TCLHDL_BITSTREAM  "-bitstream")
    set (_TCLHDL_PROGRAM    "-program")
    set (_TCLHDL_SHELL      "-shell")
    set (_TCLHDL_CLEAN      "-clean")
    set (_TCLHDL_SIMLIB     "-simlib")
    #endif ()

    add_custom_target (${_TARGET_NAME}-shell
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${CMAKE_HDL_COMMAND} ${_TCLHDL_SHELL}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-ip
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${CMAKE_HDL_COMMAND} ${_TCLHDL_IP} ${CMAKE_HDL_COMMAND_END}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-generate
        COMMAND
        ${CMAKE_HDL_SYSTEM_SOURCE} ${CMAKE_HDL_SIMULATION_SETTINGS} &&
        ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${CMAKE_HDL_COMMAND} ${_TCLHDL_GENERATE} ${CMAKE_HDL_COMMAND_END}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-report
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${CMAKE_HDL_COMMAND} ${_TCLHDL_BUILD} ${CMAKE_HDL_COMMAND_END}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-bitstream
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${CMAKE_HDL_COMMAND} ${_TCLHDL_BITSTREAM} ${CMAKE_HDL_COMMAND_END}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-program
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${CMAKE_HDL_COMMAND} ${_TCLHDL_PROGRAM} ${CMAKE_HDL_COMMAND_END}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-clean
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${CMAKE_HDL_COMMAND} ${_TCLHDL_CLEAN} ${CMAKE_HDL_COMMAND_END}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-simlib
        COMMAND
        ${CMAKE_HDL_SYSTEM_SOURCE} ${CMAKE_HDL_SIMULATION_SETTINGS} &&
        ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${CMAKE_HDL_COMMAND} ${_TCLHDL_SIMLIB} ${_TARGET_SIMULATOR} ${CMAKE_HDL_COMMAND_END}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${CMAKE_HDL_COMMAND} ${_TCLHDL_BUILD} ${CMAKE_HDL_COMMAND_END}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

endfunction()

#------------------------------------------------------------------------------
#-- TCLHDL Simulation Project Setup
#------------------------------------------------------------------------------
function(add_hdl_simulation _TARGET_NAME)

    cmake_parse_arguments(_add_hdl_simulation
        ""
        "SIMULATION;VENDOR;TOOL;REVISION;TOPLEVEL;OUTPUT_DIR;OUTPUT_NAME"
        "SETTINGS;VHDL;VHDL_2008;VERILOG;SYSTEMVERILOG;TCL;TCLHDL;SOURCES;PRE;POST;SOURCEDIR;SCRIPTDIR"
        ${ARGN}
        )

    if(NOT DEFINED _add_hdl_simulation_OUTPUT_DIR AND DEFINED CMAKE_HDL_TARGET_OUTPUT_DIR)
        set(_add_hdl_simulation_OUTPUT_DIR "${CMAKE_HDL_TARGET_OUTPUT_DIR}")
    endif()
    if(NOT DEFINED _add_hdl_simulation_OUTPUT_NAME AND DEFINED CMAKE_HDL_TARGET_OUTPUT_NAME)
        set(_add_hdl_simulation_OUTPUT_NAME "${CMAKE_HDL_TARGET_OUTPUT_NAME}")
        set(CMAKE_HDL_TARGET_OUTPUT_NAME)
    endif()
    if (NOT DEFINED _add_hdl_simulation_OUTPUT_DIR)
        set(_add_hdl_simulation_OUTPUT_DIR ${CMAKE_BINARY_DIR})
    else()
        get_filename_component(_add_hdl_simulation_OUTPUT_DIR ${_add_hdl_simulation_OUTPUT_DIR} ABSOLUTE)
    endif()
    if (_add_hdl_simulation_SIMULATION)
        list (GET _add_hdl_simulation_SIMULATION 0 _add_hdl_simulation_SIMULATION_NAME)
        cmake_parse_arguments (_add_hdl_simulation_SIMULATION "" "" "FILES" ${_add_hdl_simulation_SIMULATION})
    endif()
    if (_add_hdl_simulation_SETTINGS)
        list (GET _add_hdl_simulation_SETTINGS 0 _add_hdl_simulation_SETTINGS_NAME)
        cmake_parse_arguments (_add_hdl_simulation_SETTINGS "" "" "FILES" ${_add_hdl_simulation_SETTINGS})
    endif()


    string(TOUPPER ${_add_hdl_simulation_VENDOR} _vendor)
    string(TOUPPER ${_add_hdl_simulation_TOOL} _tool)
    string(CONCAT  _vendor_tool ${_vendor} "_" ${_tool})

    set (_HDL_NAME  	                ${_add_hdl_simulation_SIMULATION})
    set (_HDL_REVISION 	                ${_add_hdl_simulation_REVISION})
    set (_HDL_TOPLEVEL 	                ${_add_hdl_simulation_TOPLEVEL})
    set (_HDL_SETTINGS_NAME 	        ${_add_hdl_simulation_SETTINGS_NAME})
    set (_HDL_SETTINGS_FILES 	        ${_add_hdl_simulation_SETTINGS_FILES})
    set (_HDL_VHDL_FILES 	            ${_add_hdl_simulation_VHDL})
    set (_HDL_VHDL2008_FILES 	        ${_add_hdl_simulation_VHDL_2008})
    set (_HDL_VERILOG_FILES	            ${_add_hdl_simulation_VERILOG})
    set (_HDL_SYSTEMVERILOG_FILES	    ${_add_hdl_simulation_SYSTEMVERILOG})
    set (_HDL_TCL_FILES 	            ${_add_hdl_simulation_TCL})
    set (_HDL_TCLHDL_FILES 	            ${_add_hdl_simulation_TCLHDL})
    set (_HDL_PRE_FILES 	            ${_add_hdl_simulation_PRE})
    set (_HDL_POST_FILES 	            ${_add_hdl_simulation_POST})
    set (_HDL_SOURCEDIR 	            ${_add_hdl_simulation_SOURCEDIR})
    set (_HDL_SCRIPTDIR 	            ${_add_hdl_simulation_SCRIPTDIR})
    set (_HDL_TCL_SETTINGS 	            ${_add_hdl_simulation_TCL_SETTINGS})
    set (_HDL_SOURCE_FILES 	            ${_add_hdl_simulation_SOURCES} ${_add_hdl_simulation_UNPARSED_ARGUMENTS})

    set (_HDL_PROJECT_DIR "${CMAKE_BINARY_DIR}/${_TARGET_NAME}")
    set (_HDL_PROJECT_TYPE 	${_vendor_tool})

    set (CMAKE_HDL_TCLHDL_FILE_SIMULATION   "${_HDL_PROJECT_DIR}/simulation")

    #-- Set simulation file environment
    set (_name "::tclhdl::set_project_simulation \"${_HDL_SETTINGS_NAME}\" \"${_HDL_PROJECT_TYPE}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_SIMULATION} ${_name})
    set (_name "::tclhdl::add_simulation_settings \"${_HDL_SETTINGS_NAME}\" \"${_HDL_TOPLEVEL}\" \"${_HDL_SETTINGS_FILES}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_SIMULATION} ${_name})

    #-- Add sources
    _tclhdl_add_file (FUNCTION "add_simulation"  NAME "${_HDL_SETTINGS_NAME}"   TYPE "VHDL"                FILES ${_HDL_VHDL_FILES}              OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SIMULATION})
    _tclhdl_add_file (FUNCTION "add_simulation"  NAME "${_HDL_SETTINGS_NAME}"   TYPE "VHDL 2008"           FILES ${_HDL_VHDL2008_FILES}          OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SIMULATION})
    _tclhdl_add_file (FUNCTION "add_simulation"  NAME "${_HDL_SETTINGS_NAME}"   TYPE "VERILOG"             FILES ${_HDL_VERILOG_FILES}           OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SIMULATION})
    _tclhdl_add_file (FUNCTION "add_simulation"  NAME "${_HDL_SETTINGS_NAME}"   TYPE "SYSTEMVERILOG"       FILES ${_HDL_SYSTEMVERILOG_FILES}     OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SIMULATION})
    _tclhdl_add_file (FUNCTION "add_simulation"  NAME "${_HDL_SETTINGS_NAME}"   TYPE "COEFF"               FILES ${_HDL_COEFF_FILES}             OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SIMULATION})
    #    _tclhdl_add_file (FUNCTION "add_tcl"                                        TYPE ""                    FILES ${_HDL_TCL_FILES}               OUTPUT ${CMAKE_HDL_TCLHDL_FILE_SIMULATION})

    #-- Set different tools invoke depending upon OS
    set (CMAKE_HDL_SYSTEM_SOURCE "")
    if (UNIX)
        set (CMAKE_HDL_SYSTEM_SOURCE "source")
    endif ()

    #-- Set the different vendor specific calls
    if ( ${_vendor} STREQUAL "XILINX" )
        file (TO_NATIVE_PATH ${CMAKE_HDL_TOOL_SETTINGS} XILINX_SOURCE_SETTINGS)
        if ( ${_tool} STREQUAL "VIVADO" )
            set (_VENDOR_TOOL "vivado" "-mode" "tcl" "-notrace" "-source")
            set (_VENDOR_ARGS "-tclargs")
        elseif ( ${_tool} STREQUAL "ISE" )
            set (_VENDOR_TOOL "xtclsh")
            set (_VENDOR_ARGS "")
        endif ()
        set (_VENDOR_TOOL_VERSION "")
        set (_VENDOR_SOURCE "${XILINX_SOURCE_SETTINGS}")
    elseif ( ${_vendor} MATCHES "Altera|Intel" )
        if ( ${_tool} EQUAL "Quartus" )
            set (_VENDOR_TOOL "quartus_sh")
        endif ()
        set (_VENDOR_TOOL_VERSION "")
        set (_VENDOR_SOURCE "${INTEL_SOURCE_SETTINGS}")
    elseif ( ${_vendor} STREQUAL "LATTICE" )
        file (TO_NATIVE_PATH ${CMAKE_HDL_TOOL_SETTINGS} LATTICE_SOURCE_SETTINGS)
        if ( ${_tool} STREQUAL "DIAMOND" )
            set (_VENDOR_TOOL "pnmainc")
            if (UNIX)
                set (_VENDOR_TOOL "diamondc")
            endif ()
            set (_VENDOR_ARGS "")
        endif ()
        set (_VENDOR_TOOL_VERSION "")
        set (_VENDOR_SOURCE "${LATTICE_SOURCE_SETTINGS}")
    elseif ( ${_vendor} STREQUAL "MICROSEMI" )
        file (TO_NATIVE_PATH ${CMAKE_HDL_TOOL_SETTINGS} MICROSEMI_SOURCE_SETTINGS)
        if ( ${_tool} STREQUAL "LIBERO" )
            set (_VENDOR_TOOL "libero")
            if (UNIX)
                set (_VENDOR_TOOL "libero")
            endif ()
            set (_VENDOR_ARGS "")
        endif ()
        set (_VENDOR_TOOL_VERSION "")
        set (_VENDOR_SOURCE "${MICROSEMI_SOURCE_SETTINGS}")
    elseif ( ${_vendor} STREQUAL "MENTOR" )
        file (TO_NATIVE_PATH ${CMAKE_HDL_TOOL_SETTINGS} MENTOR_SOURCE_SETTINGS)
        if ( ${_tool} STREQUAL "MENTOR" )
            set (_VENDOR_TOOL "vsim")
            set (_VENDOR_ARGS "")
        endif ()
        set (_VENDOR_TOOL_VERSION "")
        set (_VENDOR_SOURCE "${MENTOR_SOURCE_SETTINGS}")
    endif ()

    #set (TCLHDL_TOOL ${CMAKE_HDL_TCLHDL})
    file (TO_NATIVE_PATH ${CMAKE_HDL_TCLHDL} TCLHDL_TOOL)
    #if ( ${HAS_TCLHDL} )
    set (_TCLHDL_TOOL                "${TCLHDL_TOOL}")
    set (_TCLHDL_DEBUG               "-debug")
    set (_TCLHDL_PROJECT             "-project")
    set (_TCLHDL_SIMULATION          "-simulation")
    set (_TCLHDL_SIMULATION_SETTINGS "-simsettings")
    #endif ()

    add_custom_target (${_TARGET_NAME}-${_HDL_SETTINGS_NAME}
        COMMAND
        ${CMAKE_HDL_SYSTEM_SOURCE} ${CMAKE_HDL_SIMULATION_SETTINGS} &&
        ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_SIMULATION} ${_HDL_SETTINGS_NAME} ${_TCLHDL_SIMULATION_SETTINGS} ${_HDL_TCL_FILES} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        )

    add_test(
        NAME ${_HDL_SETTINGS_NAME}
        COMMAND cmake --build "${CMAKE_BINARY_DIR}" --target "${_TARGET_NAME}-${_HDL_SETTINGS_NAME}"
        )

endfunction()

