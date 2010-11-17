# This is a macro to ease the use of gdb-pretty-itk.
# http://gitorious.org/gdb-pretty/gdb-pretty-itk
# Passing in a target into the macro will add the CMake magic to generate and
# copy the file needed to register ITK specific pretty-printers when debugging
# with gdb.  This file consists of the pretty-printers in which you are
# interested.  Feel free to copy this file and the template into your project as
# needed.
# See the CMakeLists.txt in the examples/ directory for an example of usage.
function( GDB_PRETTY_ITK target )
  get_target_property( target_location ${target} LOCATION )
  add_custom_command( TARGET ${target}
    POST_BUILD
    COMMAND cmake -E copy
    ${CMAKE_MODULE_PATH}/GDBPrettyITKTemplate.py
    "${target_location}-gdb.py"
    )
endfunction( GDB_PRETTY_ITK )
