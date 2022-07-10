cmake_minimum_required(VERSION 3.22)

project(elf_viewer CXX)

set(CMAKE_VERBOSE_MAKEFILE on)

set(CMAKE_CXX_FLAGS "-g -Wall -Werror -Wno-attributes")
set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g -ggdb3")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")
set(CMAKE_CXX_STANDARD 23)

add_executable(elf_viewer main.cpp)
