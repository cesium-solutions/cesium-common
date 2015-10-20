# --------------------
# Set up Boost package
# --------------------

option( Boost_USE_MULTITHREADED "Use the multithreaded versions of Boost libraries." ON )
set( Boost_ADDITIONAL_VERSIONS "1.42" "1.42.0" "1.47" "1.47.0" "1.48" "1.48.0" "1.49" "1.49.0" "1.55" "1.55.0" )

if ( WIN32 )

  set( BOOST_VERSION 1_55_0 CACHE STRING "Version of Boost" )

  if ( (NOT BOOST_ROOT) AND ((NOT BOOST_LIBRARYDIR) OR (NOT BOOST_INCLUDEDIR)) )
    if ( EXTERN_DIR )
      set( BOOST_ROOT ${EXTERN_DIR}/boost_${BOOST_VERSION}
           CACHE PATH "Boost directory." )
    endif()
  endif()

  # Append to this variable which will be used to configure startup scripts
  set( RUNTIME_DIRS ${RUNTIME_DIRS} ${BOOST_ROOT}/lib CACHE INTERNAL "" )

endif()

add_definitions( -DBOOST_SIGNALS_NO_DEPRECATION_WARNING )
add_definitions( -DBOOST_ALL_DYN_LINK )
##if ( BUILD_SHARED_LIBS )
##  add_definitions( -DBOOST_ALL_DYN_LINK )
##else()
##  set(Boost_USE_STATIC_LIBS        ON)
##  set(Boost_USE_MULTITHREADED      ON)
##  set(Boost_USE_STATIC_RUNTIME     OFF)
####  add_definitions( -DBOOST_ALL_NO_LIB )
##endif()

find_package( Boost REQUIRED
    date_time
    filesystem
    graph
    iostreams
    program_options
    regex
    signals
    system
    thread
    unit_test_framework
)

include_directories( ${Boost_INCLUDE_DIR} )
link_directories( ${Boost_LIBRARY_DIRS} )

# For some platforms (e.g. Ubuntu 11.10), some Boost libraries must be specified explicitly.
# Setting the Boost_ADD_LIBRARIES during cmake setup allows this to be done on a per-platform basis.
if ( Boost_ADD_LIBRARIES )
  list( APPEND Boost_LIBRARIES ${Boost_ADD_LIBRARIES} )
endif()

