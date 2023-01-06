#
# SPDX-License-Identifier: MIT
# Copyright (c) Contributors to the elf_viewer Project.
#

# Interactions with the conan dependency system.
# This allows cmake configure to invoke conan, downloading/building dependencies as required.
# The conan file is listed as an configure dependency, ensuring that any change to that file will force a reconfigure
# when cmake is next run. (Which will then trigger a download of the new dependencies.)

function( run_conan )
    find_program( CONAN_EXECUTABLE conan )
    if( NOT CONAN_EXECUTABLE )
        message( FATAL_ERROR "Conan is required to build this project" )
    endif()

    set_property(
        DIRECTORY
        APPEND
        PROPERTY CMAKE_CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/conanfile.txt
    )

    if( ENABLE_CONAN_LOCKING )
        # Ensure that concurrent cmake configure processes (As can occur inside IDEs like clion) do not run conan
        # install concurrently.
        message( CHECK_START "Obtaining lock to execute conan" )
        if( ENABLE_CONAN_LOCK_TIMEOUT )
            file(
                LOCK ${CONAN_LOCK_FILE}
                GUARD FUNCTION
                TIMEOUT ${CONAN_LOCK_TIMEOUT_SECONDS}
                RESULT_VARIABLE CONAN_LOCK_RESULT
            )
        else()
            file(
                LOCK ${CONAN_LOCK_FILE}
                GUARD FUNCTION
                RESULT_VARIABLE CONAN_LOCK_RESULT
            )
        endif()

        if( CONAN_LOCK_RESULT )
            message( CHECK_FAIL "failed" )
            message( FATAL_ERROR "Could not obtain conan lock (error: ${CONAN_LOCK_RESULT})" )
        else()
            message( CHECK_PASS "Lock obtained" )
        endif()


    endif()

    message( CHECK_START "Running conan" )
    execute_process(
        COMMAND /bin/bash -c "${CONAN_EXECUTABLE} install ${CMAKE_SOURCE_DIR} --build=missing --output-folder=${CMAKE_FIND_PACKAGE_REDIRECTS_DIR}"
        RESULT_VARIABLE CONAN_INSTALL_RESULT
    )

    if( CONAN_INSTALL_RESULT )
        message( CHECK_FAIL "failed" )
        message( FATAL_ERROR "Cannot run conan (error code: ${CONAN_INSTALL_RESULT})" )
    else()
        message( CHECK_PASS "All dependencies found" )
    endif()

endfunction()

include(CMakeDependentOption)

option(
    ENABLE_CONAN
    [=[
    Enable the conan dependency system. Building with this option disabled will require the developer to ensure all
    dependencies can be found via the `find_package` mechanism.
    ]=]
    ON
)

cmake_dependent_option(
    ENABLE_CONAN_LOCKING
    [=[
    Enable locking around conan runs. Multiple cmake configures can occur at the same time, (especially within IDEs
    like clion.) which can result in concurrent conan processes running. This can cause problems. To prevent concurrent
    cmake configure processes causing issues, this option enables a lock around the conan process. However, if no
    concurrent runs will occur (e.g. manual cmake runs) then the lock is overhead that is not required, and should be
    disabled.
    ]=]
    ON
    "ENABLE_CONAN"
    OFF
)

set(
    CONAN_LOCK_FILE "${CMAKE_SOURCE_DIR}/cmake/conan.lock" CACHE FILEPATH
    "Path to lock file around conan process. See ENABLE_CONAN_LOCKING option for more details."
)

cmake_dependent_option(
    ENABLE_CONAN_LOCK_TIMEOUT
    [=[
    By default, obtaining the lock around the conan process (See the ENABLE_CONAN_LOCKING option ofr more details) will
    block indefinitely. This option enables timeouts on this lock."
    ]=]
    OFF
    ENABLE_CONAN_LOCKING
    OFF
)

set(
    CONAN_LOCK_TIMEOUT_SECONDS 60 CACHE STRING
    [=[
    Time (in seconds) before the lock around conan process times out. Is only valid if ENABLE_CONAN_LOCK_TIMEOUT is set
    to ON. See ENABLE_CONAN_LOCK_TIMEOUT and ENABLE_CONAN_LOCKING for more details.
    ]=]
)

if( ENABLE_CONAN )
    run_conan()
endif()