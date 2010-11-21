# This is a module to ease the use of gdb-pretty-itk.
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

set( GDB_PRETTY_USE_TEXT ON
  CACHE BOOL "Use gdb-pretty-itk custom text pretty-printers." )
if( ${GDB_PRETTY_USE_TEXT} )
  set( GDB_PRETTY_TEXT "gdb.pretty.register ('itk.v${ITK_VERSION_MAJOR}.text', gdb.current_objfile ())" )

  set( GDB_PRETTY_USE_NUMPY ON
    CACHE BOOL "Use gdb-pretty numpy array pretty-printers." )
  if( ${GDB_PRETTY_USE_NUMPY} )
    set( GDB_PRETTY_NUMPY "gdb.pretty.register ('itk.v${ITK_VERSION_MAJOR}.numpy.save', gdb.current_objfile ())
gdb.pretty.register ('itk.v${ITK_VERSION_MAJOR}.numpy.array', gdb.current_objfile ())" )

    set( GDB_PRETTY_USE_MATPLOTLIB ON
      CACHE BOOL "Use matplotlib gdb pretty-printers." )
    if( ${GDB_PRETTY_USE_MATPLOTLIB} )
        set( GDB_PRETTY_MATPLOTLIB "gdb.pretty.register ('itk.v${ITK_VERSION_MAJOR}.matplotlib.plot_wireframe', gdb.current_objfile ())
gdb.pretty.register ('itk.v${ITK_VERSION_MAJOR}.matplotlib.plot_surface', gdb.current_objfile ())
gdb.pretty.register ('itk.v${ITK_VERSION_MAJOR}.matplotlib.imshow', gdb.current_objfile ())" )
    endif( ${GDB_PRETTY_USE_MATPLOTLIB} )

    set( GDB_PRETTY_USE_MAYAVI OFF
      CACHE BOOL "Use mayavi gdb pretty-printers." )
    if( ${GDB_PRETTY_USE_MAYAVI} )
        set( GDB_PRETTY_MAYAVI "gdb.pretty.register ('itk.v${ITK_VERSION_MAJOR}.mayavi.contour', gdb.current_objfile ())
gdb.pretty.register ('itk.v${ITK_VERSION_MAJOR}.mayavi.volume', gdb.current_objfile ())
gdb.pretty.register ('itk.v${ITK_VERSION_MAJOR}.mayavi.surf', gdb.current_objfile ())
gdb.pretty.register ('itk.v${ITK_VERSION_MAJOR}.mayavi.imshow', gdb.current_objfile ())
gdb.pretty.register ('itk.v${ITK_VERSION_MAJOR}.mayavi.ipython', gdb.current_objfile ())
gdb.pretty.register ('itk.v${ITK_VERSION_MAJOR}.mayavi.save', gdb.current_objfile ())" )

      set( GDB_PRETTY_USE_VV OFF
        CACHE BOOL "Use the VV gdb pretty-printer." )
      if( ${GDB_PRETTY_USE_VV} )
        set( GDB_PRETTY_VV "gdb.pretty.register ('itk.v${ITK_VERSION_MAJOR}.vv', gdb.current_objfile ())" )
      endif( ${GDB_PRETTY_USE_VV} )

      set( GDB_PRETTY_USE_PARAVIEW OFF
        CACHE BOOL "Use the PARAVIEW gdb pretty-printer." )
      if( ${GDB_PRETTY_USE_PARAVIEW} )
        set( GDB_PRETTY_PARAVIEW "gdb.pretty.register ('itk.v${ITK_VERSION_MAJOR}.paraview', gdb.current_objfile ())" )
      endif( ${GDB_PRETTY_USE_PARAVIEW} )
    endif( ${GDB_PRETTY_USE_MAYAVI} )

    set( GDB_PRETTY_USE_ICP OFF
      CACHE BOOL "Use itkCompareProject icp gdb pretty-printer." )
    if( ${GDB_PRETTY_USE_ICP} )
      set( GDB_PRETTY_ICP "gdb.pretty.register ('icp', gdb.current_objfile ())" )
    endif( ${GDB_PRETTY_USE_ICP} )
  endif( ${GDB_PRETTY_USE_NUMPY} )
endif( ${GDB_PRETTY_USE_TEXT} )

mark_as_advanced( GDB_PRETTY_USE_TEXT
  GDB_PRETTY_USE_NUMPY
  GDB_PRETTY_USE_ICP
  GDB_PRETTY_USE_MAYAVI
  GDB_PRETTY_USE_PARAVIEW
  GDB_PRETTY_USE_MATPLOTLIB
  GDB_PRETTY_USE_VV
  )

set( GDB_PRETTY_TEMPLATE ${PROJECT_BINARY_DIR}/GDBPrettyITKTemplate.py )
configure_file( GDBPrettyITKTemplate.py.in ${GDB_PRETTY_TEMPLATE} )

function( GDB_PRETTY_ITK target )
  get_target_property( target_location ${target} LOCATION )
  add_custom_command( TARGET ${target}
    POST_BUILD
    COMMAND cmake -E copy
    ${PROJECT_BINARY_DIR}/GDBPrettyITKTemplate.py
    "${target_location}-gdb.py"
    )
endfunction( GDB_PRETTY_ITK )
