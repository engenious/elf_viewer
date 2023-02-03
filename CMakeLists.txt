cmake_minimum_required( VERSION 3.24 )
set( CMAKE_VERBOSE_MAKEFILE on )

include( cmake/projectVersionDetails.cmake )
project( elf_viewer VERSION ${elf_viewer_BUILD_VERSION} LANGUAGES CXX )

include( cmake/applicationInfo.cmake )

set_property(
    DIRECTORY
    APPEND
    PROPERTY CMAKE_CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/vcpkg.json
)

set( CMAKE_CXX_FLAGS "-g -Wall -Werror -Wno-attributes" )
set( CMAKE_CXX_FLAGS_DEBUG "-O0 -g -ggdb3" )
set( CMAKE_CXX_FLAGS_RELEASE "-O3" )
set( CMAKE_CXX_STANDARD 23 )

find_package( cxxopts CONFIG REQUIRED )

add_executable(
    elf_viewer
    src/main.cpp
    ${APPLICATION_INFO_PATH}
    src/ProgramArgs.cpp)

target_include_directories(
    elf_viewer
    PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
)

target_link_libraries( elf_viewer PRIVATE cxxopts::cxxopts )