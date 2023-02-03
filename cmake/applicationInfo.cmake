#
# SPDX-License-Identifier: MIT
# Copyright (c) Contributors to the elf_viewer Project.
#

# Looks up relevant application and version information, and creates a cpp file (from a template), allowing build time
# information to be introspected at runtime.

if( "${elf_viewer_VERSION_MINOR}" STREQUAL "" OR "${elf_viewer_VERSION_PATCH}" STREQUAL "" )
    message(
        FATAL_ERROR
        "This project uses semantic versioning, and requires a major, minor and revision. ${elf_viewer_BUILD_VERSION} \
        does not comply."
    )
endif()

find_package( Git REQUIRED )
execute_process(
    COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
    RESULT_VARIABLE GIT_RESULT
    OUTPUT_VARIABLE elf_viewer_GIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

if( GIT_RESULT )
    message( FATAL_ERROR "Failed to get git hash (error code: ${GIT_RESULT})" )
endif()

set( APPLICATION_INFO_FILENAME ApplicationInfo.cpp CACHE FILEPATH "Filepath for build time application details" )
configure_file( src/ApplicationInfo.cpp.in ${APPLICATION_INFO_FILENAME} @ONLY )
set( APPLICATION_INFO_PATH "${CMAKE_CURRENT_BINARY_DIR}/${APPLICATION_INFO_FILENAME}" )