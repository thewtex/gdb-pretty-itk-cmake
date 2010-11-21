# This is a macro to ease the use of gdb-pretty-itk.
#
# See:
#   http://www.itk.org/Wiki/ITK/GDBPretty
#   http://gitorious.org/gdb-pretty/gdb-pretty-itk
#
# Passing in a target into the function will add the CMake magic to generate and
# copy the file needed to register ITK specific pretty-printers when debugging
# with gdb.  This file consists of the pretty-printers in which you are
# interested.  The contents of the file are specified with CMake configuration
# variables.
#
# Therefore, if you have something like this in your CMakeLists.txt
#
#   add_executable( myexe main.cxx )
#   target_link_libraries( myexe ITKCommon ITKIO )
#
# The following will register the pretty-printers:
#
#   GDB_PRETTY_ITK( myexe )
#
# IMPORTANT: include this file *after* include( ${ITK_USE_FILE} )
# so the correct ITK_VERSION_MAJOR is detected.
function( GDB_PRETTY_ITK target )
  get_target_property( target_location ${target} LOCATION )
  add_custom_command( TARGET ${target}
    POST_BUILD
    COMMAND cmake -E copy
    ${CMAKE_MODULE_PATH}/GDBPrettyITKTemplate.py
    "${target_location}-gdb.py"
    )
endfunction( GDB_PRETTY_ITK )
