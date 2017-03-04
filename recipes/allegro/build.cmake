cmake_minimum_required(VERSION 2.8)

project(ALLEGRO C CXX)

if(BUILD_SHARED_LIBS)
    set(SHARED On CACHE BOOL "")
else()
    set(SHARED Off CACHE BOOL "")
endif()

include(${CGET_CMAKE_ORIGINAL_SOURCE_FILE})
