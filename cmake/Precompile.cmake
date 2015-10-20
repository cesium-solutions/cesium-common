
option( BUILD_USE_PRECOMPILED_HEADERS "Set to ON to use precompiled headers." ON )

if ( WIN32 )

  macro( USE_PRECOMPILED PRECOMPILED_NAME SOURCES )
    foreach( SOURCE ${${SOURCES}} )
      set_source_files_properties( ${SOURCE} PROPERTIES COMPILE_FLAGS "/Yu${PRECOMPILED_NAME}" )
    endforeach()
  endmacro( USE_PRECOMPILED )

  macro( CREATE_PRECOMPILED PRECOMPILED_SOURCE )
    get_filename_component( PRECOMPILED_HEADER ${PRECOMPILED_SOURCE} NAME_WE )
    set_source_files_properties( ${PRECOMPILED_SOURCE} PROPERTIES COMPILE_FLAGS "/Yc${PRECOMPILED_HEADER}.h" )
  endmacro( CREATE_PRECOMPILED )

else ( WIN32 )

endif ( WIN32 )
