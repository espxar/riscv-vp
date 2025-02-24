cmake_minimum_required(VERSION 3.18)
project(riscv-vp
	VERSION 1.2.2
)

option(USE_SYSTEM_SYSTEMC "use systemc version provided by the system" OFF)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Debug)
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wno-unused-parameter -Wpedantic")
set(CMAKE_CXX_FLAGS_DEBUG "-g3")        #"-fsanitize=address -fno-omit-frame-pointer"
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

#message(STATUS "CMAKE_BINARY_DIR is ${CMAKE_BINARY_DIR}")
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

# Allows running tests without invoking `make install` first.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR})

include(cmake/AddGitSubmodule.cmake)

set(Boost_INCLUDE_DIR /usr/local/include)  # Intel Mac
include_directories(${Boost_INCLUDE_DIR})
find_package( Boost REQUIRED COMPONENTS iostreams program_options log)


if(USE_SYSTEM_SYSTEMC)
    find_package(SystemCLanguage REQUIRED CONFIG)
    add_library(systemc ALIAS SystemC::systemc)
    include_directories(${SystemC_INCLUDE_DIRS})
endif()

#if(USE_SYSTEM_SYSTEMC)
#	find_library(SystemC libsystemc.a)
#endif()

message(STATUS "USE_SYSTEM_SYSTEMC is ${USE_SYSTEM_SYSTEMC}")

add_compile_definitions(SC_ALLOW_DEPRECATED_IEEE_API)


set(BUILD_HIFIVE OFF) # 添加这一行
if(BUILD_HIFIVE)
    add_subdirectory(src/platform/hifive)
endif()

# 其他平台照常
add_subdirectory(src)


#subdirs(src)

enable_testing()
list(APPEND CMAKE_CTEST_ARGUMENTS "--verbose")

add_test(NAME libgdb
	COMMAND ./test.sh
	WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}/tests/libgdb")
add_test(NAME gdb
	COMMAND ./test.sh
	WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}/tests/gdb")
add_test(NAME integration
	COMMAND ./test.sh
	WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}/tests/integration")
add_test(NAME sw
	COMMAND ./test.sh
	WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}/../sw")

set_tests_properties(gdb integration sw PROPERTIES ENVIRONMENT
	PATH=$ENV{PATH}:${CMAKE_RUNTIME_OUTPUT_DIRECTORY})
set_tests_properties(libgdb PROPERTIES ENVIRONMENT
	RISCV_VP_BASE=${CMAKE_CURRENT_SOURCE_DIR}/..)
