
function(_tclhdl_add_comment ouput comment)
    file (APPEND ${output} "-----------------------------")
    file (APPEND ${output} ${comment})
    file (APPEND ${output} "-----------------------------")
endfunction()

function(_tclhdl_add_source _list _type _output)
    foreach(_HDL_SOURCE_FILE IN LISTS _list)
        set(_name "::tclhdl::add_source ")
        string (CONCAT _name ${_name} "\"${type}\" ")
        string (CONCAT _name ${_name} "\"${_HDL_SOURCE_FILE}\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${_output} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()
endfunction()


function(add_hdl _TARGET_NAME)

    cmake_parse_arguments(_add_hdl
        ""
        "VENDOR;TOOL;SETTINGS;REVISION;OUTPUT_DIR;OUTPUT_NAME"
        "VHDL;VHDL_2008;VERILOG;COEFF;TCL;TCLHDL;SOURCES;PRE;POST;SOURCEDIR;IPDIR;CONSTRAINTDIR;SETTINGDIR;SCRIPTDIR"
        ${ARGN}
        )

    if(NOT DEFINED _add_hdl_OUTPUT_DIR AND DEFINED CMAKE_HDL_TARGET_OUTPUT_DIR)
        set(_add_hdl_OUTPUT_DIR "${CMAKE_HDL_TARGET_OUTPUT_DIR}")
    endif()
    if(NOT DEFINED _add_hdl_OUTPUT_NAME AND DEFINED CMAKE_HDL_TARGET_OUTPUT_NAME)
        set(_add_hdl_OUTPUT_NAME "${CMAKE_HDL_TARGET_OUTPUT_NAME}")
        # reset
        set(CMAKE_HDL_TARGET_OUTPUT_NAME)
    endif()
    if (NOT DEFINED _add_hdl_OUTPUT_DIR)
        set(_add_hdl_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR})
    else()
        get_filename_component(_add_hdl_OUTPUT_DIR ${_add_hdl_OUTPUT_DIR} ABSOLUTE)
    endif()

    string(TOUPPER ${_add_hdl_VENDOR} _vendor)
    string(TOUPPER ${_add_hdl_TOOL} _tool)
    string(CONCAT  _vendor_tool ${_vendor} "_" ${_tool})

    set (_HDL_SETTINGS 	        ${_add_hdl_SETTINGS})
    set (_HDL_REVISION 	        ${_add_hdl_REVISION})
    set (_HDL_VHDL_FILES 	    ${_add_hdl_VHDL})
    set (_HDL_VHDL2008_FILES 	${_add_hdl_VHDL_2008})
    set (_HDL_VERILOG_FILES	    ${_add_hdl_VERILOG})
    set (_HDL_COEFF_FILES	    ${_add_hdl_COEFF})
    set (_HDL_TCL_FILES 	    ${_add_hdl_TCL})
    set (_HDL_TCLHDL_FILES 	    ${_add_hdl_TCLHDL})
    set (_HDL_PRE_FILES 	    ${_add_hdl_PRE})
    set (_HDL_POST_FILES 	    ${_add_hdl_POST})
    set (_HDL_SOURCEDIR 	    ${_add_hdl_SOURCEDIR})
    set (_HDL_IPDIR 	        ${_add_hdl_IPDIR})
    set (_HDL_CONSTRAINT 	    ${_add_hdl_CONSTRAINTDIR})
    set (_HDL_SETTINGDIR 	    ${_add_hdl_SETTINGDIR})
    set (_HDL_SCRIPTDIR 	    ${_add_hdl_SCRIPTDIR})
    set (_HDL_SOURCE_FILES 	    ${_add_hdl_SOURCES} ${_add_hdl_UNPARSED_ARGUMENTS})

    set (_HDL_PROJECT_DIR "${CMAKE_CURRENT_BINARY_DIR}/${_TARGET_NAME}")
    set (_HDL_PROJECT_TYPE 	${_vendor_tool})

    set (CMAKE_HDL_TCLHDL_FILE_PROJECT      "${_HDL_PROJECT_DIR}/project")
    set (CMAKE_HDL_TCLHDL_FILE_SOURCE       "${_HDL_PROJECT_DIR}/sources")
    set (CMAKE_HDL_TCLHDL_FILE_IP           "${_HDL_PROJECT_DIR}/ip")
    set (CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS  "${_HDL_PROJECT_DIR}/constraints")
    set (CMAKE_HDL_TCLHDL_FILE_SIMULATION   "${_HDL_PROJECT_DIR}/simulation")
    set (CMAKE_HDL_TCLHDL_FILE_PRE          "${_HDL_PROJECT_DIR}/pre")
    set (CMAKE_HDL_TCLHDL_FILE_POST         "${_HDL_PROJECT_DIR}/post")

    #-- Create Project Directory
    message (STATUS "------- Project Dir Creation: ${_HDL_PROJECT_DIR}")
    file (MAKE_DIRECTORY "${_HDL_PROJECT_DIR}")

    #-- Create TclHdl file structure
    message (STATUS "------- Touch files: ${CMAKE_HDL_TCLHDL_FILE_PROJECT}")
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_PROJECT})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_SOURCE})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_IP})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_SIMULATION})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_PRE})
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_POST})

    #-- Project file
    message (STATUS "------- Parse files: Project ")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_PROJECT} "")

    set (_name "::tclhdl::set_project_name \"${_TARGET_NAME}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_project_type \"${_HDL_PROJECT_TYPE}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_source_dir \"${_HDL_SOURCEDIR}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_ip_dir \"${_HDL_IPDIR}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_constraint_dir \"${_HDL_CONSTRAINT}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_settings_dir \"${_HDL_SETTINGDIR}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})
    set (_name "::tclhdl::set_scripts_dir \"${_HDL_SCRIPTDIR}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})

    set (_name "::tclhdl::add_project \"${_TARGET_NAME}\" \"${_HDL_SETTINGS}\" \"${_HDL_REVISION}\"\n\n")
    file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PROJECT} ${_name})

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

    #-- Parse Source Files
    message (STATUS "------- Parse files: Source -- ${_HDL_SOURCE_FILES}")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_SOURCE} "")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_SOURCE_FILES)
        set(_name "::tclhdl::add_source ")
        get_filename_component(_extension ${_HDL_SOURCE_FILE} EXT)
        if (${_extension} MATCHES "vhd")
            string (CONCAT _name ${_name} "\"VHDL\" ")
        endif()
        if (${_extension} MATCHES "v")
            string (CONCAT _name ${_name} "\"VERILOG\" ")
        endif()
        if (${_extension} MATCHES "")
            string (CONCAT _name ${_name} "\"\" ")
        endif()

        string (CONCAT _name ${_name} "\"${_HDL_SOURCE_FILE}\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_SOURCE} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()

    message (STATUS "------- Parse files: VHDL ${_HDL_VHDL_FILES}")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_VHDL_FILES)
        set(_name "::tclhdl::add_source ")
        string (CONCAT _name ${_name} "\"VHDL\" ")
        string (CONCAT _name ${_name} "\"${_HDL_SOURCE_FILE}\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_SOURCE} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()

    message (STATUS "------- Parse files: VHDL2008 ${_HDL_VHDL2008_FILES}")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_VHDL2008_FILES)
        set(_name "::tclhdl::add_source ")
        string (CONCAT _name ${_name} "\"VHDL 2008\" ")
        string (CONCAT _name ${_name} "\"${_HDL_SOURCE_FILE}\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_SOURCE} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()

    message (STATUS "------- Parse files: Verilog")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_VERILOG_FILES)
        set(_name "::tclhdl::add_source ")
        string (CONCAT _name ${_name} "\"VERILOG\" ")
        string (CONCAT _name ${_name} "\"${_HDL_SOURCE_FILE}\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_SOURCE} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()

    message (STATUS "------- Parse files: COEFF")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_COEFF_FILES)
        set(_name "::tclhdl::add_source ")
        string (CONCAT _name ${_name} "\"COEFF\" ")
        string (CONCAT _name ${_name} "\"${_HDL_SOURCE_FILE}\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_SOURCE} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()

    message (STATUS "------- Parse files: TCLHDL")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_TCLHDL_FILES)
        set(_name "::tclhdl::add_source ")
        string (CONCAT _name ${_name} "\"TCLHDL\" ")
        string (CONCAT _name ${_name} "\"${_HDL_SOURCE_FILE}\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_SOURCE} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()

    message (STATUS "------- Parse files: TCL")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_TCL_FILES)
        set(_name "::tclhdl::add_source ")
        string (CONCAT _name ${_name} "\"TCL\" ")
        string (CONCAT _name ${_name} "\"${_HDL_SOURCE_FILE}\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_SOURCE} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()

    message (STATUS "------- Parse files: PRE")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_PRE} "")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_PRE_FILES)
        set(_name "::tclhdl::add_pre ")
        string (CONCAT _name ${_name} "\"${_HDL_SOURCE_FILE}\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_PRE} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()

    message (STATUS "------- Parse files: POST")
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_POST} "")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_POST_FILES)
        set(_name "::tclhdl::add_post ")
        string (CONCAT _name ${_name} "\"${_HDL_SOURCE_FILE}\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_POST} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()

    #-- Prepare Vendor Tools

    set (CMAKE_HDL_SYSTEM_SOURCE "")
    if (UNIX)
        set (CMAKE_HDL_SYSTEM_SOURCE "source")
    endif ()

    if ( ${_vendor} STREQUAL "XILINX" )
        message (STATUS "------------ Set tools: ${_vendor}")
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
    elseif ( ${_vendor} MATCHES "Altera|Intel" )
        if ( ${_tool} EQUAL "Quartus" )
            set (_VENDOR_TOOL "quartus_sh")
        endif ()
        set (_VENDOR_TOOL_VERSION "")
        set (_VENDOR_SOURCE "${INTEL_SOURCE_SETTINGS}")
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
    #endif ()

    add_custom_target (${_TARGET_NAME}-shell
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
        ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_SHELL} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-ip
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
            ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_IP} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-generate
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
            ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_GENERATE} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-report
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
            ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_BUILD} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-bitstream
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
            ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_BITSTREAM} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-program
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
            ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_PROGRAM} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}-clean
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
            ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_CLEAN} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )

    add_custom_target (${_TARGET_NAME}
        COMMAND ${CMAKE_HDL_SYSTEM_SOURCE} ${_VENDOR_SOURCE} &&
            ${_VENDOR_TOOL} ${_TCLHDL_TOOL} ${_VENDOR_ARGS} ${_TCLHDL_DEBUG} ${_TCLHDL_BUILD} ${_TCLHDL_PROJECT} ${_TARGET_NAME}
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )

