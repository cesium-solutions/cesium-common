# Some standard steps to set up the project.

set( BUILD_SHARED_LIBS true )

set( BUILD_MAX_PROCESSES 4 CACHE STRING "The maximum number of parallel processes to use for compiling." )

option( BUILD_Libraries "Set to ON to build libraries." ON )
option( BUILD_Applications "Set to ON to build applications." ON )
option( BUILD_Examples "Set to ON to build examples." OFF )
option( BUILD_UnitTests "Set to ON to build unit tests." OFF )
option( BUILD_SystemTests "Set to ON to build system tests." OFF )
option( BUILD_PerformanceTests "Set to ON to build performance tests." OFF )
option( BUILD_UseFolders "Set to ON to use folders (should be off when using VS Express" ON )

set_property( GLOBAL PROPERTY USE_FOLDERS ${BUILD_UseFolders} )

set( CMAKE_DEBUG_POSTFIX "d" CACHE STRING "Postfix for debug libraries/applications" )

add_definitions( -DNOMINMAX )

set( INSTALL_BIN_DIR bin )
set( INSTALL_LIB_DIR lib )
set( INSTALL_DEV_DIR lib )

include( Platform )
include( Precompile )
include( BuildCommands )
