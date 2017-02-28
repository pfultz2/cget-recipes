cmake_minimum_required(VERSION 2.8)

if(BUILD_SHARED_LIBS)
    set(CURL_STATICLIB Off CACHE BOOL "")
else()
    set(CURL_STATICLIB On CACHE BOOL "")
endif()

include(${CGET_CMAKE_ORIGINAL_SOURCE_FILE})