endfunction()

function(add_hdl_ip _TARGET_NAME)

    cmake_parse_arguments(_add_hdl_ip
        ""
        "OUTPUT_DIR;OUTPUT_NAME"
        "COREGEN;XCI;XCO;XCO_UPGRADE;QSYS;TCL;TCLHDL"
        ${ARGN}
        )

    if(NOT DEFINED _add_hdl_ip_OUTPUT_DIR AND DEFINED CMAKE_HDL_TARGET_OUTPUT_DIR)
        set(_add_hdl_ip_OUTPUT_DIR "${CMAKE_HDL_TARGET_OUTPUT_DIR}")
    endif()
    if(NOT DEFINED _add_hdl_ip_OUTPUT_NAME AND DEFINED CMAKE_HDL_TARGET_OUTPUT_NAME)
        set(_add_hdl_ip_OUTPUT_NAME "${CMAKE_HDL_TARGET_OUTPUT_NAME}")
        # reset
        set(CMAKE_HDL_TARGET_OUTPUT_NAME)
    endif()
    if (NOT DEFINED _add_hdl_ip_OUTPUT_DIR)
        set(_add_hdl_ip_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR})
    else()
        get_filename_component(_add_hdl_ip_OUTPUT_DIR ${_add_hdl_ip_OUTPUT_DIR} ABSOLUTE)
    endif()

    set(_HDL_COREGEN_FILES 	    ${_add_hdl_ip_COREGEN})
    set(_HDL_XCI_FILES 	        ${_add_hdl_ip_XCI})
    set(_HDL_XCO_FILES 	        ${_add_hdl_ip_XCO})
    set(_HDL_XCO_UPGRADE_FILES 	${_add_hdl_ip_XCO_UPGRADE})

    set (_HDL_PROJECT_DIR "${CMAKE_CURRENT_BINARY_DIR}/${_TARGET_NAME}")
    set (CMAKE_HDL_TCLHDL_FILE_IP           "${_HDL_PROJECT_DIR}/ip")

    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_IP})
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_IP} "")

    message (STATUS "------- Parse files: COREGEN")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_COREGEN_FILES)
        set(_name "::tclhdl::add_ip ")
        string (CONCAT _name ${_name} "\"COREGEN\" ")
        string (CONCAT _name ${_name} "\"${_HDL_SOURCE_FILE}\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_IP} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()

    message (STATUS "------- Parse files: XCI")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_XCI_FILES)
        set(_name "::tclhdl::add_ip ")
        string (CONCAT _name ${_name} "\"XCI\" ")
        string (CONCAT _name ${_name} "\"${_HDL_SOURCE_FILE}\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_IP} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()

    message (STATUS "------- Parse files: XCO")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_XCO_FILES)
        set(_name "::tclhdl::add_ip ")
        string (CONCAT _name ${_name} "\"XCO\" ")
        string (CONCAT _name ${_name} "\"${_HDL_SOURCE_FILE}\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_IP} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()

    message (STATUS "------- Parse files: XCO_UPGRADE")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_XCO_UPGRADE_FILES)
        set(_name "::tclhdl::add_ip ")
        string (CONCAT _name ${_name} "\"XCO\" ")
        string (CONCAT _name ${_name} "\"${_HDL_SOURCE_FILE}\"")
        string (CONCAT _name ${_name} "\"UPGRADE\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_IP} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()


endfunction()

function(add_hdl_constraint _TARGET_NAME)

    cmake_parse_arguments(_add_hdl_constraint
        ""
        "OUTPUT_DIR;OUTPUT_NAME"
        "UCF;XDC;SDF;LPF;TCL;TCLHDL"
        ${ARGN}
        )

    if(NOT DEFINED _add_hdl_constraint_OUTPUT_DIR AND DEFINED CMAKE_HDL_TARGET_OUTPUT_DIR)
        set(_add_hdl_constraint_OUTPUT_DIR "${CMAKE_HDL_TARGET_OUTPUT_DIR}")
    endif()
    if(NOT DEFINED _add_hdl_constraint_OUTPUT_NAME AND DEFINED CMAKE_HDL_TARGET_OUTPUT_NAME)
        set(_add_hdl_constraint_OUTPUT_NAME "${CMAKE_HDL_TARGET_OUTPUT_NAME}")
        # reset
        set(CMAKE_HDL_TARGET_OUTPUT_NAME)
    endif()
    if (NOT DEFINED _add_hdl_constraint_OUTPUT_DIR)
        set(_add_hdl_constraint_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR})
    else()
        get_filename_component(_add_hdl_constraint_OUTPUT_DIR ${_add_hdl_constraint_OUTPUT_DIR} ABSOLUTE)
    endif()

    set(_HDL_UCF_FILES 	${_add_hdl_constraint_UCF})
    set(_HDL_XDC_FILES 	${_add_hdl_constraint_XDC})

    set (_HDL_PROJECT_DIR "${CMAKE_CURRENT_BINARY_DIR}/${_TARGET_NAME}")

    set (CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS  "${_HDL_PROJECT_DIR}/constraints")

    #-- Create TclHdl file structure
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS})
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS} "")

    message (STATUS "------- Parse files: UCF")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_UCF_FILES)
        set(_name "::tclhdl::add_constraint ")
        string (CONCAT _name ${_name} "\"UCF\" ")
        string (CONCAT _name ${_name} "\"${_HDL_SOURCE_FILE}\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()

    message (STATUS "------- Parse files: XDC")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_XDC_FILES)
        set(_name "::tclhdl::add_constraint ")
        string (CONCAT _name ${_name} "\"XDC\" ")
        string (CONCAT _name ${_name} "\"${_HDL_SOURCE_FILE}\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_CONSTRAINTS} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()

endfunction()

function(add_hdl_settings _TARGET_NAME)

    cmake_parse_arguments(_add_hdl_settings
        ""
        "NAME;OUTPUT_DIR;OUTPUT_NAME"
        "SETTINGS"
        ${ARGN}
        )

    if(NOT DEFINED _add_hdl_settings_OUTPUT_DIR AND DEFINED CMAKE_HDL_TARGET_OUTPUT_DIR)
        set(_add_hdl_settings_OUTPUT_DIR "${CMAKE_HDL_TARGET_OUTPUT_DIR}")
    endif()
    if(NOT DEFINED _add_hdl_settings_OUTPUT_NAME AND DEFINED CMAKE_HDL_TARGET_OUTPUT_NAME)
        set(_add_hdl_settings_OUTPUT_NAME "${CMAKE_HDL_TARGET_OUTPUT_NAME}")
        # reset
        set(CMAKE_HDL_TARGET_OUTPUT_NAME)
    endif()
    if (NOT DEFINED _add_hdl_settings_OUTPUT_DIR)
        set(_add_hdl_settings_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR})
    else()
        get_filename_component(_add_hdl_settings_OUTPUT_DIR ${_add_hdl_settings_OUTPUT_DIR} ABSOLUTE)
    endif()

    set(_HDL_SETTINGS_NAME 	    ${_add_hdl_settings_NAME})
    set(_HDL_SETTINGS_FILES 	${_add_hdl_settings_SETTINGS})

    set (_HDL_PROJECT_DIR "${CMAKE_CURRENT_BINARY_DIR}/${_TARGET_NAME}")

    set (CMAKE_HDL_TCLHDL_FILE_SETTINGS  "${_HDL_PROJECT_DIR}/settings")

    #-- Create TclHdl file structure
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_SETTINGS})
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_SETTINGS} "")

    message (STATUS "------- Parse files: SETTINGS")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_SETTINGS_FILES)
        set(_name "::tclhdl::add_settings ")
        string (CONCAT _name ${_name} "\"${_HDL_SETTINGS_NAME}\" ")
        string (CONCAT _name ${_name} "\"${_HDL_SOURCE_FILE}\"")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_SETTINGS} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()


