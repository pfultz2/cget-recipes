cmake_minimum_required(VERSION 3.2)

# Workaround catch include file
find_path(CATCH_HEADER catch/catch.hpp)
include_directories(${CATCH_HEADER}/catch/)
find_path(CATCH_HEADER catch/catch.hpp)
message(STATUS "CATCH_HEADER: ${CATCH_HEADER}")
include(${CGET_CMAKE_ORIGINAL_SOURCE_FILE})
