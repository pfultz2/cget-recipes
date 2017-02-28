cmake_minimum_required(VERSION 2.8)

if(BUILD_SHARED_LIBS)
    set(CARES_STATIC Off CACHE BOOL "")
    set(CARES_SHARED On CACHE BOOL "")
else()
    set(CARES_STATIC On CACHE BOOL "")
    set(CARES_SHARED Off CACHE BOOL "")
endif()

include(${CGET_CMAKE_ORIGINAL_SOURCE_FILE})
