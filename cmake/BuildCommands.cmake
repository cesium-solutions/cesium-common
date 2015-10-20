# Needed for the named parameter arguments
include( CMakeParseArguments )

#
# Function to encapsulate all the standard steps for building a target
# Parameters:
#   BASENAME           - name of the target to build
#   TYPE               - the type of target, either "Library" or "Executable"
#   LINK_TYPE          - the linking type for Library targets: STATIC, SHARED, or DEFAULT (the default)
#   GROUP              - The organization group to place the library in (for IDE build environments)
#   INCLUDE_DIRS       - a list of directories to include
#   DEFINES            - a list of preprocessor definitions
#   COMPILE_FLAGS      - a list of compilation flags
#   LINK_FLAGS         - a list of link flags
#   LIBRARY_DIRS       - a list of library path dirs
#   LIBRARIES          - a list of library dependencies
#   FLAT_SOURCE_TREE   - whether to use a flat organization structure for the source (for IDE build environments)
#   HEADERS_PUBLIC     - a list of public header files
#   HEADERS_PRIVATE    - a list of private header files
#   SOURCES            - a list of source files
#   QT_MOCFILES        - a list of qt moc files
#   QT_UIFILES         - a list of qt ui files
#   QT_QRCFILES        - a list of qt resource files
#   NO_INSTALL         - Flag to indicate not to install the target in the standard location
#   HEADER_INSTALL_DIR - the directory to install public headers to
#   DEBUG              - print debug information
#
function( BUILD_TARGET )

  # -----------------------------------
  # Set up and parse multiple arguments
  # -----------------------------------
  set( options
       FLAT_SOURCE_TREE
       NO_INSTALL
       DEBUG
  )
  set( oneValueArgs
       BASENAME
       TYPE
       LINK_TYPE
       GROUP
       HEADER_INSTALL_DIR
  )
  set( multiValueArgs
       INCLUDE_DIRS
       DEFINES
       COMPILE_FLAGS
       LINK_FLAGS
       LIBRARY_DIRS
       LIBRARIES
       HEADERS_PUBLIC
       HEADERS_PRIVATE
       SOURCES
       QT_MOCFILES
       QT_UIFILES
       QT_QRCFILES
  )

  cmake_parse_arguments(
      BUILD_TARGET
      "${options}"
      "${oneValueArgs}"
      "${multiValueArgs}"
      ${ARGN}
  )

  if ( BUILD_TARGET_DEBUG )
    message( STATUS "Parameters for BUILD_TARGET:" )
    message( STATUS "BASENAME:           " ${BUILD_TARGET_BASENAME} )
    message( STATUS "TYPE:               " ${BUILD_TARGET_TYPE} )
    message( STATUS "LINK_TYPE:          " ${BUILD_TARGET_LINK_TYPE} )
    message( STATUS "GROUP:              " ${BUILD_TARGET_GROUP} )
    message( STATUS "INCLUDE_DIRS:       " ${BUILD_TARGET_INCLUDE_DIRS} )
    message( STATUS "DEFINES:            " ${BUILD_TARGET_DEFINES} )
    message( STATUS "COMPILE_FLAGS:      " ${BUILD_TARGET_COMPILE_FLAGS} )
    message( STATUS "LINK_FLAGS:         " ${BUILD_TARGET_LINK_FLAGS} )
    message( STATUS "LIBRARY_DIRS:       " ${BUILD_TARGET_LIBRARY_DIRS} )
    message( STATUS "LIBRARIES:          " ${BUILD_TARGET_LIBRARIES} )
    message( STATUS "FLAT_SOURCE_TREE:   " ${BUILD_TARGET_FLAT_SOURCE_TREE} )
    message( STATUS "HEADERS_PUBLIC:     " ${BUILD_TARGET_HEADERS_PUBLIC} )
    message( STATUS "HEADERS_PRIVATE:    " ${BUILD_TARGET_HEADERS_PRIVATE} )
    message( STATUS "SOURCES:            " ${BUILD_TARGET_SOURCES} )
    message( STATUS "QT_MOCFILES:        " ${BUILD_TARGET_QT_MOCFILES} )
    message( STATUS "QT_UIFILES:         " ${BUILD_TARGET_QT_UIFILES} )
    message( STATUS "QT_QRCFILES:        " ${BUILD_TARGET_QT_QRCFILES} )
    message( STATUS "NO_INSTALL:         " ${BUILD_TARGET_NO_INSTALL} )
    message( STATUS "HEADER_INSTALL_DIR: " ${BUILD_TARGET_HEADER_INSTALL_DIR} )
    message( STATUS "DEBUG:              " ${BUILD_TARGET_DEBUG} )
  endif()

  # ------------------------------------
  # Preliminary Build checks and filters
  # ------------------------------------
  # Apply rough build filters: BUILD_${BUILD_TARGET_BASENAME} takes precedence if it is defined.
  # Otherwise use the value of BUILD_${BUILD_TARGET_GROUP}
  # If neither exist, the default is to build the target
  # Note: Don't add the option for BUILD_${BUILD_TARGET_BASENAME}, otherwise it will always
  # be defined and you'd have to turn all the targets off manually if you want to turn off a whole group
  ##  option( BUILD_${BUILD_TARGET_BASENAME} "Set ON to build this target." ON )
  option( BUILD_${BUILD_TARGET_GROUP}    "Set ON to build this group." ON )

  if ( DEFINED BUILD_${BUILD_TARGET_BASENAME} )
    if ( NOT BUILD_${BUILD_TARGET_BASENAME} )
      return()
    endif()
  elseif ( NOT BUILD_${BUILD_TARGET_GROUP} )
    return()
  endif()

  # Apply fine-grained build filters on a per file level using the FILE_EXCLUDE_LIST
  ##filter_list( BUILD_TARGET_HEADERS_PUBLIC  FILE_EXCLUDE_LIST )
  ##filter_list( BUILD_TARGET_HEADERS_PRIVATE FILE_EXCLUDE_LIST )
  ##filter_list( BUILD_TARGET_SOURCES         FILE_EXCLUDE_LIST )
  ##filter_list( BUILD_TARGET_QT_MOCFILES     FILE_EXCLUDE_LIST )
  ##filter_list( BUILD_TARGET_QT_UIFILES      FILE_EXCLUDE_LIST )
  ##filter_list( BUILD_TARGET_QT5_QRCFILES    FILE_EXCLUDE_LIST )

  if ( NOT DEFINED BUILD_TARGET_BASENAME )
      message( "Error: BUILD_TARGET no BASENAME parameter specified" )
      return()
  endif()

  include_directories( ${BUILD_TARGET_INCLUDE_DIRS} )

  if ( DEFINED BUILD_TARGET_DEFINES )
      add_definitions( ${BUILD_TARGET_DEFINES} )
  endif()

  # ----------------------
  # Qt specific processing
  # ----------------------

  # Process Qt MOC Files
  if ( BUILD_TARGET_QT_MOCFILES )
    qt_wrap_cpp(
        ${BUILD_TARGET_BASENAME}
        ${BUILD_TARGET_BASENAME}_MOCSOURCES
        ${BUILD_TARGET_QT_MOCFILES}
    )

    if ( BUILD_TARGET_FLAT_SOURCE_TREE )
      source_group(
          \\ FILES ${BUILD_TARGET_QT_MOCFILES}
      )
    endif()
    source_group(
        \\generated\\moc_files FILES
        ${${BUILD_TARGET_BASENAME}_MOCSOURCES}
    )

    if ( BUILD_TARGET_DEBUG )
      message( STATUS "${BUILD_TARGET_BASENAME} Generated MOC Files: "
          ${${BUILD_TARGET_BASENAME}_MOCSOURCES}
      )
    endif()
  endif()

  # Process Qt UI Files
  if ( DEFINED BUILD_TARGET_QT_UIFILES )
    qt_wrap_ui(
        ${BUILD_TARGET_BASENAME}
        ${BUILD_TARGET_BASENAME}_UISOURCES
        ${BUILD_TARGET_BASENAME}_UIHEADERS
        ${BUILD_TARGET_QT_UIFILES}
    )

    source_group(
        \\ui_files FILES
        ${BUILD_TARGET_QT_UIFILES}
    )
    source_group(
        \\generated\\ui_files FILES
        ${${BUILD_TARGET_BASENAME}_UIHEADERS}
        ${${BUILD_TARGET_BASENAME}_UISOURCES}
    )

    if ( BUILD_TARGET_DEBUG )
      message( STATUS "${BUILD_TARGET_BASENAME} Generated UI Files: "
          ${${BUILD_TARGET}_UIHEADERS}
          ${${BUILD_TARGET}_UIHEADERS}
      )
    endif()
  endif()

  # Process Qt QRC Files
  if ( DEFINED BUILD_TARGET_QT_QRCFILES )
    if ( QT_VERSION_4 )
      qt4_add_resources(
          ${BUILD_TARGET_BASENAME}_RESOURCES
          ${BUILD_TARGET_QT_QRCFILES}
      )
    else()
      qt5_add_resources(
          ${BUILD_TARGET_BASENAME}_RESOURCES
          ${BUILD_TARGET_QT_QRCFILES}
      )
    endif()

    source_group(
        \\qrc_files FILES
        ${BUILD_TARGET_BASENAME_QT_QRCFILES}
    )
    source_group(
        \\generated\\qrc_files FILES
        ${${BUILD_TARGET_BASENAME}_RESOURCES}
    )

    if ( BUILD_TARGET_DEBUG )
      message( STATUS "${BUILD_TARGET_BASENAME} Generated Qt Resource Files: " ${${BUILD_TARGET_BASENAME}_RESOURCES} )
    endif()
  endif()

  # --------------------------------
  # Massaging of dependent libraries
  # --------------------------------
  if ( DEFINED BUILD_TARGET_LIBRARY_DIRS )
    link_directories( ${BUILD_TARGET_LIBRARY_DIRS} )
  endif()

  if ( DEFINED BUILD_TARGET_LINK_TYPE )
    if ( BUILD_TARGET_LINK_TYPE STREQUAL "SHARED" )
      set( LINK_TYPE SHARED )
    elseif( BUILD_TARGET_LINK_TYPE STREQUAL "STATIC" )
      set( LINK_TYPE STATIC )
    endif()
  endif()
  if ( NOT DEFINED LINK_TYPE )
    if ( BUILD_SHARED_LIBS )
      set( LINK_TYPE SHARED )
    else()
      set( LINK_TYPE STATIC )
    endif()
  endif()

  # When building static libraries, add the corresponding compile definition for each of the linked in libraries
  # This requires that:
  #   - all libraries be specified that will be linked even though CMake automatically links in
  #     derivative dependent libraries (only when building shared libs)
  #   - the library names use the <libname>_STATIC to indicate static linking
  #   - the BUILD_TARGET_LIBRARIES doesn't use full paths for its elements
  if ( NOT BUILD_SHARED_LIBS )
    foreach( TARGET_LIB ${BUILD_TARGET_LIBRARIES} )
      if ( NOT (TARGET_LIB STREQUAL "optimized") AND NOT (TARGET_LIB STREQUAL "debug") )
        add_definitions( -D${TARGET_LIB}_STATIC )
      endif()
    endforeach()
  endif()

  # -----------------
  # Set up the Target
  # -----------------
  set( ${BUILD_TARGET_BASENAME}_ALL_FILES
      ${BUILD_TARGET_HEADERS_PUBLIC}
      ${BUILD_TARGET_HEADERS_PRIVATE}
      ${BUILD_TARGET_SOURCES}
      ${BUILD_TARGET_QT_MOCFILES}
      ${${BUILD_TARGET_BASENAME}_MOCSOURCES}
      ${BUILD_TARGET_QT_UIFILES}
      ${${BUILD_TARGET_BASENAME}_UIHEADERS}
      ${${BUILD_TARGET_BASENAME}_UISOURCES}
      ${BUILD_TARGET_QT_QRCFILES}
      ${${BUILD_TARGET_BASENAME}_RESOURCES}
  )

  if ( ${BUILD_TARGET_TYPE} STREQUAL "Library" )
      # Only add the static definition for the library if a special link type isn't specified
      if ( DEFINED BUILD_TARGET_LINK_TYPE )
        if ( BUILD_TARGET_LINK_TYPE STREQUAL "STATIC" )
          add_definitions( -D${BUILD_TARGET_BASENAME}_STATIC )
        endif()
      elseif ( NOT BUILD_SHARED_LIBS )
          add_definitions( -D${BUILD_TARGET_BASENAME}_STATIC )
      endif()
      add_library(
          ${BUILD_TARGET_BASENAME} ${LINK_TYPE}
          ${${BUILD_TARGET_BASENAME}_ALL_FILES}
      )
  elseif( ${BUILD_TARGET_TYPE} STREQUAL "Executable" )
      add_executable(
          ${BUILD_TARGET_BASENAME}
          ${${BUILD_TARGET_BASENAME}_ALL_FILES}
      )
  else()
      message( FATAL_ERROR "BUILD_TARGET unrecognized type: " ${BUILD_TARGET_TYPE} )
      return()
  endif()

  if ( BUILD_TARGET_FLAT_SOURCE_TREE )
      source_group(
          \\ FILES
          ${BUILD_TARGET_HEADERS_PUBLIC}
          ${BUILD_TARGET_HEADERS_PRIVATE}
          ${BUILD_TARGET_SOURCES}
      )
  endif()

  if( DEFINED BUILD_TARGET_LIBRARIES )
      target_link_libraries(
          ${BUILD_TARGET_BASENAME}
          ${BUILD_TARGET_LIBRARIES}
      )
  endif()

  set_property( SOURCE ${BUILD_TARGET_HEADERS_PUBLIC}
                PROPERTY PUBLIC_HEADER
  )

  set_target_properties(
      ${BUILD_TARGET_BASENAME}
      PROPERTIES
      DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX}
  )

  if ( DEFINED BUILD_TARGET_GROUP )
      set_target_properties(
          ${BUILD_TARGET_BASENAME} PROPERTIES
          FOLDER ${BUILD_TARGET_GROUP}
      )
  endif()

  if ( NOT WIN32 AND NOT BUILD_SHARED_LIBS )
      # Ensure that static libraries use position independent code on Linux
      set_target_properties(
          ${BUILD_TARGET_BASENAME} PROPERTIES
          POSITION_INDEPENDENT_CODE ON
      )
  endif()
  if ( DEFINED BUILD_TARGET_COMPILE_FLAGS OR DEFINED OS_COMPILE_FLAGS )
      set_target_properties(
          ${BUILD_TARGET_BASENAME} PROPERTIES
          COMPILE_FLAGS
              ${BUILD_TARGET_COMPILE_FLAGS}
              ${OS_COMPILE_FLAGS}
      )
  endif()

  if ( NOT BUILD_TARGET_NO_INSTALL )
      install(
          TARGETS ${BUILD_TARGET_BASENAME}
          RUNTIME DESTINATION ${INSTALL_BIN_DIR} COMPONENT Runtime
          LIBRARY DESTINATION ${INSTALL_LIB_DIR} COMPONENT Runtime
          ARCHIVE DESTINATION ${INSTALL_DEV_DIR} COMPONENT Development
      )
      if ( DEFINED BUILD_TARGET_HEADER_INSTALL_DIR )
          install(
              FILES ${BUILD_TARGET_HEADERS_PUBLIC}
              DESTINATION ${BUILD_TARGET_HEADER_INSTALL_DIR}
          )
      endif()
  endif()

endfunction()
