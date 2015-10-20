# ---------------------------
# Set platform specific stuff
# ---------------------------
if ( WIN32 )
  # turn off dll-interface warning
  add_definitions( "/wd4251" )
  # turn off: non dll-interface struct '' used as base for dll-interface
  add_definitions( "/wd4275" )
  # turn off: "forcing value to bool" warning
  add_definitions( "/wd4800" )
  # turn off: unsafe use of type 'bool' in operation
  add_definitions( "/wd4804" )
  # prevent inclusion of superfluous windows file
  add_definitions( "-DWIN32_LEAN_AND_MEAN" "-DWIN32_EXTRA_LEAN" )
  # disable warning 4996: Function call with parameters that may be unsafe
  add_definitions( "-D_SCL_SECURE_NO_WARNINGS" )

  set( BUILD_COMPILEFLAGS "${BUILD_COMPILEFLAGS} /EHsc" )
  if ( BUILD_MAX_PROCESSES )
    set( BUILD_COMPILEFLAGS "${BUILD_COMPILEFLAGS} /MP${BUILD_MAX_PROCESSES}" )
  else()
    set( BUILD_COMPILEFLAGS "${BUILD_COMPILEFLAGS} /MP" )
  endif()

  ##list( APPEND BUILD_COMPILEFLAGS "/bigobj" )

else()

endif()