endfunction()

function(add_hdl_flow _TARGET_NAME)

    cmake_parse_arguments(_add_hdl_flow
        ""
        "OUTPUT_DIR;OUTPUT_NAME"
        "FLOW"
        ${ARGN}
        )

    if(NOT DEFINED _add_hdl_flow_OUTPUT_DIR AND DEFINED CMAKE_HDL_TARGET_OUTPUT_DIR)
        set(_add_hdl_flow_OUTPUT_DIR "${CMAKE_HDL_TARGET_OUTPUT_DIR}")
    endif()
    if(NOT DEFINED _add_hdl_flow_OUTPUT_NAME AND DEFINED CMAKE_HDL_TARGET_OUTPUT_NAME)
        set(_add_hdl_flow_OUTPUT_NAME "${CMAKE_HDL_TARGET_OUTPUT_NAME}")
        # reset
        set(CMAKE_HDL_TARGET_OUTPUT_NAME)
    endif()
    if (NOT DEFINED _add_hdl_flow_OUTPUT_DIR)
        set(_add_hdl_flow_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR})
    else()
        get_filename_component(_add_hdl_flow_OUTPUT_DIR ${_add_hdl_flow_OUTPUT_DIR} ABSOLUTE)
    endif()

    set(_HDL_FLOW_FILES 	${_add_hdl_flow_FLOW})

    set (_HDL_PROJECT_DIR "${CMAKE_CURRENT_BINARY_DIR}/${_TARGET_NAME}")

    set (CMAKE_HDL_TCLHDL_FILE_BUILD  "${_HDL_PROJECT_DIR}/build")

    #-- Create TclHdl file structure
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_BUILD})
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_BUILD} "")

    message (STATUS "------- Parse files: FLOW")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_FLOW_FILES)
        set(_name "::tclhdl::build_")
        string (CONCAT _name ${_name} "${_HDL_SOURCE_FILE}")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_BUILD} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()

