#
# SPDX-License-Identifier: MIT
# Copyright (c) Contributors to the elf_viewer Project.
#

# Looks up relevant version information, and creates a cpp file (from a template), allowing build time information to be
# introspected at runtime.

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

set(VERSION_INFO_FILENAME VersionInfo.cpp CACHE FILEPATH "Filepath for build time version")
configure_file( src/VersionInfo.cpp.in ${VERSION_INFO_FILENAME} @ONLY )
set(VERSION_INFO_PATH "${CMAKE_CURRENT_BINARY_DIR}/${VERSION_INFO_FILENAME}")