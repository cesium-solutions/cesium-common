# set up OpenGL stuff

if ( NOT OPENGL_FOUND )
  find_package( OpenGL REQUIRED )

  include_directories(
      ${OPENGL_INCLUDE_DIR}
  )
endif()
