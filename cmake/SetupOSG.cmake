# -------------------
# Set up OpenGL Stuff
# -------------------
find_package( OpenGL REQUIRED )

include_directories( ${OPENGL_INCLUDE_DIR} )

# ---------------------------------------
# Set up OpenSceneGraph/OpenThreads stuff
# ---------------------------------------

if ( WIN32 )
  if ( NOT OSG_VERSION )
    set( OSG_VERSION 3.2.0 CACHE STRING "OpenSceneGraph Version" )
  endif()

  if ( NOT OSG_DIR )
    if ( EXTERN_DIR )
      set( ENV{OSG_DIR} ${EXTERN_DIR}/OpenSceneGraph-${OSG_VERSION}
           CACHE PATH "OpenSceneGraph root directory" PARENT )
    elseif ( NOT WIN32 )
      set( ENV{OSG_DIR} /usr
           CACHE PATH "OpenSceneGraph root directory" PARENT )
    else()
      message( FATAL_ERROR "Neither OSG_DIR nor EXTERN_DIR are set, set one of these appropriately." )
      return()
    endif()
  else()
    set( ENV{OSG_DIR} ${OSG_DIR} )
  endif()

  find_package( OpenSceneGraph ${OSG_VERSION} REQUIRED
                osgDB
                osgGA
                osgSim
                osgText
                osgUtil
                osgViewer
  )

  set( RUNTIME_DIRS ${RUNTIME_DIRS} $ENV{OSG_DIR}/bin CACHE INTERNAL "" )

else()

  find_package( OpenSceneGraph REQUIRED COMPONENTS
                osgDB
                osgGA
                osgSim
                osgText
                osgUtil
                osgViewer
  )

endif()

include_directories( ${OPENSCENEGRAPH_INCLUDE_DIRS} )