endfunction()

function(add_hdl_flow _TARGET_NAME)

    cmake_parse_arguments(_add_hdl_flow
        ""
        "OUTPUT_DIR;OUTPUT_NAME"
        "FLOW"
        ${ARGN}
        )

    if(NOT DEFINED _add_hdl_flow_OUTPUT_DIR AND DEFINED CMAKE_HDL_TARGET_OUTPUT_DIR)
        set(_add_hdl_flow_OUTPUT_DIR "${CMAKE_HDL_TARGET_OUTPUT_DIR}")
    endif()
    if(NOT DEFINED _add_hdl_flow_OUTPUT_NAME AND DEFINED CMAKE_HDL_TARGET_OUTPUT_NAME)
        set(_add_hdl_flow_OUTPUT_NAME "${CMAKE_HDL_TARGET_OUTPUT_NAME}")
        # reset
        set(CMAKE_HDL_TARGET_OUTPUT_NAME)
    endif()
    if (NOT DEFINED _add_hdl_flow_OUTPUT_DIR)
        set(_add_hdl_flow_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR})
    else()
        get_filename_component(_add_hdl_flow_OUTPUT_DIR ${_add_hdl_flow_OUTPUT_DIR} ABSOLUTE)
    endif()

    set(_HDL_FLOW_FILES 	${_add_hdl_flow_FLOW})

    set (_HDL_PROJECT_DIR "${CMAKE_CURRENT_BINARY_DIR}/${_TARGET_NAME}")

    set (CMAKE_HDL_TCLHDL_FILE_BUILD  "${_HDL_PROJECT_DIR}/build")

    #-- Create TclHdl file structure
    file (TOUCH ${CMAKE_HDL_TCLHDL_FILE_BUILD})
    file (WRITE ${CMAKE_HDL_TCLHDL_FILE_BUILD} "")

    message (STATUS "------- Parse files: FLOW")
    foreach(_HDL_SOURCE_FILE IN LISTS _HDL_FLOW_FILES)
        set(_name "::tclhdl::build_")
        string (CONCAT _name ${_name} "${_HDL_SOURCE_FILE}")
        string (CONCAT _name ${_name} "\n")
        file (APPEND ${CMAKE_HDL_TCLHDL_FILE_BUILD} ${_name})
        message (STATUS "------------ Parse files: ${_name}")
    endforeach()

endfunction()

