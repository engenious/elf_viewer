find_program( CONAN_EXECUTABLE conan )
if( NOT CONAN_EXECUTABLE )
    message( FATAL_ERROR "Conan is required to build this project" )
endif()

set_property(
    DIRECTORY
    APPEND
    PROPERTY CMAKE_CONFIGURE_DEPENDS ${CMAKE_SOURCE_DIR}/conanfile.txt
)

message( CHECK_START "Obtaining lock to execute conan" )
# TODO add cache var to control if this times out, and how long the timeout is
# Ensure that concurrent cmake configure processes (As can occur inside IDEs like clion) do not run conan install
# concurrently.
file(
    LOCK ${CMAKE_SOURCE_DIR}/cmake/conan.lock
    GUARD FILE
)
message( CHECK_PASS "Lock obtained" )

message( CHECK_START "Running conan" )
## TODO control via config/cache vars?
execute_process(
    COMMAND /bin/bash -c "${CONAN_EXECUTABLE} install ${CMAKE_SOURCE_DIR} --build=missing --output-folder=${CMAKE_FIND_PACKAGE_REDIRECTS_DIR}"
    RESULT_VARIABLE conan_result
)

if( conan_result )
    message( CHECK_FAIL "failed" )
    message( FATAL_ERROR "Cannot run conan (error code: ${conan_result})" )
else()
    message( CHECK_PASS "Dependencies downloaded" )
endif()
