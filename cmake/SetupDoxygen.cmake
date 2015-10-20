#-- Add an Option to toggle the generation of the API documentation
# Adapted from: http://www.bluequartz.net/projects/EIM_Segmentation/SoftwareDocumentation/html/usewithcmakeproject.html

option( BUILD_Documentation "Use Doxygen to create the HTML based API documentation" OFF )

if ( BUILD_Documentation )
  FIND_PACKAGE(Doxygen)
  if (NOT DOXYGEN_FOUND)
    message( FATAL_ERROR 
             "Doxygen is needed to build the documentation. Please install it correctly"
    )
  endif()

  option( DOXYGEN_HTMLHELP "Generate Compressed HTML Help files" OFF )
  if ( DOXYGEN_HTMLHELP EQUAL ON )
    set( DOXYGEN_GENERATE_HTMLHELP YES )
  else()
    set( DOXYGEN_GENERATE_HTMLHELP NO )
  endif()
  set( DOXYGEN_HHC_EXECUTABLE "" CACHE FILEPATH "Location of HHC Program" )

  set( DOXYGEN_EXCLUDE_PATTERNS "*/test/* */share/* */detail/* */templates/* *.cpp *.c"
       CACHE STRING "Exclude Patterns" )

  #-- Configure the Template Doxyfile and DoxygenText.hpp for our specific project
  configure_file( doc/Doxyfile.in 
                  ${PROJECT_BINARY_DIR}/doc/${CMAKE_PROJECT_NAME}/Doxyfile
                  @ONLY IMMEDIATE
  )

  configure_file( doc/DoxygenText.hpp.in
                  ${PROJECT_BINARY_DIR}/doc/${CMAKE_PROJECT_NAME}/DoxygenText.hpp
                  @ONLY IMMEDIATE
  )

  #-- Add a custom target to run Doxygen when ever the project is built
  add_custom_target( doc #ALL
                     COMMAND ${DOXYGEN_EXECUTABLE} ${PROJECT_BINARY_DIR}/doc/${CMAKE_PROJECT_NAME}/Doxyfile
                     SOURCES ${PROJECT_BINARY_DIR}/doc/${CMAKE_PROJECT_NAME}/Doxyfile
  )
  # IF you do NOT want the documentation to be generated EVERY time you build the project
  # then leave out the 'ALL' keyword from the above command.


  file( GLOB_RECURSE HELPFILES
        ${PROJECT_BINARY_DIR}/doc/${CMAKE_PROJECT_NAME}/html/*
  )
  install( FILES ${HELPFILES}
           DESTINATION doc/${CMAKE_PROJECT_NAME}/html
  )
endif()
